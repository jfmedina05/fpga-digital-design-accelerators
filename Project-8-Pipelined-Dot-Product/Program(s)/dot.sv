`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Created for Indiana University's E315 Class
//
// 
// Andrew Lukefahr
// lukefahr@iu.edu
//
// 2021-03-24
// 2020-02-25
//
//////////////////////////////////////////////////////////////////////////////////

module dot #(   

    parameter ROWS = 3,
    parameter COLS = 4

    )(

    input clk, 
    input rst, 

    // Incomming Matrix AXI4-Stream
    input  [31:0]                   INPUT_AXIS_TDATA,
    input                           INPUT_AXIS_TLAST,
    input                           INPUT_AXIS_TVALID,
    output logic                    INPUT_AXIS_TREADY,

    //weight matrix
    input  [31:0]                   weights [0:ROWS-1] [0:COLS-1], 
    
    // Outgoing Vector AXI4-Stream 		
    output logic [31:0]             OUTPUT_AXIS_TDATA,
    output logic                    OUTPUT_AXIS_TLAST,
    output logic                    OUTPUT_AXIS_TVALID,
    input                           OUTPUT_AXIS_TREADY

    );  

    // output vector array (also used for dot calculations)
    logic [31:0] outputs [0:COLS-1];       
    // bulk clear the entire output array 
    logic clear_outputs;

    // buffer for the most recent input
    logic [31:0] inbuf, next_inbuf;     

    // ask for the Floating-Point Multiply-Accumulate module to be run
    logic run_fmac;

    // tracks the row/column location of weight matrix values headed to the fmac
    logic [31:0]  i, next_i;
    logic [31:0]  j, next_j;

    // tracks the row/column location of returning fmac values 
    logic [31:0] rxi, rxj;

    // per-output ready flag: 1 when final (last row) FMAC result for this column has been written
    logic [COLS-1:0] out_ready;
    
    /////////////////////////////////////////////
    //
    // Floating Point Multiply Accumulate (FMAC)
    //
    /////////////////////////////////////////////

    wire [31:0] fmac_tdata;
    wire        fmac_tvalid; 

    axis_fmac fmac0(
        .clk, 

        .A_TDATA   (weights[i][j]),
        .A_TVALID  (run_fmac), 

        .B_TDATA   (inbuf), 
        .B_TVALID  (run_fmac),

        .C_TDATA   (outputs[j]), 
        .C_TVALID  (run_fmac), 

        .OUT_TDATA (fmac_tdata), 
        .OUT_TVALID(fmac_tvalid)
    );

    /////////////////////////////////////////////
    //
    // Input Vector Receive +
    // Send-to-FPU Control  + 
    // Output Vector Transmit
    //
    /////////////////////////////////////////////

    // FMAC latency
    localparam int FMAC_DELAY = 8; 

    // small timer for inter-row waits (only needed when COLS is small)
    localparam int TIMER_SZ = $clog2(FMAC_DELAY + 1);
    logic [TIMER_SZ-1:0] fpu_timer, next_fpu_timer; 

    // Hazard-safe inter-row wait:
    // For same column j across consecutive rows, with this FSM:
    //   separation = COLS + WAIT_INTER + 1
    // require: separation >= FMAC_DELAY
    // so: WAIT_INTER >= FMAC_DELAY - (COLS + 1)
    localparam int WAIT_INTER = (FMAC_DELAY > (COLS + 1)) ?
                                (FMAC_DELAY - (COLS + 1)) : 0;

    // STATES
    enum { ST_IDLE,
           ST_RUN_FMAC,
           ST_WAIT_INTER,
           ST_TERM_ROW,
           ST_OUTPUT } state, next_state;

    // sequential block
    always_ff @(posedge clk) begin
        if (rst) begin
            state      <= ST_IDLE;
            fpu_timer  <= 'h0; 
            i          <= 0;
            j          <= 0;
            inbuf      <= 32'h0;            
        end else begin
            state      <= next_state;           
            fpu_timer  <= next_fpu_timer;
            i          <= next_i;
            j          <= next_j;
            inbuf      <= next_inbuf;             
        end
    end 
    
    // combinational control
    always_comb begin        
        // defaults
        next_state      = state;

        // timer default: count down if non-zero
        next_fpu_timer  = (fpu_timer == 'h0 ? 'h0 : fpu_timer - 'h1);

        next_i          = i; 
        next_j          = j;  
        next_inbuf      = inbuf; 

        run_fmac        = 1'h0;
        clear_outputs   = 1'h0;

        // input control
        INPUT_AXIS_TREADY   = 1'h0; 
        
        // output control
        OUTPUT_AXIS_TDATA   = outputs[j];
        OUTPUT_AXIS_TLAST   = 1'h0;
        OUTPUT_AXIS_TVALID  = 1'h0;
    
        case (state)

            //--------------------------------------------------
            // Wait for the first input of a new dot product
            //--------------------------------------------------
            ST_IDLE:  begin
                INPUT_AXIS_TREADY = 1'h1; 

                if (INPUT_AXIS_TVALID) begin
                    // start new dot product
                    next_i     = 0;
                    next_j     = 0;
                    next_inbuf = INPUT_AXIS_TDATA;

                    // Start issuing FMACs next cycle
                    next_state = ST_RUN_FMAC;
                end
            end
           
            //--------------------------------------------------
            // Stream FMAC operations for the current row
            // One FMAC issued every cycle: j = 0..COLS-1
            //--------------------------------------------------
            ST_RUN_FMAC: begin
                // issue FMAC for (i,j) this cycle
                run_fmac = 1'h1;

                if (j == COLS - 1) begin
                    // finished this row's columns
                    if (i < ROWS - 1) begin
                        // more rows to process

                        if (WAIT_INTER == 0) begin
                            // large COLS (e.g., 10): no inter-row wait needed
                            next_state = ST_TERM_ROW;
                        end else begin
                            // small COLS (e.g., 4): hazard-safe inter-row wait
                            next_fpu_timer = WAIT_INTER;
                            next_state     = ST_WAIT_INTER;
                        end

                    end else begin
                        // last row: after issuing final FMAC, go directly to OUTPUT
                        next_i     = 0;
                        next_j     = 0;
                        next_state = ST_OUTPUT;
                    end

                end else begin
                    // continue across columns in this row
                    next_j     = j + 1;
                    next_state = ST_RUN_FMAC;
                end
            end

            //--------------------------------------------------
            // Inter-row wait: only used when COLS < FMAC_DELAY
            //--------------------------------------------------
            ST_WAIT_INTER: begin
                if (fpu_timer == 0) begin
                    next_state = ST_TERM_ROW;
                end
            end

            //--------------------------------------------------
            // Fetch next input element for the next row
            //--------------------------------------------------
            ST_TERM_ROW: begin
                INPUT_AXIS_TREADY = 1'h1;
                    
                if (INPUT_AXIS_TVALID) begin
                    next_i     = i + 1;
                    next_j     = 0;
                    next_inbuf = INPUT_AXIS_TDATA;

                    // start FMACs for next row
                    next_state = ST_RUN_FMAC;
                end
            end                         

            //--------------------------------------------------
            // Stream out the resulting output vector
            // Only assert VALID when that output element is ready.
            //--------------------------------------------------
            ST_OUTPUT: begin
                // only drive VALID when this column's output is ready
                if (out_ready[j]) begin
                    OUTPUT_AXIS_TVALID = 1'h1;
                    OUTPUT_AXIS_TLAST  = (j == COLS - 1 ? 1'h1 : 1'h0);
                end

                if (OUTPUT_AXIS_TVALID && OUTPUT_AXIS_TREADY) begin
                    if (j == COLS - 1) begin
                        // done transmitting all outputs
                        next_j        = 0;
                        clear_outputs = 1'h1;   // clear accumulators and ready flags
                        next_state    = ST_IDLE;
                    end else begin
                        // transmit the next output vector element 
                        next_j        = j + 1;
                    end
                end
            end
             
       endcase
    end


    /////////////////////////////////////////////
    //
    // Recv from FMAC Control + Output Ready Flags
    //
    /////////////////////////////////////////////

    always_ff @(posedge clk) begin
    
        if (rst) begin
            rxi       <= 0;
            rxj       <= 0;
            outputs   <= '{default:32'h0};
            out_ready <= '{default:1'b0};
        
        end else if (clear_outputs) begin
            outputs   <= '{default:32'h0};
            out_ready <= '{default:1'b0};
            rxi       <= 0;
            rxj       <= 0;

        // this waits until the FPU gives a valid result
        // then stores it back into the outputs buffer
        end else if (fmac_tvalid) begin
            outputs[rxi] <= fmac_tdata;

            // If this result is from the last row, mark this column as fully ready
            if (rxj == ROWS - 1) begin
                out_ready[rxi] <= 1'b1;
            end

            // advance (rxi, rxj) in row-major fashion to match issue order:
            // (0,0),(0,1),..(0,COLS-1),(1,0),...(ROWS-1,COLS-1)
            if (rxi < COLS - 1) begin
                rxi <= rxi + 1;
            end else begin
                rxi <= 0;
                if (rxj < ROWS - 1) begin
                    rxj <= rxj + 1;
                end else begin
                    rxj <= 0;
                end
            end
        end
    end

endmodule

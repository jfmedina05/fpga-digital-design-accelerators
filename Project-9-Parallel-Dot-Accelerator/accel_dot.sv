`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Created for Indiana University's E315 Class
//
// Andrew Lukefahr
// lukefahr@iu.edu
//
// Parallelized for Project 9: vertical split across columns
//
// - Requires COLS to be even.
// - Instantiates two dot cores in parallel, each handling COLS/2 columns.
// - Broadcasts the same input stream to both dot cores (locked-step ready).
// - Multiplexes outputs: first dot0 vector, then dot1 vector.
// - OUTPUT_AXIS_TLAST asserted only on the final word of dot1.
//
//////////////////////////////////////////////////////////////////////////////////

module accel_dot #(
    parameter int ROWS = 3,
    parameter int COLS = 4
)(
    input  logic                         clk,
    input  logic                         rst,

    // Incoming Matrix AXI4-Stream
    input  logic [31:0]                  INPUT_AXIS_TDATA,
    input  logic                         INPUT_AXIS_TLAST,
    input  logic                         INPUT_AXIS_TVALID,
    output logic                         INPUT_AXIS_TREADY,

    // the weight matrix
    input  logic [31:0]                  weights [0:ROWS-1][0:COLS-1],

    // Outgoing Vector AXI4-Stream
    output logic [31:0]                  OUTPUT_AXIS_TDATA,
    output logic                         OUTPUT_AXIS_TLAST,
    output logic                         OUTPUT_AXIS_TVALID,
    input  logic                         OUTPUT_AXIS_TREADY
);

    // COLS must be even for vertical split.
    initial begin
        if ((COLS % 2) != 0) begin
            $error("accel_dot: COLS must be even for vertical parallelization (COLS=%0d)", COLS);
        end
    end

    localparam int SUBCOLS = (COLS / 2);

    // Split weights vertically into two halves.
    logic [31:0] weights0 [0:ROWS-1][0:SUBCOLS-1];
    logic [31:0] weights1 [0:ROWS-1][0:SUBCOLS-1];

    genvar r, c;
    generate
        for (r = 0; r < ROWS; r++) begin : GEN_W_R
            for (c = 0; c < SUBCOLS; c++) begin : GEN_W_C
                assign weights0[r][c] = weights[r][c];
                assign weights1[r][c] = weights[r][c + SUBCOLS];
            end
        end
    endgenerate

    // Two dot engines.
    logic [31:0] dot0_tdata,  dot1_tdata;
    logic        dot0_tlast,  dot1_tlast;
    logic        dot0_tvalid, dot1_tvalid;
    logic        dot0_tready, dot1_tready;

    logic        in_tready0,  in_tready1;

    dot #(
        .ROWS(ROWS),
        .COLS(SUBCOLS)
    ) dot0 (
        .clk(clk),
        .rst(rst),

        .INPUT_AXIS_TDATA(INPUT_AXIS_TDATA),
        .INPUT_AXIS_TLAST(INPUT_AXIS_TLAST),
        .INPUT_AXIS_TVALID(INPUT_AXIS_TVALID),
        .INPUT_AXIS_TREADY(in_tready0),

        .weights(weights0),

        .OUTPUT_AXIS_TDATA(dot0_tdata),
        .OUTPUT_AXIS_TLAST(dot0_tlast),
        .OUTPUT_AXIS_TVALID(dot0_tvalid),
        .OUTPUT_AXIS_TREADY(dot0_tready)
    );

    dot #(
        .ROWS(ROWS),
        .COLS(SUBCOLS)
    ) dot1 (
        .clk(clk),
        .rst(rst),

        .INPUT_AXIS_TDATA(INPUT_AXIS_TDATA),
        .INPUT_AXIS_TLAST(INPUT_AXIS_TLAST),
        .INPUT_AXIS_TVALID(INPUT_AXIS_TVALID),
        .INPUT_AXIS_TREADY(in_tready1),

        .weights(weights1),

        .OUTPUT_AXIS_TDATA(dot1_tdata),
        .OUTPUT_AXIS_TLAST(dot1_tlast),
        .OUTPUT_AXIS_TVALID(dot1_tvalid),
        .OUTPUT_AXIS_TREADY(dot1_tready)
    );

    // Keep both dot cores aligned on the input stream.
    assign INPUT_AXIS_TREADY = in_tready0 & in_tready1;

    // Output mux FSM: dot0 then dot1.
    typedef enum logic [1:0] { OUT_WAIT, OUT_DOT0, OUT_DOT1 } out_state_t;
    out_state_t out_state, out_state_n;

    always_comb begin
        dot0_tready       = 1'b0;
        dot1_tready       = 1'b0;

        OUTPUT_AXIS_TDATA  = 32'h0;
        OUTPUT_AXIS_TVALID = 1'b0;
        OUTPUT_AXIS_TLAST  = 1'b0;

        out_state_n = out_state;

        unique case (out_state)
            OUT_WAIT: begin
                // Wait until dot0 has data ready to transmit
                if (dot0_tvalid)
                    out_state_n = OUT_DOT0;
            end

            OUT_DOT0: begin
                OUTPUT_AXIS_TDATA  = dot0_tdata;
                OUTPUT_AXIS_TVALID = dot0_tvalid;
                OUTPUT_AXIS_TLAST  = 1'b0; // overall TLAST must be at end of dot1

                dot0_tready = OUTPUT_AXIS_TREADY;

                if (dot0_tvalid && OUTPUT_AXIS_TREADY && dot0_tlast)
                    out_state_n = OUT_DOT1;
            end

            OUT_DOT1: begin
                OUTPUT_AXIS_TDATA  = dot1_tdata;
                OUTPUT_AXIS_TVALID = dot1_tvalid;
                OUTPUT_AXIS_TLAST  = dot1_tlast;

                dot1_tready = OUTPUT_AXIS_TREADY;

                if (dot1_tvalid && OUTPUT_AXIS_TREADY && dot1_tlast)
                    out_state_n = OUT_WAIT;
            end

            default: out_state_n = OUT_WAIT;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst)
            out_state <= OUT_WAIT;
        else
            out_state <= out_state_n;
    end

endmodule

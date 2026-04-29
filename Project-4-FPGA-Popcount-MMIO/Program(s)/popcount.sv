`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// E315
//
// 
// Andrew Lukefahr
// lukefahr@iu.edu
//
// Jaiden Medina
// jfmedina@iu.edu
//
// 10-25
// 
//
//////////////////////////////////////////////////////////////////////////////////


module popcount(
        input               ACLK,
        input               ARESETN,

        //MMIO Inputs
        input [31:0]        WRITE_DATA,
        input               WRITE_VALID,
        
        // Count signals
        output logic [31:0] COUNT,
        input               COUNT_RST,
        output logic        COUNT_BUSY //busy = 1 when counting is happening, busy=0 at idle 
        
    );

// update me!
// for loop checks each of the 32 bits in the number and adds 1 for every bit that’s a 1. After the loop, the total is how many 1s (the popcount) were in the number
    function automatic [5:0] pop32(input logic [31:0] x);
        int i;
        pop32 = '0;
        for (i = 0; i < 32; i++) begin
            pop32 += x[i];
        end
    endfunction

    logic [31:0] count_q;
    logic        busy_q;

    always_ff @(posedge ACLK) begin
        if (!ARESETN) begin
            count_q <= 32'h0;
            busy_q  <= 1'b0;
        end else begin
            // pulse busy for one cycle when a write is accepted
            busy_q <= WRITE_VALID;

            if (COUNT_RST) begin
                count_q <= 32'h0;
            end else if (WRITE_VALID) begin
                count_q <= count_q + pop32(WRITE_DATA);
            end
        end
    end

    assign COUNT      = count_q;
    assign COUNT_BUSY = busy_q;
endmodule
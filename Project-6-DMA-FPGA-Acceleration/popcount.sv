`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Created for Indiana University's E315 Class
//
// 
// Andrew Lukefahr
// lukefahr@iu.edu
//
// Ethan Japundza
// ejapundz@iu.edu
//
// 2021-02-23
// 2020-02-25
//
//////////////////////////////////////////////////////////////////////////////////


module popcount(

        //AXI4-Stream SIGNALS
        input               S_AXIS_ACLK,
        input               S_AXIS_ARESETN,
		input [31:0]        S_AXIS_TDATA,
        input [3:0]         S_AXIS_TKEEP,
        input               S_AXIS_TLAST, //TLAST represents end of DMA transfer
        input               S_AXIS_TVALID,
        output              S_AXIS_TREADY,

        //MMIO Inputs
        input [31:0]        WRITE_DATA,
        input               WRITE_VALID,
        
        // Count signals
        output reg [31:0]   COUNT,
        input               COUNT_RST,
        output reg          COUNT_BUSY //busy = 1 when counting is happening, busy=0 at idle 
        
    );
   
    assign S_AXIS_TREADY = 1'h1; //I changed this from 0 to 1 due to it stalling on the autograder lol
   
    // update me!
    //Essentially, the goal here is to accept data when S_AXIS_TVALID && S_AXIS_TREADY.
    //When the data is accepted, it will accumulate popcounts into COUNT (32-bit).
    //Use TLAST to clear busy at the end.
    //Supports reset on S_AXIS_ARESETN low, COUNT_RST, and MMIO write with WRITE_DATA[0]==1

    //This function is for computing the popcount of the 32-bit word
    function [5:0] popc32;
        input [31:0] v;
        integer i;
        reg [5:0] sum;
        begin
            sum = 6'd0;
            for (i = 0; i < 32; i = i + 1) begin
                sum = sum + v[i];
            end
            popc32 = sum;
        end
    endfunction

    //Synchronous active-high resets from COUNT_RST and MMIO write
    always @(posedge S_AXIS_ACLK) begin
        if (!S_AXIS_ARESETN) begin
            COUNT <= 32'h0;
            COUNT_BUSY <= 1'b0;
        end else begin
            if (COUNT_RST) begin
                COUNT <= 32'h0;
                COUNT_BUSY <= 1'b0;
            end else if (WRITE_VALID && (WRITE_DATA[0] == 1'b1)) begin
                //Mmio reset command.
                COUNT <= 32'h0;
                COUNT_BUSY <= 1'b0;
            end else begin
                //Accept beat only when TVALID && TREADY.
                if (S_AXIS_TVALID && S_AXIS_TREADY) begin
                    // mark busy at start of transfer
                    if (!COUNT_BUSY) begin
                        COUNT_BUSY <= 1'b1;
                    end
                    //Accumulate popcount (zero-extend 6-bit value to 32 bits).
                    COUNT <= COUNT + {26'd0, popc32(S_AXIS_TDATA)};
                    if (S_AXIS_TLAST) begin
                        COUNT_BUSY <= 1'b0;
                    end
                end
            end
        end
    end

endmodule


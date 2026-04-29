`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2020 05:46:53 AM
// Design Name: 
// Module Name: axis_ema
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module axis_ema_sv #(
    parameter integer DATA_WIDTH = 32,
    parameter integer KEEP_WIDTH = DATA_WIDTH/8
)(
    input  wire                         ACLK,
    input  wire                         ARESETN,

    input  wire [DATA_WIDTH-1:0]        S_AXIS_TDATA,
    input  wire [KEEP_WIDTH-1:0]        S_AXIS_TKEEP,
    input  wire                         S_AXIS_TLAST,
    input  wire                         S_AXIS_TVALID,
    output wire                         S_AXIS_TREADY,

    output wire [DATA_WIDTH-1:0]        M_AXIS_TDATA,
    output wire [KEEP_WIDTH-1:0]        M_AXIS_TKEEP,
    output wire                         M_AXIS_TLAST,
    output wire                         M_AXIS_TVALID,
    input  wire                         M_AXIS_TREADY
);

    reg [DATA_WIDTH-1:0] ema_reg;

    assign S_AXIS_TREADY = M_AXIS_TREADY;
    assign M_AXIS_TVALID = S_AXIS_TVALID;
    assign M_AXIS_TKEEP  = S_AXIS_TKEEP;
    assign M_AXIS_TLAST  = S_AXIS_TLAST;

    wire [DATA_WIDTH-1:0] ema_next_comb;
    assign ema_next_comb = (S_AXIS_TDATA >> 2) + (ema_reg >> 2) + (ema_reg >> 1);
    assign M_AXIS_TDATA = ema_next_comb;

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            // initialize ema_reg to 1000 (adjusted to DATA_WIDTH)
            ema_reg <= { {(DATA_WIDTH-10){1'b0}}, 10'd1000 };
        end else if (S_AXIS_TVALID && S_AXIS_TREADY) begin
            ema_reg <= ema_next_comb;
        end
    end

endmodule

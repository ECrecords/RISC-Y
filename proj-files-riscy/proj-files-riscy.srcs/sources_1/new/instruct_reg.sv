`timescale 1ns / 100ps

`ifndef global
`define global
`include "global.svh"
`endif

module instruct_reg(
    input CLK,
    input RST,
    input WE,
    input [DATA_WIDTH-1:0] IR_IN,
    output reg [DATA_WIDTH-1:0] IR_OUT
);

always_ff @( posedge CLK ) begin : IR_WRITE
    if ( RST ) begin
        IR_OUT <= 'h0;
    end else begin
        if (WE) begin
            IR_OUT <= IR_IN;
        end
    end
end

endmodule
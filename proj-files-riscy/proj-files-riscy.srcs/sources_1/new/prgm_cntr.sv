`timescale 1ns / 100ps

`ifndef global
`define global
`include "global.svh"
`endif

module prgm_cntr(
    input CLK,
    input RST,
    input WE,
    input [DATA_WIDTH-1:0] PC_IN,
    output reg [DATA_WIDTH-1:0] PC_OUT
);

always_ff @( posedge CLK ) begin : PC_WRITE
    if ( RST ) begin
        PC_OUT <= 'h0;
    end else begin
        if (WE) begin
            PC_OUT <= PC_IN;
        end
    end
end

endmodule
`timescale 1ns / 100ps

`ifndef global
`define global
`include "global.svh"
`endif

module reg_file
    #( parameter ADDR_WIDTH = 5 )
    (   input CLK,
        input RST,
        input WE,
        input [ADDR_WIDTH-1:0] WA,
        input [ADDR_WIDTH-1:0] RA1,
        input [ADDR_WIDTH-1:0] RA2,
        input [DATA_WIDTH-1:0] WD,
        output reg [DATA_WIDTH-1:0] X1,
        output reg [DATA_WIDTH-1:0] X2 );

reg [DATA_WIDTH-1:0] rf [0:(2**(ADDR_WIDTH)-1)];

always_ff @( posedge CLK ) begin : RF_WRITE
    if ( RST ) begin
        for (int i = 1; i < 2**(ADDR_WIDTH) ; i = i + 1 ) begin
            rf[i] <= 'h0;
        end
    end else begin
        if (WE & WA != 0) begin
            rf[WA] <= WD;
        end
    end
end

always_comb begin : RF_READ
    if (RA1 == 0) begin
        X1 = 'h0;
    end else begin
        X1 = rf[RA1];
    end

    if (RA2 == 0) begin
        X2 = 'h0;
    end else begin
        X2 = rf[RA2];
    end
end

endmodule

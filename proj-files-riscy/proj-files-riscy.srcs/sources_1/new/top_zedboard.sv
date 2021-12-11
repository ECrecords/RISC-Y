`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/06/2021 05:15:40 PM
// Design Name:
// Module Name: top_zedboard
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

`ifndef global
`define global
`include "global.svh"
`endif

module top_zedboard(
        input               GCLK,
        input               MRST,
        input       [3:0]   SEL,
        input       [3:0]   SW,
        output reg  [7:0]   LED
    );

reg [DATA_WIDTH-1:0] csr0;
wire [DATA_WIDTH-1:0] csr1;

riscy CPU (
    .CLK(GCLK),
    .RST(MRST),
    .CSR0_IN(csr0),
    .CSR1(csr1)
);

always_comb begin : LED_OUT
    case(SEL)
        LOWER_HALFWORD_0BYTE:
            LED = csr1[7:0];
        LOWER_HALFWORD_1BYTE:
            LED = csr1[15:8];
        UPPER_HALFWORD_0BYTE:
            LED = csr1[23:16];
        UPPER_HALFWORD_1BYTE:
            LED = csr1[31:23];
        default:
            LED = 8'hAA;
    endcase
end


always_comb begin : SW_IN
    case(SEL)
        L_HALFWORD_0NIBBLE:
            csr0[3:0] = SW;
        L_HALFWORD_1NIBBLE:
            csr0[7:4] = SW;
        L_HALFWORD_2NIBBLE:
            csr0[11:8] = SW;
        L_HALFWORD_3NIBBLE:
            csr0[15:12] = SW;
        default:
            csr0 = 'hAA;
    endcase
end




endmodule

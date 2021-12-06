`timescale 1ns / 100ps

`ifndef global
`define global
`include "global.svh"
`endif

module alu(
        input   [DATA_WIDTH-1:0] A,
        input   [DATA_WIDTH-1:0] B,
        input   [ALU_SEL-1:0] SEL,
        output reg  [DATA_WIDTH-1:0] C,
        output reg EQ,
        output reg NE,
        output reg LT,
        output reg LTU,
        output reg GE,
        output reg GEU );

    reg signed [DATA_WIDTH-1:0] a_sig;
    reg signed [DATA_WIDTH-1:0] b_sig;

    assign a_sig = A;
    assign b_sig = B;

    always_comb begin : ALU_OP
        case(SEL)
            ALU_ADD:
                C <= a_sig + b_sig;
            ALU_SLT:
                C <= (a_sig < b_sig) ? 'h1 : 'h0;
            ALU_SLTU:
                C <= (A < B) ? 'h1 : 'h0;
            ALU_AND:
                C <= A & B;
            ALU_OR:
                C <= A | B;
            ALU_XOR:
                C <= A ^ B;
            ALU_SLL:
                C <= A << B[4:0];
            ALU_SRL:
                C <= A >> B[4:0];
            ALU_SUB:
                C <= a_sig - b_sig;
            ALU_SRA:
                C <= a_sig >>> B[4:0];
            default:
                C <= 'hx;
        endcase
    end

    always_comb begin : FLAGS
        EQ <= (a_sig == b_sig) ? 'h1 : 'h0;
        NE <= (a_sig != b_sig) ? 'h1 : 'h0;

        LT <= (a_sig < b_sig) ? 'h1 : 'h0;
        LTU <= (A < B) ? 'h1 : 'h0;

        GE <= (a_sig >= b_sig) ? 'h1 : 'h0;
        GEU <= (A >= B) ? 'h1 : 'h0;

    end
endmodule

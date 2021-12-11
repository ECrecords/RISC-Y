`timescale 1ns/100ps

`ifndef global
`define global
`include "global.svh"
`endif

module imm_gen (
    input [31:7]                IMM_FIELD,
    input [2:0]                 IMM_SEL,
    output reg [DATA_WIDTH-1:0] EXT_IMM
);
    always_comb begin : GEN_IMM
        case(IMM_SEL)
            I_IMM:
                EXT_IMM <= {{21{IMM_FIELD[31]}}, IMM_FIELD[30:25], IMM_FIELD[24:21], IMM_FIELD[20]};
            S_IMM:
                EXT_IMM <= {{21{IMM_FIELD[31]}}, IMM_FIELD[30:25], IMM_FIELD[11:8], IMM_FIELD[7]};
            B_IMM:
                EXT_IMM <= {{20{IMM_FIELD[31]}}, IMM_FIELD[7], IMM_FIELD[30:25], IMM_FIELD[11:8], 1'b0};
            U_IMM:
                EXT_IMM <= { IMM_FIELD[31], IMM_FIELD[30:20], IMM_FIELD[19:12], {12{1'b0}}};
            J_IMM:
                EXT_IMM <= {{12{IMM_FIELD[31]}} ,IMM_FIELD[19:12], IMM_FIELD[20], IMM_FIELD[30:25], IMM_FIELD[24:21], 1'b0};
            default:
                EXT_IMM <= 'h0;
        endcase
    end
endmodule
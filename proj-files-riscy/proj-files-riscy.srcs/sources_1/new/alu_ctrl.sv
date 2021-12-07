`timescale 1ns / 100ps

`ifndef global
`define global
`include "global.svh"
`endif

module alu_ctrl(
    input [14:12]               FUNCT3,
    input [31:25]               FUNCT7,
    input [2:0]                 OP_MODE,
    output reg [ALU_SEL-1:0]    ALU_SEL
);

always_comb begin : GEN_ALU_OP
    case(OP_MODE)
        OPM_OPIMM: begin
            if ( FUNCT3 == ADD ) begin
                ALU_SEL <= ALU_ADD;
            end
            else if ( FUNCT3 == SLT ) begin
                ALU_SEL <= ALU_SLT;
            end
            else if ( FUNCT3 == SLTU ) begin
                ALU_SEL <= ALU_SLTU;
            end
            else if ( FUNCT3 == AND ) begin
                ALU_SEL <= ALU_AND;
            end
            else if ( FUNCT3 == OR ) begin
                ALU_SEL <= ALU_OR;
            end
            else if ( FUNCT3 == XOR ) begin
                ALU_SEL <= ALU_XOR;
            end
            else if ( FUNCT3 == SLL ) begin
                ALU_SEL <= ALU_SLL;
            end
            else if ( FUNCT3 == SRL | FUNCT3 == SRA) begin
                if ( FUNCT7 == F7_EN0 ) begin
                    ALU_SEL <= ALU_SRL;
                end
                else if ( FUNCT7 == F7_EN1 ) begin
                    ALU_SEL <= ALU_SRA;
                end
                else begin
                    ALU_SEL <= 'hx;
                end
            end
            else begin
                ALU_SEL <= 'hx;
            end
        end

        OPM_OP: begin
            if ( FUNCT7 == F7_EN1 ) begin
                if ( FUNCT3 == SUB ) begin
                    ALU_SEL <= ALU_SUB;
                end
                else if ( FUNCT3 == SRA ) begin
                    ALU_SEL <= ALU_SRA;
                end
                else begin
                    ALU_SEL <= 'hx;
                end
            end
            else if ( FUNCT7 == F7_EN0 ) begin
                if ( FUNCT3 == ADD ) begin
                    ALU_SEL <= ALU_ADD;
                end
                else if ( FUNCT3 == SLT ) begin
                    ALU_SEL <= ALU_SLT;
                end
                else if ( FUNCT3 == SLTU ) begin
                    ALU_SEL <= ALU_SLTU;
                end
                else if ( FUNCT3 == AND ) begin
                    ALU_SEL <= ALU_AND;
                end
                else if ( FUNCT3 == OR ) begin
                    ALU_SEL <= ALU_OR;
                end
                else if ( FUNCT3 == XOR ) begin
                    ALU_SEL <= ALU_XOR;
                end
                else if ( FUNCT3 == SLL ) begin
                    ALU_SEL <= ALU_SLL;
                end
                else if ( FUNCT3 == SRL) begin
                    ALU_SEL <= ALU_SRL;
                end
                else if ( FUNCT3 == SLL) begin
                    ALU_SEL <= ALU_SLL;
                end
                else begin
                    ALU_SEL <= 'hx;
                end
            end
            else begin
                ALU_SEL <= 'hx;
            end
        end

        OPM_FETCH:
            ALU_SEL <= ALU_ADD;
        OPM_JAL:
            ALU_SEL <= ALU_ADD;
        OPM_BRANCH:
            ALU_SEL <= ALU_ADD;
        OPM_LOAD_STORE:
            ALU_SEL <= ALU_ADD;
        OPM_NOP:
            ALU_SEL <= ALU_ADD;
        default:
            ALU_SEL <= 'hx;
    endcase
end


endmodule

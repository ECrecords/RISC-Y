`timescale 1ns / 1ps

`ifndef global
`define global
`include "global.svh"
`endif

        module riscy(
                input                       GCLK,
                input                       MRST,
                input [DATA_WIDTH-1:0]      CSR0_IN,
                output reg [DATA_WIDTH-1:0] CSR1
            );

            //CONTROL & STATUS REGISTERS======================
            reg [DATA_WIDTH-1:0] csr0;
            // reg [DATA_WIDTH-1:0] csr1;
            //================================================

            //CONTROL UNIT======================================
            wire        pc_we;
            wire        mem_addr_sel;
            wire        mem_we;
            wire        mem_re;
            wire        ir_we;
            wire        rf_we;
            wire [1:0]  rf_wdata_sel;
            wire [2:0]  imm_sel;
            wire        csr_we;
            wire        alua_sel;
            wire [1:0]  alub_sel;
            wire        is_branch;
            //================================================

            //PROGRAM COUNTER=================================
            reg pc_en;
            reg [DATA_WIDTH-1:0] pc_out;
            //================================================

            //MEMORY==========================================
            reg [MEM_ADDR_WIDTH-1:0] mem_addr;
            reg [DATA_WIDTH-1:0] mem_out;
            reg mem_ena;
            //================================================

            //IMMEDIATE GENERATOR=============================
            wire [DATA_WIDTH-1:0] ext_imm;
            //================================================

            //INSTRUCTION REGISTER============================
            wire [DATA_WIDTH-1:0] ir;
            //================================================

            //REGISTER FILE===================================
            reg [DATA_WIDTH-1:0] x1;
            reg [DATA_WIDTH-1:0] x2;
            reg [DATA_WIDTH-1:0] rf_wdata;
            //================================================

            //ALU=============================================
            reg [DATA_WIDTH-1:0] alu_a;
            reg [DATA_WIDTH-1:0] alu_b;
            wire [DATA_WIDTH-1:0] alu_out;
            reg [DATA_WIDTH-1:0] alu_rslt;
            reg [5:0] flag;
            wire [5:0] alu_flg_out;
            reg sel_flag;
            reg br_flg;
            //================================================

            //ALU CONTROL=====================================
            wire [ALU_SEL-1:0] alu_sel;
            wire [2:1] op_mode;
            
            //================================================

            //================================================
            //================================================
            //================================================
            //================================================

            // always_ff @( posedge GCLK ) begin : LED_OUT
            //     case(SW_SEL)
            //         LOWER_HALFWORD_0BYTE:
            //             LED <= csr1[7:0];
            //         LOWER_HALFWORD_1BYTE:
            //             LED <= csr1[15:8];
            //         UPPER_HALFWORD_0BYTE:
            //             LED <= csr1[23:16];
            //         UPPER_HALFWORD_1BYTE:
            //             LED <= csr1[31:23];
            //         default:
            //             LED <= 8'hAA;
            //     endcase
            // end

            // always_ff @( posedge GCLK ) begin : SW_IN
            //     if (MRST) begin
            //         csr0 <= 'h0;
            //     end
            //     else begin
            //         case(SW_SEL)
            //             L_HALFWORD_0NIBBLE:
            //                 csr0[3:0] <= SW;
            //             L_HALFWORD_1NIBBLE:
            //                 csr0[7:4] <= SW;
            //             L_HALFWORD_2NIBBLE:
            //                 csr0[11:8] <= SW;
            //             L_HALFWORD_3NIBBLE:
            //                 csr0[15:12] <= SW;
            //             default:
            //                 csr0 <= 'hAA;
            //         endcase
            //     end
            // end




            //CSR MAP=========================================
            always_ff @( posedge GCLK ) begin : IN_CSR0
                if (MRST) begin
                    csr0 <= 'h0;
                end
                else begin
                        csr0 <= CSR0_IN;
                end
            end

            always_ff @( posedge GCLK ) begin : CSR1_OUT
                if (MRST) begin
                    CSR1 <= 'h0;
                end
                else begin
                    if (csr_we) begin
                        CSR1 <= x1;
                    end
                end
            end
            //================================================

            //CTRL U MAP======================================
            ctrl_unt CU(
                         .CLK            (GCLK),
                         .RST            (MRST),
                         .OPCODE         (ir[6:0]),
                         .PC_WE          (pc_we),
                         .MEM_ADDR_SEL   (mem_addr_sel),
                         .MEM_WE         (mem_we),
                         .MEM_RE         (mem_re),
                         .IR_WE          (ir_we),
                         .RF_WE          (rf_we),
                         .RF_WDATA_SEL   (rf_wdata_sel),
                         .IMM_SEL        (imm_sel),
                         .CSR_WE         (csr_we),
                         .ALUA_SEL       (alua_sel),
                         .ALUB_SEL       (alub_sel),
                         .OP_MODE        (op_mode),
                         .IS_BRANCH      (is_branch)
                     );
            //================================================

            //PC MAP==========================================
            assign pc_en = pc_we | br_flg;

            prgm_cntr PC(
                          .CLK    (GCLK),
                          .RST    (MRST),
                          .WE     (pc_en),
                          .PC_IN  (alu_out),
                          .PC_OUT (pc_out)
                      );
            //================================================

            //MEMORY MAP======================================
            assign mem_ena = mem_we | mem_re;

            always_comb begin : MAS
                if ( mem_addr_sel ) begin
                    mem_addr <= alu_rslt;
                end
                else if ( ~mem_addr_sel ) begin
                    mem_addr <= pc_out;
                end
                else begin
                    mem_addr <= 'hx;
                end
            end

            memory MEM ( .clka  (GCLK),    // input wire clka
                         .ena   (mem_ena),      // input wire ena
                         .wea   (mem_we),      // input wire [0 : 0] wea
                         .addra (mem_addr),  // input wire [15 : 0] addra
                         .dina  (x2),    // input wire [31 : 0] dina
                         .douta (mem_out) );  // output wire [31 : 0] douta
            //================================================

            //IR MAP==========================================
            instruct_reg IR(
                             .CLK       (GCLK),
                             .RST       (MRST),
                             .WE        (ir_we),
                             .IR_IN     (mem_out),
                             .IR_OUT    (ir)
                         );
            //================================================

            //IMM GEN MAP=====================================
            imm_gen IMM_GEN(
                        .IMM_FIELD(ir[31:7]),
                        .IMM_SEL(imm_sel),
                        .EXT_IMM(ext_imm)
                    );
            //================================================

            //RF MAP==========================================
            always_comb begin : RF_WDATA
                case(rf_wdata_sel)
                    RFWS_ALU_RSLT:
                        rf_wdata <= alu_rslt;
                    RFWS_MEM_OUT:
                        rf_wdata <= mem_out;
                    RFWS_CSR:
                        rf_wdata <= csr0;
                    default:
                        rf_wdata <= 'hx;
                endcase
            end

            reg_file RF(
                         .CLK   (GCLK),
                         .RST   (MRST),
                         .WE    (rf_we),
                         .WA    (ir[11:7]),
                         .RA1   (ir[19:15]),
                         .RA2   (ir[24:20]),
                         .WD    (rf_wdata),
                         .X1    (x1),
                         .X2    (x2)
                     );
            //================================================


            //ALU CTRL MAP====================================
            alu_ctrl ALU_CTRL (
                         .FUNCT3    (ir[14:12]),
                         .FUNCT7    (ir[31:25]),
                         .OP_MODE    (op_mode),
                         .ALU_SEL   (alu_sel)
                     );
            //================================================

            //ALU MAP=========================================
            always_comb begin : ALU_A
                case(alua_sel)
                    A_X1:
                        alu_a <= x1;
                    A_PC:
                        alu_a <= pc_out;
                    default:
                        alu_a <= 'hx;
                endcase
            end

            always_comb begin : ALU_B
                case(alub_sel)
                    B_X2:
                        alu_b <= x2;
                    B_FOUR:
                        alu_b <= 'h4;
                    B_EXT_IMM:
                        alu_b <= ext_imm;
                    default:
                        alu_b <= 'hx;
                endcase
            end

            always_ff @( posedge GCLK ) begin : ALU_RSLT
                if ( MRST ) begin
                    alu_rslt <= 'h0;
                end
                else begin
                    alu_rslt <= alu_out;
                end
            end

            alu ALU(
                    .A(alu_a),
                    .B(alu_b),
                    .SEL(alu_sel),
                    .C(alu_out),
                    .EQ(alu_flg_out[5]),
                    .NE(alu_flg_out[4]),
                    .LT(alu_flg_out[3]),
                    .LTU(alu_flg_out[2]),
                    .GE(alu_flg_out[1]),
                    .GEU(alu_flg_out[0])
                );

            always_ff @( posedge GCLK ) begin : FLAG_REG
                if (MRST) begin
                    flag <= 'h0;
                end
                else begin
                    flag <= alu_flg_out;
                end
            end

            always_comb begin : FLAG_SEL
                case(ir[14:12])
                    BEQ:
                        sel_flag <= flag[5];
                    BNE:
                        sel_flag <= flag[4];
                    BLT:
                        sel_flag <= flag[3];
                    BLTU:
                        sel_flag <= flag[2];
                    BGE:
                        sel_flag <= flag[1];
                    BGEU:
                        sel_flag <= flag[0];
                    default:
                        sel_flag <= 'hx;
                endcase
            end

            always_comb begin : BRANCH_SEL
                if (is_branch) begin
                    br_flg <= sel_flag;
                end
                else if (~is_branch) begin
                    br_flg <= 'h0;
                end
                else begin
                    br_flg <= 'hx;
                end
            end
            //================================================

        endmodule

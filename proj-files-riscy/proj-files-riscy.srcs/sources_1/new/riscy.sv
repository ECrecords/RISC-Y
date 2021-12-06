`timescale 1ns / 1ps

`ifndef global
`define global
`include "global.svh"
`endif

module riscy(
        input GCLK,
        input MRST,
        input [7:0] SW,
        output [7:0] LED
    );

    //CONTROL UNIT======================================
    ctrl_unt CU(
                 .CLK            (GCLK),
                 .RST            (MRST),
                 .OPCODE         (),
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
                 .IS_BRANCH      (is_branch)
             );
    //================================================

    //PROGRAM COUNTER=================================
    prgm_cntr PC(
                  .CLK    (GCLK),
                  .RST    (MRST),
                  .WE     (pc_we),
                  .PC_IN  (),
                  .PC_OUT (pc_out)
              );
    //================================================

    //MEMORY==========================================
    reg [15:0] mem_addr;
    reg [DATA_WIDTH-1:0] alu_rslt;
    reg mem_ena;

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

    memory MEM ( .clka(GCLK),    // input wire clka
                 .ena(mem_en),      // input wire ena
                 .wea(mem_re),      // input wire [0 : 0] wea
                 .addra(mem_addr),  // input wire [15 : 0] addra
                 .dina(),    // input wire [31 : 0] dina
                 .douta(mem_out) );  // output wire [31 : 0] douta
    //================================================

    //REGISTER FILE===================================
    reg_file RF(
                 .CLK(GCLK),
                 .RST(MRST),
                 .WE(rf_we),
                 .WA(),
                 .RA1(),
                 .RA2(),
                 .WD(),
                 .X1(x1),
                 .X2(x2)
             );
    //================================================             

    //ALU=============================================
    reg [DATA_WIDTH-1:0] alu_a;
    reg [DATA_WIDTH-1:0] alu_b;

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
    
    always_ff @( posedge GCLK ) begin : ALU_RSLT
        if ( MRST ) begin
            alu_rslt <= 'h0;
        end
        else begin
            alu_rslt <= alu_out;
        end
    end

    alu ALU(
            .A(),
            .B(),
            .SEL(),
            .C(alu_out),
            .EQ(),
            .NE(),
            .LT(),
            .LTU(),
            .GE(),
            .GEU()
        );

    //---=============================================


    instruct_reg IR();    


endmodule

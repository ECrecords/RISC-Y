`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2021 03:21:15 PM
// Design Name: 
// Module Name: tb_ctrl_unt
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


module tb_ctrl_unt;

localparam CLK_PERIOD = 10;
reg         gclk;
reg         mrst;
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
reg  [6:0]  opcode;

ctrl_unt CU (
.CLK            (gclk),
.RST            (mrst),
.OPCODE         (opcode),
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

initial begin
    gclk <= 0;
    forever begin
        #(CLK_PERIOD/2) gclk <= ~gclk;
    end
end

initial begin
    mrst <= 1;
    opcode <= 7'b1110011;
    #CLK_PERIOD mrst <= 0;
end

endmodule

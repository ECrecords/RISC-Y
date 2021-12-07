# RISC-Y

## Pyhon Assembler

Assembler still needs work, currently code needs to be hard coded into the script  
to generate a ```coe``` file.

[assembler.py][assembler.py]  

## COE Files

Simulation Program: [memory_sim.coe](memory_sim.coe)  

Zedboard Program: [memory_zedboard.coe](memory_zedboard.coe)  

## SystemVerilog Design Code

Zedboared Interface: [top_zedboard.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/top_zedboard.sv)  

Global Constant: [global.svh](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/global.svh)  

Top Module (RISC-Y): [riscy.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/riscy.sv)  

Control Unit: [ctrl_unt.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/ctrl_unt.sv)  

Program Counter: [prgm_cntr.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/prgm_cntr.sv)  

Memory: Vivado IP was used for the processor's memory.  

Instruction Register: [prgm_cntr.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/instruct_reg.sv)  

Register File: [reg_file.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/reg_file.sv)

Immediate Gennerator: [imm_gen.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/imm_gen.sv)  

ALU Controller: [alu_ctrl.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/alu_ctrl.sv)  

ALU: [alu.sv](proj-files-riscy/proj-files-riscy.srcs/sources_1/new/alu.sv)  

## SystemVerilog Test-bench Code

RISC-Y: [tb_riscy.sv](proj-files-riscy/proj-files-riscy.srcs/sim_1/new/tb_riscy.sv)

ALU: [tb_alu.sv](proj-files-riscy/proj-files-riscy.srcs/sim_1/new/tb_alu.sv)

Control Unit: [tb_ctrl_unt.sv](proj-files-riscy/proj-files-riscy.srcs/sim_1/new/tb_ctrl_unt.sv)

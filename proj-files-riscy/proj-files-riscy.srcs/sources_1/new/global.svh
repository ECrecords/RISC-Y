
parameter DATA_WIDTH = 32;
parameter ALU_SEL = 4;

//ALU OPERATIONS===========
parameter ALU_ADD = 0;
parameter ALU_SLT = 1;
parameter ALU_SLTU = 2;
parameter ALU_AND = 3;
parameter ALU_OR = 4;
parameter ALU_XOR = 5;
parameter ALU_SLL = 6;
parameter ALU_SRL = 7;
parameter ALU_SUB = 8;
parameter ALU_SRA = 9;
//=======================

//OPERATION MODE=========
parameter OP_IMM   = 3'b000;
parameter OP       = 3'b001;
parameter JAL      = 3'b010;
parameter BRANCH   = 3'b011;
parameter LOAD     = 3'b100;
parameter STORE    = 3'b101;
parameter SYSTEM   = 3'b110;
parameter NOP      = 3'b111;
//=======================


//=======================
//PRGM CNTR
//==MEM_ADDR_SEL OPTIONS
parameter MAS_PC         = 1'h0;
parameter MAS_ALU_RSLT    = 1'h1;
//=======================

//=======================
//CTRL UNIT
//==ALUA_SEL OPTIONS
parameter A_X1         = 1'h0;
parameter A_PC         = 1'h1;
//==ALUB_SEL OPTIONS
parameter B_X2         = 2'h0;
parameter B_FOUR       = 2'h1;
parameter B_EXT_IMM    = 2'h2;
//=======================

//=======================
//RF_WDATA_SEL OPTIONS
parameter RFWS_ALU_RSLT = 2'h0;
parameter RFWS_MEM_OUT = 2'h1;
parameter RFWS_CSR     = 2'h2;
//=======================

//=======================
//IMM_SEL OPTIONS
parameter I_IMM = 3'h0;
parameter S_IMM = 3'h1;
parameter B_IMM = 3'h2;
parameter U_IMM = 3'h4;
parameter J_IMM = 3'h5;
//=======================

//=======================
//FUNCT3 ENCODING
parameter ADD = 0;
parameter SUB = 0;
parameter SLT = 1;
parameter SLTU = 2;
parameter AND = 3;
parameter OR = 4;
parameter XOR = 5;
parameter SLL = 6;
parameter SRL = 7;
parameter SRA = 7;
//=======================

//=======================
//FUNCT7 ENCODING
parameter F7_EN0 = 7'h0;
parameter F7_EN1 = 7'h32;
//=======================

//=======================
//Memory Address Width
parameter MEM_ADDR_WIDTH = 16;

//FUNCT3 ENCODING BRANCH
parameter BEQ   = 3'h0;
parameter BNE   = 3'h1;
parameter BLT   = 3'h2;
parameter BLTU  = 3'h3;
parameter BGE   = 3'h4;
parameter BGEU  = 3'h5;

//SW_SEL SWITCH CSR1
parameter LOWER_HALFWORD_0BYTE = 4'b0001;
parameter LOWER_HALFWORD_1BYTE = 4'b0011;
parameter UPPER_HALFWORD_0BYTE = 4'b0111;
parameter UPPER_HALFWORD_1BYTE = 4'b1111;

//SW_SEL SWITCH 
parameter L_HALFWORD_0NIBBLE = 4'b0001;
parameter L_HALFWORD_1NIBBLE = 4'b0011;
parameter L_HALFWORD_2NIBBLE = 4'b0111;
parameter L_HALFWORD_3NIBBLE = 4'b1111;

//OP MODES
parameter OPM_FETCH = 3'h0;
parameter OPM_OP = 3'h1;
parameter OPM_OPIMM = 3'h2;
parameter OPM_JAL = 3'h3;
parameter OPM_BRANCH = 3'h4;
parameter OPM_LOAD_STORE = 3'h5;
parameter OPM_NOP = 3'h6;

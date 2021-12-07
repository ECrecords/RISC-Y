`timescale 1ns / 100ps

`ifndef global
`define global
`include "global.svh"
`endif

        module ctrl_unt(
                input               CLK,
                input               RST,
                input      [6:0]    OPCODE,
                output reg          PC_WE,
                output reg          MEM_ADDR_SEL,
                output reg          MEM_WE,
                output reg          MEM_RE,
                output reg          IR_WE,
                output reg          RF_WE,
                output reg [1:0]    RF_WDATA_SEL,
                output reg [2:0]    IMM_SEL,
                output reg          CSR_WE,
                output reg          ALUA_SEL,
                output reg [1:0]    ALUB_SEL,
                output reg [2:0]    OP_MODE,
                output reg          IS_BRANCH
            );

            typedef enum {  FETCH, FETCH2, DECODE,
                            EX_OP_IMM, EX_OP, EX_JAL, EX_BRANCH, EX_LOAD, EX_STORE, EX_SYSTEM, EX_NOP,
                            MEM_LOAD, MEM_STORE,
                            WB_OP, WB_LOAD, WB_SYSTEM,
                            ERROR } T_STATE;

            T_STATE curr_state, nx_state;

            always_ff @( posedge CLK ) begin : STATE_SEL
                if ( RST ) begin
                    curr_state <= FETCH;
                end
                else begin
                    curr_state <= nx_state;
                end
            end

            wire [2:0] opcode;
            assign opcode = OPCODE[4:2];

            always_comb begin : NX_STATE
                case(curr_state)
                    FETCH:
                        nx_state <= FETCH2;
                    FETCH2:
                        nx_state <= DECODE;
                    DECODE: begin
                        if (opcode == OP_IMM )
                            nx_state <= EX_OP_IMM;

                        else if (opcode == OP)
                            nx_state <= EX_OP;

                        else if (opcode == JAL)
                            nx_state <= EX_JAL;

                        else if (opcode == BRANCH)
                            nx_state <= EX_BRANCH;

                        else if (opcode == LOAD)
                            nx_state <= EX_LOAD;

                        else if (opcode == STORE)
                            nx_state <= EX_STORE;

                        else if (opcode == SYSTEM)
                            nx_state <= EX_SYSTEM;

                        else if (opcode == NOP)
                            nx_state <= EX_NOP;

                        else
                            nx_state <= ERROR;
                    end
                    EX_OP_IMM:
                        nx_state <= WB_OP;
                    EX_OP :
                        nx_state <= WB_OP;
                    EX_JAL:
                        nx_state <= FETCH;
                    EX_BRANCH:
                        nx_state <= FETCH;
                    EX_LOAD:
                        nx_state <= MEM_LOAD;
                    EX_STORE:
                        nx_state <= MEM_STORE;
                    EX_SYSTEM:
                        nx_state <= WB_SYSTEM;
                    EX_NOP:
                        nx_state <= FETCH;
                    MEM_LOAD:
                        nx_state <= WB_LOAD;
                    WB_OP:
                        nx_state <= FETCH;
                    WB_LOAD:
                        nx_state <= FETCH;
                    WB_SYSTEM:
                        nx_state <= FETCH;
                    default:
                        nx_state <= ERROR;
                endcase
            end

            always_comb begin : OUTPUT_LOGIC
                case(curr_state)
                    FETCH: begin
                        //=========================
                        //PC
                        PC_WE               <= 1;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 1;
                        MEM_ADDR_SEL        <=  MAS_PC;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= A_PC;
                        ALUB_SEL            <= B_FOUR;
                        OP_MODE             <= OPM_FETCH;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    FETCH2: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 1;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 1;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    DECODE: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= A_X1;
                        ALUB_SEL            <= B_X2;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    EX_OP_IMM: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= I_IMM;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= A_X1;
                        ALUB_SEL            <= B_EXT_IMM;
                        OP_MODE             <= OPM_OPIMM;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    EX_OP : begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= A_X1;
                        ALUB_SEL            <= B_X2;
                        OP_MODE             <= OPM_OP;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    EX_JAL: begin
                        //=========================
                        //PC
                        PC_WE               <= 1;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= J_IMM;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= A_PC;
                        ALUB_SEL            <= B_EXT_IMM;
                        OP_MODE             <= OPM_JAL;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    EX_BRANCH: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= B_IMM;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU

                        ALUA_SEL            <= A_PC;
                        ALUB_SEL            <= B_EXT_IMM;
                        OP_MODE             <= OPM_BRANCH;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 1;
                        //=========================
                    end
                    EX_LOAD: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= I_IMM;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= A_X1;
                        ALUB_SEL            <= B_EXT_IMM;
                        OP_MODE             <= OPM_LOAD_STORE;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end

                    EX_STORE: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= S_IMM;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU

                        ALUA_SEL            <= A_X1;
                        ALUB_SEL            <= B_EXT_IMM;
                        OP_MODE             <= OPM_LOAD_STORE;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end

                    EX_SYSTEM: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 1;
                        //=========================
                        //ALU
                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    EX_NOP: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 0;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= OPM_NOP;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    MEM_LOAD: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 1;
                        MEM_ADDR_SEL        <= MAS_ALU_RSLT;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic

                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    MEM_STORE: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 1;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= MAS_ALU_RSLT;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    WB_OP: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 1;
                        RF_WDATA_SEL        <= RFWS_ALU_RSLT;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU

                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    WB_LOAD: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 1;
                        RF_WDATA_SEL        <= RFWS_MEM_OUT;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    WB_SYSTEM: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 0;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 0;
                        //=========================
                        //Reg File
                        RF_WE               <= 1;
                        RF_WDATA_SEL        <= RFWS_CSR;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                    default: begin
                        //=========================
                        //PC
                        PC_WE               <= 0;
                        //=========================
                        //Memory
                        MEM_WE              <= 0;
                        MEM_RE              <= 0;
                        MEM_ADDR_SEL        <= 'hx;
                        //=========================
                        //Intruct Reg
                        IR_WE               <= 'h0;
                        //=========================
                        //Reg File
                        RF_WE               <= 0;
                        RF_WDATA_SEL        <= 'hx;
                        //=========================
                        //Imm Gen
                        IMM_SEL             <= 'hx;
                        //=========================
                        //CSR
                        CSR_WE              <= 0;
                        //=========================
                        //ALU
                        ALUA_SEL            <= 'hx;
                        ALUB_SEL            <= 'hx;
                        OP_MODE             <= 'hx;
                        //=========================
                        //Branch Logic
                        IS_BRANCH           <= 0;
                        //=========================
                    end
                endcase
            end
        endmodule



opcode = {
    "OP_IMM"    : "1100011",
    "OP"        : "1100111",
    "JAL"       : "1101011",
    "BRANCH"    : "1101111",
    "LOAD"      : "1110011",
    "STORE"     : "1110111",
    "SYSTEM"    : "1111011",
    "NOP"       : "1111111",
}

funct7 = {
    "OP0": "0000000",
    "OP1": "0100000"
}

op_funct3 = {
    "ADD":   [funct7["OP0"], "000"],
    "SUB":   [funct7["OP1"], "000"],
    "SLT":   [funct7["OP0"], "001"],
    "SLTU":   [funct7["OP0"], "010"],
    "AND":   [funct7["OP0"], "011"],
    "OR":   [funct7["OP0"], "100"],
    "XOR":   [funct7["OP0"], "101"],
    "SLL":   [funct7["OP0"], "110"],
    "SRL":   [funct7["OP0"], "111"],
    "SRA":   [funct7["OP1"], "111"],
}

branch_funct3 = {
    "BEQ": "000",
    "BNE": "001",
    "BLT": "010",
    "BLTU": "011",
    "BLE": "100",
    "BLEU": "101"
}

op_imm_funct3 = {
    "ADDI": "000",
    "SLTI": "001",
    "SLTIU": "010",
    "ANDI": "011",
    "ORI": "100",
    "XORI": "101",
    "SLLI": "110",
    "SRLI": [funct7["OP0"], "111"],
    "SRAI": [funct7["OP1"], "111"],
}


def bindigits(n, bits):
    s = bin(n & int("1"*bits, 2))[2:]
    return ("{0:0>%s}" % (bits)).format(s)


def op(funct3, rd, rs1, rs2):
    return op_funct3[funct3][0] + "{0:05b}".format(rs2) + "{0:05b}".format(rs1) + op_funct3[funct3][1] + "{0:05b}".format(rd) + opcode["OP"] + ",\n"


def op_imm(funct3, rd, rs1, imm):
    bin_imm = bindigits(imm, 12)
    if funct3 == "SRLI" or funct3 == "SRLI":
        return op_imm_funct3[funct3][0] + "{0:05b}".format(imm) + "{0:05b}".format(rs1) + op_imm_funct3[funct3][1] + "{0:05b}".format(rd) + opcode["OP_IMM"] + ",\n"
    else:
        return bin_imm + "{0:05b}".format(rs1) + op_imm_funct3[funct3] + "{0:05b}".format(rd) + opcode["OP_IMM"] + ",\n"


def branch(funct3, rs1, rs2, imm):
    bin_imm = bindigits(imm, 12)
    return bin_imm[0] + bin_imm[2:8] + "{0:05b}".format(rs2) + "{0:05b}".format(rs1) + branch_funct3[funct3] + bin_imm[8:] + bin_imm[1] + opcode["BRANCH"] + ",\n"


def jal(rd, imm):
    bin_imm = bindigits(imm, 20)
    return bin_imm[0] + bin_imm[10:] + bin_imm[9] + bin_imm[1:9] + "{0:05b}".format(rd) + opcode["JAL"] + ",\n"


def align():
    zeros = "{0:032b}".format(0)
    return zeros + ",\n" + zeros + ",\n" + zeros + ",\n"


def load(rd, rs1, imm):
    return bindigits(imm, 12) + "{0:05b}".format(rs1) + "000" + "{0:05b}".format(rd) + opcode["LOAD"] + ",\n"


def store(rs1, rs2, imm):
    bin_imm = "{0:012b}".format(imm)
    return bin_imm[0:7] + "{0:05b}".format(rs2) + "{0:05b}".format(rs1) + "000" + bin_imm[7:] + opcode["STORE"] + ",\n"


def system(rd, rs1):
    return "{0:012b}".format(0) + "{0:05b}".format(rs1) + "000" + "{0:05b}".format(rd) + opcode["SYSTEM"] + ",\n"

def nop():
    return "{0:025b}".format(0) + opcode["NOP"] + ",\n"

def write_mem(value):
    return bindigits(value, 32) + "\n"


def write_coe():
    with open('memory_sim.coe', 'w') as f:
        f.write("memory_initialization_radix=2;\n memory_initialization_vector=\n")
        # f.write(load(1, 0, 64))
        # f.write(align())
        # f.write(op_imm("ADDI", 2, 0, 1))
        # f.write(align())
        # f.write(op_imm("ADDI", 5, 0, 31))
        # f.write(align())
        # f.write(op("ADD", 6, 0, 0))
        # f.write(align())
        # f.write(op_imm("ADDI", 4, 0, 1))
        # f.write(align())
        # f.write(op("ADD", 3, 0, 0))
        # f.write(align())
        # f.write(op("ADD", 3, 2, 3))
        # f.write(align())
        # f.write(branch("BNE", 3, 1, -4))
        # f.write(align())
        # f.write(system(0, 4))
        # f.write(align())
        # f.write(op("SLL", 4, 4, 2))
        # f.write(align())
        # f.write(op("ADD", 6, 6, 2))
        # f.write(align())
        # f.write(branch("BNE", 6, 5, -14))
        # f.write(align())
        # f.write(jal(0, -20))
        # f.write(align())
        # f.write(nop())
        # f.write(align())
        # f.write(nop())
        # f.write(align())
        # f.write(nop())
        # f.write(align())
        # f.write(write_mem(3125000))
        # f.write(align())

        f.writelines(op_imm("ADDI", 3, 0, 512))
        f.write(align())
        f.write(op_imm("ADDI", 4, 0, 1))
        f.write(align())
        f.write(op("ADD", 5, 4, 5))
        f.write(align())
        f.write(system(0,5))
        f.write(align())
        f.write(branch("BNE", 5, 3, -6))
        f.write(align())
        f.write(nop())
        f.write(align())
        f.write(jal(0, -4))
        f.write(align())


write_coe()

import sys

# ---------------- OPCODES ----------------

OPCODES = {
    "NOP":  "000000",
    "ADD":  "000001",
    "SUB":  "000010",
    "ADDI": "000011",
    "SUBI": "000100",
    "CMP":  "000101",
    "JMP":  "000110",
    "JEQ":  "000111",
    "JNE":  "001000",
    "JLT":  "010001",
    "JGT":  "010010",
    "MOV":  "010011",
    "LDA":  "010100",
    "STR":  "010101",
    "HLT":  "111111",
}

R_TYPE = {"ADD", "SUB", "CMP", "MOV"}
I_TYPE = {"ADDI", "SUBI"}
MEM_TYPE = {"LDA", "STR"}
J_TYPE = {"JMP", "JEQ", "JNE", "JLT", "JGT"}
NOP_TYPE = {"NOP", "HLT"}

REGISTER_LIST = {f"R{i}": format(i, "04b") for i in range(16)}

def tokenize(line):
    line = line.replace(",", " ")
    return [x.upper() for x in line.split() if x]

def clean_line(line):
    return line.split(";")[0].strip()

def bin_to_hex(bin_str):
    return format(int(bin_str, 2), "08X")

def reg(token):
    if token not in REGISTER_LIST:
        raise ValueError(f"Invalid register: {token}")
    return REGISTER_LIST[token]

def imm18(value):
    return format(int(value, 0) & 0x3FFFF, "018b")

def jimm26(value):
    return format(int(value, 0) & 0x3FFFFFF, "026b")

def encode_r(opcode, rd, rs1, rs2):
    return opcode + reg(rd) + reg(rs1) + reg(rs2) + ("0" * 14)

def encode_i(opcode, rd, rs1, imm):
    return opcode + reg(rd) + reg(rs1) + imm18(imm)

def encode_mem(opcode, rd, rs1, rs2):
    return opcode + reg(rd) + reg(rs1) + reg(rs2) + ("0" * 14)

def encode_j(opcode, offset):
    return opcode + jimm26(offset)

def assemble_line(line):
    line = clean_line(line)
    if not line:
        return None

    parts = tokenize(line)
    mnemonic = parts[0]

    if mnemonic in NOP_TYPE:
        return bin_to_hex(OPCODES[mnemonic] + ("0" * 26))

    if mnemonic in {"ADD", "SUB"}:
        if len(parts) != 4:
            raise ValueError(f"{mnemonic} expects: rd rs1 rs2")
        _, rd, rs1, rs2 = parts
        return bin_to_hex(encode_r(OPCODES[mnemonic], rd, rs1, rs2))

    if mnemonic == "CMP":
        if len(parts) != 3:
            raise ValueError("CMP expects: rs1 rs2")
        _, rs1, rs2 = parts
        return bin_to_hex(encode_r(OPCODES[mnemonic], "R0", rs1, rs2))

    if mnemonic == "MOV":
        if len(parts) != 3:
            raise ValueError("MOV expects: rd rs")
        _, rd, rs = parts
        return bin_to_hex(encode_r(OPCODES[mnemonic], rd, rs, "R0"))

    if mnemonic in {"ADDI", "SUBI"}:
        if len(parts) != 4:
            raise ValueError(f"{mnemonic} expects: rd rs1 imm")
        _, rd, rs1, imm = parts
        return bin_to_hex(encode_i(OPCODES[mnemonic], rd, rs1, imm))

    if mnemonic == "LDA":
        if len(parts) != 3:
            raise ValueError("LDA expects: rd rs1")
        _, rd, rs1 = parts
        return bin_to_hex(encode_mem(OPCODES[mnemonic], rd, rs1, "R0"))

    if mnemonic == "STR":
        if len(parts) != 3:
            raise ValueError("STR expects: rs1 rs2")
        _, rs1, rs2 = parts
        return bin_to_hex(encode_mem(OPCODES[mnemonic], "R0", rs1, rs2))

    if mnemonic in J_TYPE:
        if len(parts) != 2:
            raise ValueError(f"{mnemonic} expects: offset")
        _, offset = parts
        return bin_to_hex(encode_j(OPCODES[mnemonic], offset))

    raise ValueError(f"Unknown instruction: {mnemonic}")

def assemble_file(input_file, output_file):
    with open(input_file, "r") as f:
        lines = f.readlines()

    output = []
    for i, line in enumerate(lines):
        try:
            result = assemble_line(line)
            if result:
                output.append(result)
        except Exception as e:
            raise Exception(f"Error on line {i+1}: {line.strip()}\n{e}")

    with open(output_file, "w") as f:
        for line in output:
            f.write(line + "\n")

    print(f"[OK] Assembled {len(output)} instructions -> {output_file}")

def main():
    input_file = None
    output_file = "program.hex"

    args = sys.argv[1:]
    i = 0

    while i < len(args):
        if args[i] == "-f":
            input_file = args[i + 1]
            i += 2
        elif args[i] == "-o":
            output_file = args[i + 1]
            i += 2
        else:
            print(f"Unknown argument: {args[i]}")
            return

    if not input_file:
        print("Usage: python assembler.py -f input.asm -o output.hex")
        return

    assemble_file(input_file, output_file)

if __name__ == "__main__":
    main()
# Custom 32-bit CPU ISA (Option A - RISC Style)

## Overview
This CPU uses a fixed 32-bit instruction length.

- 16 registers (R0–R15)
- 4-bit register addressing
- 3 instruction formats: R-type, I-type, J-type

---

# Instruction Formats

## 1. R-Type (Register-Register)

Used for:
- ADD
- SUB
- CMP
- AND
- OR

Bit layout:

opcode = bits 31 to 26 (6 bits)  
rd     = bits 25 to 22 (4 bits)  
rs1    = bits 21 to 18 (4 bits)  
rs2    = bits 17 to 14 (4 bits)  
unused = bits 13 to 0  (14 bits)

Meaning:
rd = rs1 op rs2

---

## 2. I-Type (Immediate)

Used for:
- ADDI
- SUBI
- LOAD (future use)
- immediate arithmetic

Bit layout:

opcode = bits 31 to 26 (6 bits)  
rd     = bits 25 to 22 (4 bits)  
rs1    = bits 21 to 18 (4 bits)  
imm    = bits 17 to 0  (18 bits signed)

Meaning:
rd = rs1 op imm

---

## 3. J-Type (Jump / Branch)

Used for:
- JMP
- JEQ
- JNE
- JGT
- JLT

Bit layout:

opcode  = bits 31 to 26 (6 bits)  
offset  = bits 25 to 0  (26 bits signed)

Meaning:
PC = PC + offset

---

# Opcode Table

NOP  = 000000  
ADD  = 000001  
SUB  = 000010  
ADDI = 000011  
SUBI = 000100  
CMP  = 000101  
JMP  = 000110  
JEQ  = 000111
JNE  = 010000
JLT  = 010001
JGT  = 010010
MOV  = 010011
LDA  = 010100
STR  = 010101




HLT  = 111111
---

# Execution Model

R-Type:
- uses rs1 and rs2
- writes result to rd

I-Type:
- uses rs1 and imm
- writes result to rd

J-Type:
- modifies program counter
- does not write to registers

---

# Design Rules

- fixed 32-bit instructions
- 4-bit registers (16 total)
- no overlapping fields
- same format, different interpretation depending on opcode
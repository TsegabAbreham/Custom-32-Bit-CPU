# Quick Overview

The Logisim CPU consists of several components:

- **RAM (16M × 41)** – stores instructions  
- **PC (Program Counter)** – increments through instructions in RAM  
- **CU (Control Unit)** – controls instruction flow (explained later)  
- **32-bit Registers** – 8 general-purpose registers  
- **ALU (Arithmetic Logic Unit)** – 32-bit unit supporting:
  - Addition
  - Subtraction
  - Multiplication
  - Comparisons (greater than, equal, less than)

- **MAR & MDR (Memory Address/Data Registers)** – interface with external memory and enable memory-mapped I/O

---

## CPU Overview Screenshot

<img width="2078" height="916" alt="image" src="https://github.com/user-attachments/assets/7594d522-93de-44b0-bcb9-89888a1fd262" />


---

# Component Details

## RAM (16M × 41)

The RAM stores up to **16 million instructions**, each **41 bits** long (explained below).

---

## PC (Program Counter)

The Program Counter increments through instruction addresses in RAM.

Each instruction takes approximately **4 clock cycles** to execute, making it slower than modern architectures like x86 or ARM.

This CPU uses a **ring counter (one-hot counter)** instead of binary counting.

Instead of:

0001 → 0010 → 0011 → 0100 → 0101


It uses:

0000 → 0010 → 0100 → 1000


In other words, a single bit shifts left each cycle.

---

## Instruction Format & Control Unit (CU)

Each instruction is **41 bits**, structured as:


[ 4-bit OPCODE ] [ 4-bit DEST ] [ 1-bit MODE ] [ 32-bit SOURCE ]


### Breakdown:

### 1. Opcode (4 bits)

Supports 16 instructions:

- NOP (0) – Do nothing  
- ADD (1) – Add two numbers  
- SUB (2) – Subtract two numbers  
- MUL (3) – Multiply two numbers  
- MOV (4) – Move value between registers or immediate  
- OUT (5) – Output to external components  
- HLT (6) – Halt execution until interrupted  
- JMP (7) – Jump to an address in RAM  
- CMP (8) – Compare two values  
- JE (9) – Jump if equal  
- JNE (10) – Jump if not equal  
- JG (11) – Jump if greater than  
- JL (12) – Jump if less than  
- LDA (13) – Load from memory  
- STR (14) – Store to memory  

---

### 2. Destination Register (4 bits)

Specifies the destination register (R0–R8).

---

### 3. Mode Bit (1 bit)

Defines how the source operand is interpreted:

- 0 → Immediate value  
- 1 → Register value  

This avoids needing separate immediate instructions like `ADDI` or `SUBI`.

---

### 4. Source (32 bits)

The source operand, which can be:

- A 32-bit immediate value  
- A register value (if Mode = 1)

---

## Example Instruction

### Assembly:

ADD R0, R1


### Binary (41-bit format):

[OPCODE ADD] [DEST R0] [MODE = register] [SOURCE R1]

0001 0000 1 00000000000000000000000000000001


### Hex representation:

21 0000 0001

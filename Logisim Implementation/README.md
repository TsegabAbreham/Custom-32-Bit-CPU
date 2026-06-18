# Quick Overview
The Logisim CPU consists different components those being:
 - RAM (16M x 41) for instruction holding 
 - PC (Program Counter) Counter for incrementing each instruction in the RAM
 - CU (Control Unit) controls the flow of instruction, more about it later.
 - 32-bit Registers - consists a total of 8 general purpose registers
 - ALU (Arthmetic Logic Unit) - A 32-bit ALU capable of doing simple arthmetic like addition, subtraction, multiplication, and comparisions (greater than, equal, less than).
 - MAR AND MDR memories to communicate with outer memory, allows the connection of I/O devices through memory mapping.

The totally hand-wired CPU screenshot overview:
<img width="2078" height="916" alt="image" src="https://github.com/user-attachments/assets/556c87b0-b73e-44a2-b22c-599a0fed88dc" />

# Each Components Overview
## RAM (16M x 41)
The RAM is able to take in 16 million instructions each being 41 bits (more on that later).

## PC (Program Counter)
The Program Counter increments the instructions available in the RAM by one each time until that instruction is done executing. Each instruction takes about 4 clock cycles to complete making it slower than the mature CPU archthectures like x86 or ARM. It uses a concept called the ring counter or one-hot counter. This basically, instead of counting in traditional binary like 0001 -> 0010 -> 0011 -> 0100 -> 0101 and so on it counts like this: 0000 -> 0010 -> 0100 -> 1000, meaning the 1 shifts one place to the left on each clock cycle.

## Instructions and the Control Unit (CU)
In this CPU archthecture the instruction handling and the control unit follows a specific order. As mentioned before the CPU uses a RAM taking in a single instruction 41-bits long and here is why:
 -> The CPU splits this 41-bit long instruction into a 4, 4, 1, 32 bit format each serving a different purpose. 
      -> The first 4 bit split means the optcode. This CPU has a total of 16 instructions (4-bit) and those supported instructions are:
                   - NOP: Do nothing (0)
                   - ADD: Add two numbers (1)
                   - SUB: Subtract two numbers (2)
                   - MUL: Multiply two numbers (3)
                   - MOV: Move a number into a register or move a register value into another register (4)
                   - OUT: Send the output to the external components (5)
                   - HLT: Halt or stop CPU instruction execution until interrupted back again (6)
                   - JMP: Jump into a certain address in the RAM (7)
                   - CMP: compare two values (8)
                   - JE: Jump if equal (9)
                   - JNE: Jump if NOT equal (10)
                   - JG: Jump if greater than (11)
                   - JL: Jump if less than (12)
                   - LDA: Load from memory (13)
                   - STR: Store on memory (14)
      -> The second 4-bit represents the destination register (0-8) or where the value will end up when using the intruction like MOV or others.
      -> The third 1-bit represents the Mode (0-1), since the opcode is 4-bits and supports only 16 instructions adding new instructions like ADDI or SUBI is not ideal so instead there is a feature for Mode if 1 it means you are doing Register to Register interaction and if it is 0 you are doing a Immediate value to Register interaction.
      -> The final 32-bit is the Source. This could either be an immediate value or a register (if the Mode is 1) and acts like the value that gets to the destination register. 

-> Example instruction for adding two registers can be: 
        ADD R0, R1 turned into binary 41-bits: [OPCODE FOR ADD] 0001 [DESTINATION FOR R0] 0000 [MODE FOR REG TO REG] 1 [SOURCE FOR R1] 00000000000000000000000000000001
        so altogether... 0001 0000 1 00000000000000000000000000000001 or turned into hex: 21 0000 0001
        

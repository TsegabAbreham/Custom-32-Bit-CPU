module Decoder(
    input [31:0] instr,

    output [5:0] opcode,
    output [3:0] rd,
    output [3:0] rs1,
    output [3:0] rs2,
    output [17:0] imm
);

assign opcode = instr[31:26];

// R-type / I-type common fields
assign rd     = instr[25:22];
assign rs1    = instr[21:18];

// R-type only
assign rs2    = instr[17:14];

// I-type immediate (18-bit)
assign imm    = instr[17:0];

// J-type immediate (24-bits)


endmodule


module CU(
    input [5:0] opcode,
    input equal,
    input lessthan,
    input greaterthan,

    output reg ALU_src,
    output reg reg_write,
    output reg [3:0] ALU_op,
    output reg write_cmp,
    output reg pc_load,
    output reg [1:0] wb_sel,
    output reg mem_read,
    output reg mem_write,
    output reg hlt_signal
);

always @(*) begin
    // DEFAULTS - Reset all signals to prevent latches
    ALU_src    = 0;
    reg_write  = 0;
    ALU_op     = 4'b0000;
    write_cmp  = 0;
    pc_load    = 0;
    wb_sel     = 2'b00;
    mem_read   = 0;
    mem_write  = 0;
    hlt_signal = 0;

    case(opcode)
        6'b000000: reg_write = 0; // NOP

        6'b000001: begin // ADD
            ALU_op    = 4'b0001;
            reg_write = 1;
        end

        6'b000011: begin // ADDI
            ALU_src   = 1;
            ALU_op    = 4'b0001;
            reg_write = 1;
        end

        6'b000101: begin // CMP
            ALU_op    = 4'b0101;
            write_cmp = 1;
        end

        6'b000110: begin // JMP (Unconditional)
            pc_load   = 1;
        end

        6'b000111: begin // JEQ (Branch if Equal)
            if (equal) pc_load = 1;
        end

        6'b001000: begin // JNE
            if (!equal) pc_load = 1;
        end

        6'b010011: begin // MOV
            reg_write = 1;
            wb_sel    = 2'b01;
        end

        6'b010100: begin // LDA
            reg_write = 1;
            wb_sel    = 2'b10;
            mem_read  = 1;
        end

        6'b010101: begin // STR
            mem_write = 1;
        end

        6'b111111: begin // HLT
            hlt_signal = 1;
        end
        
        default: pc_load = 0;
    endcase
end

endmodule
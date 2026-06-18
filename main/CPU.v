module CPU(
    input clk,
    input reset
);

// ---------------- MEMORY / PC ----------------
wire mem_read, mem_write;
wire [31:0] mem_out;
wire PC_LOAD;
wire [10:0] NEXT_PC;
wire [10:0] PC_OUT;

PC pc(
    .clk(clk),
    .reset(reset),
    .pc_load(PC_LOAD),
    .next_pc(NEXT_PC),
    .pc(PC_OUT),
    .hlt_signal(halted)
);

// ---------------- INSTRUCTION FETCH ----------------
wire [31:0] INSTRUCTION;
IMEM instructionMemory(
    .addr(PC_OUT),
    .dout(INSTRUCTION)
);

wire [31:0] IR_OUT;
IR ir(
    .clk(clk),
    .reset(reset),
    .instr_in(INSTRUCTION),
    .IR_out(IR_OUT)
);

// ---------------- DECODER ----------------
wire [5:0] opcode;
wire [3:0] rd, rs1, rs2;
wire [17:0] imm;

Decoder decoder(
    .instr(IR_OUT),
    .opcode(opcode),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm)
);

// ---------------- REGISTER FILE ----------------
wire [31:0] regA, regB;
wire [31:0] alu_result;
wire [1:0] wb_sel;
wire reg_write;
wire [31:0] write_data;

assign write_data =
    (wb_sel == 2'b00) ? alu_result :
    (wb_sel == 2'b01) ? regA :
    (wb_sel == 2'b10) ? mem_out :
    32'b0;

// Debug wires for testbench monitoring
wire [31:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;

Reg_File RF(
    .clk(clk), .reset(reset), .reg_write(reg_write),
    .rs1(rs1), .rs2(rs2), .rd(rd),
    .write_data(write_data), .read_data1(regA), .read_data2(regB),
    .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7),
    .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15)
);

// ---------------- CMP FLAGS ----------------
// RENAMED: These match your testbench's "uut.equal_r" etc.
reg equal_r, less_r, greater_r; 
wire [1:0] cmp_result;
wire write_cmp;

always @(posedge clk) begin
    if (reset) begin
        equal_r   <= 0;
        less_r    <= 0;
        greater_r <= 0;
    end else if (write_cmp) begin
        equal_r   <= (cmp_result == 2'b00);
        greater_r <= (cmp_result == 2'b01);
        less_r    <= (cmp_result == 2'b10);
    end
end

// ---------------- CONTROL UNIT ----------------
wire ALU_src;
wire [3:0] ALU_op;

wire hlt_signal;
reg halted;

always @(posedge clk) begin
    if (hlt_signal)
        halted <= 1;   // latch halt forever
end

CU controlUnit(
    .opcode(opcode),
    .ALU_src(ALU_src),
    .reg_write(reg_write),
    .ALU_op(ALU_op),
    .write_cmp(write_cmp),
    .pc_load(PC_LOAD),
    .equal(equal_r),        // Connected to the regs above
    .lessthan(less_r),     // Connected to the regs above
    .greaterthan(greater_r), // Connected to the regs above
    .wb_sel(wb_sel),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .hlt_signal(hlt_signal)
);

// ---------------- ALU ----------------
wire signed [31:0] imm_sext = {{14{imm[17]}}, imm};
wire [31:0] operandB = (ALU_src) ? imm_sext : regB;

ALU alu(
    .NUM1(regA),
    .NUM2(operandB),
    .ALU_op(ALU_op),
    .OP(alu_result),
    .OPCMP(cmp_result)
);

// ------------- DATA MEMORY ----------------
wire [31:0] mem_addr = (mem_write || mem_read) ? alu_result : 32'b0;

EXT_RAM dataMem(
    .clk(clk), 
    .mem_read(mem_read), 
    .mem_write(mem_write),
    .addr(mem_addr),     // This should be the result of R2 + imm
    .write_data(regA),   // The color data in R1
    .read_data(mem_out)
);

// ---------------- JMP / BRANCH LOGIC ----------------

wire signed [31:0] pc_ext = {21'b0, PC_OUT};
wire signed [31:0] jump_sum = pc_ext + imm_sext;

assign NEXT_PC = (PC_LOAD) ? jump_sum[10:0] : (PC_OUT + 11'd1);

endmodule
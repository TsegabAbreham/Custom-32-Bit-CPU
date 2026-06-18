module testbench;

reg clk;
reg reset;

CPU uut(
    .clk(clk),
    .reset(reset)
);

// ---------------- CLOCK ----------------
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period (100MHz)
end

// ---------------- RESET ----------------
initial begin
    reset = 1;
    #12;
    reset = 0;
end

// ---------------- VCD DUMP ----------------
initial begin
    $dumpfile("build/cpu.vcd");
    $dumpvars(0, testbench);
end

// ---------------- HUMAN READABLE TRACE ----------------
always @(posedge clk) begin
    if (!reset) begin
        #1;
        $display("\n--------------------------------------------------");
        $display("TIME=%0t", $time);

        $display("PC=%0d  NEXT_PC=%0d  IR=%h  OPCODE=%b",
            uut.PC_OUT,
            uut.NEXT_PC,
            uut.IR_OUT,
            uut.opcode
        );

        $display("DECODE: rd=%0d rs1=%0d rs2=%0d imm=%0d",
            uut.rd, uut.rs1, uut.rs2, uut.imm
        );

        $display("CTRL: ALU_src=%b ALU_op=%b reg_write=%b pc_load=%b write_cmp=%b",
            uut.ALU_src, uut.ALU_op, uut.reg_write, uut.PC_LOAD, uut.write_cmp
        );

        $display("ALU: A=%0d B=%0d RESULT=%0d",
            uut.regA, uut.operandB, uut.alu_result
        );

        $display("FLAGS: EQ=%b LT=%b GT=%b RAW=%b",
            uut.equal_r, uut.less_r, uut.greater_r, uut.cmp_result
        );

        $display("REGS: R1=%0d R2=%0d R3=%0d R10=%0d R11=%0d R12=%0d R13=%0d R14=%0d",
            uut.r1, uut.r2, uut.r3,
            uut.r10, uut.r11, uut.r12, uut.r13, uut.r14
        );
    end
end

// ---------------- STOP (FIXED) ----------------
initial begin
    // Increased time to allow loops to finish. 
    // If you draw 400 pixels, you need at least 4000-5000 units.
    #10000; 
    $display("\nSimulation finished at time %0t.", $time);
    $finish;
end

endmodule
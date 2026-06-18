module Reg_File(
    input clk,
    input reset,

    input reg_write,

    input [3:0] rs1,
    input [3:0] rs2,
    input [3:0] rd,

    input [31:0] write_data,

    output reg [31:0] read_data1,
    output reg [31:0] read_data2,

    output [31:0] r0,  output [31:0] r1,
    output [31:0] r2,  output [31:0] r3,
    output [31:0] r4,  output [31:0] r5,
    output [31:0] r6,  output [31:0] r7,
    output [31:0] r8,  output [31:0] r9,
    output [31:0] r10, output [31:0] r11,
    output [31:0] r12, output [31:0] r13,
    output [31:0] r14, output [31:0] r15
);

    reg [31:0] regs [0:15];

    integer i;

    assign r0  = regs[0];
    assign r1  = regs[1];
    assign r2  = regs[2];
    assign r3  = regs[3];
    assign r4  = regs[4];
    assign r5  = regs[5];
    assign r6  = regs[6];
    assign r7  = regs[7];
    assign r8  = regs[8];
    assign r9  = regs[9];
    assign r10 = regs[10];
    assign r11 = regs[11];
    assign r12 = regs[12];
    assign r13 = regs[13];
    assign r14 = regs[14];
    assign r15 = regs[15];

    // READ
    always @(*) begin
        read_data1 = regs[rs1];
        read_data2 = regs[rs2];
    end

    // WRITE
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 16; i = i + 1)
                regs[i] <= 0;
        end
        else if (reg_write) begin
            regs[rd] <= write_data;
            $display("WRITE: r%0d = %0d", rd, write_data);
        end
    end

    // INIT
    initial begin
        for (i = 0; i < 16; i = i + 1)
            regs[i] = 0;
    end

endmodule
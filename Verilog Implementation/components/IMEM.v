module IMEM(
    input [31:0] din,
    input [10:0] addr,
    input clk,
    input WE,
    output reg [31:0] dout
);

reg [31:0] imem [0:2047];

always @(posedge clk) begin
    if (WE)
        imem[addr] <= din;
end

initial begin
    $readmemh("program/output/program.hex", imem);
end

always @(*) begin
    dout = imem[addr];
end



endmodule
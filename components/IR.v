module IR(
    input clk,
    input reset,
    input [31:0] instr_in,
    output reg [31:0] IR_out
);

always @(posedge clk) begin
    if (reset)
        IR_out <= 32'b0;
    else
        IR_out <= instr_in;
end

endmodule
module PC(
    input clk,
    input reset,
    input pc_load,
    input [10:0] next_pc,
    input hlt_signal,
    output reg [10:0] pc
);

always @(posedge clk) begin
    if (reset)
        pc <= 11'b0;
    else if (pc_load)
        pc <= next_pc;   // jump/branch
    else if (hlt_signal)
        pc <= pc;
    else
        pc <= pc + 1;    // normal execution
end

endmodule
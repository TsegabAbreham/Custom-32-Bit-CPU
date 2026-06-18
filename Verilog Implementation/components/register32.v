module reg #(
    parameter WIDTH = 32
)(
    input  [WIDTH-1:0] din,
    input  clk,
    input  reset,
    output reg [WIDTH-1:0] dout
);

always @(posedge clk) begin
    if (reset)
        dout <= {WIDTH{1'b0}};
    else
        dout <= din;
end

endmodule
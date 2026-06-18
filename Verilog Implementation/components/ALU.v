module ALU(
    input [31:0] NUM1,
    input [31:0] NUM2,

    input [3:0] ALU_op,

    output reg [31:0] OP,
    output reg [1:0] OPCMP
);

always @(*) begin
    OP = 32'b0;
    OPCMP = 2'b00;

    case (ALU_op)

        4'b0001: begin
            OP = NUM1 + NUM2;   // ADD
        end

        4'b0010: begin
            OP = NUM1 - NUM2;   // SUB
        end

        4'b0011: begin
            OP = NUM1 & NUM2;   // AND
        end

        4'b0100: begin
            OP = NUM1 | NUM2;   // OR
        end

        4'b0101: begin
            // CMP (compare only)
            if (NUM1 == NUM2)
                OPCMP = 2'b00;
            else if (NUM1 > NUM2)
                OPCMP = 2'b01;
            else
                OPCMP = 2'b10;;
        end

        default: begin
            OP = 32'b0;
            OPCMP = 2'b00;
        end

    endcase
end

endmodule
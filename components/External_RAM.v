module EXT_RAM(
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] addr,
    input [31:0] write_data,
    output reg [31:0] read_data
);

    localparam MEM_WORDS = 65536;

    reg [15:0] memory [0:MEM_WORDS-1];

    // Word-addressed RAM:
    // addr 255 -> memory[255]
    wire [15:0] ram_addr = addr[15:0];

    integer i;
    integer file;

    initial begin
        for (i = 0; i < MEM_WORDS; i = i + 1) begin
            memory[i] = 16'h0000;
        end

`ifdef SIMULATION
        file = $fopen("memory.csv", "w");
        if (file) begin
            $fwrite(file, "index,address,data_hex,data_dec\n");
            for (i = 0; i < MEM_WORDS; i = i + 1) begin
                $fwrite(file, "%0d,%0d,0x%04h,%0d\n",
                    i, i, memory[i], memory[i]);
            end
            $fclose(file);
        end
`endif
    end

    always @(posedge clk) begin
        if (mem_write) begin
            memory[ram_addr] <= write_data[15:0];
            $display("RAM WRITE: addr=%0d data=%0d (0x%04h) time=%0t",
                     ram_addr, write_data[15:0], write_data[15:0], $time);
        end

        if (mem_read) begin
            read_data <= {16'b0, memory[ram_addr]};
        end else begin
            read_data <= 32'b0;
        end
    end

`ifdef SIMULATION
    always @(posedge clk) begin
        if (mem_write) begin
            #1;
            file = $fopen("memory.csv", "w");
            if (file) begin
                $fwrite(file, "index,address,data_hex,data_dec\n");
                for (i = 0; i < MEM_WORDS; i = i + 1) begin
                    $fwrite(file, "%0d,%0d,0x%04h,%0d\n",
                        i, i, memory[i], memory[i]);
                end
                $fclose(file);
            end
        end
    end
`endif

endmodule
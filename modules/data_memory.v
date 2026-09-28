module data_memory (
    input clk,
    input mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data 
);
    reg [31:0] data_mem [0:63];
    assign read_data = data_mem[address[7:2]];
    always @(posedge clk) begin
        if(mem_write) begin
            data_mem[address[7:2]] <= write_data; 
        end
    end
endmodule
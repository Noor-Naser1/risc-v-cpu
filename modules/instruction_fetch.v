module pc_register(
    input clk,
    input reset,
    input [31:0] next_pc,
    output reg [31:0] current_pc
);


    always @(posedge clk) begin
        if (reset) begin
            current_pc <= 32'b0 ;
        end
        else begin 
            current_pc <= next_pc;
        end
    end
endmodule

module pc_incrementer(
    input [31:0] current_pc,
    output [31:0] next_pc
);
    assign next_pc = current_pc + 4;
endmodule

module instruction_memory (
    input [31:0] pc_address,
    output [31:0] instruction
);
    reg [31:0] mem_arr [0:63];
    assign instruction = mem_arr[pc_address[7:2]];
    
endmodule
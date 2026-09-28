module instruction_decoder(
    input [31:0] instruction,
    output [6:0] opcode,
    output [4:0] rd,
    output [2:0] funct3,
    output [4:0] rs1,
    output [4:0] rs2,
    output [6:0] funct7,
    output [31:0] imm
);
    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign funct7 = instruction[31:25];

    assign imm = (opcode == 7'b0010011 ||
                  opcode == 7'b0000011 || 
                  opcode == 7'b1100111) 
                  ? {{20{instruction[31]}},instruction[31:20]}:
                 (opcode == 7'b0100011)
                        ? {{20{instruction[31]}}, instruction [31:25], instruction[11:7]}:
                 (opcode == 7'b1100011)
                        ? {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25], instruction[11:8], 1'b0}:
                 (opcode == 7'b0110111 ||
                  opcode == 7'b0010111)
                        ? {instruction[31:12],12'b0}:
                 (opcode == 7'b1101111)
                    ? {{11{instruction[31]}}, instruction[31], instruction[19:12],
                        instruction[20], instruction[30:21], 1'b0} :

                32'b0;

endmodule

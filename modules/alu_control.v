module alu_control(
    input [1:0] alu_op,
    input [2:0] funct3,
    input funct7_5,
    input op_5,
    output reg [3:0] alu_ctrl 
);
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;
    localparam ALU_SLL = 4'b0110;
    localparam ALU_SRL = 4'b0111;
    localparam ALU_SLTU = 4'b1000;
    localparam ALU_SRA = 4'b1001;
    always @(*) begin
        alu_ctrl = ALU_ADD;

        case (alu_op)
            2'b00: alu_ctrl = ALU_ADD;
            2'b01: alu_ctrl = ALU_SUB;
            2'b10: begin
                case (funct3)                                                     // (1) added
                    3'b000: alu_ctrl = (op_5 && funct7_5) ? ALU_SUB : ALU_ADD;  // (2) added
                    3'b001: alu_ctrl = ALU_SLL;
                    3'b010: alu_ctrl = ALU_SLT;
                    3'b011: alu_ctrl = ALU_SLTU;
                    3'b100: alu_ctrl = ALU_XOR;                                  // (2) added
                    3'b101: alu_ctrl = funct7_5 ? ALU_SRA : ALU_SRL;             // (3) finished
                    3'b110: alu_ctrl = ALU_OR;                                   // (4) typo fixed
                    3'b111: alu_ctrl = ALU_AND;                                  // (4) typo fixed
                    default: alu_ctrl = ALU_ADD;
                endcase  
            end
            default: alu_ctrl = ALU_ADD;                                          // (5)
        endcase
    end
endmodule
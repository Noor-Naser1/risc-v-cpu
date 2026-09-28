module cpu (
    input clk,
    input reset
);
    wire [31:0] pc, next_pc;
    wire [31:0] instruction;
    wire [31:0] pc_plus4;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm;
    wire reg_write;
    wire [1:0] alu_src_a ;
    wire alu_src_b;
    wire mem_write;
    wire [1:0] result_src;
    wire branch;
    wire jump;
    wire jalr;
    wire [1:0] alu_op;
    wire [3:0] alu_ctrl;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] alu_result;
    wire zero;
    wire [31:0] read_data;
    wire [31:0] result;
    wire taken;
    wire [31:0] pc_target;

//---------fetch-------
pc_register pc_reg (
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .current_pc(pc)
);
pc_incrementer pc_inc (
    .current_pc(pc),
    .next_pc(pc_plus4)
);
instruction_memory imem (
    .pc_address(pc),
    .instruction(instruction)
);
//-------decoder-------
instruction_decoder decoder (
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7),
    .imm(imm)
);

    control_unit ctrl (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .alu_op(alu_op)
    );

    register_file regs (
        .clk(clk),
        .write_enable(reg_write),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rd_addr(rd),
        .rd_data(result), 
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
// --------execute -----------
    alu_control alu_ctl (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7_5(funct7[5]),
        .op_5(opcode[5]),
        .alu_ctrl(alu_ctrl)
    );

    alu alu0 (
        .a(alu_a),            
        .b(alu_b),              
        .alu_op(alu_ctrl),      
        .result(alu_result),
        .zero(zero)
    );

    branch_unit bu (
        .branch(branch),
        .funct3(funct3),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .taken(taken)
    );
//----------- memory ----------
    data_memory dmem (
        .clk(clk),
        .mem_write(mem_write),
        .address(alu_result),    
        .write_data(rs2_data),
        .read_data(read_data)
    );
assign alu_a = (alu_src_a == 2'b01) ? pc :
               (alu_src_a == 2'b10) ? 32'b0 :
                                      rs1_data;

assign alu_b = alu_src_b ? imm : rs2_data;

assign result = (result_src == 2'b01) ? read_data :
                (result_src == 2'b10) ? pc_plus4 :
                                        alu_result;

assign pc_target = pc + imm;

assign next_pc = jalr            ? {alu_result[31:1], 1'b0} :
                 (jump || taken) ? pc_target :
                                   pc_plus4;
endmodule
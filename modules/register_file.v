module register_file (
    input wire clk,
    input wire write_enable,
    input wire [4:0] rs1_addr,
    input wire [4:0] rs2_addr,
    input wire [4:0] rd_addr,
    input wire [31:0] rd_data,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);
    wire [31:0] reg_outputs [0:31];
    //decoder to know to which reg we are writing
    reg [31:0] reg_write_enable;
    always @(*) begin
        reg_write_enable = 32'b0;
        if (write_enable && rd_addr != 5'b0) begin 
            reg_write_enable[rd_addr] = 1'b1;
        end
    end 
    // creating 32 regs from register.v 
    genvar i;
    generate 
        for(i = 0; i < 32; i = i + 1) begin : REG_LOOP
            register reg_i (
                .clk(clk),
                .write_enable(reg_write_enable[i]),
                .data_in(rd_data),
                .data_out(reg_outputs[i])
            );
        end
    endgenerate


    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : reg_outputs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : reg_outputs[rs2_addr];
endmodule

module branch_unit (
    input branch,
    input [2:0] funct3,
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    output reg taken
);
always @(*) begin
    taken = 1'b0;
    if (branch) begin
    case(funct3) 
    3'b000: begin
        if(rs1_data == rs2_data) begin
            taken = 1;
        end
    end
    3'b001: begin
        if(rs1_data != rs2_data) begin
            taken = 1;
        end
    end
    3'b100: begin
        if($signed(rs1_data) < $signed(rs2_data)) begin
            taken = 1;
        end
    end
    3'b101: begin
        if($signed(rs1_data) >= $signed(rs2_data)) begin
            taken = 1;
        end
    end
    3'b110: begin
        if($unsigned(rs1_data) < $unsigned(rs2_data)) begin
            taken = 1;
        end
    end
    3'b111: begin
        if($unsigned(rs1_data) >= $unsigned(rs2_data)) begin
            taken = 1;
        end
    end
    default: taken = 1'b0;
    endcase
    end
end
endmodule
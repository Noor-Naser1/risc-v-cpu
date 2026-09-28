module register (
    input clk,
    input write_enable,
    input [31:0] data_in,
    output [31:0] data_out
);
    reg [31:0] stored_value;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_value <= data_in;
        end
    end

    assign data_out = stored_value;
    initial begin
    stored_value = 32'b0;
    end
endmodule

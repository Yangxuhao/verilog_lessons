`timescale 1ns/1ns
module cfq_tb;
	reg clk_tb,rst_tb;
	reg [7:0]a_tb;
	reg [3:0]b_tb;
	wire [7:0]out_tb;
	wire [7:0]c_out_tb;
	cfq CFQ(.clk(clk_tb),.rst(rst_tb),.a(a_tb),.b(b_tb),.out(out_tb),.c_out(c_out_tb));
	initial begin
			clk_tb=1'b0;
			rst_tb=1'b0;
			#60 rst_tb=1'b1;
			a_tb=8'b00011111;
			b_tb=4'b0010;
			#100 a_tb=8'b00011101;
			b_tb=4'b0011;
			#100 $finish;
		end
always #20 clk_tb=~clk_tb;
endmodule
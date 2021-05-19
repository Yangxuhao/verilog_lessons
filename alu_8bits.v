//03/23/21 15:02:12
//Author��xuhao Yang
`timescale 1ns/1ps
`define Add         3'b000
`define Substract   3'b001
`define Substract_a 3'b010
`define Or          3'b011
`define And         3'b100
`define Xor         3'b101
`define Xnor        3'b110

module  alu_8bits(a,b,oper,c_out,sum,clk,res);
    input[7:0] a,b;
    input[11:0] oper;
	input clk;
	input res;
    output reg c_out;
    output reg[7:0] sum;
    

    always@(posedge clk or negedge res)begin
		if (~res) begin
			c_out <= 0;
			sum <= 8'b0000_0000;
		end
		else begin
			case(oper)
    		`Add:{c_out,sum} <= a+b;
    		`Substract:begin sum <= a-b;c_out <= 0;end
    		`Substract_a:begin sum <= b-a;c_out <= 0;end
    		`Or:begin sum <= a|b;c_out <= 0;end
    		`And:begin sum <= a&b;c_out <= 0;end
    		`Xor:begin sum <= a^b;c_out <= 0;end
    		`Xnor:begin sum <= a~^b;c_out <= 0;end
			default:begin
				c_out <= 0;
				sum <= 8'b0000_0000;
			end
    	endcase
		end
    	
    end

endmodule

module  alu_8bits_tb;
reg[7:0] a,b;
reg[11:0] oper;
reg clk,res;
wire c_out;
wire[7:0] sum;
alu_8bits	alu_8bits(.a(a),.b(b),.oper(oper),.c_out(c_out),.sum(sum),.clk(clk),.res(res));

initial begin
		clk <= 0;res <= 0;
	#10 res <=1;
	#10 a<=8'b0000_0000;b<=8'b0000_0001;oper<=`Xor;
	#10 a<=8'b0000_0011;b<=8'b0000_0101;oper<=`Or;
	#10 a<=8'b1111_1111;b<=8'b1010_0001;oper<=`Add;
	#10 a<=8'b0000_0100;b<=8'b0000_1001;oper<=`Xor;
	#10 a<=8'b0000_0110;b<=8'b0110_0001;oper<=`Xnor;
	#10 a<=8'b0110_0000;b<=8'b0010_0001;oper<=`And;
	#100 $stop;
	
	
end
always #5 clk = ~clk;



endmodule
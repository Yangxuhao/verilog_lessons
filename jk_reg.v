//03/23/21 12:46:47
//Author?xuhao Yang
//JK´¥·¢Æ÷
`timescale 1ns/1ps
module  jk_reg(
		input clk,
		input rst,
		input j,
		input k,
		input q0,
		output reg q1
);


always@(posedge clk or negedge rst)begin
	
	if(~rst)begin
		q1 <= 0;
	end
	else begin
		case({j,k})
		2'b00:begin
			q1 <= q0;
		end
		2'b01:begin
			q1 <= 1'b0;
		end
		2'b10:begin
			q1 <= 1'b1;
		end
		2'b11:begin
			q1 <= (~q0);
		end
		
	endcase
	end

end

endmodule

module jk_reg_tb;
	reg clk,rst;
	reg j;
	reg k;
	reg q0;
	//reg cnt;
	wire q1;
	jk_reg jk(
			.clk(clk),
			.rst(rst),
			.j(j),
			.k(k),
			.q0(q0),
			.q1(q1)
	);
	
	initial begin
		clk <= 0;
		rst <= 0;
		//cnt <= 0;
		j <= 0;
		k <= 0;
		#17 rst<=1;
		#1000 $stop;
		
	end
	always#5 clk<=~clk;
	always@(posedge clk)begin
		#50 j <= 0;k <= 0;q0 <= 0; 
		#50 j <= 0;k <= 1;q0 <= 1; 
		#50 j <= 1;k <= 0;q0 <= 0; 
		#50 j <= 1;k <= 1;q0 <= 1; 
		//#50 j <= 0,k <= 0,q0 <= 0; 
	end
endmodule
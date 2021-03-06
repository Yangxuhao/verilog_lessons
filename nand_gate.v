
`timescale 1ns/100ps

module nand_gate(A,B,Y);
			input A;
			input B;
			output Y;
			assign Y = ~(A&B);

endmodule

module nand_gate_tb;
reg aa,bb;
wire yy;
nand_gate nand_gate(.A(aa),.B(bb),.Y(yy));

initial begin

	 aa<=0;bb<=0;
	#10 aa<=0;bb<=1;
	#10 aa<=1;bb<=0;
	#10 aa<=1;bb<=1;
	#10 $stop;
	
	
end
endmodule
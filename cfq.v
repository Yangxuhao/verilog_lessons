
module cfq(clk,rst,a,b,out,r_out);
	input [7:0]a;
	input [3:0]b;
	input clk,rst;
	output [7:0]out;
	output [7:0]r_out;
	reg [7:0]out;

	reg [7:0]r_out;
        reg [15:0]c;
	reg [15:0]d;
	integer e;
        always@(posedge clk or negedge rst)
		if(rst==0)
			begin	
			 	out<=8'b00000000;
				r_out<=8'b00000000;
			end

		else
			begin
				c <={8'h0,a};
				d <={4'b0000,b,8'h0};
			 	c ={c[14:0],1'b0};
				while(e<=15)
					begin
						if(c>=d)
							begin
								c =c-d;
								c ={c[14:0],1'b1};
								e =e+1'b1;
							end
						else
							begin
								c ={c[14:0],1'b0};
								e =e+1'b1;
							end
					end
				out =c[7:0];
				r_out =c[15:8];
			end

endmodule
					
		

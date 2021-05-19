//01/30/21 12:44:58
//Author£ºxuhao Yang
`timescale 1ns/10ps
module  fn_sw(a,b,sel,y);
    input a;
    input b;
    input sel;
    output y;
    reg y;
    //assign y=sel?(a^b):(a&b);
    always@(a or b or sel)begin
    	if(sel==1) begin
    		y<=a^b;
    	end
    	else begin
    		y<=a&b;
    	end
    end
    	
endmodule

module fn_sw_tb;
		reg a,b,sel;
		wire y;
		fn_sw fn_sw(.a(a),.b(b),.sel(sel),.y(y));
		initial begin
				a<=0;b<=0;sel<=0;
				#10 a<=0;b<=0;sel<=1;
				#10 a<=0;b<=1;sel<=0;
				#10 a<=0;b<=1;sel<=1;
				#10 a<=1;b<=0;sel<=0;
				#10 a<=1;b<=0;sel<=1;
				#10 a<=1;b<=1;sel<=0;
				#10 a<=1;b<=1;sel<=1;
				#10 $stop;
		end
endmodule


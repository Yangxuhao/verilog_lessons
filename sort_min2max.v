//03/24/21 21:51:48
//Author£ºxuhao Yang
`timescale 1ns/100ps
module  sort_min2max(a,b,c,d,ra,rb,rc,rd,clk);
    input[7:0] a,b,c,d;
    output reg[7:0] ra,rb,rc,rd;
    input clk;
    reg[7:0] temp1,temp2,temp3,temp4,temp5,temp6;
    always@(a,b,c,d,clk)begin
    	sort(temp1,temp2,a,b);
    	sort(temp3,temp4,c,d);
    	sort(rd,temp5,temp1,temp3);
    	sort(temp6,ra,temp2,temp4);
    	sort(rc,rb,temp5,temp6);
    	
    end
    task sort;
    output[7:0] max;
    output[7:0] min;
    input[7:0] a;
    input[7:0] b;
    if(a>b)begin
    	max = a;
    	min = b;
    end
    else begin
    	max = b;
    	min = a;
    end
	  endtask
endmodule


module sort_min2max_tb;
reg[7:0] a,b,c,d;
wire[7:0] ra,rb,rc,rd;
reg clk;
sort_min2max sort_min2max(a,b,c,d,ra,rb,rc,rd,clk);
initial begin
	clk = 0;
	a=0;b=2;c=7;d=4;
	# 100 $stop;
	
end
always #5 clk = ~clk;
endmodule

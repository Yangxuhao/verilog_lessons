//03/24/21 13:22:23
//Author：xuhao Yang
//环形计数器，还需要改parameter的
`timescale 1ns/1ps
module  ring_count(reset,clk,count);
    parameter ct_width=4;
    input reset,clk;
    reg[3:0] temp;
    reg[2:0] cnt=0;
    output reg[ct_width-1:0] count;
    always@(posedge clk or negedge reset)begin
    	if(~reset)begin
    		count <= 4'b0001;
    		temp <= 0;
    		cnt <= 0;
    	end
    	else begin
    		temp = count;
    		if(cnt<3)begin
    			count = {temp[2:0],temp[3]};
    			cnt <= cnt +1;
    		end
    		else if(cnt>=3&cnt<5) begin
    			count = {temp[0],temp[3:1]};
    			cnt <= cnt +1;
    		end
    		else begin
    			count <= 0'b0001;
    			cnt <= 0;
    		end
    	  
    	end
    end 

endmodule

module ring_count_tb;
		reg reset,clk;
		wire[3:0] count;
		ring_count ring_count(.reset(reset),.clk(clk),.count(count));
		
		initial begin
			clk <= 0;
			reset <= 0;
			#17 reset <= 1;
			#1000 $stop;
		end
		always#5 clk <= ~clk;
		
		

endmodule

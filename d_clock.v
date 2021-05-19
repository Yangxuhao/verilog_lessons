//03/26/21 15:20:27
//Author��xuhao Yang
`timescale 1ns/1ps
module  d_clock(clk,res,stop,min,sec,secv100);
    input clk,res,stop;
    output [6:0] secv100;
    output [5:0] sec;
    output [5:0] min;
    
    reg[6:0] cnt100;
    reg[5:0] cnt60;
    reg[5:0] cnt60_s;
    
    always@(posedge clk or negedge res)begin//ģ100������
    	
    	if(~res)begin
    		cnt100 <= 0;
    	end
    	else if(stop)begin
    		cnt100 <= cnt100;
    	end
    	else begin
    		if(cnt100 < 7'b1100100)begin
			     cnt100 = cnt100 + 1'b1;
		    end	
		    else begin
			     cnt100 <= 0;
		    end	
    	end
		
	end
	
	always@(negedge clk or negedge res)begin//ģ60������
    	
    	if(~res)begin
    		cnt60 <= 0;
    	end
    	else if(stop)begin
    		cnt60 <= cnt60;
    	end
    	else begin
    		if(cnt100 == 7'b1100100) begin
    			if(cnt60 < 6'b111100)begin
			     	cnt60 <= cnt60 + 1'b1;
			    end
			    else begin
			    	cnt60 <= 0;
			    end
		    end	
		    else begin
			     cnt60 <= cnt60;
		    end	
    	end
		
	end
	  
	always@(negedge clk or negedge res)begin//ģ60������
    	
    	if(~res)begin
    		cnt60_s <= 0;
    	end
    	else if(stop)begin
    		cnt60_s <= cnt60_s;
    	end
    	else begin
    		if((cnt60 == 6'b111100)&(cnt100 == 7'b1100100))begin
    			if(cnt60_s < 6'b111100)begin
			     cnt60_s <= cnt60_s + 1'b1;
			    end
			    else begin
			    	cnt60_s <= 0;
			    end
		    end	
		    else begin
			     cnt60_s <= cnt60_s;
		    end	
    	end
		
	end
  assign secv100 = cnt100;
  assign sec = cnt60;
  assign min = cnt60_s;

endmodule


module d_clock_tb;
reg clk;
reg res;
reg stop;
wire[6:0] secv100;
wire[5:0] sec;
wire[5:0] min;

d_clock d_clock(clk,res,stop,min,sec,secv100);


initial begin
	clk = 0;
	res = 0;
	stop = 0;
	#17 res = 1;
	#2000 $stop;
end

always #5 clk = ~clk;

endmodule
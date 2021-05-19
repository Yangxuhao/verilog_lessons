//03/26/21 14:32:17
//Author��xuhao Yang
`timescale 1ns/100ps
module  Sequential_detector(clk,res,seq,asm);
    input clk;
    input res;
    input seq;
    output reg asm;
    reg[3:0] statue;
    parameter statue1 =4'b1001,statue2 =4'b0011,statue3 =4'b0111,statue4 =4'b1110,statue5= 4'b1100;
    
    always@(negedge clk or negedge res)begin
    	if(~res)begin
    		asm <= 0;
    		statue <= statue1;
    	end
    	else begin
    		asm = 0;
    		case(statue)
    			statue1:begin
    				if(seq == 1) statue <= statue2;
    				else statue <= statue1;
    			end
    			statue2:begin
    				if(seq == 0) statue <= statue3;
    				else statue <= statue1;
    			end
    			statue3:begin
    				if(seq == 0) statue <= statue4;
    				else statue <= statue1;
    			end
    			statue4:begin
    				if(seq == 1) statue <= statue5;
    				else statue <= statue1;
    			end
    			statue5:begin
    				if(seq == 1)begin
    				 asm <= 1;
    				 statue <= statue2;
    				end
    				else statue <= statue1;
    			end
    			default:begin
    				asm <= 0;
    				statue <= statue1;
    			end
    		endcase
    		
    	end
    	
    end

endmodule


module Sequential_detector_tb;
reg clk;
reg res;
reg seq;
reg[15:0] sequence;
wire asm;

Sequential_detector Sequential_detector(clk,res,seq,asm);

initial begin
	clk <= 0;
	res <= 0;
	sequence <= 16'b1001_1100_1111_0011;
	#17 res <= 1;
	#1000 $stop;
end
always #5 clk <= ~clk;
always@(posedge clk)begin
	seq = sequence[0];
	sequence = sequence>>1;
	
end





endmodule
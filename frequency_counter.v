//03/25/21 23:48:28
//Author��xuhao Yang
//����Ƶ�ʼ�
`timescale 1ns/100 ps
module  frequency_counter(clk,clk1,res,frequency);
    input clk,clk1,res;
    output reg[23:0] frequency;
    reg[23:0] temp;
    reg[30:0] cnt;
    reg en;
    
    always@(posedge clk or negedge res)begin
    	if(~res)begin
    		temp <= 0;
    		cnt <= 0;
    		en <= 0;
    		frequency <= 24'b0;
    	end	
    end
    
		always@(posedge clk)begin//��������Ϊ1s��enʹ���ź�
			if(cnt<500000-1)begin
				cnt <= cnt +1;
			end
			else begin
				cnt <= 0;
				en <= ~en;
			end
		end

    
    always@(posedge clk1)begin
    	if(en)begin
    		temp = temp + 1;
    		frequency = 0;
    	end
    	else begin
    		frequency = temp*20 ;
    		//50000000/temp
    		temp = 0;
    	end
    end 
endmodule


module frequency_counter_tb;
reg clk;
reg res;
reg clk1;
reg clk2;
wire[23:0] frequency;
reg[29:0] cnt;

frequency_counter frequency_counter(clk,clk1,res,frequency);

initial begin
	clk <= 0;
	res <= 0;
	clk2 <= 0;
	cnt <= 0;
	clk1 <= 0;
	#17 res <= 1;	
	#1000000 $stop;
end

always #50 clk = ~clk;

//clk1Ƶ��Ϊ800hz,����1250000����Ϊclk����Ϊ100������cnt���о�����Ϊ6250
always@(posedge clk)begin
	if(cnt<6250-1)begin
		cnt <= cnt +1;
	end
	else begin
		cnt <= 0;
		clk1 <= ~clk1;
	end
end

endmodule
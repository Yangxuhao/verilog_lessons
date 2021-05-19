//03/22/21 20:04:29
//Author��xuhao Yang
//����UART�������ݽ���
//RX�ź��ߣ�ʱ��Clk�� ������ɱ�־ rdsig �����ݴ���dataerror����żУ�飩����ʽ����ֹͣλ�������ݽ��ս��dataout[7:0]
`timescale 1ns/1ps
module  UART_RX(
		input RX,
		input clk_div,
		output reg rx_flag,
		output reg dataerror,
		output reg frameerror,
		output reg[7:0] data
		);
    reg[7:0] cnt;
    reg rxbuf,rxfall,receive;
    parameter paritymoed = 1'b0;
    reg presult,idle;
    
    
    always@(posedge clk_div)begin
    	rxbuf <= RX;
    	rxfall <= rxbuf&(~RX);
    end
    
    always@(posedge clk_div)begin
    	if(rxfall && (~idle))begin
    		receive <= 1'b1;
    	end
    	else if(cnt == 8'd168)begin
    		receive <= 1'b0;
    	end
    end
    
    always@(posedge clk_div)begin
    	if(receive == 1'b1)begin
    		case(cnt)
    			8'd0:begin
    				idle <= 1'b1;
    				cnt <= cnt+1'b1;
    				rx_flag <= 1'b0;
    				data[7:0] <= 8'bz;
    				
    			end
    			8'd24:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						rx_flag <= 1'b0;
						data[0] <= RX;
						presult <= paritymoed ^ RX;						
    			end
    			8'd40:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						rx_flag <= 1'b0;
						data[1] <= RX;
						presult <= presult ^ RX;						
    			end
    			8'd56:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						rx_flag <= 1'b0;
						data[2] <= RX;
						presult <= presult ^ RX;						
    			end
    			8'd72:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						rx_flag <= 1'b0;
						data[3] <= RX;
						presult <= presult ^ RX;						
    			end
    			8'd88:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						rx_flag <= 1'b0;
						data[4] <= RX;
						presult <= presult ^ RX;						
    			end
    			8'd104:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						rx_flag <= 1'b0;
						data[5] <= RX;
						presult <= presult ^ RX;		
    			end
    			8'd120:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						rx_flag <= 1'b0;
						data[6] <= RX;
						presult <= presult ^ RX;		
    			end
    			8'd136:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						rx_flag <= 1'b0;
						data[7] <= RX;
						presult <= presult ^ RX;		
    			end
    			8'd152:begin
    				idle <= 1'b1;
						cnt <= cnt + 1'b1;
						if(presult == RX)begin
							dataerror <= 1'b0;
						end
						else begin
							dataerror <= 1'b1;
						end		
						rx_flag <= 1'b1;
    			end
    			8'd168:begin
    				idle <= 1'b1;
    				cnt <= cnt + 1'b1;
    				if(RX == 1'b1)begin
    					frameerror <= 1'b0;
    				end
    				else begin
    					frameerror <= 1'b1;
    				end
    				rx_flag <= 1'b1;
    			end
    			default:begin
    				cnt <= cnt + 8'b1;
    			end
    		endcase
    	end
    	else begin
    		cnt <= 8'b0;
    		idle <= 1'b0;
    		rx_flag <= 1'b0;
    	end
    
    	
    end
    

endmodule


module RX_tb;
 
reg RX,clk_div;
wire rx_flag,dataerror,frameerror;
wire [7:0]data;
 
 
 
//	 ����
UART_RX RX_U1(
	.RX(RX),			//  	UART��RX
	.clk_div(clk_div),	//      ʱ��
	.rx_flag(rx_flag),    //		������ɱ�־
	.dataerror(dataerror),  //		���ݴ����־
	.frameerror(frameerror),	//      ֡����
	.data(data)
    );
    
 
 
initial
	begin
		RX = 1;
		clk_div = 1;
 
		forever               // �ظ����� RX�źţ���ģ���������
			begin
				#100;
				
				#10 RX = 0;		//  ��ʼλ
				#16 RX = 1;		//  bit 0
				#16 RX = 0;		//  bit 1
				#16 RX = 1;		//  bit 2
				#16 RX = 0;		//  bit 3
				#16 RX = 1;		//  bit 4
				#16 RX = 0;		//  bit 5
				#16 RX = 1;		//  bit 6
				#16 RX = 0;		//  bit 7
				#16 RX = 1;		//  bit У�飬����У��λ��1
				#16 RX = 1;		//  bit ֹͣ	
			end
	end
 
 
 
always #0.5 clk_div = ~clk_div;
 
 
endmodule
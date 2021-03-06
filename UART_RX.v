//03/22/21 20:04:29
//Author：xuhao Yang
//用于UART串口数据接收
//RX信号线，时钟Clk、 接收完成标志 rdsig ，数据错误dataerror（奇偶校验），格式错误（停止位）、数据接收结果dataout[7:0]
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
 
 
 
//	 例化
UART_RX RX_U1(
	.RX(RX),			//  	UART的RX
	.clk_div(clk_div),	//      时钟
	.rx_flag(rx_flag),    //		接收完成标志
	.dataerror(dataerror),  //		数据错误标志
	.frameerror(frameerror),	//      帧错误
	.data(data)
    );
    
 
 
initial
	begin
		RX = 1;
		clk_div = 1;
 
		forever               // 重复产生 RX信号，对模块产生激励
			begin
				#100;
				
				#10 RX = 0;		//  起始位
				#16 RX = 1;		//  bit 0
				#16 RX = 0;		//  bit 1
				#16 RX = 1;		//  bit 2
				#16 RX = 0;		//  bit 3
				#16 RX = 1;		//  bit 4
				#16 RX = 0;		//  bit 5
				#16 RX = 1;		//  bit 6
				#16 RX = 0;		//  bit 7
				#16 RX = 1;		//  bit 校验，这里校验位是1
				#16 RX = 1;		//  bit 停止	
			end
	end
 
 
 
always #0.5 clk_div = ~clk_div;
 
 
endmodule
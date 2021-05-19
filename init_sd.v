//04/12/21 16:44:22
//Author：xuhao Yang
module  init_sd(

				input clk,
				input res_n,
				input MISO_bit,//data out，SD卡返回的
				output reg sd_cs,
				output reg MOSI_bit,//data in，写入SD卡的
				output reg[15:0] response
				);
		localparam CMD0 = 48'h400000000095,CMD8 = 48'h48000001AA87,CMD55 = 48'h7700000000FF,CMD41 = 48'h6940000000FF;
		localparam WAIT_74_CYCLE = 0,SEND_CMD0 = 1,READ_CMD0_RESP = 2,SEND_CMD8 = 3,READ_CMD8_RESP = 4,
		         SEND_CMD55 = 5,READ_CMD55_RESP = 6,SEND_CMD41 = 7,READ_CMD41_RESP = 8,END = 9;
		localparam POWER_ON_NUM = 80;
								
		reg[3:0] state,next_state;
    reg[15:0] clock_counter;
    reg[47:0] MOSI;
    reg[15:0] recv_data;
    reg activator;
    reg[12:0]  poweron_cnt;
    
    //上电等待稳定计数器
		always @(posedge clk or negedge res_n) begin
		    if(!res_n)
		        poweron_cnt <= 13'd0;
		    else if(cur_state == st_idle) begin
		        if(poweron_cnt < POWER_ON_NUM)
		            poweron_cnt <= poweron_cnt+ 1'b1;
		    end
		    else
		        poweron_cnt <= 13'd0;
		end

    
    
    always@(posedge clk or negedge res_n)begin
    	if(~res_n)begin
    		state <= 0;
    		next_state <= 0;
    		clock_counter <= 0;
    		MOSI <= 0;
    		recv_data <= 0;
    		activator <=0;
    	end
    	else begin
    		state <= next_state;
    		if(clock_counter ==372 && response[7:0] != 8'b0)begin
    			clock_counter <= 243;
    		end
    		else begin
    			clock_counter <= clock_counter +1;
    		end
    		if(clock_counter <373)begin
    			activator <= 1;
    			response <= recv_data;
    		end
    		else activator <=0;
    	
    	end
    end
    always@(clock_counter)begin
    	state <= next_state;
    	case(state)
    		WAIT_74_CYCLE:begin
    			if(poweron_cnt == POWER_ON_NUM)  //默认状态，上电等待SD卡稳定
                next_state = st_send_cmd0;
            else
                next_state = st_idle;
    			
    		end
    		SEND_CMD0:begin
    			if(clock_counter > 80 && clock_counter < 128)begin
    				next_state = SEND_CMD0;
    			end
    			else begin
    				next_state = READ_CMD0_RESP;
    			end
    		end
    		READ_CMD0_RESP:begin
    			if(clock_counter > 128 && clock_counter <145)begin
    				next_state = READ_CMD0_RESP;
    			end
    			else begin 
    				next_state = SEND_CMD8;
    			end
    		end
    		SEND_CMD8:begin
    			if(clock_counter > 145 && clock_counter <193)begin
    				next_state = SEND_CMD8;
    			end
    			else begin
    				next_state = READ_CMD8_RESP;
    			end
    		end
    		READ_CMD8_RESP:begin
    			if(clock_counter > 193 && clock_counter <242)begin
    				next_state = READ_CMD8_RESP;
    			end
    			else begin
    				next_state = SEND_CMD55;
    			end
    		end
    		SEND_CMD55:begin
    			if(clock_counter > 242 && clock_counter <290)begin
    				next_state = SEND_CMD55;
    			end
    			else begin
    				next_state = READ_CMD55_RESP;
    			end
    		end
    		READ_CMD55_RESP:begin
    			if(clock_counter > 290 && clock_counter < 307)begin
    				next_state = READ_CMD55_RESP;
    			end
    			else begin
    				next_state = SEND_CMD41;
    			end
    		end
    		SEND_CMD41:begin
    			if(clock_counter > 307 && clock_counter < 355)begin
    				next_state = SEND_CMD41;
    			end
    			else begin
    				next_state = READ_CMD41_RESP;
    			end
    		end
    		READ_CMD41_RESP:begin
    			if(clock_counter > 355 && clock_counter < 372 )begin
    				next_state = READ_CMD41_RESP;
    			end
    			else begin
    				if(response[7:0] != 8'b0)begin
    				next_state = END;
    				end
    				else begin
    				next_state = END;
    				end
    			end
    		end
    	  END:begin end
    	  default:begin end
    	endcase
    end
    assign clk_inv = ~clk;
    always@(posedge clk_inv)begin
    	if(activator == 1)begin
    		case(state)
    			WAIT_74_CYCLE:begin
    				sd_cs <= 1;
    				MOSI_bit <= 1;
    				MOSI <= CMD0;
    			end
    			SEND_CMD0:begin
    				sd_cs <= 0;
    				MOSI_bit <= MOSI[47];
    				MOSI = MOSI << 1;
    			end
    			READ_CMD0_RESP:begin
    				sd_cs <= 0;
    				MOSI_bit <= 1;
    				MOSI <= CMD8;
    				recv_data <={recv_data[14:0],MISO_bit}; //将sd卡返回的数据存入recv_data
    			end
    			SEND_CMD8:begin
    				sd_cs <= 0;
    				MOSI_bit <= MOSI[47];
    				MOSI = MOSI << 1;
    			end
    			READ_CMD8_RESP:begin
    				sd_cs <= 0;
    				MOSI_bit <= 1;
    				MOSI <= CMD55;
    				recv_data <={recv_data[14:0],MISO_bit}; 
    			end
    			SEND_CMD55:begin
    				sd_cs <= 0;
    				MOSI_bit <= MOSI[47];
    				MOSI = MOSI << 1;
    			end
    			READ_CMD55_RESP:begin
    				sd_cs <= 0;
    				MOSI_bit <= 1;
    				MOSI <= CMD41;
    				recv_data <={recv_data[14:0],MISO_bit}; 
    			end
    			SEND_CMD41:begin
    				sd_cs <= 0;
    				MOSI_bit <= MOSI[47];
    				MOSI = MOSI << 1;
    			end
    			READ_CMD41_RESP:begin
    				sd_cs <= 0;
    				MOSI_bit <= 1;
    				MOSI <= CMD55;
    				recv_data <={recv_data[14:0],MISO_bit}; 
    			end
    		  END:begin end
    		  default:begin end
    		endcase
    	end
    	else begin
    		sd_cs <= 1;
    		MOSI_bit <= 0;
    		recv_data <= 16'h0;
    	end
    	
    end

endmodule


module init_sd_tb;
reg clk,res_n,MISO_bit;

wire sd_cs,MOSI_bit;
wire [15:0] response;

init_sd  init_sd(clk,res_n,MISO_bit,sd_cs,MOSI_bit,response);


initial begin
	clk <= 0;res_n <= 0;MISO_bit <= 1;
	#10 res_n <= 1;
	#2000 $stop;
	
end
always #5 clk = ~clk;
endmodule
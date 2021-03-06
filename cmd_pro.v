//02/19/21 14:33:10
//Author??xuhao Yang
module  cmd_pro(clk,res,din_pro,en_din_pro,dout_pro,en_dout_pro,rdy);
    input clk,res;
    input[7:0] din_pro;
    input en_din_pro;
    output [7:0] dout_pro;
    output en_dout_pro;
    output rdy;
    
    parameter add_ab = 8'h0a;
    parameter sub_ab = 8'h0b;
    parameter and_ab = 8'h0c;
    parameter or_ab = 8'h0d;
    
    reg[2:0]  state;
    reg[7:0]  cmd_reg,A_reg,B_reg;
    reg[7:0]  dout_pro;
    
    always@(posedge clk or negedge res)
    if(~res)begin
    	state<=0;
    	cmd_reg<=0;A_reg<=0;B_reg<=0;dout_pro<=0;
    end
    else begin
    	case(state)
    		0:begin
    			en_dout_pro<=0;
    			if(en_din_pro)begin
    				cmd_reg<=din_pro;
    				state<=1;
    			end
    		end
    		1:begin
    			if(en_din_pro)begin
    				A_reg<=din_pro;
    				state<=2;
    			end
    		end
    		2:begin
    			if(en_din_pro)begin
    				B_reg<=din_pro;
    				state<=3;
    			end
    		end
    		3:begin
    			state<=4;
    			case(cmd_reg)
    				add_ab:begin
    					dout_pro<=A_reg+B_reg;
    				end
    				sub_ab:begin
    					dout_pro<=A_reg-B_reg;
    				end
    				and_ab:begin
    					dout_pro<=A_reg&B_reg;
    				end
    				or_ab:begin
    					dout_pro<=A_reg|B_reg;
    				end
    			4:begin
    				if(~rdy)begin
    					enout_pro<=1;
    					state<=0;
    				end
    			end
    			endcase
    		end
    		default:begin
    			state<=0;
    			enout_pro<=0;
    		end
    		
    	endcase
    end

endmodule

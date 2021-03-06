//02/02/21 21:51:34
//Author??xuhao Yang
`timescale 1ns/10ps
module  tri_gen(clk,res,d_out);
    input clk,res;
    output[8:0] d_out;
    
    reg[1:0]	state;//״̬???Ĵ???
    reg[8:0]	d_out;
    reg[7:0]  con;
    always@(posedge clk or negedge res)
    if(~res)begin
    	state<=0;d_out<=0;con<=0;
    end
    else begin
    	case(state)
    		0:begin
    			d_out<=d_out+1;
    			if(d_out==299)begin
    				state<=2;
    			end
    		end
    		1:begin
    			d_out<=d_out-1;
    			if(d_out==1)begin
    				state<=0;
    			end
    		end
    		2:begin
    			if(con==200)begin
    				state<=1;
    				con<=0;
    			end
    			else begin
    				con<=con+1;
    			end
    		end
    		default:begin
    			state<=0;
    			con<=0;
    			d_out<=0;
    		end
    	endcase
    end

endmodule


module  tri_gen_tb;
    reg clk,res;
    wire[8:0] d_out;
    tri_gen  U1(.clk(clk),.res(res),.d_out(d_out));
    initial begin
    	res<=0;clk<=0;
    	#17 res<=1;
    	#10000 $stop;
    end
    always#5 clk=~clk;
    

endmodule


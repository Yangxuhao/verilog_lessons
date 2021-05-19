//02/02/21 14:36:41
//Author：xuhao Yang
//相邻16点相加
`timescale 1ns/10ps
module  sigma_16p(clk,res,data_in,syn_in,data_out,syn_out);
    input clk,res,syn_in;
    input[7:0] data_in;
    output[11:0] data_out;
    output syn_out;

    reg syn_in_n1;//syn_in的反向延时
    wire syn_pulse;

    assign syn_pulse = syn_in_n1&syn_in;

    reg[3:0] con_syn;

    wire[7:0] comp_8;//补码
    wire[11:0] d_12;//升位结果
    assign comp_8=data_in[7]?{data_in[7],~data_in[6:0]+1}:data_in;
    assign d_12 = {comp_8[7],comp_8[7],comp_8[7],comp_8[7],comp_8};

    reg[11:0] sigma;//累加计算
    reg[11:0] data_out;
    reg syn_out;

    always@(posedge clk or negedge res)
    if(~res)begin
    	syn_in_n1<=0;
    	con_syn<=0;
    	sigma<=0;
    	data_out<=0;
    	syn_out<=0;
    end
    else begin
    	//syn_in_n1<=~syn_in;
    	if(syn_pulse)begin
    		con_syn<=con_syn+1;
    	end
    	syn_in_n1<=~syn_in;
    	if(syn_pulse)begin
    		if(con_syn==15)begin
    			sigma<=d_12;
    			data_out<=sigma;
    			syn_out<=1;
    		end
    		else begin
    			sigma<=sigma+d_12;
    		end
    	end
    	else begin
    		syn_out<=0;
    	end
    end

endmodule

module sigma_16p_tb;
	reg clk,res;
	reg[7:0] data_in;
	reg syn_in;
	wire[11:0] data_out;
	wire syn_out;


	sigma_16p  sigma_16p(.clk(clk),.res(res),.data_in(data_in),.syn_in(syn_in),.data_out(data_out),.syn_out(syn_out));

	initial begin
		clk<=0;res<=0;data_in<=1;syn_in<=0;
		#17 res<=1;
		#25000 $stop;
	end


	always#5 clk<=~clk;

	always#50 syn_in<=~syn_in;

endmodule

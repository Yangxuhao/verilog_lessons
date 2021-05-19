//03/23/21 22:08:34
//Author：xuhao Yang
//决策器，大于3输出1，小于等于3输出0
module  decider(data_in,out);
    input[6:0] data_in;
    output reg out;
    reg[2:0] sum;
    reg[6:0] tmp_data_in;
    
always@(data_in)begin
	sum = 0;
	tmp_data_in = data_in;
	while(tmp_data_in)begin
		if(tmp_data_in[0])begin
			sum = sum+1;
		end
		tmp_data_in=tmp_data_in>>1;
		end
	
	if(sum>3)begin
		out = 1'b1;
		
	end
	else begin
		out = 1'b0;
		
	end
end
endmodule

module decider_tb;
reg[6:0] data_in;
wire out;
decider decider(data_in,out);
initial begin
	data_in<=7'b1010001;
	#50 data_in<=7'b1010101;
	#50 data_in<=7'b1011001;
	#50 data_in<=7'b1010001;
	#50 $stop;	
end
endmodule
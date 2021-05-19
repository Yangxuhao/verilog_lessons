//03/24/21 18:33:48
//Author：xuhao Yang
//除法器
module  divider(dividend,divisor,q,r);//q为商，r为余数
    input[7:0] dividend;
    input[3:0] divisor;
    output reg[7:0] q;
    output reg[7:0] r;
    
    reg[15:0] tmp_dividend;//除数，被除数扩展后的值
    reg[15:0] tmp_divisor;
    
    integer i;
    always@(dividend or divisor)begin
    	tmp_dividend = {8'h00,dividend};
    	tmp_divisor = {divisor,8'h00};
    	for(i=0;i<8;i=i+1)begin
    		tmp_dividend= tmp_dividend<<1;
    		if(tmp_dividend >= tmp_divisor)begin
    			tmp_dividend = tmp_dividend - tmp_divisor + 1'b1;
    		end

    	end
    	q = tmp_dividend[15:8];
    	r = tmp_dividend[7:0];
    end

endmodule

module divider_tb;
	reg[7:0] dividend;
	reg[3:0] divisor;
	wire[7:0] q;
	wire[7:0] r; 
	divider divider(dividend,divisor,q,r);
	initial begin
		dividend = 13;divisor = 2;
		#50 dividend =15;divisor =4;
		#100 $stop;
	end

endmodule
//04/04/21 14:00:42
//Author��xuhao Yang
module  count(
              input clk,
              input res,
              input ci1,ci5,ci10,
              output [3:0] cout
              );
    reg[2:0] q1,q5,q10;
    assign cout = q1 + (q5*5) + (q10*10);
    always@(negedge clk or negedge res or posedge ci1)begin
    	if(~res)begin
    		q1 <= 0;
    	end
    	else begin
    		if(ci1 == 1)begin
    		  q1 <= q1 + 1;
    		end
    		else begin
    			q1 <= q1;
    		end
    	end
    end
    always@(negedge clk or negedge res or posedge ci5)begin
    	if(~res)begin
    		q5 <= 0;
    	end
    	else begin
    		if(ci5 == 1)begin
    		 q5 <= q5 + 1;
    		end
    		else begin
    			q5 <= q5;
    		end
    	end
    end
    always@(negedge clk or negedge res or posedge ci10)begin
    	if(~res)begin
    		q10 <= 0;
    	end
    	else begin
    		if(ci10 == 1)begin
    			q10 <= q10 + 1;
    	  end
    	  else begin
    	  	q10 <= q10;
    	  end
    	end
    end
endmodule

module contrl(
              input clk,res,
              input[3:0] money,//Ͷ�����Ǯ��
              input[2:0] fee,//Ʊ��
              output reg[2:0] money_o,//������
              output reg ticket//��Ʊ�ź�
              );
    always@(posedge clk or negedge res)begin
    	if(~res)begin
    		money_o <= 0;
    		ticket <= 0;
    	end
    	else begin
    		if(money >= fee)begin
    			ticket <= 1;
    			money_o <= money - fee;
    		end
    		else begin
    			ticket <= 0;
    			money_o = 0;
    		end
    	end
    end
endmodule

module vending_machine(
                        input clk,res,
                        input ci1,ci5,ci10,
                        output [3:0] cout,//Ͷ�����Ǯ��
						input[2:0] fee,//Ʊ��
						output [2:0] money_o,//������
						output  ticket//��Ʊ�ź�
                       );
     wire [3:0] money;
     count u1(clk,res,ci1,ci5,ci10,cout);
     assign money = cout;
     contrl u2(clk,res,cout,fee,money_o,ticket);

endmodule

module vending_machine_tb;
reg clk,res;
reg ci1,ci5,ci10;
reg[2:0] fee;
//wire[3:0] money,
wire[3:0] cout;
wire[2:0] money_o;
wire ticket;

vending_machine vm(clk,res,ci1,ci5,ci10,cout,fee,money_o,ticket);

initial begin
	clk<=0;
	res<=0;
	#17 res <= 1;
	#10 fee<=3'd6;{ci1,ci5,ci10} <= 3'b010;
	#10 res <= 0;
	#10 res <= 1;
	#100 $stop;
end
always #5 clk <= ~clk;
//assign money = cout;


endmodule
//01/30/21 13:59:36
//Author£ºxuhao Yang
`timescale 1ns/10ps
module  comp_conv(a,a_comp);
    input[7:0] a;
    output[7:0] a_comp;
    wire[6:0] b;
    wire[7:0] y;
    
    
    assign b=~a[6:0];
    assign y[6:0]=b+1;
    assign y[7]=a[7];   
    assign a_comp = a[7]?y:a;
    

endmodule

module  comp_conv_tb;
    reg[7:0] a_in;
    wire[7:0] a_out;
		comp_conv comp_conv(.a(a_in),.a_comp(a_out));
		initial begin
			a_in<=0;
			#3000 $stop;
		end
		always #10 a_in<=a_in+1;
endmodule
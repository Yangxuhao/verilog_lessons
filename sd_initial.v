//04/20/21 15:54:56
//Author：xuhao Yang
module  sd_initial(
                   input sd_clk,
                   input rse_n,
                   input reg[3:0] data_in,
                   output reg[3:0] data_out,
                   output reg[47:0] response

                    );
                    
parameter CMD0   = {8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h95};
//接口状态命令
parameter CMD8   = {8'h48, 8'h00, 8'h00, 8'h01, 8'haa, 8'h87};
//告诉SD卡接下来是应用相关命令
parameter CMD55  = {8'h77, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff};
//发送操作寄存器OCR内容命令
parameter ACMD41 = {8'h69, 8'h40, 8'h00, 8'h00, 8'h00, 8'hff};

reg res_en,res_flag;
reg[47:0] res_data;
reg[5:0] res_bit_cnt;

//信号接收
always @(posedge sd_clk or negedge rse_n) begin
    if(!rst_n) begin
        res_en <= 1'b0;
        res_data <= 48'd0;
        res_flag <= 1'b0;
        res_bit_cnt <= 6'd0;
    end
    else begin
        //sd_miso = 0开始接收响应数据
        if(res_flag == 1'b0) begin
            res_flag <= 1'b1;
            res_data <= {res_data[46:0], sd_miso};
            res_bit_cnt <= res_bit_cnt + 6'd1;
            res_en <= 1'b0;
        end
        else if(res_flag) begin
            //R1返回一个字节，R3 R5返回5个字节
            //这里统一接收6个字节，多出的一个字节为nop（8个时钟周期的延迟）
            res_data <= {res_data[46:0], sd_miso}; //拼接+移位
            res_bit_cnt <= res_bit_cnt + 6'd1;
            if(res_bit_cnt == 6'd47) begin
                res_flag <= 1'b0;
                res_bit_cnt <= 6'd0;
                res_en <= 1'b1;
            end
        end
        else
            res_en <= 1'b0;
    end
end





endmodule

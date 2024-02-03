module error(

    input                       clk,
    input                       rst_n,
    input       signed [9:0]    target,
    input       signed [9:0]    y,
    
    output      signed [9:0]     ek0,
    output reg  signed [9:0]     ek1,
    output reg  signed [9:0]     ek2
);

assign ek0 = target - y;   // 计算e(k)

always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) begin
        ek1 <= 10'd0;
        ek2 <= 10'd0;
    end
    else begin
        ek1 <= ek0;                 // 延时一个时钟周期 得到e(k-1)
        ek2 <= ek1;                 // 再延时一个时钟周期 得到e(k-2)
    end 
end


endmodule

///
// Company: <Name>
//
// File: demo_top.v
// File history:
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//      <Revision number>: <Date>: <Comments>
//
// Description: 
//
// <Description here>
//
// Targeted device: <Family::SmartFusion> <Die::A2F060M3E> <Package::288 CS>
// Author: <Name>
//
/// 

//`timescale <time_units> / <precision>

module pid_top (

    input clk,                          // 时钟信号
    input rst_n,                        // 复位信号
    input signed [9:0] target,          // 目标值
    input signed [9:0] y,               // 实际输出值

    input [3:0] kp,
    input [3:0] ki,
    input [3:0] kd,
    
    output signed [14:0] uk0            // pid 输出值
);


wire signed [9:0] ek0;
wire signed [9:0] ek1;
wire signed [9:0] ek2;

error error_inst(
    .clk(clk),
    .rst_n(rst_n),
    .y(y),
    .ek0(ek0),
    .ek1(ek1),
    .ek2(ek2)
);

wire signed [14:0] d_uk; // pid 增量
incre_value incre_value_inst(
    .ek0(ek0),
    .ek1(ek1),
    .ek2(ek2),
    .kp(kp),
    .ki(ki),
    .kd(kd),
    .d_uk(d_uk)
);

pid_value pid_value_inst(

    .clk(clk),
    .rst_n(rst_n),
    .d_uk(d_uk),
    .uk0(uk0)
);

endmodule



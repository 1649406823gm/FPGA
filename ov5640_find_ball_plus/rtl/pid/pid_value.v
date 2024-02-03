///
// Company: <Name>
//
// File: pid_value.v
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

module pid_value( 

    input clk,                          // 时钟信号
    input rst_n,                        // 复位信号，低电平有效
    input signed [14:0] d_uk,           // pid 增量

    output reg signed [14:0] uk0        // pid 输出值

);

reg signed [14:0] uk1 = 15'd0;          // 上一时刻u(k-1) 的值

always @(d_uk) begin
    uk0 = uk1 + d_uk;                   // 计算pid 输出值
    uk1 = uk0;                          // 寄存上一时刻 u(k-1) 的值
end

//<statements>

endmodule


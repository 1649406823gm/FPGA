///
// Company: <Name>
//
// File: incre_value.v
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

module incre_value( 

    input signed [9:0] ek0,
    input signed [9:0] ek1,
    input signed [9:0] ek2,

    input [3:0] kp,
    input [3:0] ki,
    input [3:0] kd,

    output signed [14:0] d_uk

);


assign  d_uk = kp * (ek0 - ek1) + ki * ek0 + kd*((ek0 - ek1)-(ek1 - ek2)); // 计算pid增量

//<statements>

endmodule



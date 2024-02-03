`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/07 13:55:29
// Design Name: 
// Module Name: PID_Control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pid_ctrl(
    input           clk,
    input           rst_n,

    input           pid_en,
    output          pid_ack,

    input signed [15:0] desired_value,
    input signed [15:0] current_value,

    //mul 100
    input[7:0]         Kp,
    input[7:0]         Ki,
    input[7:0]         Kd,

    output signed[16:0] out
);

reg cal_delay_0;
reg cal_delay_1;

reg signed[15:0]    Kp_fb;
reg signed[15:0]    Kp_fb_reduce;
reg signed[15:0]    Kp_fb_reduce_d0;

reg signed[18:0]    Ki_integral;
reg signed[18:0]    Ki_fb;
reg signed[18:0]    Ki_fb_reduce;

reg signed[15:0]    Kd_error;
reg signed[15:0]    Kd_last_error;
reg signed[15:0]    Kd_fb;
reg signed[15:0]    Kd_fb_reduce;
reg signed[15:0]    Kd_fb_reduce_d0;

assign pid_ack = cal_delay_1;

assign out = Kp_fb_reduce_d0 + Ki_fb_reduce + Kd_fb_reduce;


always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0 )
    begin
        cal_delay_0 <= 1'b0;
        cal_delay_1 <= 1'b0;
    end
    else begin
        cal_delay_0 <= pid_en;
        cal_delay_1 <= cal_delay_0;
    end

end

//P -------------------------------------------------
always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        Kp_fb <= 1'b0;
    else if( pid_en == 1'b1)
        Kp_fb <= ( desired_value - current_value ) * Kp;
    else
        Kp_fb <= Kp_fb;
end

always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        Kp_fb_reduce <= 'd0;
    else if( cal_delay_0 == 1'b1)
        Kp_fb_reduce <= (Kp_fb >>> 7) + (Kp_fb >>> 9); // /102.4
    else
        Kp_fb_reduce <= Kp_fb_reduce;
end

always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        Kp_fb_reduce_d0 <= 'd0;
    else if( cal_delay_1 == 1'b1)
        Kp_fb_reduce_d0 <= Kp_fb_reduce;
    else
        Kp_fb_reduce_d0 <= Kp_fb_reduce;

end
//------------------------------------------------------------------------------------

//I --------------------------------------------------------
always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        Ki_integral <= 'd0;
    else if( pid_en == 1'b1)
        if( Ki_integral > $signed('d3000) && ( desired_value - current_value ) > $signed('d0) )
            Ki_integral <= Ki_integral;
        else if( Ki_integral < $signed(-'d3000) && ( desired_value - current_value ) < $signed('d0) )
            Ki_integral <= Ki_integral;
        else
            Ki_integral <= Ki_integral + ( desired_value - current_value );
    else
        Ki_integral <= Ki_integral;
end


always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0 )
        Ki_fb <= 'd0;
    else if( cal_delay_0 == 1'b1 )
        Ki_fb <= Ki_integral * Ki;
    else
        Ki_fb <= Ki_fb;
end

always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0 )
        Ki_fb_reduce <= 'd0;
    else if( cal_delay_1 == 1'b1)
        Ki_fb_reduce <= (Ki_fb >>> 7) + (Ki_fb >>> 9); // /102.4
    else
        Ki_fb_reduce <= Ki_fb_reduce;
end

//------------------------------------------------------------------------------


//D    ---------------------------
always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        Kd_error <= 'd0;
    else if( pid_en == 1'b1)
        Kd_error <= ( desired_value - current_value );
    else
        Kd_error <= Kd_error;
end

always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        Kd_fb <= 'd0;
    else if( cal_delay_0 == 1'b1)
        Kd_fb <= (Kd_error - Kd_last_error) * Kd;
    else
        Kd_fb <= Kd_fb;
end


always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        Kd_last_error <= 'd0;
    else if( cal_delay_0 == 1'b1)
        Kd_last_error <= Kd_error;
    else
        Kd_last_error <= Kd_last_error;
end

always@(posedge clk or negedge rst_n)
begin
    if( rst_n == 1'b0)
        Kd_fb_reduce <= 'd0;
    else if( cal_delay_1 == 1'b1)
        Kd_fb_reduce <= (Kd_fb >>> 7) + (Kd_fb >>> 9); // /102.4
    else
        Kd_fb_reduce <= Kd_fb_reduce;
end
//--------------------------------
endmodule

//输入时钟来自lcd,25Mhz
module servo_dri (
	input					clk			    , 
	input					rst_n			,
	//输入坐标
	input			[9:0]	x_pos			,
	input			[9:0]	y_pos			,
	input					coor_valid_flag	,
    
    input           [9:0]   k210_xpos,
    input           [9:0]   k210_ypos,
    input                   k210_coor_flag,
    
    //串口
    input               rx,
    output              tx,
    
    //pid测试
    output          [14:0]   pid_x,
    output          [14:0]   pid_y,
    
	//舵机pwm
	output	reg		    	x_pwm,
	output	reg		   		y_pwm,
  
    output  reg             k210_xpwm,
    output  reg             k210_ypwm
);

wire xpid_ack;
wire ypid_ack;
wire [16:0] xout;
wire [16:0] yout;

//输入时钟周期为10ns,cnt_4us= 4us/10ns=400
localparam cnt_4us = 400;
//输入时钟周期为10ns,输入舵机信号IO的周期为20ms,cnt=20ms/10ns=2_000_000
localparam cnt_20ms = 1_000_000;

//占空比最大为2.5ms，最小为0.5ms
//min=0.5ms/10ns=50_000;
//max=2.5ms/10ns=250_000;
localparam max = 250_000;
localparam min = 2_5000;

reg [20:0] period_cnt;
//reg [9:0]  us_cnt;
//
//reg us_flag;

reg [17:0] x_duty_cycle;   //x_pwm占空比数值
reg [17:0] y_duty_cycle;   //y_pwm占空比数值

reg [17:0] k210_x_duty_cycle;   //x_pwm占空比数值
reg [17:0] k210_y_duty_cycle;   //y_pwm占空比数值

reg coor_valid_flag_r;
reg coor_valid_flag_pos;

reg k210_coor_flag_r;
reg k210_coor_flag_pos;

//pid串口调试
//rs232 rs232_inst(
//   .clk                 (clk),
//   .rst_n               (rst_n),
//
//   .rx                  (rx),
//   .tx                  (tx),
//   
//   .tx_data             (1),
//   .tx_trig             (1),
//);


//FPGA
always @(posedge clk) begin
    coor_valid_flag_r <= coor_valid_flag;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        coor_valid_flag_pos <= 1'b0;
    else if(~coor_valid_flag_r && coor_valid_flag)
        coor_valid_flag_pos <= 1'b1;
    else 
        coor_valid_flag_pos <= 1'b0;
end

//k210
always @(posedge clk) begin
    k210_coor_flag_r <= k210_coor_flag;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        k210_coor_flag_pos <= 1'b0;
    else if(~k210_coor_flag_r && k210_coor_flag)
        k210_coor_flag_pos <= 1'b1;
    else 
        k210_coor_flag_pos <= 1'b0;
end



//FPGAx方向舵机控制数据
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		x_duty_cycle <= 18'd7_5000; //1.5ms,初始位置时中间
	else if (coor_valid_flag_pos == 1'b1)begin
	        if(x_pos >= 10'd400 && x_duty_cycle > min)
//	        	x_duty_cycle <= x_duty_cycle - 3*(x_pos - 10'd400);
                x_duty_cycle <= x_duty_cycle + 10*xout;
			else if(x_pos < 10'd400 && x_duty_cycle < max)	
//        		x_duty_cycle <= x_duty_cycle + 3*(10'd400 - x_pos);
                x_duty_cycle <= x_duty_cycle + 10*xout;
        	else
        		x_duty_cycle <= x_duty_cycle;
    end
    else
    	x_duty_cycle <= x_duty_cycle;
end

//FPGAy方向舵机控制数据
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		y_duty_cycle <= 18'd7_5000; //1.5ms,初始位置时中间
	else if (coor_valid_flag_pos == 1'b1)begin
	        if(y_pos >= 10'd240 && y_duty_cycle > min)
//	        	y_duty_cycle <= y_duty_cycle - 3*(y_pos - 10'd240);
                y_duty_cycle <= y_duty_cycle + 10*yout;
			else if(y_pos < 10'd240 && y_duty_cycle < max)	
//        		y_duty_cycle <= y_duty_cycle + 3*(10'd240 - y_pos);
                y_duty_cycle <= y_duty_cycle + 10*yout;
        	else
        		y_duty_cycle <= y_duty_cycle;
    end
    else
    	y_duty_cycle <= y_duty_cycle;
end

//K210x方向舵机控制数据
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		k210_x_duty_cycle <= 18'd7_5000; //1.5ms,初始位置时中间
	else if (k210_coor_flag_pos == 1'b1)begin
	        if(k210_xpos >= 10'd400 && k210_x_duty_cycle > min)
	        	k210_x_duty_cycle <= k210_x_duty_cycle - 3*(k210_xpos - 10'd400);
//                x_duty_cycle <= x_duty_cycle + xout;
			else if(k210_xpos < 10'd400 && k210_x_duty_cycle < max)	
        		k210_x_duty_cycle <= k210_x_duty_cycle + 3*(10'd400 - k210_xpos);
//                x_duty_cycle <= x_duty_cycle - xout;
        	else
        		k210_x_duty_cycle <= k210_x_duty_cycle;
    end
    else
    	k210_x_duty_cycle <= k210_x_duty_cycle;
end

//K210y方向舵机控制数据
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		k210_y_duty_cycle <= 18'd7_5000; //1.5ms,初始位置时中间
	else if (k210_coor_flag_pos == 1'b1)begin
	        if(k210_ypos >= 10'd240 && k210_y_duty_cycle > min)
	        	k210_y_duty_cycle <= k210_y_duty_cycle - 3*(k210_ypos - 10'd240);
//                y_duty_cycle <= y_duty_cycle + yout;
			else if(k210_ypos < 10'd240 && k210_y_duty_cycle < max)	
        		k210_y_duty_cycle <= k210_y_duty_cycle + 3*(10'd240 - k210_ypos);
//                y_duty_cycle <= y_duty_cycle - yout;
        	else
        		k210_y_duty_cycle <= k210_y_duty_cycle;
    end
    else
    	k210_y_duty_cycle <= k210_y_duty_cycle;
end

////4us基准信号
//always @(posedge clk or negedge rst_n) begin
//	if(!rst_n)
//		us_cnt <= 10'd0;
//	else if(us_cnt >= cnt_4us - 1)
//		us_cnt <= 10'd0;
//	else	
//        us_cnt <= us_cnt + 1'b1;
//end
//
//always @(posedge clk or negedge rst_n) begin
//	if(!rst_n)
//		us_flag <= 1'b0;
//	else if(us_cnt == cnt_4us - 2)
//		us_flag <= 1'b1;
//	else	
//        us_flag <= 1'b0;
//end

//20ms周期计数
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		period_cnt <= 13'd0;
	else if (period_cnt == cnt_20ms - 1'b1)
	    period_cnt <= 13'd0;   
	else
		period_cnt <= period_cnt + 1'b1;
end

//x舵机
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		x_pwm <= 1'b0;
	else if(period_cnt <= x_duty_cycle)
		x_pwm <= 1'b1;
	else
		x_pwm <= 1'b0;    
end

//y舵机
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		y_pwm <= 1'b0;
	else if(period_cnt <= y_duty_cycle)
		y_pwm <= 1'b1;
	else
		y_pwm <= 1'b0;    
end


//k210x舵机
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		k210_xpwm <= 1'b0;
	else if(period_cnt <= k210_x_duty_cycle)
		k210_xpwm <= 1'b1;
	else
		k210_xpwm <= 1'b0;    
end

//k210y舵机
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		k210_ypwm <= 1'b0;
	else if(period_cnt <= k210_y_duty_cycle)
		k210_ypwm <= 1'b1;
	else
		k210_ypwm <= 1'b0;    
end


pid_ctrl pid_ctrl_instx(
    .clk            (   clk),
    .rst_n          (   rst_n),

   .pid_en          (   1'b1),
   .pid_ack         (   xpid_ack),

    .desired_value  (   10'd400),
    .current_value  (   x_pos),

    .Kp             (   'd10),
    .Ki             (   'd1),
    .Kd             (   'd10),
    
    .out            (   xout)
);

pid_ctrl pid_ctrl_insty(
    .clk            (   clk),
    .rst_n          (   rst_n),

   .pid_en          (   1'b1),
   .pid_ack         (   ypid_ack),

    .desired_value  (   10'd240),
    .current_value  (   y_pos),

    .Kp             (   'd10),
    .Ki             (   'd1),
    .Kd             (   'd10),
    
    .out            (   yout)
);






















//pid_top pid_top_inst_x(
//    .clk        (clk),
//    .rst_n      (rst_n),
//    .target     (10'd400),
//    .y          (x_pos),
//    .kp         (4'd2),
//    .ki         (0),
//    .kd         (0),
//    .uk0        (pid_x)
//);
//
//pid_top pid_top_inst_y(
//    .clk        (clk),
//    .rst_n      (rst_n),
//    .target     (10'd240),
//    .y          (y_pos),
//    .kp         (4'd2),
//    .ki         (4'd2),
//    .kd         (0),
//    .uk0        (pid_y)
//);

endmodule



////输入时钟来自lcd,25Mhz
//module servo_dri (
//	//system signals
//	input					clk			, 
//	input					rst_n			,
//	//输入坐标
//	input			[9:0]	x_pos			,
//	input			[9:0]	y_pos			,
//	input					coor_valid_flag	,
//	//舵机pwm
//	output			    	x_pwm			,
//	output			   		y_pwm		
//);
//
//
//
////目标中心坐标
//localparam          ctr_xpos = 10'd400;
//localparam          ctr_ypos = 10'd240;
//
////对应0度
////X舵机初始状态x_pwm
//localparam ctr_xpwm   = 18'd150_000;
////Y舵机初始状态y_pwm 
//localparam ctr_ypwm   = 18'd150_000;
//
//reg [28:0] wait_cnt;  //等待5s计数器
//
//reg  [20:0]  period_cnt ;   //周期计数器频率：50hz 周期:20ms  计数值:20ms/10ns=2_000_000
//reg  [17:0]  x_duty_cycle ;   //x_pwm占空比数值
//reg  [17:0]  y_duty_cycle ;   //y_pwm占空比数值
//
////根据占空比和计数值之间的大小关系来输出pwm
//assign x_pwm = (period_cnt <= x_duty_cycle) ?  1'b1  :  1'b0;
//assign y_pwm = (period_cnt <= y_duty_cycle) ?  1'b1  :  1'b0;
//
////输入时钟周期为10ns,输入舵机信号IO的周期为20ms,cnt=2_000_000;
////周期计数器 20ms
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n)
//        period_cnt <= 21'd0;
//    else if(period_cnt == 21'd2_000_000 - 1'b1)
//        period_cnt <= 21'd0;
//    else
//        period_cnt <= period_cnt + 1'b1;
//end
//
////5s计数器
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n)
//        wait_cnt <= 29'd0;
//    else if((wait_cnt == 29'd500_000_000 - 1'b1) || (coor_valid_flag == 1'b1))
//        wait_cnt <= 29'd0;
//    else
//        wait_cnt <= wait_cnt + 1'b1;
//end
//
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n)
//        x_duty_cycle <= ctr_xpwm;
//    else if(coor_valid_flag == 1'b1) begin    //目标有效信号拉高
//        if(period_cnt == 21'd2_000_000) begin  //计满20ms
//            if(x_pos >= ctr_xpos)begin    //目标横坐标在中心点右侧
//                if(((x_pos - ctr_xpos) >= 10'd0) && (x_duty_cycle >= 18'd50_000)) //大于中心点50像素,且大于最小0.5ms pwm占比
//                    x_duty_cycle <= x_duty_cycle - 18'd2_50;  //X舵机向右转0.002ms占空比
//                else
//                    x_duty_cycle <= x_duty_cycle;  //目标横坐标落在在中心点50像素内x_pwm保持不变
//            end
//            else begin
//                if(((ctr_xpos - x_pos) >= 10'd0) && (x_duty_cycle <= 18'd250_000))  //目标横坐标落在中心点左侧,且小于最大2.5ms pwm占比
//                    x_duty_cycle <= x_duty_cycle + 18'd2_50;  //X舵机向左转0.0025ms占空比
//                else
//                    x_duty_cycle <= x_duty_cycle;
//            end
//        end
//    end
//    else begin
//        if(wait_cnt == 29'd500_000_000)  //目标信号拉低,且等待5s回到舵机初始位置
//            x_duty_cycle <= ctr_xpwm;
//    end
//end
//
////============================Y_PWM========================================
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n)
//        y_duty_cycle <= ctr_ypwm;
//    else if(coor_valid_flag == 1'b1)begin    //目标有效信号拉高
//        if(period_cnt == 21'd2_000_000)begin  //计满20ms
//            if(y_pos >= ctr_ypos)    //目标纵坐标在中心点上侧
//                if(((y_pos - ctr_ypos) >= 10'd0) && (y_duty_cycle <= 18'd250_000)) //大于中心点50像素,且小于最大2.5ms pwm占比
//                    y_duty_cycle <= y_duty_cycle + 18'd5_00;  //Y舵机向下转0.0025ms占空比
//                else
//                    y_duty_cycle <= y_duty_cycle;  //目标纵坐标落在在中心点50像素内y_pwm保持不变
//            else begin
//                if(((ctr_ypos - y_pos) >= 10'd0) && ((y_duty_cycle >= 18'd50_000)))  //目标横坐标落在中心点左侧,且大于0.5ms pwm占比
//                    y_duty_cycle <= y_duty_cycle - 18'd5_00;  //Y舵机向上转0.005ms占空比
//                else
//                    y_duty_cycle <= y_duty_cycle;
//            end
//        end
//    end
//    else begin
//        if(wait_cnt == 29'd500_000_000) //目标信号拉低,且等待5s回到舵机初始位置
//            y_duty_cycle <= ctr_ypwm;
//    end
//end 
//
//endmodule
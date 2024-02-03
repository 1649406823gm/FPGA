//目标物体坐标提取模块,接受来自lcd的输出时序
module coordinate(
    input           clk,
    input           rst_n,

    //图像处理前的数据接口
    //来自lcd的时序信号
    input           vsync_i,
    input           hsync_i,
    input           data_en_i,
    
    input           data_i,
    
    //串口测试接口
    // output  reg [15:0] valid_num_cnt,
    
    //图像处理后的数据接口,提供给舵机
    output  [9:0]   x_coor,
    output  [9:0]   y_coor,
    output          coor_valid_flag,
    
    output   [9:0] x_min_o,
    output   [9:0] x_max_o,
    output   [9:0] y_min_o,
    output   [9:0] y_max_o
);

reg [9:0] x_min;
reg [9:0] x_max;
reg [9:0] y_min;
reg [9:0] y_max;

reg [9:0] x_min_r;
reg [9:0] x_max_r;
reg [9:0] y_min_r;
reg [9:0] y_max_r;




reg data_en_i_pos	;
reg data_en_i_r1	;

reg vsync_i_pos		;
reg vsync_i_neg		;
reg vsync_i_r1		;


//有效像素点计数和有效物体有效标志
reg [15:0] valid_num_cnt;
reg 	   valid_flag;

//x和y坐标总和
reg	[31:0] x_coor_all;
reg	[31:0] y_coor_all;

//行和列计数
reg [9:0]  row_cnt;
reg [9:0]  col_cnt;	

//框
reg [9:0] x;
reg [9:0] y;
wire add_x,add_y,end_x,end_y;




always @(posedge clk or negedge rst_n) begin
    data_en_i_r1 <= data_en_i;
end
//数据有效上升沿,对列计数
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        data_en_i_pos <= 1'b0;
    else if(~data_en_i_r1 & data_en_i)
        data_en_i_pos <= 1'b1;
    else
        data_en_i_pos <= 1'b0;
end


always @ (posedge clk) begin	
	vsync_i_r1 <= vsync_i;
end
//场有效上降沿
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		vsync_i_pos <= 1'b0;
	else if (~vsync_i_r1 && vsync_i)
	    vsync_i_pos <= 1'b1;    
	else	
        vsync_i_pos <= 1'b0;
end

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		vsync_i_neg <= 1'b0;
	else if (vsync_i_r1 && ~vsync_i)
	    vsync_i_neg <= 1'b1;    
	else	
        vsync_i_neg <= 1'b0;
end


//列计数
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		col_cnt <= 10'd0;
	else if(data_en_i)
		col_cnt <= col_cnt + 1'b1;
	else 	
		col_cnt <= 10'd0;
end

//行计数
//always @(posedge clk or negedge rst_n) begin
//	if(!rst_n)
//		row_cnt <= 10'd0;
//	else if(vsync_i_neg)
//		row_cnt <= 10'd0;
//	else if (data_en_i_pos)	
//		row_cnt <= row_cnt + 1'b1;
//end
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		row_cnt <= 10'd0;
	else if(col_cnt == 10'd800 - 1'b1)
		row_cnt <= row_cnt + 1'b1;
	else if(row_cnt == 10'd480 - 1'b1)	
		row_cnt <= 10'd0;
end



//目标数据计数
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		valid_num_cnt <= 16'd0;
	else if (vsync_i_neg == 1'b1)
		valid_num_cnt <= 16'd0;   
	else if (data_en_i == 1'b1 && data_i == 1'b1)
		valid_num_cnt <= valid_num_cnt + 1'b1;   
end


//目标有效标志
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        valid_flag <= 1'b0;
    else if(vsync_i_neg == 1'b1)
        valid_flag <= 1'b0;
    else if(valid_num_cnt >= 16'd1500)
        valid_flag <= 1'b1;
end     

//x坐标求和
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		x_coor_all <= 32'd0;
	else if (data_en_i == 1'b1 && data_i == 1'b1)
	    x_coor_all <=  x_coor_all +  col_cnt;  
	else if (vsync_i_neg == 1'b1)
	    x_coor_all <= 32'd0;    	   
end


//y坐标求和
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		y_coor_all <= 32'd0;
	else if (data_en_i == 1'b1 && data_i == 1'b1)
	    y_coor_all <=  y_coor_all +  row_cnt;  
	else if (vsync_i_neg == 1'b1)
	    y_coor_all <= 32'd0;    	   
end

//assign x_coor =  (vsync_i == 1'b1 ) ? x_coor_all / valid_num_cnt : 10'd0;
//assign y_coor =  (vsync_i == 1'b1 ) ? y_coor_all / valid_num_cnt : 10'd0;
assign coor_valid_flag = valid_flag && vsync_i;



//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n) begin
//        x_min <= 10'd800 - 1'b1;
//    end
//    else if(vsync_i_pos) begin
//        x_min <= 10'd800 - 1'b1;
//    end
//    else if(data_i== 1'b1 && x_min > col_cnt) begin
//        x_min <= col_cnt;
//    end
//end
//
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n) begin
//        x_max <= 0;
//    end
//    else if(vsync_i_pos) begin
//        x_max <= 0;
//    end
//    else if(data_i == 1'b1 && x_max < col_cnt) begin
//        x_max <= col_cnt;
//    end
//end
//
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n) begin
//        y_min <= 10'd480 - 1'b1;
//    end
//    else if(vsync_i_pos) begin
//        y_min <= 10'd480 - 1'b1;
//    end
//    else if(data_i == 1'b1 && y_min > row_cnt) begin
//        y_min <= row_cnt;
//    end
//end
//
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n) begin
//        y_max <= 0;
//    end
//    else if(vsync_i_pos) begin
//        y_max <= 0;
//    end
//    else if(data_i == 1'b1 && y_max < row_cnt) begin
//        y_max <= row_cnt;
//    end
//end













assign add_x = data_en_i;
assign end_x = add_x && (x == 10'd800 - 10'd1);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        x <= 10'd0;
    else if(add_x) begin
        if(end_x)
            x <= 10'd0;
        else
            x <= x + 10'd1;
    end
end


assign add_y = end_x;
assign end_y = add_y && (y == 10'd480 - 10'd1);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        y <= 10'd0;
    else if(add_y) begin
        if(end_y)
            y <= 10'd0;
        else
            y <= y + 10'd1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        x_min <= 10'd800;
    end
    else if(vsync_i_pos) begin
        x_min <= 10'd800;
    end
    else if(data_i== 1'b1 && x_min > x) begin
        x_min <= x;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        x_max <= 0;
    end
    else if(vsync_i_pos) begin
        x_max <= 0;
    end
    else if(data_i == 1'b1 && x_max < x) begin
        x_max <= x;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        y_min <= 10'd480;
    end
    else if(vsync_i_pos) begin
        y_min <= 10'd480;
    end
    else if(data_i == 1'b1 && y_min > y) begin
        y_min <= y;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        y_max <= 0;
    end
    else if(vsync_i_pos) begin
        y_max <= 0;
    end
    else if(data_i == 1'b1 && y_max < y) begin
        y_max <= y;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        x_min_r <= 0;
        x_max_r <= 0;
        y_min_r <= 0;
        y_max_r <= 0;
    end
    else if(vsync_i_pos) begin
        x_min_r <= x_min;
        x_max_r <= x_max;
        y_min_r <= y_min;
        y_max_r <= y_max;
    end
end

assign x_min_o = x_min_r;
assign x_max_o = x_max_r;
assign y_min_o = y_min_r;
assign y_max_o = y_max_r;

assign x_coor =  (vsync_i == 1'b1 ) ? (x_max_r + x_min_r) / 2 : 10'd0;
assign y_coor =  (vsync_i == 1'b1 ) ? (y_max_r + y_min_r) / 2 : 10'd0;

endmodule
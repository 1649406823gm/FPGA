//module gaussian_filter(
//    input           clk,
//    input           rst_n,
//    
//    //图像处理前的数据接口
//    input           vsync_i,    //vsync信号
//    input           hsync_i,     //hsync信号
//    input           data_en_i,       //数据使能信号
//    input   [15:0]  y_data_i,           //之前的数据
//    
//    //图像处理后的数据接口
//    output          vsync_o,  //vsync信号
//    output          hsync_o,   //hsync信号
//    output          data_en_o,     //数据使能信号
//    output  [15:0]  erode_data_o
//);
//
//
//wire matrix_11,matrix_12,matrix_13,matrix_21,matrix_22,matrix_23,matrix_31,matrix_32,matrix_33;
//
//reg     [11:0]              gs_1                    ;
//reg     [11:0]              gs_2                    ;
//reg     [11:0]              gs_3                    ;
//reg     [11:0]              gs                      ;
//
//
//reg [2:0] vsync_i_r;
//reg [2:0] hsync_i_r;
//reg [2:0] data_en_i_r;
//
//wire matrix_frame_vsync;
//wire matrix_frame_hsync;
//wire matrix_frame_clken;
//
//matrix_3x3_16bit matrix_3x3_16bit_inst(
//    .clk                (clk),
//    .rst_n              (rst_n),
//
//    //图像处理前的数据接口
//    .vsync_i            (vsync_i),    //vsync信号
//    .hsync_i            (hsync_i),     //hsync信号
//    .clk_en_i           (data_en_i),
//    .data_i             (y_data_i),           //之前的数据
//    
//    .matrix_frame_vsync (matrix_frame_vsync),
//    .matrix_frame_hsync (matrix_frame_hsync),
//    .matrix_frame_clken (matrix_frame_clken),
//
//    //图像处理后的数据接口
//    .matrix_11          (matrix_11),
//    .matrix_12          (matrix_12),
//    .matrix_13          (matrix_13),
//    .matrix_21          (matrix_21),
//    .matrix_22          (matrix_22),
//    .matrix_23          (matrix_23),
//    .matrix_31          (matrix_31),
//    .matrix_32          (matrix_32),    
//    .matrix_33          (matrix_33)
//);    
//
//always @ (posedge clk or negedge rst_n)begin
//    if(!rst_n)begin
//        gs_1 <= 'd0;
//        gs_2 <= 'd0;
//        gs_3 <= 'd0;
//    end
//    else begin
//        gs_1 <= matrix_11     + matrix_12 * 2 + matrix_13;
//        gs_2 <= matrix_21 * 2 + matrix_22 * 4 + matrix_23 * 2;
//        gs_3 <= matrix_31     + matrix_32 * 2 + matrix_33;
//    end
//end
//
////clk2，相加
////---------------------------------------------------
//always @(posedge clk or negedge rst_n)begin
//    if(!rst_n)begin
//        gs <= 'd0;
//    end
//    else begin
//        gs <= gs_1 + gs_2 + gs_3;
//    end
//end
//
////clk3，除以16 -> 右移4位 -> 取高8位
////---------------------------------------------------
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n) begin
//        gaussian_data <= 'd0;
//    end
//    else begin
//        gaussian_data <= gs[11:4];
//    end
//end
//
//assign erode_data_o = erode ? 16'hffff : 16'h0000;
//
//
//always @(posedge clk or negedge rst_n) begin
//    if(!rst_n) begin
//        data_en_i_r <= 0;
//        hsync_i_r <= 0;
//        vsync_i_r <= 0; 
//    end
//    else begin
//        data_en_i_r <= {data_en_i_r[2:0],matrix_frame_clken};
//        hsync_i_r   <= {hsync_i_r[2:0],matrix_frame_hsync};
//        vsync_i_r   <= {vsync_i_r[2:0],matrix_frame_vsync};
//    end
//end
//
//assign data_en_o = data_en_i_r[3];
//assign hsync_o   = hsync_i_r[3];
//assign vsync_o   = vsync_i_r[3];
//
//endmodule
module lcd_display(
    input                lcd_clk,
    input                rst_n,       //复位，低电平有效
    
//    input           [9:0] x_min_i,
//    input           [9:0] x_max_i,
//    input           [9:0] y_min_i,
//    input           [9:0] y_max_i,
//    
//    input           [15:0] data_i,
    
    
    
    input        [10:0]  pixel_xpos,  //当前像素点横坐标
    input        [10:0]  pixel_ypos,  //当前像素点纵坐标  
    input        [10:0]  h_disp,      //LCD屏水平分辨率
    input        [10:0]  v_disp,      //LCD屏垂直分辨率       
    output  reg  [15:0]  pixel_data   //像素数据
);


//parameter define  
parameter WHITE = 16'b11111_111111_11111;  //白色
parameter BLACK = 16'b00000_000000_00000;  //黑色
parameter RED   = 16'b11111_000000_00000;  //红色
parameter GREEN = 16'b00000_111111_00000;  //绿色
parameter BLUE  = 16'b00000_000000_11111;  //蓝色

//根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条
always @(posedge lcd_clk or negedge rst_n) begin
    if(!rst_n)
        pixel_data <= BLACK;
    else begin
//        if(pixel_ypos == 10 && pixel_xpos >= 20 && pixel_xpos <= 500)
//            pixel_data <= BLUE;
//        else if(pixel_ypos == 50 && pixel_xpos >= 20 && pixel_xpos <= 500)
//            pixel_data <= BLUE;
//        else if(pixel_xpos == 20 && pixel_xpos >= 10 && pixel_xpos <= 50)
//            pixel_data <= BLUE;
//        else if(pixel_xpos == 500 && pixel_xpos >= 10 && pixel_xpos <= 50)
//            pixel_data <= BLUE;   
//        else 
//            pixel_data <= data_i;
    
    
//        if(pixel_ypos == y_min_i && pixel_xpos >= x_min_i && pixel_xpos <= x_max_i)
//            pixel_data <= BLUE;
//        else if(pixel_ypos == y_max_i && pixel_xpos >= x_min_i && pixel_xpos <= x_max_i)
//            pixel_data <= BLUE;
//        else if(pixel_xpos == x_min_i && pixel_xpos >= y_min_i && pixel_xpos <= y_max_i)
//            pixel_data <= BLUE;
//        else if(pixel_xpos == x_max_i && pixel_xpos >= y_min_i && pixel_xpos <= y_max_i)
//            pixel_data <= BLUE;   
//        else 
//            pixel_data <= data_i;
//            
//        if((pixel_xpos >= 11'd0) && (pixel_xpos < h_disp/5*1))
//            pixel_data <= WHITE;
//        else if((pixel_xpos >= h_disp/5*1) && (pixel_xpos < h_disp/5*2))    
//            pixel_data <= BLACK;
//        else if((pixel_xpos >= h_disp/5*2) && (pixel_xpos < h_disp/5*3))    
//            pixel_data <= RED;   
//        else if((pixel_xpos >= h_disp/5*3) && (pixel_xpos < h_disp/5*4))    
//            pixel_data <= GREEN;                
//        else 
//            pixel_data <= BLUE;      
    end    
end
  
endmodule

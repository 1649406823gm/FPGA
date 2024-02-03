module bluetooth(
    input   wire    clk,
    input   wire    rst_n,
        
    input   wire    rx,
    output  wire    tx,

    //作为坐标处理的接口
    input [7:0] tx_data,
    input       tx_trig,
    
    output reg [9:0] k210_xpos,
    output reg [9:0] k210_ypos,
    output           k210_coor_flag
);


parameter  UART_BPS = 14'd9600;
parameter  CLK_FREQ = 26'd50_000_000;

wire [7:0] po_data;
wire       po_flag;

reg [2:0]  dot_flag;
reg        n_flag;

reg [2:0]  byte_cnt;

reg [7:0]  po_data_d0;
reg [7:0]  po_data_d1;
reg [7:0]  po_data_d2;
reg [7:0]  po_data_d3;
reg [7:0]  po_data_d4;
reg [7:0]  po_data_d5;


reg [7:0]  xdata1;
reg [7:0]  xdata2;
reg [7:0]  xdata3;
reg [7:0]  ydata1;
reg [7:0]  ydata2;
reg [7:0]  ydata3;
reg [7:0]  n_data;

uart_tx #(
    .UART_BPS(UART_BPS),
    .CLK_FREQ(CLK_FREQ)
) uart_tx_inst(
    .sys_clk(clk),
    .sys_rst_n(rst_n),
    .pi_data(xdata1),
    .pi_flag(po_flag),
    .tx(tx)
);

uart_rx #(
    .UART_BPS(UART_BPS),
    .CLK_FREQ(CLK_FREQ)
) uart_rx_inst(
    .sys_clk(clk),
    .sys_rst_n(rst_n),
    .rx(rx),
    .po_data(po_data),
    .po_flag(po_flag)
);

parameter IDLE       = 7'b0_000_001;
parameter Send_Data1 = 7'b0_000_010;
parameter Send_Data2 = 7'b0_000_100;
parameter Send_Data3 = 7'b0_001_000;
parameter Send_Data4 = 7'b0_010_000;
parameter Send_Data5 = 7'b0_100_000;
parameter Send_Data6 = 7'b1_000_000;

reg [6:0] state;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
        byte_cnt <= 3'd0;
    end
    else begin
        if(byte_cnt == 3'd6)
            byte_cnt <= 3'd0;
        case(state)
            IDLE : begin
                byte_cnt <= 3'd0;
                if(po_flag) begin 
                    if(po_data == 8'h0B)
                        state <= Send_Data1;
                    else if(po_data != 8'h0B)
                        state <= IDLE;
                end
                else
                    state <= IDLE;
            end
            Send_Data1: begin
//                byte_cnt <= byte_cnt + 1'b1;
                if(po_flag) begin
                    if(po_data != 8'h0A) begin
                        byte_cnt <= byte_cnt + 1'b1;
                        state <= Send_Data2;
                    end
                    else if(po_data == 8'h0A)
                        state <= IDLE;
                end
                else 
                    state <= Send_Data1;
            end
            Send_Data2: begin
//                byte_cnt <= byte_cnt + 1'b1;
                if(po_flag) begin
                    if(po_data != 8'h0A) begin
                        if(po_data == 8'h44)
                            state <= Send_Data4;
                        else begin
                            state <= Send_Data3;
                            byte_cnt <= byte_cnt + 1'b1;        //鑻ヤ负閫楀彿锛屼笉搴旇绠椾綔鏈夋晥鏁板€硷紝鏁呬笉搴旇鍔锛屽弽涔嬪姞1
                       end
                    end
                    else if(po_data == 8'h0A)
                        state <= IDLE;
                    else if(po_data == 8'h44)
                        state <= Send_Data4; 
                end
                else
                    state <= Send_Data2;
            end
            Send_Data3: begin
//                byte_cnt <= byte_cnt + 1'b1;
                if(po_flag) begin
                    if(po_data != 8'h0A) begin
                        if(po_data == 8'h44)
                            state <= Send_Data4;
                        else begin
                            state <= Send_Data4;
                            byte_cnt <= byte_cnt + 1'b1;
                        end
                    end
                    else if(po_data == 8'h0A)
                        state <= IDLE;
                end
                else
                    state <= Send_Data3;
            end
//            Dot: begin
//                if(po_flag) begin
//                    if(po_data != 8'h0A) begin
//                        state <= Send_Data4;
//                    end
//                    else if(po_data == 8'h0A)
//                        state <= IDLE;
//                end
//                else
//                    state <= Dot;
//            end
            Send_Data4: begin
//                byte_cnt <= byte_cnt + 1'b1;
                if(po_flag) begin
                    if(po_data != 8'h0A) begin
                        if(po_data == 8'h44)
                            state <= Send_Data4;
                        else begin
                            state <= Send_Data5;
                            byte_cnt <= byte_cnt + 1'b1;
                        end
                    end
                    else if(po_data == 8'h0A)
                        state <= IDLE;
                end
                else
                    state <= Send_Data4;
            end
            Send_Data5: begin
//                byte_cnt <= byte_cnt + 1'b1;
                if(po_flag) begin
                    if(po_data != 8'h0A) begin
                        state <= Send_Data6;
                        byte_cnt <= byte_cnt + 1'b1;
                    end
                    else if(po_data == 8'h0A)
                        state <= IDLE;
                end
                else
                    state <= Send_Data5;
            end
            Send_Data6: begin
//                byte_cnt <= byte_cnt + 1'b1;
                if(po_flag) begin
                    if(po_data != 8'h0A) begin
                        state <= IDLE;
                        byte_cnt <= byte_cnt + 1'b1;
                    end
                    else if(po_data == 8'h0A)
                        state <= IDLE;
                end
                else
                    state <= Send_Data6;
            end
            default : state <= IDLE;
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        xdata1 <= 8'b0;
        xdata2 <= 8'b0;
        xdata3 <= 8'b0;
        ydata1 <= 8'b0;
        ydata2 <= 8'b0;
        ydata3 <= 8'b0;
        dot_flag <= 3'd0;
    end
    else if(state == Send_Data1 && po_data != 8'h0A) begin
        xdata1 <= po_data - 8'h30;
//        dot_flag <= 3'd0;
    end
    else if(state == Send_Data2 && po_data != 8'h0A) begin
        if(po_data == 8'h44) begin
            xdata2 <= 8'h44;
            dot_flag <= 3'd2;
        end    
        else begin
            xdata2 <= po_data - 8'h30;
//            dot_flag <= 3'd0;
        end
    end
    else if(state == Send_Data3 && po_data != 8'h0A) begin
        if(po_data == 8'h44) begin
            xdata3 <= 8'h44;
            dot_flag <= 3'd3;
        end
        else begin
            xdata3 <= po_data - 8'h30;
//            dot_flag <= 3'd0;
        end
    end
    else if(state == Send_Data4 && po_data != 8'h0A) begin
       if(po_data == 8'h44) begin
            ydata1 <= 8'h44;
            dot_flag <= 3'd4;
       end
       else begin
            ydata1 <= po_data - 8'h30;
//            dot_flag <= 3'd0;
       end
    end
    else if(state == Send_Data5 && po_data != 8'h0A) begin
//       dot_flag <= 3'd0;
       ydata2 <= po_data - 8'h30;
    end
    else if(state == Send_Data6 && po_data != 8'h0A) begin
//        dot_flag <= 3'd0;
        ydata3 <= po_data - 8'h30;
    end
    else begin
        xdata1 <= xdata1;
        xdata2 <= xdata2;
        xdata3 <= xdata3;
        ydata1 <= ydata1;
        ydata2 <= ydata2;
        ydata3 <= ydata3;
    end    
end


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        k210_xpos <= 10'd0;
        k210_xpos <= 10'd0;
    end
    else if(state == IDLE) begin
        case(byte_cnt)
            3'd3: begin
                if(dot_flag == 3'd3) begin
                    k210_xpos <= xdata1 * 10 + xdata2;
                    k210_ypos <= ydata1;
                end
                else if(dot_flag == 3'd2) begin
                    k210_xpos <= xdata1;
                    k210_ypos <= ydata1 * 10 + ydata2;
                end
            end
            3'd6: begin
                k210_xpos <= xdata1 * 100 + xdata2 * 10 + xdata3;
                k210_ypos <= ydata1 * 100 + ydata2 * 10 + ydata3;
            end
            3'd4: begin
                if(dot_flag == 3'd2) begin
                    k210_xpos <= xdata1;
                    k210_ypos <= ydata1 * 100 + ydata2 * 10 + ydata3;
                end
                else if(dot_flag == 3'd4) begin
                    k210_xpos <= xdata1 * 100 + xdata2 * 10 + xdata3;
                    k210_ypos <= ydata1;
                end
                else begin
                    k210_xpos <= xdata1 * 10 + xdata2;
                    k210_ypos <= ydata1 * 10 + ydata2;
                end
            end
            3'd5: begin
                if(dot_flag == 3'd3) begin
                    k210_xpos <= xdata1 * 10 + xdata2;
                    k210_ypos <= ydata1 * 100 + ydata2 * 10 + ydata3;
                end
                else if(dot_flag == 3'd4) begin
                    k210_xpos <= xdata1 * 100 + xdata2 * 10 + xdata3;
                    k210_ypos <= ydata1 * 10 + ydata2;
                end
            end
            default: begin
                k210_xpos <= k210_xpos;
                k210_ypos <= k210_ypos;
            end
        endcase
    end
end

assign k210_coor_flag = (state == IDLE) ? 1'b1 :1'b0;

endmodule
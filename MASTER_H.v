`timescale 1ns / 1ps


module MASTER_H(
    input HRESET,
    input HCLK,
    input HREADY,
    input [31:0]HRDATA,
    input [31:0]data_out,
    input [31:0]add,
    input [31:0]add_m,
    input HWRITE,
    input [2:0]size,
    input [2:0]burst_type,
    input [1:0]trans,
    input [31:0]wrap_input,
    input again,
    input new,
    input [31:0]single_input,
    
    output reg[31:0]HADDR,
    output reg[31:0]HADDR_M,
    output [31:0]HWDATA,
    output [31:0]data_in,
    output reg[7:0]HSIZE,
    output reg[2:0]HBURST,
    output reg[1:0]HTRANS,
    output reg[7:0]N,
    output reg[7:0]M,
    output reg[31:0]O,
    output [31:0]count_no,
    output reg[31:0]count,
    output reg burst_done
    
    );
    
    // 1byte --> HSIZE=3'b000;
    // 2byte --> HSIZE=3'b001;
    // 4byte --> HSIZE=3'b010;
    // 8byte --> HSIZE=3'b011;
    // 16byte --> HSIZE=3'b100;
    
    assign HWDATA = data_out;
    assign data_in = HRDATA;
    
     reg[1:0]count0=2'd0;
     reg[31:0]count1=32'd0;
     reg[2:0]count2=3'd0;
     reg[2:0]count3=3'd0;
     reg[3:0]count4=4'd0;
     reg[3:0]count5=4'd0;
     reg[4:0]count6=5'd0;
     reg[4:0]count7=5'd0;

     
    assign count_no = (wrap_input - add)/4;
    
    
    integer i;
    initial begin
        N <= 8'd0;
        M <= 8'd0;
        O <= 32'd0;
        burst_done <= 0;
        count <= 0;
    end
    
    reg [1:0]r1 = 2'b11;
    
    always @(*)begin
        case(size)
            3'b000: HSIZE <= 8'd8; 
            3'b001: HSIZE <= 8'd16;
            3'b010: HSIZE <= 8'd32;
            3'b011: HSIZE <= 8'd64;
            3'b100: HSIZE <= 8'd128;
            endcase
            end 
            
//             HBURST <= 3'b000; //only 1 transfer
//             HBURST <= 3'b001; //incrementing with unknown length
//             HBURST <= 3'b010; //4 beats, wrapping
//             HBURST <= 3'b011; //4 beats, incrementing
//             HBURST <= 3'b100; //8 beats, wrapping
//             HBURST <= 3'b101; //8 beats, incrementing
//             HBURST <= 3'b110; //16 beats, wrapping
//             HBURST <= 3'b111; //16 beats, incrementing
    
    
     
    //burst_type==3'b000
    always @(negedge HCLK) begin
        if(HRESET==0)begin
                HADDR <= 32'd0;
                HTRANS  <= 2'b00;
                HADDR_M <= 32'd0;
                count0 <= 0;
                O <= 32'd4;
        end
        if(trans == 2'b00)
                burst_done <= 0;
        if(HREADY==1 && HRESET==1 && burst_done == 0)begin
            if(burst_type == 3'b000 && trans != 2'b01)begin
                HBURST <= 3'b000;
                count0 <= count0 + 1;
                HADDR <= single_input;
                HTRANS <= 2'b10; 
                if(new == 1)begin
                O <= 32'd4;
                HADDR_M <= 32'd0;
                end
                HADDR_M <= add_m + O;           
                if(HADDR == single_input)begin
                HTRANS <= 2'b00;
                if (new == 0) begin
                O <= O + (1 << size);
                end
                end
                if(again == 1 && HTRANS == 2'b00)begin
                burst_done <= 0;
                count0 <= 0;
                HADDR_M <= add_m + O;
                end
                if(count0 == 2 && again != 1)begin
                burst_done <= 1;
                count0 <= 0;
                end 
                end
                end 
                if(burst_type == 3'b000 && trans == 2'b01)begin
                    HTRANS <= 2'b01;
                    HBURST <= 3'b000;
                end
                if(burst_type != 3'b000 && count == 2)begin
                    count0 <= 0;
                end
    end
              
    
    
    //burst_type==3'b001
    always @(negedge HCLK) begin
        if(HRESET==0)begin
                HADDR <= 32'd0;
                HADDR_M <= 32'd0;
                N <= 8'd0;
                O <= 32'd4;
                count1 <= 0;
                HTRANS  <= 2'b00;
        end
        if(HREADY==1 && HRESET==1)begin
            if(burst_type == 3'b001 && trans != 2'b00 && trans != 2'b01)begin
                HBURST <= 3'b001;
                if(count1 == 0)begin
                HTRANS <= 2'b10;
                end
                if(count1 > 0)begin
                HTRANS <= 2'b11;
                end
                if(new == 1)begin
                O <= 32'd4;
                HADDR_M <= 32'd0;
                end
                if(trans == 2'b10)begin
                count1 <= count1 + 1;
                N <= N + (1 << size);
                HADDR <= add + N;
                if (new == 0) begin
                O <= O + (1 << size);
                HADDR_M <= add_m + O;
                end
                end
            end
            if(burst_type == 3'b001 && trans == 2'b00)begin
                N <= 8'd0;
                count1 <= 32'd0;
                HTRANS <= 2'b00;
                HBURST <= 3'b001;
            end
            if(burst_type == 3'b001 && trans == 2'b01)begin
                HTRANS <= 2'b01;
                HBURST <= 3'b001;
            end
        end
    end 
    
   //burst_type==3'b010
   always @(negedge HCLK)begin
            if(HRESET==0)begin
                HADDR <= 32'd0;
                HADDR_M <= 32'd0;
                N <= 8'd0;
                M <= 8'd0;
                O <= 32'd4;
                count2 <= 0;
                count <= 0;
                HTRANS  <= 2'b00;
                burst_done <= 0;
            end
            if(trans == 2'b00)
                burst_done <= 0;
            if(HREADY==1 && HRESET==1 && burst_done == 0)begin

                if(burst_type == 3'b010 && trans != 2'b01)begin
                HBURST <= 3'b010;
                if(count2 == 0)
                HTRANS <= 2'b10;
                if(count2 > 0 && count2 < 3)
                HTRANS <= 2'b11;
                if(new == 1)begin
                O <= 32'd4;
                HADDR_M <= 32'd0;
                end
                if(count2 < 4 - count_no)begin
                count2 <= count2 + 1;
                count <= count + 1;
                N <= N + (1 << size);
                HADDR <= wrap_input + N;
                if (new == 0) begin
                O <= O + (1 << size);
                HADDR_M <= add_m + O;
                end
                end 
                if(count2 >= 4 - count_no && count2 < 3)begin
                N <= 8'd0;
                M <= M + (1 << size);
                end
                if(count2 >= 4 - count_no && count2 < 4)begin
                N <= 8'd0;
                count2 <= count2 + 1;
                count <= count + 1;
                HADDR <= add + M;
                if (new == 0) begin
                O <= O + (1 << size);
                HADDR_M <= add_m + O;
                end
                end 
                if(count2 >= 3) begin
                N <= 8'd0;
                M <= 8'd0;
                if(again == 1)begin
                burst_done <= 0;
                count2 <= 0;
                count <= 0;
                end
                if(count2 == 4 )begin
                burst_done <= 1;
                count2 <= 0;
                count <= 0;
                HTRANS <= 2'b00;
                end 
                end
                end

                if(burst_type == 3'b010 && trans == 2'b01)begin
                HTRANS <= 2'b01;
                HBURST <= 3'b010;
                end
                
                if(burst_type != 3'b010 && count2 == 4)begin
                count2 <= 0;
                count <= 0;
                end
            end

            end
            
    //burst_type==3'b011
   always @(negedge HCLK)begin
            if(HRESET==0)begin
                HADDR <= 32'd0;
                HADDR_M <= 32'd0;
                N <= 8'd0;
                O <= 32'd4;
                count3 <= 0;
                HTRANS  <= 2'b00;
                burst_done <= 0;
            end
            
            if(trans == 2'b00)
                burst_done <= 0;
            if(HREADY==1 && HRESET==1 && burst_done == 0)begin
                if(burst_type == 3'b011 && trans != 2'b01)begin
                    HBURST <= 3'b011;
                    if(count3 <=3)begin
                    count3 <= count3 + 1;
                    N <= N + (1 << size);
                    HADDR <= add + N;
                    if (new == 0) begin
                    O <= O + (1 << size);
                    HADDR_M <= add_m + O;
                    end
                    end
                    if(new == 1)begin
                    O <= 32'd4;
                    HADDR_M <= 32'd0;
                    end
                    if(count3==0)
                    HTRANS <= 2'b10;
                    if(count3 > 0)
                    HTRANS <= 2'b11;
                    if(count3 >= 3) begin
                    N <= 8'd0;
                    if(again == 1)begin
                    burst_done <= 0;
                    count3 <= 0;
                    end
                    if(count3 == 4)begin
                    burst_done <= 1;
                    count3 <= 0;
                    HTRANS <= 2'b00;
                    end 
                    end
                    end 
                if(burst_type == 3'b011 && trans == 2'b01)begin
                    HTRANS <= 2'b01;
                    HBURST <= 3'b011;
                end
                if(burst_type != 3'b011 && count3 == 4)begin
                    count3 <= 0;
                end
     end
     end
            
   //burst_type = 3'b100
    always @(negedge HCLK)begin
            if(HRESET==0)begin
                HADDR <= 32'd0;
                HADDR_M <= 32'd0;
                N <= 8'd0;
                M <= 8'd0;
                O <= 32'd4;
                count4 <= 0;
                HTRANS  <= 2'b00;
                burst_done <= 0; 
            end
            if(trans == 2'b00)
                burst_done <= 0;
            if(HREADY==1 && HRESET==1 && burst_done == 0)begin

                if(burst_type == 3'b100 && trans != 2'b01)begin
                HBURST <= 3'b100;
                if(count4 == 0)
                HTRANS <= 2'b10;
                if(count4 > 0 && count4 < 7)
                HTRANS <= 2'b11;
                if(new == 1)begin
                O <= 32'd4;
                HADDR_M <= 32'd0;
                end
                if(count4 < 8 - count_no)begin
                count4 <= count4 + 1;
                N <= N + (1 << size);
                HADDR <= wrap_input + N;
                if (new == 0) begin
                O <= O + (1 << size);
                HADDR_M <= add_m + O;
                end
                end 
                if(count4 >= 8 - count_no && count4 < 7)begin
                N <= 8'd0;
                M <= M + (1 << size);
                end
                if(count4 >= 8 - count_no && count4 < 8)begin
                N <= 8'd0;
                count4 <= count4 + 1;
                HADDR <= add + M;
                if (new == 0) begin
                O <= O + (1 << size);
                HADDR_M <= add_m + O;
                end
                end 
                if(count4 >= 7) begin
                N <= 8'd0;
                M <= 8'd0;
                if(again == 1)begin
                burst_done <= 0;
                count4 <= 0;
                end
                if(count4 == 8 )begin
                burst_done <= 1;
                count4 <= 0;
                HTRANS <= 2'b00;
                end 
                end
                end

                if(burst_type == 3'b100 && trans == 2'b01)begin
                HTRANS <= 2'b01;
                HBURST <= 3'b100;
                end
                
                if(burst_type != 3'b100 && count4 == 8)begin
                count4 <= 0;
                end
            end

            end
            
     //burst_type = 3'b101
     always @(negedge HCLK)begin
            if(HRESET==0)begin
                HADDR <= 32'd0;
                HADDR_M <= 32'd0;
                N <= 8'd0;
                O <= 32'd4;
                count5 <= 0;
                HTRANS  <= 2'b00;
                burst_done <= 0;
            end
            
            if(trans == 2'b00)
                burst_done <= 0;
            if(HREADY==1 && HRESET==1 && burst_done == 0)begin
                if(burst_type == 3'b101 && trans != 2'b01)begin
                    HBURST <= 3'b101;
                    if(count5 <=7)begin
                    count5 <= count5 + 1;
                    N <= N + (1 << size);
                    HADDR <= add + N;
                    if (new == 0) begin
                    O <= O + (1 << size);
                    HADDR_M <= add_m + O;
                    end
                    end
                    if(new == 1)begin
                    O <= 32'd4;
                    HADDR_M <= 32'd0;
                    end
                    if(count5==0)
                    HTRANS <= 2'b10;
                    if(count5 > 0)
                    HTRANS <= 2'b11;
                    if(count5 >= 7) begin
                    N <= 8'd0;
                    if(again == 1)begin
                    burst_done <= 0;
                    count5 <= 0;
                    end
                    if(count5 == 8)begin
                    burst_done <= 1;
                    count5 <= 0;
                    HTRANS <= 2'b00;
                    end 
                    end
                    end 
                if(burst_type == 3'b101 && trans == 2'b01)begin
                    HBURST <= 3'b101;
                    HTRANS <= 2'b01;
                end
                if(burst_type != 3'b101 && count5 == 8)begin
                    count5 <= 0;
                end
     end
     end
     
    //burst_type = 3'b110
    always @(negedge HCLK)begin
            if(HRESET==0)begin
                HADDR <= 32'd0;
                HADDR_M <= 32'd0;
                N <= 8'd0;
                M <= 8'd0;
                O <= 32'd4;
                count6 <= 0;
                HTRANS  <= 2'b00;
                burst_done <= 0; 
            end
            if(trans == 2'b00)
                burst_done <= 0;
            if(HREADY==1 && HRESET==1 && burst_done == 0)begin

                if(burst_type == 3'b110 && trans != 2'b01)begin
                HBURST <= 3'b110;
                if(count6 == 0)
                HTRANS <= 2'b10;
                if(count6 > 0 && count6 < 15)
                HTRANS <= 2'b11;
                if(new == 1)begin
                O <= 32'd4;
                HADDR_M <= 32'd0;
                end
                if(count6 < 16 - count_no)begin
                count6 <= count6 + 1;
                N <= N + (1 << size);
                HADDR <= wrap_input + N;
                if (new == 0) begin
                O <= O + (1 << size);
                HADDR_M <= add_m + O;
                end
                end 
                if(count6 >= 16 - count_no && count6 < 15)begin
                N <= 8'd0;
                M <= M + (1 << size);
                end
                if(count6 >= 16 - count_no && count6 < 16)begin
                N <= 8'd0;
                count6 <= count6 + 1;
                HADDR <= add + M;
                if (new == 0) begin
                O <= O + (1 << size);
                HADDR_M <= add_m + O;
                end
                end 
                if(count6 >= 15) begin
                N <= 8'd0;
                M <= 8'd0;
                if(again == 1)begin
                burst_done <= 0;
                count6 <= 0;
                end
                if(count6 == 16 )begin
                burst_done <= 1;
                count6 <= 0;
                HTRANS <= 2'b00;
                end 
                end
                end

                if(burst_type == 3'b110 && trans == 2'b01)begin
                HTRANS <= 2'b01;
                HBURST <= 3'b110;
                end
                
                if(burst_type != 3'b110 && count6 == 16)begin
                count6 <= 0;
                end
            end 
            end
    //burst_type = 3'b111
    always @(negedge HCLK)begin
            if(HRESET==0)begin
                HADDR <= 32'd0;
                HADDR_M <= 32'd0;
                N <= 8'd0;
                O <= 32'd4;
                count7 <= 0;
                HTRANS  <= 2'b00;
                burst_done <= 0;
            end
            
            if(trans == 2'b00)
                burst_done <= 0;
            if(HREADY==1 && HRESET==1 && burst_done == 0)begin
                if(burst_type == 3'b111 && trans != 2'b01)begin
                    HBURST <= 3'b111;
                    if(count7 <=15)begin
                    count7 <= count7 + 1;
                    N <= N + (1 << size);
                    HADDR <= add + N;
                    if (new == 0) begin
                    O <= O + (1 << size);
                    HADDR_M <= add_m + O;
                    end
                    end
                    if(new == 1)begin
                    O <= 32'd4;
                    HADDR_M <= 32'd0;
                    end
                    if(count7==0)
                    HTRANS <= 2'b10;
                    if(count7 > 0)
                    HTRANS <= 2'b11;
                    if(count7 >= 15) begin
                    N <= 8'd0;
                    if(again == 1)begin
                    burst_done <= 0;
                    count7 <= 0;
                    end
                    if(count7 == 16)begin
                    burst_done <= 1;
                    count7 <= 0;
                    HTRANS <= 2'b00;
                    end 
                    end
                    end 
                if(burst_type == 3'b111 && trans == 2'b01)begin
                    HBURST <= 3'b111;
                    HTRANS <= 2'b01;
                end
                if(burst_type != 3'b111 && count7 == 16)begin
                    count7 <= 0;
                end
     end
     end                                           
endmodule


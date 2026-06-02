`timescale 1ns / 1ps

module S_data_mem1(
    input HWRITE,
    input HCLK,
    input HREADY,
    input [1:0]HTRANS,
    input [31:0]HADDR,
    input [31:0]HWDATA,
    input HSEL_2,
    output reg[31:0]HRDATA_2
    
    
    );
    
    reg [31:0]register[32:63];
    integer i;
    
    initial begin
    register[32] = 32'd90;
    register[33] = 32'd91;
    register[34] = 32'd92;
    register[35] = 32'd93;
    register[36] = 32'd94;
    register[37] = 32'd95;
    register[38] = 32'd96;
    register[39] = 32'd97;
    register[40] = 32'd98;
    register[41] = 32'd99;
    register[42] = 32'd100;
    register[43] = 32'd101;
    register[44] = 32'd102;
    register[45] = 32'd104;
    register[46] = 32'd105;
    register[47] = 32'd107;
    end
    reg [31:0]r3;
    reg prev_write;
    
    wire [31:0] internal_index = HADDR >> 2;
    
    always @(negedge HCLK && HSEL_2 == 1 && HTRANS != 2'b00)begin
            r3 <= internal_index;
          prev_write <= HWRITE;
          if(prev_write == 1)
            register[r3] <= HWDATA;
        
          if(HWRITE==0 && HREADY==1 && HTRANS != 2'b01) 
            HRDATA_2 <= register[internal_index];

        
        end
        
endmodule

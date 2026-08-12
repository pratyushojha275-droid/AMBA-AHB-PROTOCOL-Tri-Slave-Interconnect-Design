`timescale 1ns / 1ps

module S_data_mem2(
    input HWRITE,
    input HCLK,
    input HREADY,
    input [1:0]HTRANS,
    input [31:0]HADDR,
    input [31:0]HWDATA,
    input HSEL_3,
    output reg[31:0]HRDATA_3
    
    
    );
    
    reg [31:0]register[64:95];
    integer i;
    
    initial begin
    register[64] = 32'd221;
    register[65] = 32'd222;
    register[66] = 32'd223;
    register[67] = 32'd224;
    register[68] = 32'd225;
    register[69] = 32'd227;
    register[70] = 32'd228;
    register[71] = 32'd229;
    register[72] = 32'd230;
    register[73] = 32'd231;
    register[74] = 32'd232;
    register[75] = 32'd233;
    register[76] = 32'd234;
    register[77] = 32'd235;
    register[78] = 32'd237;
    register[79] = 32'd238;
    register[90] = 32'd345;
    register[91] = 32'd346;
    register[92] = 32'd347;
    register[93] = 32'd348;
    register[94] = 32'd349;
    register[95] = 32'd350;
    
    end
    reg [31:0]r3;
    reg prev_write;
    
    wire [31:0] internal_index = HADDR >> 2;
    
    always @(negedge HCLK && HSEL_3 == 1 && HTRANS != 2'b00)begin
          r3 <= internal_index;
          prev_write <= HWRITE;
          if(prev_write == 1)
            register[r3] <= HWDATA;
        
          if(HWRITE==0 && HREADY==1 && HTRANS != 2'b01) 
            HRDATA_3 <= register[internal_index];
          end
        
endmodule

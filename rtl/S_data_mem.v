`timescale 1ns / 1ps

module S_data_mem(
    input HWRITE,
    input HCLK,
    input HREADY,
    input [1:0]HTRANS,
    input [31:0]HADDR,
    input [31:0]HWDATA,
    input HSEL_1,
    output reg[31:0]HRDATA_1
    
    
    );
    
    reg [31:0]register[0:31];
    integer i;
    
    reg [31:0]r3;
    reg prev_write;
    wire [31:0] internal_index = HADDR >> 2;
    
    always @(negedge HCLK && HSEL_1 == 1 && HTRANS != 2'b00)begin
          r3 <= internal_index;
          prev_write <= HWRITE;
          if(prev_write == 1)
            register[r3] <= HWDATA;
        
          if(HWRITE==0 && HREADY==1 && HTRANS != 2'b01) 
            HRDATA_1 <= register[internal_index];
          end
        
endmodule

`timescale 1ns / 1ps

module M_data_mem(
    input HWRITE,
    input HCLK,
    input [31:0]HADDR_M,
    input [31:0]HRDATA,
    input HREADY,
    input [1:0]HTRANS,
    output reg [31:0]HWDATA

    );
    
    reg [31:0]register[0:255];
    integer i;
    
    reg [31:0]r3;
    reg prev_read;
    wire [31:0] internal_index = HADDR_M >> 2;
    
    always @(negedge HCLK && HTRANS != 2'b01)begin  
          if(HTRANS != 2'b00)begin
            r3 <= internal_index;
          end
          prev_read <= HWRITE;
          if(prev_read == 0)
          register[r3] <= HRDATA;

          if(HWRITE==1)begin
            HWDATA <= register[internal_index];
          end 
          end  
    
endmodule

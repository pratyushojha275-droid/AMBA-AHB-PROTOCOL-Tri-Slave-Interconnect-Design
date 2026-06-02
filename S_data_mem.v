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
    
    initial begin
    register[0] = 32'd84;
    register[1] = 32'd103;
    register[2] = 32'd137;
    register[3] = 32'd118;
    register[4] = 32'd30;
    register[5] = 32'd40;
    register[6] = 32'd56;
    register[7] = 32'd23;
    register[8] = 32'd101;
    register[9] = 32'd145;
    register[10] = 32'd78;
    register[11] = 32'd33;
    register[12] = 32'd47;
    register[13] = 32'd53;
    register[14] = 32'd80;
    register[15] = 32'd37;
    end
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

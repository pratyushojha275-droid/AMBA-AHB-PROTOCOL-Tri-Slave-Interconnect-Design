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
    
    initial begin
    register[0] = 32'd32;
    register[1] = 32'd48;
    register[2] = 32'd64;
    register[3] = 32'd96;
    register[4] = 32'd54;
    register[5] = 32'd65;
    register[6] = 32'd57;
    register[7] = 32'd87;
    register[8] = 32'd90;
    register[9] = 32'd45;
    register[10] = 32'd89;
    register[11] = 32'd92;
    register[12] = 32'd14;
    register[13] = 32'd17;
    register[14] = 32'd49;
    register[15] = 32'd76;
    register[16] = 32'd11;
    register[17] = 32'd12;
    register[18] = 32'd13;
    register[19] = 32'd14;
    register[20] = 32'd15;
    register[21] = 32'd16;
    register[22] = 32'd17;
    register[23] = 32'd18;
    register[24] = 32'd19;
    register[25] = 32'd20;
    register[26] = 32'd21;
    register[27] = 32'd22;
    register[28] = 32'd23;
    register[29] = 32'd24;
    register[30] = 32'd25;
    register[31] = 32'd26;
    register[32] = 32'd300;
    register[33] = 32'd301;
    register[34] = 32'd302;
    register[35] = 32'd303;
    register[36] = 32'd304;
    register[37] = 32'd305;
    register[38] = 32'd306;
    register[39] = 32'd307;
    register[40] = 32'd308;
    register[41] = 32'd309;
    register[42] = 32'd310;
    register[43] = 32'd311;
    register[44] = 32'd312;
    register[45] = 32'd313;
    register[46] = 32'd314;
    register[47] = 32'd315;
    register[48] = 32'd316;
    register[49] = 32'd317;
    register[50] = 32'd318;
    register[51] = 32'd320;
    register[52] = 32'd321;
    register[53] = 32'd322;
    register[54] = 32'd323;
    register[55] = 32'd324;
    register[56] = 32'd325;
    register[57] = 32'd326;
    register[58] = 32'd327;
    register[59] = 32'd328;
    register[60] = 32'd329;
    register[61] = 32'd330;
    register[62] = 32'd331;
    register[63] = 32'd332;
    
    end 
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

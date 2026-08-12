`timescale 1ns / 1ps

module decoder(
        input [31:0]HADDR,
        output reg HSEL_1,
        output reg HSEL_2,
        output reg HSEL_3,
        output reg [1:0]m_select
        
    );
    
    initial begin
        m_select =0;
        end
    
    always @(*)begin
        
        if(HADDR <= 32'd124)begin
            HSEL_1 = 1;
            HSEL_2 = 0;
            HSEL_3 = 0;
            m_select = 0;
        end
        
        if(HADDR >= 32'd128 && HADDR <= 32'd252)begin
            HSEL_1 = 0;
            HSEL_2 = 1;
            HSEL_3 = 0;
            m_select = 1;
        end
        
        if(HADDR >= 32'd256 && HADDR <= 32'd380)begin
            HSEL_1 = 0;
            HSEL_2 = 0;
            HSEL_3 = 1;
            m_select = 2;
        end
    end
endmodule

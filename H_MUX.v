`timescale 1ns / 1ps

module H_MUX(
        input [1:0]m_select,
        input [31:0] HRDATA_1,
        input [31:0] HRDATA_2,
        input [31:0] HRDATA_3,
        output reg [31:0]HRDATA
    );
    
    always @(*)begin
        case(m_select)
            0: HRDATA <= HRDATA_1;
            1: HRDATA <= HRDATA_2;
            2: HRDATA <= HRDATA_3;
        endcase
    end    
endmodule

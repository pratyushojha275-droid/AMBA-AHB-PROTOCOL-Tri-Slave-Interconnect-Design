`timescale 1ns / 1ps

module Top(
    input HRESET,
    input HCLK,
    input HREADY,
    input HWRITE,
    input [31:0]add,
    input [31:0]add_m,
    input [2:0]size,
    input [2:0]burst_type,
    input [1:0]trans,
    input [31:0]wrap_input,
    input [31:0]single_input,
    input again,
    input new,
    
    output [31:0]HADDR,
    output [31:0]HADDR_M,
    output [31:0]HWDATA,
    output [31:0]HRDATA,
    output [7:0]HSIZE,
    output [2:0]HBURST,
    output [1:0]HTRANS,
    output [7:0]N,
    output [7:0]M,
    output [31:0]O,
    output [31:0]count_no,
    output [31:0]count,
    output burst_done,
    output [1:0]m
    );
    
    wire [31:0]t1;
    wire [31:0]t2;
    wire [31:0]t3;
    wire [31:0]h1;
    wire [31:0]h2;
    wire [31:0]h3;
    wire s1;
    wire s2;
    wire s3;
    reg [1:0]m_delayed;
    
    always @(negedge HCLK) begin
        if (HRESET == 0) begin
            m_delayed <= 0;
        end
        if (HREADY == 1) begin
            m_delayed <= m; 
        end
    end
    
    MASTER_H U1(.HRESET(HRESET), 
            .HCLK(HCLK), 
            .HREADY(HREADY), 
            .HWRITE(HWRITE),
            .data_out(t2),
            .HADDR(HADDR),
            .HADDR_M(HADDR_M),
            .size(size),
            .HRDATA(HRDATA),
            .HWDATA(HWDATA),
            .data_in(t3),
            .add(add),
            .add_m(add_m),
            .HSIZE(HSIZE),
            .burst_type(burst_type),
            .trans(trans),
            .HBURST(HBURST),
            .HTRANS(HTRANS),
            .N(N),
            .M(M),
            .O(O),
            .wrap_input(wrap_input),
            .single_input(single_input),
            .count_no(count_no),
            .count(count),
            .again(again),
            .new(new),
            .burst_done(burst_done)
            );
    
    M_data_mem U2(.HWRITE(HWRITE),
                  .HRDATA(t3),
                  .HWDATA(t2),
                  .HADDR_M(HADDR_M),
                  .HCLK(HCLK),
                  .HREADY(HREADY),
                  .HTRANS(HTRANS)
                  );
                  
    S_data_mem U3(.HWRITE(HWRITE),
                  .HWDATA(HWDATA),
                  .HRDATA_1(h1),
                  .HADDR(HADDR),
                  .HCLK(HCLK),
                  .HREADY(HREADY),
                  .HTRANS(HTRANS),
                  .HSEL_1(s1)
                  );
    
    S_data_mem1 U4(.HWRITE(HWRITE),
                  .HWDATA(HWDATA),
                  .HRDATA_2(h2),
                  .HADDR(HADDR),
                  .HCLK(HCLK),
                  .HREADY(HREADY),
                  .HTRANS(HTRANS),
                  .HSEL_2(s2)
                  );
                  
    S_data_mem2 U5(.HWRITE(HWRITE),
                  .HWDATA(HWDATA),
                  .HRDATA_3(h3),
                  .HADDR(HADDR),
                  .HCLK(HCLK),
                  .HREADY(HREADY),
                  .HTRANS(HTRANS),
                  .HSEL_3(s3)
                  );
                  
    decoder U6(.HADDR(HADDR),
                 .HSEL_1(s1),
                 .HSEL_2(s2),
                 .HSEL_3(s3),
                 .m_select(m) 
                 );
                 
    H_MUX U7(.HRDATA_1(h1),
             .HRDATA_2(h2),
             .HRDATA_3(h3),
             .HRDATA(HRDATA),
             .m_select(m_delayed)
             );
    
endmodule

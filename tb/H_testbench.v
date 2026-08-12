`timescale 1ns / 1ps

module H_testbench;

    reg HRESET;
    reg HCLK;
    reg HREADY;
    reg HWRITE;
    reg [31:0] add;
    reg [31:0] add_m;
    reg [2:0] size;
    reg [2:0] burst_type;
    reg [1:0] trans;
    reg [31:0] wrap_input;
    reg [31:0] single_input;
    reg again;
    reg new;

    wire [31:0] HADDR;
    wire [31:0] HADDR_M;
    wire [31:0] HWDATA;
    wire [31:0] HRDATA;
    wire [7:0] HSIZE;
    wire [2:0] HBURST;
    wire [1:0] HTRANS;
    wire [7:0] N;
    wire [7:0] M;
    wire [31:0] O;
    wire [31:0] count;
    wire [31:0] count_no;
    wire burst_done ;
    wire [1:0] m;
        
    Top DUT(
        .HRESET(HRESET),
        .HCLK(HCLK),
        .HREADY(HREADY),
        .HWRITE(HWRITE),
        .add(add),
        .add_m(add_m),
        .size(size),
        .burst_type(burst_type),
        .trans(trans),
        .wrap_input(wrap_input),
        .single_input(single_input),
        .again(again),
        .new(new),
        
        .HADDR(HADDR),
        .HADDR_M(HADDR_M),
        .HWDATA(HWDATA),
        .HRDATA(HRDATA),
        .HSIZE(HSIZE),
        .HBURST(HBURST),
        .HTRANS(HTRANS),
        .N(N),
        .M(M),
        .O(O),
        .count(count),
        .count_no(count_no),
        .burst_done(burst_done),
        .m(m)
    );

   
    initial begin
        HCLK = 0;
        forever #5 HCLK = ~HCLK;
    end

    initial begin
        DUT.U2.register[0] = 32'd32;
        DUT.U2.register[1] = 32'd48;
        DUT.U2.register[2] = 32'd64;
        DUT.U2.register[3] = 32'd96;
        DUT.U2.register[4] = 32'd54;
        DUT.U2.register[5] = 32'd65;
        DUT.U2.register[6] = 32'd57;
        DUT.U2.register[7] = 32'd87;
        DUT.U2.register[8] = 32'd90;
        DUT.U2.register[9] = 32'd45;
        DUT.U2.register[10] = 32'd89;
        DUT.U2.register[11] = 32'd92;
        DUT.U2.register[12] = 32'd14;
        DUT.U2.register[13] = 32'd17;
        DUT.U2.register[14] = 32'd49;
        DUT.U2.register[15] = 32'd76;
        DUT.U2.register[16] = 32'd11;
        DUT.U2.register[17] = 32'd12;
        DUT.U2.register[18] = 32'd13;
        DUT.U2.register[19] = 32'd14;
        DUT.U2.register[20] = 32'd15;
        DUT.U2.register[21] = 32'd16;
        DUT.U2.register[22] = 32'd17;
        DUT.U2.register[23] = 32'd18;
        DUT.U2.register[24] = 32'd19;
        DUT.U2.register[25] = 32'd20;
        DUT.U2.register[26] = 32'd21;
        DUT.U2.register[27] = 32'd22;
        DUT.U2.register[28] = 32'd23;
        DUT.U2.register[29] = 32'd24;
        DUT.U2.register[30] = 32'd25;
        DUT.U2.register[31] = 32'd26;
        DUT.U2.register[32] = 32'd300;
        DUT.U2.register[33] = 32'd301;
        DUT.U2.register[34] = 32'd302;
        DUT.U2.register[35] = 32'd303;
        DUT.U2.register[36] = 32'd304;
        DUT.U2.register[37] = 32'd305;
        DUT.U2.register[38] = 32'd306;
        DUT.U2.register[39] = 32'd307;
        DUT.U2.register[40] = 32'd308;
        DUT.U2.register[41] = 32'd309;
        DUT.U2.register[42] = 32'd310;
        DUT.U2.register[43] = 32'd311;
        DUT.U2.register[44] = 32'd312;
        DUT.U2.register[45] = 32'd313;
        DUT.U2.register[46] = 32'd314;
        DUT.U2.register[47] = 32'd315;
        DUT.U2.register[48] = 32'd316;
        DUT.U2.register[49] = 32'd317;
        DUT.U2.register[50] = 32'd318;
        DUT.U2.register[51] = 32'd320;
        DUT.U2.register[52] = 32'd321;
        DUT.U2.register[53] = 32'd322;
        DUT.U2.register[54] = 32'd323;
        DUT.U2.register[55] = 32'd324;
        DUT.U2.register[56] = 32'd325;
        DUT.U2.register[57] = 32'd326;
        DUT.U2.register[58] = 32'd327;
        DUT.U2.register[59] = 32'd328;
        DUT.U2.register[60] = 32'd329;
        DUT.U2.register[61] = 32'd330;
        DUT.U2.register[62] = 32'd331;
        DUT.U2.register[63] = 32'd332;
    end
    
    initial begin
        DUT.U2.register[0] = 32'd32;
        DUT.U2.register[1] = 32'd48;
        DUT.U3.register[0] = 32'd84;
        DUT.U3.register[1] = 32'd103;
        DUT.U3.register[2] = 32'd137;
        DUT.U3.register[3] = 32'd118;
        DUT.U3.register[4] = 32'd30;
        DUT.U3.register[5] = 32'd40;
        DUT.U3.register[6] = 32'd56;
        DUT.U3.register[7] = 32'd23;
        DUT.U3.register[8] = 32'd101;
        DUT.U3.register[9] = 32'd145;
        DUT.U3.register[10] = 32'd78;
        DUT.U3.register[11] = 32'd33;
        DUT.U3.register[12] = 32'd47;
        DUT.U3.register[13] = 32'd53;
        DUT.U3.register[14] = 32'd80;
        DUT.U3.register[15] = 32'd37;
    end
    
    initial begin
        DUT.U4.register[32] = 32'd90;
        DUT.U4.register[33] = 32'd91;
        DUT.U4.register[34] = 32'd92;
        DUT.U4.register[35] = 32'd93;
        DUT.U4.register[36] = 32'd94;
        DUT.U4.register[37] = 32'd95;
        DUT.U4.register[38] = 32'd96;
        DUT.U4.register[39] = 32'd97;
        DUT.U4.register[40] = 32'd98;
        DUT.U4.register[41] = 32'd99;
        DUT.U4.register[42] = 32'd100;
        DUT.U4.register[43] = 32'd101;
        DUT.U4.register[44] = 32'd102;
        DUT.U4.register[45] = 32'd104;
        DUT.U4.register[46] = 32'd105;
        DUT.U4.register[47] = 32'd107;
    end
    
    initial begin
        DUT.U5.register[64] = 32'd221;
        DUT.U5.register[65] = 32'd222;
        DUT.U5.register[66] = 32'd223;
        DUT.U5.register[67] = 32'd224;
        DUT.U5.register[68] = 32'd225;
        DUT.U5.register[69] = 32'd227;
        DUT.U5.register[70] = 32'd228;
        DUT.U5.register[71] = 32'd229;
        DUT.U5.register[72] = 32'd230;
        DUT.U5.register[73] = 32'd231;
        DUT.U5.register[74] = 32'd232;
        DUT.U5.register[75] = 32'd233;
        DUT.U5.register[76] = 32'd234;
        DUT.U5.register[77] = 32'd235;
        DUT.U5.register[78] = 32'd237;
        DUT.U5.register[79] = 32'd238;
        DUT.U5.register[90] = 32'd345;
        DUT.U5.register[91] = 32'd346;
        DUT.U5.register[92] = 32'd347;
        DUT.U5.register[93] = 32'd348;
        DUT.U5.register[94] = 32'd349;
        DUT.U5.register[95] = 32'd350;
    end
    
    initial begin
        HRESET <= 1;
        HREADY <= 1;
        HWRITE <= 0;
        size <= 3'b010;
        add <= 32'h0;
        add_m <= 32'd0;
        trans <= 2'b10;
        burst_type <= 3'b010;
        wrap_input <= 32'd12;
        again <= 0;
        new <= 0;
        single_input <= 32'd04;

        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        trans <= 2'b00;
        @(negedge HCLK);
        again <= 1;
        add_m <= 32'd0;
        new <= 1;
        @(negedge HCLK);
        new <= 0;
        HWRITE <= 1;
        trans <= 2'b10;
        again <= 0;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        burst_type <= 3'b100;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        trans <= 2'b00;
        @(negedge HCLK);
        trans <= 2'b10;
        burst_type <= 3'b010;
        @(negedge HCLK);
        HWRITE <= 0;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        burst_type <= 3'b001;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        trans <= 2'b00;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        burst_type <= 3'b010;
        trans <= 2'b10;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        burst_type <= 3'b000;
        @(negedge HCLK);
        @(negedge HCLK);
        again <= 1;
        single_input <= 32'd08;
        @(negedge HCLK);
        again <= 0;
        @(negedge HCLK);
        burst_type <= 3'b100;
        wrap_input <= 32'd20;
        @(negedge HCLK);
        HWRITE <= 1 ;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        HREADY <= 0;
        @(negedge HCLK);
        HREADY <= 1;
        trans <= 2'b10;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        trans <= 2'b00;
        @(negedge HCLK);
        trans <= 2'b10;
        burst_type <= 3'b100;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        burst_type <= 3'b110;
        wrap_input <= 32'd144;
        add <= 32'd128;
        @(negedge HCLK);
        HWRITE <= 0;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        burst_type <= 3'b111;
        add <= 32'd256;
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);
        @(negedge HCLK);

        if ($time < 1000) begin
            #(1000 - $time);
        end
        $finish;
    end

endmodule

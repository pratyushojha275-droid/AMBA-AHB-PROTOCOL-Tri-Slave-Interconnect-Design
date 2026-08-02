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
        $display("--- AUTOMATIC SIMULATION STARTED ---");
        $monitor("Time = %0t ns | HTRANS = %b | HBURST = %b | HWRITE = %b | HADDR = %h", 
                 $time, HTRANS, HBURST, HWRITE, HADDR);
    end

   
    integer error_count = 0;
    integer timeout = 0;
    
    initial begin
        timeout = 0;
        while (HTRANS !== 2'b00 && timeout < 20) begin
            @(posedge HCLK);
            timeout = timeout + 1;
        end
        
        if (HTRANS === 2'b11) begin
            $display("[PASS] Test 1: Successfully transitioned to IDLE state.");
        end else begin
            $display("[ERROR] Test 1: TIMEOUT! Failed to transition to IDLE state.");
            error_count = error_count + 1;
        end

        timeout = 0;
        while (HBURST !== 3'b100 && timeout < 30) begin
            @(posedge HCLK);
            timeout = timeout + 1;
        end
        
        if (HBURST === 3'b100) begin
            $display("[PASS] Test 2: Successfully transitioned to WRAP8 burst.");
        end else begin
            $display("[ERROR] Test 2: TIMEOUT! Failed to transition to WRAP8 burst.");
            error_count = error_count + 1;
        end
        
        timeout = 0;
        while (HWRITE !== 1 && timeout < 30) begin
            @(posedge HCLK);
            timeout = timeout + 1;
        end
        
        if (HWRITE === 1) begin
            $display("[PASS] Test 3: Successfully entered WRITE mode.");
        end else begin
            $display("[ERROR] Test 3: TIMEOUT! Failed to enter WRITE mode.");
            error_count = error_count + 1;
        end

        #(990 - $time);
        $display("-----------------------------------------");
        if (error_count == 0) begin
            $display("FINAL GRADING: ALL BACKGROUND TESTS PASSED! [0 ERRORS]");
        end else begin
            $display("FINAL GRADING: DESIGN FAILED WITH %0d ERRORS.", error_count);
        end
        $display("-----------------------------------------");
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
        
        $display("--- SIMULATION REACHED 1000ns. FINISHED. ---");
        $finish;
    end

endmodule

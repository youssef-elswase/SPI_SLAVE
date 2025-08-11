module SPI_SLAVE_tb ();
    parameter MEM_DEPTH = 256,ADDR_SIZE = 8;
    reg MOSI;
    reg SS_n;
    reg clk;
    reg rst_n;
    reg [7:0] tx_data;
    reg tx_valid;
    wire [9:0] rx_data;
    wire rx_valid;
    wire MISO;
    reg [7:0] addr,data,dummy;
    // instantiation SPI_SLAVE module
    spi_slave u0 (MOSI,SS_n,clk,rst_n,tx_valid,tx_data,MISO,rx_data,rx_valid);

    integer i ;

    initial begin
        clk = 0;
        forever begin
        #1    clk = ~clk;
        end
    end


    initial begin
        rst_n = 0;
        @(negedge clk);
        rst_n = 1;

        // test master to write addr want to write it
        dummy = 8'b11111111;
        addr = 8'b01010000;
        data = 8'b10010000;
        SS_n = 0;
        MOSI = 0;
        @(negedge clk);
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        for ( i = 7 ; i >= 0 ; i = i - 1 ) begin
            MOSI = addr[i];
            @(negedge clk);
        end

        // test master to write data
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        for ( i = 7 ; i >= 0 ; i = i - 1 ) begin
            MOSI = data[i];
            @(negedge clk);
        end

        // test slave to read addr form mem want to read it
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        MOSI = 0;
        @(negedge clk);
        for ( i = 7 ; i >= 0 ; i = i - 1 ) begin
            MOSI = addr[i];
            @(negedge clk);
            end

        // test slave to write data from mem to master
        tx_valid = 1;
        tx_data = data;
        MOSI = 1;
        @(negedge clk);
        MOSI = 1;
        @(negedge clk);
        for ( i = 7 ; i >= 0 ; i = i - 1 ) begin
            MOSI = dummy;
            @(negedge clk);       
        end  
        repeat(20) @(negedge clk);
        $stop;

    end
        

    initial begin
        $monitor("MOSI=%d,MISO=%d,SS_n=%d,rst_n=%d,rx_data=%d,rx_valid=%d,tx_data=%d,tx_valid=%d",MOSI,MISO,SS_n,rst_n,rx_data,rx_valid,tx_data,tx_valid);
    end


endmodule
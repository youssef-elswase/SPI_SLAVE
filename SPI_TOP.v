module SPI_TOP(
    MOSI,MISO,SS_n,clk,rst_n
);
    input MOSI,SS_n,clk,rst_n;
    output MISO;

    wire [9:0] rx_data;
    wire rx_valid,tx_valid;
    wire [7:0] tx_data;

    SPI_SLAVE u2 (MOSI,SS_n,clk,rst_n,tx_valid,tx_data,MISO,rx_data,rx_valid);
    RAM_SPI u1 (rx_data, rx_valid, clk, rst_n, tx_data, tx_valid);

endmodule
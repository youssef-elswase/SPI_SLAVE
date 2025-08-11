module RAM_SPI (din, rx_valid, clk, rst_n, dout, tx_valid);

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input [ADDR_SIZE+1 : 0] din;
input rx_valid, clk, rst_n;

output reg [ADDR_SIZE-1:0] dout;
output reg tx_valid;

reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
reg [ADDR_SIZE-1:0] ADDR;                    //internal 

//Read/Write Operation
always @(posedge clk)begin
    if(~rst_n)begin
        dout <= 0;
        tx_valid <= 0;
        ADDR <= 0;
    end
    else  
    if(rx_valid) begin
       case (din[ADDR_SIZE+1:ADDR_SIZE])
       //Write
       2'b00 : begin
            ADDR<=din[ADDR_SIZE-1:0];
       end
       2'b01 : begin
            mem[ADDR]<=din[ADDR_SIZE-1:0];
       end
       //Read
       2'b10 : begin
            ADDR<=din[ADDR_SIZE-1:0];
       end
       2'b11 : begin
            dout<=mem[ADDR];
            tx_valid<=1;
       end
    endcase
    end
 end
endmodule
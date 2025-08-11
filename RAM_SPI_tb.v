module RAM_SPI_tb ();

parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

reg [ADDR_SIZE+1 : 0] din;
reg rx_valid, clk, rst_n;
wire tx_valid;
wire [ADDR_SIZE-1:0] dout;

RAM_SPI RAM_tb (din, rx_valid, clk, rst_n, dout, tx_valid);

// Reference memory for checking
reg [ADDR_SIZE-1:0] ref_mem [MEM_DEPTH-1:0];

// clock generation
initial begin 
    clk = 0;
    forever begin
        #5 clk =~clk;
    end
end

integer i;

reg [ADDR_SIZE-1:0] addr, data;

initial begin
   $readmemb ("mem.dat",RAM_tb.mem);
   rst_n = 0; 
   rx_valid=0;

   // give values to rest of input
   @ (negedge clk); 
   rst_n = 1;

   // test write operation only
   for (i = 0; i<10000; i = i + 1 ) begin
    addr = $random;
    data = $random;
    @(negedge clk); 
      rx_valid = 1; 
      din = {2'b00,addr};
    @(negedge clk);
      rx_valid = 1; 
      din = {2'b01,data};
      ref_mem[addr] = data;
    @(negedge clk);
      rx_valid = 0;
   end

   // test read operation only
   for (i = 0; i<10000; i = i + 1 ) begin
    addr = $random;
    data = $random;
      @(negedge clk); 
        din={2'b10,addr};
        rx_valid=1;
      @(negedge clk); 
        din={2'b11,addr}; 
        rx_valid=1;
      @(negedge clk);
        rx_valid = 0;
      @(posedge clk);
      if (tx_valid && dout==ref_mem[addr])
        $display("PASS addr=%0d val=%0d",addr,dout);
      else
        $display("FAIL addr=%0d got=%0d exp=%0d",addr,dout,ref_mem[addr]);
   end

$finish;

end
endmodule
module SPI_SLAVE(
    MOSI,SS_n,clk,rst_n,tx_valid,tx_data,MISO,rx_data,rx_valid
);
    input MOSI ,SS_n,clk,rst_n,tx_valid;
    input [7:0] tx_data;
    output reg MISO,rx_valid;
    output reg [9:0] rx_data;

      // FSM States
    parameter IDLE       = 0;
    parameter READ_ADD   = 1;
    parameter READ_DATA  = 2;
    parameter CHK_CMD    = 3;
    parameter WRITE      = 4;

    reg [9:0] write;
   // reg [7:0] read;
    reg R_Data;
    reg [3:0] counter ;

    reg [3:0] cs,ns;

    // mem state 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cs <= IDLE;
        end
        else begin
            cs <= ns;
        end
    end

    // next state

    always @(cs,SS_n,MOSI) begin
        case (cs)
            IDLE:
            ns = (SS_n) ? IDLE : CHK_CMD;
            CHK_CMD:
            begin
              if (SS_n == 0 && MOSI == 0 ) begin
                ns = WRITE;
              end
              else if (SS_n==0 && MOSI == 1 && R_Data == 0 ) begin
                ns = READ_ADD;
              end
              else if (SS_n==0 && MOSI == 1 && R_Data == 1 ) begin
                ns = READ_DATA;
              end
              else begin
                ns = IDLE;
              end
              end
            WRITE:
            begin
              if (~SS_n ) begin
                ns = WRITE;
              end
              else if ( SS_n || counter == 4'hf ) begin
                ns = IDLE;
              end
            end
            READ_ADD:
            begin
              if (~SS_n) begin
                ns = READ_ADD;
              end
              else begin
                ns = IDLE;
              end
            end
            READ_DATA:
            begin
              if (~SS_n) begin
                ns = READ_DATA;
              end
              else begin
                ns = IDLE;
              end
            end
            
        endcase
    end

    // output & counter

    always @(posedge clk) begin
        if (~rst_n) begin
            counter <= 10;
            R_Data <= 0;
        end
        else begin
            case (cs)
                IDLE: rx_valid = 0;
                WRITE:
                begin
                  counter = counter - 1;
                  write[counter] <= MOSI;
                  if (counter == 4'hf) begin
                    rx_valid <= 1;
                    rx_data <= write;
                    counter <= 10; 
                  end
                end
                READ_ADD:
                begin
                  counter = counter - 1;
                  write[counter] <= MOSI;
                  if (counter == 4'hf) begin
                    rx_valid <= 1;
                    rx_data <= write;
                    R_Data <= 1;
                    counter <= 10; 
                  end
                end
                READ_DATA:
                begin
                    counter = counter - 1;
                    write[counter] <= MOSI;
                  if (R_Data && tx_valid) begin
                    MISO <= tx_data[counter-2];
                    if (counter == 4'hf) begin
                        rx_valid <= 1;
                        rx_data <= write;
                        R_Data <= 0;
                        counter <= 10; 
                    end
                  end
                end
            endcase
        end
    end


endmodule
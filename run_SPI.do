vlib work
vlog  SPI_SLAVE_tb.v SPI_SLAVE.v SPI_TOP_tb.v SPI_TOP.v RAM_SPI.v RAM_SPI_tb.v
vsim -voptargs=+acc work.SPI_TOP_tb
add wave *
run -all
#quit -sim
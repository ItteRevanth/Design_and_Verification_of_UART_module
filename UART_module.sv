//Top Module - Integrates the reciever and transmitter modules of the UART
module uart_top
#(
  parameter clk_freq = 1000000,  //On-board clk frequancy
  parameter baud_rate = 9600    //User-defined baud_rate
)
  (
    input clk,rst,
    input send,
    input [7:0] tx_data,  //data that is to be transmitted
    input rx,             //Serial reciever
    output [7:0] rx_data, //Data that is recieved
    output tx,            //Serial transmitter
    output tx_done, rx_done //Flags
  );
  
  uarttx    //Transmitter module handler
#(
    clk_freq,baud_rate
) utx(clk,rst,send,tx_data,tx,tx_done);
  
  uartrx    //Reciever module handler
#(
  clk_freq,baud_rate
) urx (clk,rst,rx,rx_data,rx_done);
  
endmodule

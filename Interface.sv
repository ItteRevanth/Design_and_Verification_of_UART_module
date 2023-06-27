//Interface between DUT and TestBench
interface uart_if;
  logic clk;
  logic uclktx;
  logic uclkrx;
  logic rst;
  logic rx;
  logic [7:0] tx_data;
  logic send;
  logic tx;
  logic [7:0] rx_data;
  logic tx_done;
  logic rx_done;
endinterface

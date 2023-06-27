//Transaction class
class transaction;
  typedef enum bit[1:0] {write = 2'b00,read = 2'b01} oper_type; //Enumaeration for read and write operations of UART
  
  randc oper_type oper;  //randomization of write/read operation mode
  
  bit rx;
  randc bit [7:0] tx_data;  //Randomizing the data to be transmitted
  bit send,tx;
  bit [7:0] rx_data;
  bit rx_done,tx_done;
  
  function void display(input string cls);  //Display module to track transaction and class where it happened
    $display("[%0s]:oper:%0s,send:%0b,tx_in:%0b,rx_in:%0b,tx_out:%0b,rx_out:%0b,done_tx:%0b,done_rx:%0b",cls,oper.name(),send,tx_data,rx,tx,rx_data,tx_done,rx_done);
  endfunction
  
  function transaction copy();  //copy constructor for deep copy
    copy = new();
    copy.oper = this.oper;
    copy.rx = this.rx;
    copy.tx_data = this.tx_data;
    copy.send = this.send;
    copy.tx = this.tx;
    copy.rx_data = this.rx_data;
    copy.rx_done = this.rx_done;
    copy.tx_done = this.tx_done;
  endfunction
  
endclass

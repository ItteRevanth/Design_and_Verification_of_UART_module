// TestBench Top - Generates global signals,merges dut with interface and runs environment
module tb_top;
  uart_if uif();  // Instantiate the UART interface
  
  uart_top #(1000000, 9600) dut(uif.clk, uif.rst, uif.send, uif.tx_data, uif.rx, uif.rx_data, uif.tx, uif.tx_done, uif.rx_done);
  // Instantiate the UART DUT (Design Under Test) module and connect it to the UART interface signals
  
  initial begin
    uif.clk <= 0;  // Initialize the clock signal of the UART interface
  end
  
  always #10 uif.clk <= ~uif.clk;  // Toggle the clock signal of the UART interface every 10 time units
  
  environment env;  // Instantiate the test environment
  
  initial begin
    env = new(uif);  // Create a new instance of the test environment and connect it to the UART interface
    env.gen.count = 5;  // Set the transaction count for the generator in the test environment
    env.main();  // Start the main task of the test environment
  end
  
  initial begin
    $dumpfile("UART.vcd");  // Specify the VCD (Value Change Dump) file to save simulation waveforms
    $dumpvars(0, tb_top);  // Dump all variables in the tb_top module to the VCD file
  end
  
  assign uif.uclktx = dut.utx.uclk;  // Connect the UART interface transmit clock to the DUT's transmit clock
  assign uif.uclkrx = dut.urx.uclk;  // Connect the UART interface receive clock to the DUT's receive clock
  
endmodule

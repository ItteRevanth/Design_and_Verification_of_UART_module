// ScoreBoard Class - Recieves DUT response via monitor and compares with standard result or golden data or algorithm
class ScoreBoard;
  transaction t;  // Placeholder for a transaction object
  mailbox #(bit[7:0]) mon2sco;  // Mailbox for receiving data from monitor
  mailbox #(bit [7:0]) drv2sco;  // Mailbox for receiving data from driver
  
  bit[7:0] ds, ms;  // Variables to store received data values
  event nxtsco;  // Event to signal next scoreboard iteration
  
  // Constructor
  function new(mailbox #(bit[7:0]) mon2sco, mailbox #(bit [7:0]) drv2sco);
    this.mon2sco = mon2sco;  // Assign the monitor mailbox
    this.drv2sco = drv2sco;  // Assign the driver mailbox
  endfunction
  
  // Task for the main functionality of the scoreboard
  task main();
    forever begin
      mon2sco.get(ms);  // Receive data from monitor
      drv2sco.get(ds);  // Receive data from driver
      $display("[SCO]: DRV:%0d, SCO:%0d", ds, ms);  // Display the received data values
      
      if (ms == ds)
        $display("DATA MATCHED!");
      else
        $error("DATA MISMATCHED!");
      
      -> nxtsco;  // Wait for the nxtsco event to be triggered
    end
  endtask
  
endclass

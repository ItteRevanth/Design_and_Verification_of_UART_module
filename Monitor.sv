// Monitor Class - Sends response of DUT to scoreboard
class monitor;
  transaction t;
  virtual uart_if uif;

  mailbox #(bit [7:0]) mon2sco; // Mailbox for communication between monitor and scoreboard
  bit [7:0] srx; // Send data
  bit [7:0] rrx; // Receive data

  function new(mailbox #(bit[7:0]) mon2sco);
    this.mon2sco = mon2sco;
  endfunction

  task main();
    t = new();
    forever begin
      @(posedge uif.uclktx); // Wait for positive edge of transmit clock (uclktx)

      // Check if both send and receive signals are high
      if ((uif.send == 1'b1) && (uif.rx == 1'b1)) begin
        @(posedge uif.uclktx); // Wait for the next positive edge of transmit clock

        // Loop to receive 8 bits of data
        for (int i = 0; i <= 7; i++) begin
          @(posedge uif.uclktx); // Wait for the next positive edge of transmit clock
          srx[i] = uif.tx; // Store received bit in srx array
        end

        $display("[MON]: Data Sent on UART TX: %0d", srx);

        @(posedge uif.uclktx); // Wait for the next positive edge of transmit clock
        mon2sco.put(srx); // Put the received data into the mailbox for the scoreboard
      end
      
      // Check if both receive and send signals are low
      else if ((uif.rx == 1'b0) && (uif.send == 1'b0)) begin
        wait (uif.rx_done == 1); // Wait until rx_done signal is high (indicating data reception is complete)
        rrx = uif.rx_data; // Store received data in rrx variable
        $display("[MON]: Data Rcvd: %0d", rrx);

        @(posedge uif.uclkrx); // Wait for the next positive edge of receive clock (uclkrx)
        mon2sco.put(rrx); // Put the received data into the mailbox for the scoreboard
      end
    end
  endtask
endclass

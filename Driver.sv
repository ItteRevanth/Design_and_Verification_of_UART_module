//Driver Class - Performs reset function and sends data selectively to DUT from generator
class driver;
  virtual uart_if uif;  //Virtual handler of interface
  
  transaction t;
  mailbox #(transaction) gen2drv; //Mailbox recieved from generator
  mailbox #(bit[7:0]) drv2sco;
  
  event nxtdrv;
  
  bit[7:0] d_in;
  bit wr = 0; //Random Operation rd/wr
  bit[7:0] rx_data; //Data rercieved during rd operation
  
  function new(mailbox #(transaction) gen2drv,mailbox #(bit[7:0]) drv2sco);  //Custom constructor
    this.gen2drv = gen2drv;
    this.drv2sco = drv2sco;
  endfunction
  
  task reset();          //reset operation
    uif.rst <= 1'b1;
    uif.tx_data <= 0;
    uif.send <= 0;
    uif.rx <= 1'b1;
    uif.rx_data <= 0;
    uif.tx <= 1'b1;
    uif.rx_done <= 0;
    uif.tx_done <= 0;
    repeat(5) @(posedge uif.uclktx);
    uif.rst <= 1'b0;
    @(posedge uif.uclktx);
    $display("[DRV] : RESET DONE");
  endtask
  
  task main();
    forever begin
      gen2drv.get(t);
      if(t.oper==2'b00) //data transmission
        begin
          @(posedge uif.uclktx);
          uif.rst <= 1'b0;
          uif.send <= 1'b1;
          uif.rx <= 1'b1;
          uif.tx_data <= t.tx_data;
          d_in <= t.tx_data;
          @(posedge uif.uclktx);
          uif.send <= 1'b0;
          
          drv2sco.put(t.tx_data);
          $display("[DRV]:Data sent %0d",t.tx_data);
          wait(uif.tx_done == 1'b1);
          ->nxtdrv;
        end
      else if(t.oper==2'b01) begin //Data Recieving
        @(posedge uif.uclkrx);
        uif.rst <= 1'b0;
        uif.rx <= 1'b0;
        @(posedge uif.uclkrx);
        for(int i=0;i<=7;i++) begin
          @(posedge uif.uclkrx);
          uif.rx <= $urandom;
          rx_data[i] <= uif.rx;
        end
        
        drv2sco.put(rx_data);
        $display("[DRV]:Data Rcvd:%0d",rx_data);
        wait(uif.rx_done == 1'b1);
        uif.rx <= 1'b1;
        ->nxtdrv;
      end
    end
  endtask
  
endclass

//Generator Class - generates random stimuli of transaction members
class generator;
  transaction t;
  mailbox #(transaction) gen2drv; //Mailbox to send transaction to driver
  event done;
  
  int count = 0;
  
  event nxtdrv,nxtsco;
  
  function new(mailbox #(transaction) gen2drv);  //Custom constructor
    this.gen2drv = gen2drv;
    t = new();
  endfunction
  
  task main();
    repeat(count) begin
      assert(t.randomize()) else $error("Randomization Failed!");
      gen2drv.put(t.copy);
      t.display("GEN");
      @(nxtdrv);  //Wait till driver send stimuli to DUT
      @(nxtsco);  //wait till scoreboard matches data from DUT and driver
    end
    
    -> done;  //All the stimuli are sent
  endtask

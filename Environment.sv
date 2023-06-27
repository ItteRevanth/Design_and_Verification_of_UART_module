// Environment Class - Contains all classes and initializes them
class Environment;
  transaction tr;  // Placeholder for a transaction object
  generator gen;  // Generator component
  driver drv;  // Driver component
  monitor mon;  // Monitor component
  scoreboard sco;  // Scoreboard component
  
  event nextgd, nextgs;  // Events to signal next generator and scoreboard iterations
  
  mailbox #(transaction) gen2drv;  // Mailbox for communication between generator and driver
  mailbox #(bit[7:0]) drv2sco, mon2sco;  // Mailboxes for communication between driver and scoreboard/monitor
  
  virtual uart_if uif;  // Virtual interface for UART communication
  
  // Constructor
  function new(virtual uart_if uif);
    gen2drv = new();  // Create generator-to-driver mailbox
    drv2sco = new();  // Create driver-to-scoreboard mailbox
    mon2sco = new();  // Create monitor-to-scoreboard mailbox
    gen = new(gen2drv);  // Create generator instance
    drv = new(gen2drv, drv2sco);  // Create driver instance
    mon = new(mon2sco);  // Create monitor instance
    sco = new(mon2sco, drv2sco);  // Create scoreboard instance
    
    this.uif = uif;
    drv.uif = this.uif;
    mon.uif = this.uif;
    
    gen.nxtdrv = nextgd;  // Assign nextgd event to generator
    drv.nxtdrv = nextgd;  // Assign nextgd event to driver
    gen.nxtsco = nextgs;  // Assign nextgs event to generator
    sco.nxtsco = nextgs;  // Assign nextgs event to scoreboard
  endfunction
  
  // Task for pre-test initialization
  task pre_test();
    drv.reset;
  endtask
  
  // Task for the main test functionality
  task test();
    fork
      gen.main;  // Start generator
      drv.main;  // Start driver
      mon.main;  // Start monitor
      sco.main;  // Start scoreboard
    join_none
  endtask
  
  // Task for post-test actions
  task post_test();
    wait(gen.done.triggered);  // Wait for generator to finish
    $finish();  // Finish simulation
  endtask
  
  // Main task for the test environment
  task main();
    pre_test();  // Perform pre-test initialization
    test();  // Run the test
    post_test();  // Perform post-test actions
  endtask
  
endclass

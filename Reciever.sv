//Recieving Module - Performs the rx function of the UART module
module uartrx
  #(
  parameter clk_freq = 1000000,   //On-board clk frequency
  parameter baud_rate = 9600      //User-defined baud_rate
  )
  (
    input clk,rst,
    input rx,
    output reg [7:0] rx_data,   //Data that is recieved from rx
    output reg rx_done
  );
  
  localparam clk_count = (clk_freq/baud_rate);   //Local clk frequnecy
  
  int count = 0;   //For uclk generation
  int counts = 0;  //For counting no. of bits recieved
  
  reg uclk = 0;   //local clk based on baud_rate
  
  enum bit [1:0] {idle = 2'b00, start = 2'b01} state;  //Enumaration of states
  
  //Generating clk based on baud_rate
  always @(posedge clk)
    begin
      if(count <= clk_count/2)
        count <= count+1;
      else begin
        count <= 0;
        uclk <= ~uclk;
      end
    end
  
  //The main FSM of the recievers module
  always @(posedge uclk)
    begin
      if(rst)          //For resetting the module
        state <= idle;
      else begin
        case(state)
          idle:                   //State-1
            begin
              rx_data <= 8'h00;
              rx_done <= 1'b0;
              counts <= 0;
              count <= 0;
              
              if(rx==1'b0)
                state <= start;
              else
                state <= idle;
            end
          start:                  //State-2
            begin
              if(counts <= 7)
                begin
                  rx_data <= {rx,rx_data[7:1]};
                  counts <= counts+1;
                end
              else begin
                counts <= 0;
                rx_done <= 1'b1;
                state <= idle;
              end
            end
          default : state <= idle; //Default state
        endcase
      end
    end
endmodule

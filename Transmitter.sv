//Transmitting Module - Performs the tx function of the UART module
module uarttx
  #(
    parameter clk_freq = 1000000, //On-board clk frequency
    parameter baud_rate = 9600    //user defined baud_rate
  )
  (
    input reg clk,rst,
    input send,
    input [7:0] tx_data, //Data to be trabsferred
    output reg tx,       //tx data line for serial transmission, by default high
    output reg tx_done
  );
  
  localparam clk_count = (clk_freq/baud_rate);  //Freq. of local clk
  
  reg [7:0] d_in; //temporarily stores tx_data, so that data changes are avoided during transmission
  
  integer count = 0;  //For uclk generation
  integer counts = 0; //For identifying no. of bits sent serially
  reg uclk = 0;  //Local clk based on baud_rate
  
  enum bit[1:0] {idle = 2'b00,start = 2'b01,transmit = 2'b10,done = 2'b11}state;
  
  always @(posedge clk)  //Generating clk for given baud rate from onboard clk
    begin
      if(count < clk_count)
        count <= count+1;
      else begin
        count <= 0;
        uclk <= ~uclk;
      end
    end
  
  //The main FSM of the  module
  always @(posedge uclk)
    begin
      if(rst)    //For resetting the module
        state <= idle;
      else begin
        case(state)
          idle:                      //State-1
            begin
              count <= 0;
              counts <= 0;
              tx <= 1'b1;
              tx_done <= 1'b0;
              
              if(send) begin
                state <= transmit;
                tx <= 1'b0;
                d_in <= tx_data;
              end
              else
                state <= idle;
            end
          transmit:                      //State-2
            begin
              if(counts <= 7) begin
                counts <= counts+1;
                tx <= d_in[counts];
                state <= transmit;
              end
              else begin
                counts <= 0;
                tx <= 1'b1;
                tx_done <= 1'b1;
                state <= idle;
              end
            end
        endcase
      end
    end
  
endmodule

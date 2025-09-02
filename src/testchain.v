module testchain #(parameter P = 2 // Number of inverter pairs (default: 2 pairs = 4 inverters)
		   ) (
		      input wire  clk,
		      input wire  rst_n,
		      input wire  din,
		      input wire  test,
		      output wire dout
		      );
   
   // Flip-flop to store input data
   reg ff_input;
   reg ff_output;
   
   always @(posedge clk or negedge rst_n) begin
      if (rst_n == 1'b0)
	ff_input <= 1'b0;
      else
	ff_input <= din;
   end
   
   // Generate even number  of inverters (2*P inverters total)
   // Each pair of inverters should not be optimized away
   wire [2*P:0] inv_chain;
   
   // Connect first inverter to flip-flop output
   assign inv_chain[0] = ff_input;
   
   // Generate inverter chain - use generate block to prevent optimization
   genvar i;
   generate
      for (i = 0; i < 2*P; i = i + 1) begin : inv_pair
         // Add synthesis directive to prevent optimization
         (* keep = "true", dont_touch = "true" *)
         not #1 inv_gate (inv_chain[i+1], inv_chain[i]);
      end
   endgenerate
   
   // Output multiplexer controlled by test signal
   always @(posedge clk or negedge rst_n) begin
      if (rst_n == 1'b0)
	ff_output <= 1'b0;
      else
	ff_output <= test ? inv_chain[2*P] : ff_input;
   end
   
endmodule

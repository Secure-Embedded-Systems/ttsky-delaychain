module testchain #(parameter P = 2 // Number of inverter pairs (default: 2 pairs = 4 inverters)
		   ) (
		      input wire  clk,
		      input wire  rst_n,
		      input wire  din,
		      input wire  test,
		      output wire dout
		      );
  
   reg ff_input;
   reg ff_output;
 
   always @(posedge clk or negedge rst_n) begin
      if (rst_n == 1'b0)
	ff_input <= 1'b0;
      else
	ff_input <= din;
   end
 
   (* keep = "true" *) wire [2*P:0] inv_chain;
 
   assign inv_chain[0] = ff_input;
 
   genvar i;
   generate
      for (i = 0; i < 2*P; i = i + 1) begin : inv_pair
         (* keep = "true" *) cinv inv_gate (.q(inv_chain[i+1]), .a(inv_chain[i]));
      end
   endgenerate
 
   always @(posedge clk or negedge rst_n) begin
      if (rst_n == 1'b0)
	ff_output <= 1'b0;
      else
	ff_output <= test ? inv_chain[2*P] : ff_input;
   end

   assign dout = ff_output;
   
endmodule

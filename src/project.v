/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_delaychain (
			 input wire [7:0]  ui_in,   // Dedicated inputs
			 output wire [7:0] uo_out,  // Dedicated outputs
			 input wire [7:0]  uio_in,  // IOs: Input path
			 output wire [7:0] uio_out, // IOs: Output path
			 output wire [7:0] uio_oe,  // IOs: Enable path (active high: 0=input, 1=output)
			 input wire	   ena,	    // always 1 when the design is powered, so you can ignore it
			 input wire	   clk,	    // clock
			 input wire	   rst_n    // reset_n - low to reset
			 );
   
   wire _unused = &{ena, 1'b0};

   assign uio_out = 0;
   assign uio_oe  = 0;
   
   wire [7:0] c1q, c2q, c3q, c4q, c5q, c6q, c7q, c8q, c9q;
 
   genvar i;
   generate
      for (i = 0; i < 8; i = i + 1) begin : thechain
	 testchain #(.P(1))   chain1 (.clk(clk), .rst_n(rst_n), .din(ui_in[i]), .test(uio_in[0]), .dout(c1q[i]));
	 testchain #(.P(2))   chain2 (.clk(clk), .rst_n(rst_n), .din(  c1q[i]), .test(uio_in[0]), .dout(c2q[i]));
	 testchain #(.P(4))   chain3 (.clk(clk), .rst_n(rst_n), .din(  c2q[i]), .test(uio_in[0]), .dout(c3q[i]));
	 testchain #(.P(8))   chain4 (.clk(clk), .rst_n(rst_n), .din(  c3q[i]), .test(uio_in[0]), .dout(c4q[i]));
	 testchain #(.P(16))   chain5 (.clk(clk), .rst_n(rst_n), .din(  c4q[i]), .test(uio_in[0]), .dout(c5q[i]));
	 testchain #(.P(32))  chain6 (.clk(clk), .rst_n(rst_n), .din(  c5q[i]), .test(uio_in[0]), .dout(c6q[i]));
	 testchain #(.P(64))  chain7 (.clk(clk), .rst_n(rst_n), .din(  c6q[i]), .test(uio_in[0]), .dout(c7q[i]));
	 testchain #(.P(96))  chain8 (.clk(clk), .rst_n(rst_n), .din(  c7q[i]), .test(uio_in[0]), .dout(c8q[i]));
	 testchain #(.P(128))  chain9 (.clk(clk), .rst_n(rst_n), .din(  c8q[i]), .test(uio_in[0]), .dout(c9q[i]));
	 assign uo_out[i] = c9q[i];
      end
   endgenerate

endmodule

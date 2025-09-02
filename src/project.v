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
    input wire	      ena,     // always 1 when the design is powered, so you can ignore it
    input wire	      clk,     // clock
    input wire	      rst_n    // reset_n - low to reset
			 );
   
   assign uio_oe = 8'b0; // use uio as input
   wire _unused = &{ena, 1'b0};

   wire [7:0] c1q, c2q, c5q, c10q, c20q, c50q, c100q, c200q, c500q;
   
   genvar i;
   generate
      for (i = 0; i < 8; i = i + 1) begin : thechain
	 testchain #(.P(1))   chain1  (.clk(clk), .rst_n(rst_n), .din(ui_in[i]), .test(uio_in[0]), .dout(c1q[i]));
	 testchain #(.P(2))   chain2  (.clk(clk), .rst_n(rst_n), .din(  c1q[i]), .test(uio_in[0]), .dout(c2q[i]));
	 testchain #(.P(5))   chain5  (.clk(clk), .rst_n(rst_n), .din(  c2q[i]), .test(uio_in[0]), .dout(c5q[i]));
	 testchain #(.P(10))  chain10 (.clk(clk), .rst_n(rst_n), .din(  c5q[i]), .test(uio_in[0]), .dout(c10q[i]));
	 testchain #(.P(20))  chain20 (.clk(clk), .rst_n(rst_n), .din( c10q[i]), .test(uio_in[0]), .dout(c20q[i]));
	 testchain #(.P(50))  chain50 (.clk(clk), .rst_n(rst_n), .din( c20q[i]), .test(uio_in[0]), .dout(c50q[i]));
	 testchain #(.P(100)) chain100(.clk(clk), .rst_n(rst_n), .din( c50q[i]), .test(uio_in[0]), .dout(c100q[i]));
	 testchain #(.P(200)) chain200(.clk(clk), .rst_n(rst_n), .din(c100q[i]), .test(uio_in[0]), .dout(c200q[i]));
	 testchain #(.P(500)) chain500(.clk(clk), .rst_n(rst_n), .din(c200q[i]), .test(uio_in[0]), .dout(c500q[i]));
	 assign uo_out[i] = c500q[i];
      end
   endgenerate
			     
endmodule

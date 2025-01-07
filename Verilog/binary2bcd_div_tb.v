`include "binary2bcd_div.v"

`timescale 1ns/1ps

module tb_top_module;

parameter PERIOD = 10;
parameter LARGE_NUMBER = 9999;

integer i;

//top module input
reg [13:0] in_binary;
reg clk;
reg rst_n;
//top module output
wire [15:0] packed_bcd;

top_module u_top_module(
    .in_binary(in_binary),
    .clk(clk),
    .rst_n(rst_n),
    .packed_bcd(packed_bcd)
);

//generate clk
always #(PERIOD/2) clk = ~clk;

//system reset
initial begin
    clk = 1;
    rst_n = 1;

    #(PERIOD) rst_n = 0;
    #(PERIOD) rst_n = 1;
end


//dump the waveform of the simulation
initial begin
    $dumpfile("binary2bcd_div.vcd");
    $dumpvars;
end

initial begin
    wait(rst_n == 0);
    in_binary = 0;
    wait(rst_n == 1);
    //in_binary = 14'b00_0000_0000_0000;
    for (i = 0; i < LARGE_NUMBER; i = i + 1) begin
        @(posedge clk) in_binary = in_binary + 1;
        #(4*PERIOD); //needed??
    end
$finish;
end



endmodule
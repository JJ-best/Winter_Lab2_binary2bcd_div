`include "binary2bcd_div.v"

`timescale 1ns/1ps

module tb_top_module;

parameter PERIOD = 10;
parameter LARGE_NUMBER = 9999;

integer i, j;
integer error;

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
    #(PERIOD/2) rst_n = 1;
end


//dump the waveform of the simulation
initial begin
    $dumpfile("binary2bcd_div.vcd");
    $dumpvars;
end

// there you can read data from the solution file,and store in the register.
reg [15:0] solution [0:9999];
initial begin
  $readmemb("solution.dat",solution);
end

initial begin
    wait(rst_n == 0);
    in_binary = 0;
    wait(rst_n == 1);
    //in_binary = 14'b00_0000_0000_0000;
    for (i = 0; i < LARGE_NUMBER; i = i + 1) begin
        @(posedge clk) in_binary = in_binary + 1;
        #(4*PERIOD); //make the input waveform same as HLS
    end

end

//auto check result
initial begin
    error = 0; //error count
    wait(rst_n == 0);
    wait(rst_n == 1);
    for (j = 0; j < LARGE_NUMBER; j = j + 1) begin
        @(posedge clk) #(PERIOD);
        if (packed_bcd != solution[j][15:0]) begin
            error = error + 1;
            $display("pattern number No.%d is wrong at %t", j, $time);
            $display("your answer is %b, but the correct answer is %b", packed_bcd, solution[j]);
        end
        #(3*PERIOD);
    end

    if (error == 0) begin
        $display("Your answer is correct!");
    end else begin
        $display("Your answer is wrong!");
    end

    #(PERIOD)$finish;
end



endmodule
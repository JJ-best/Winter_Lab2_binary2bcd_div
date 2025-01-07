module top_module (
    input wire [13:0]in_binary,  //14-bit binary(0~16383)
    input wire clk,
    input wire rst_n,
    output reg [15:0]packed_bcd //16-bit BCD(0~9999)
);
reg [13:0]in_binary_;
wire [15:0]packed_bcd_;

//asynchronous reset
always @(posedge clk) begin
    if (~rst_n) begin //check rst_n value before
        in_binary_ <= 14'b00_0000_0000_0000;
        packed_bcd <= 16'b0000_0000_0000_0000;
    end else begin
        in_binary_ <= in_binary;
        packed_bcd <= packed_bcd_;
    end
        
end

binary2bcd_div ins1(.in_binary(in_binary_), .packed_bcd(packed_bcd_));
endmodule


// combinational block
module binary2bcd_div (
    input wire [13:0]in_binary,  //14-bit binary(0~16383)
    output wire [15:0]packed_bcd //16-bit BCD(0~9999)
);
integer i;
reg [13:0]a;
reg [3:0] digit[0:3];
always @(*) begin
    a = in_binary;
    for (i = 0; i < 4; i = i + 1) begin
        digit[i][3:0] = a % 10; //get LSB
        a = a / 10;
    end
end
assign packed_bcd = {digit[3], digit[2], digit[1], digit[0]};
endmodule


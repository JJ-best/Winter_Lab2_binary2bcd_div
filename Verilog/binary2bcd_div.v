module top_module (
    input wire [13:0]in_binary,  //14-bit binary(0~16383)
    input wire clk,
    input wire rst_n,
    output reg [15:0]packed_bcd //16-bit BCD(0~9999)
);
reg [13:0]in_binary_reg;
wire [15:0]packed_bcd_wire;
integer i;
reg [13:0]a[0:4];
reg [3:0]digit[0:3];

//asynchronous reset
always @(posedge clk) begin
    if (~rst_n) begin //check rst_n value before
        in_binary_reg <= 14'b00_0000_0000_0000;
        packed_bcd <= 16'b0000_0000_0000_0000;
    end else begin
        in_binary_reg <= in_binary;
        packed_bcd <= packed_bcd_wire;
    end
end

//combinational block
always @(*) begin
    a[0][13:0] = in_binary_reg;
    for (i = 0; i < 4; i = i + 1) begin
        digit[i][3:0] = a[i][13:0] % 10; //get LSB
        a[i+1][13:0] = a[i][13:0] / 10;
    end
end
assign packed_bcd_wire = {digit[3], digit[2], digit[1], digit[0]};
        
endmodule

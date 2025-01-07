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


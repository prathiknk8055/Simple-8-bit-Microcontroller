// adder.sv
module adder(
    input logic [7:0] in,
    output logic [7:0] out
);
assign out = in + 8'd1;
endmodule
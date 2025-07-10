module adder(
    input logic [7:0] in, // 8-bit input 
    output logic [7:0] out, // output value = increment by 1 
);

assign out = in + 8'd1; // Increment the input by 1
endmodule
//2-to-1 multiplexer
module mux(
    input logic [7:0] in1, // First input
    input logic [7:0] in2, // Second input
    input logic sel,       // Select signal
    output logic [7:0] out // Output based on select signal)
);

assign out = (sel)? in1: in2; // If sel is high, output in1, else output in2

endmodule
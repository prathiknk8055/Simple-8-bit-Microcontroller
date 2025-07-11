module mux(
    input  logic [7:0] in1,
    input  logic [7:0] in2,
    input  logic       sel,
    output logic [7:0] out
);
    assign out = (sel) ? in1 : in2;
endmodule

module data_memory(
    input  logic clk, E, WE,
    input  logic [3:0] Addr,
    input  logic [7:0] Data_in,
    output logic [7:0] Data_out
);
    logic [7:0] DataMem [255:0];

    always_ff @(posedge clk) begin
        if (E && WE)
            DataMem[Addr] <= Data_in;
    end

    always_comb begin
        if (E && !WE)
            Data_out = DataMem[Addr];
        else if (E && WE)
            Data_out = Data_in;
        else
            Data_out = 8'b0;
    end
endmodule

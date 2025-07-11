module program_mem (
    input  logic clk,
    input  logic E,
    input  logic [7:0] addr,
    output logic [11:0] I,
    input  logic load_en,
    input  logic [7:0] load_addr,
    input  logic [11:0] load_I
);
    logic [11:0] prog_mem [255:0];

    always_ff @(posedge clk) begin
        if (load_en)
            prog_mem[load_addr] <= load_I;
    end

    assign I = (E) ? prog_mem[addr] : 12'd0;
endmodule

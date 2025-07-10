module program_mem (
    input logic clk,
    input logic E,      //Enable to read
    input logic [7:0] addr,
    output logic [11:0] I,
    input logic load_en, //enable to write
    input logic [7:0]load_addr, //load address
    input logic [11:0] load_I //load instructions
);

logic [11:0] prog_mem [255:0]; // 256x12-bit memory

always_ff @( posedge clk ) begin
    if (load_en)
        prog_mem[load_addr] <= load_I; // Write instruction to memory
end

assign I = (E) ? prog_mem[addr] : 12'b0; // Read instruction if enabled

endmodule
module data_memory(
input logic clk,E,WE, //clock,Enable,Write Enable
input logic [3:0] Addr,
input logic [7:0] Data_in,
output logic [7:0] Data_out
);

logic [7:0] DataMem [255:0]; //256 x 8 bit memory

always_ff @(posedge clk) begin
	if(E && WE) begin
		DataMem[Addr] <= Data_in; //write when posedge clock
	end
end

always_comb begin
	if (E && !WE)
		Data_out = DataMem[Addr]; // Read from the memory
	else if (E && WE)
		Data_out =  Data_in; //Written Data
	else
		Data_out = 8'b0; //Disable

end
endmodule



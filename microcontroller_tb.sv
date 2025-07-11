`timescale 1ns/1ps
module microcontroller_tb();
    logic clk, rst;

    MicroController uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting simulation...");
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
        #500;
        $display("Simulation finished.");
        $stop;
    end
endmodule

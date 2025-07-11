module alu8bit (
    input  logic        enable,
    input  logic [3:0]  mode,
    input  logic [7:0]  operand1, operand2,
    output logic [7:0]  result,
    output logic [3:0]  flag
);
    logic carry, overflow, sign, zero;

    always_comb begin
        result   = 8'b0;
        carry    = 1'b0;
        overflow = 1'b0;
        sign     = 1'b0;
        zero     = 1'b0;

        if (enable) begin
            case (mode)
                4'd0:  {carry, result} = operand1 + operand2;
                4'd1:  {carry, result} = operand1 - operand2;
                4'd2:  result = operand1;
                4'd3:  result = operand2;
                4'd4:  result = operand1 & operand2;
                4'd5:  result = operand1 | operand2;
                4'd6:  result = operand1 ^ operand2;
                4'd7:  begin result = operand1 * operand2; carry = 1'b0; end
                4'd8:  {carry, result} = operand2 + 8'h1;
                4'd9:  {carry, result} = operand1 + 8'h1;
                4'd10: result = {operand2[6:0], operand2[7]};
                4'd11: result = {operand1[0], operand1[7:1]};
                4'd12: result = operand2 << 2;
                4'd13: result = operand2 >> 2;
                4'd14: result = operand2 >>> 3;
                4'd15: {carry, result} = 8'b0 - operand2;
                default: result = 8'b0;
            endcase

            zero     = (result == 8'b0);
            sign     = result[7];
            overflow = (operand1[7] != operand2[7]) && (result[7] != operand1[7]);
        end

        flag = {zero, carry, overflow, sign};
    end
endmodule

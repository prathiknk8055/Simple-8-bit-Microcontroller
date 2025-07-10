module alu8bit (
input  logic        enable,   // << Enable control added
input  logic [3:0]  mode,     // ALU mode selector
input  logic [7:0]  operand1,operand2, // First operand (Accumulator),Second operand (from memory or immediate)
output logic [7:0]  result,   // Result of the operation
output logic [3:0]  flag      // Flags: {Z (zero), C (carry), O (overflow), S (sign)}
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
            4'd0: {carry,result} = operand1 + operand2;// ADD
            4'd1: {carry,result} = operand1 - operand2;// SUB
            4'd2: result = operand1;                   // Pass operand1
            4'd3: result = operand2;                   // Pass operand2
            4'd4: result = operand1 & operand2;        // AND
            4'd5: result = operand1 | operand2;        // OR
            4'd6: result = operand1 ^ operand2;        // XOR
            4'd7: begin                                // MUL
                result = operand1 * operand2;
                carry = 1'b0;
            end
            4'd8: {carry,result} = operand2 + 8'h1;    // INC operand2
            4'd9: {carry,result} = operand1 + 8'h1;    // INC operand1
            4'd10: result = {operand2[6:0], operand2[7]}; // Rotate left
            4'd11: result = {operand1[0], operand1[7:1]}; // Rotate right
            4'd12: result = operand2 << 2;             // Logical Shift Left by 2
            4'd13: result = operand2 >> 2;             // Logical Shift Right by 2
            4'd14: result = operand2 >>> 3;            // Arithmetic Shift Right by 3
            4'd15: {carry,result} = 8'b0 - operand2;   // 2's complement
            default: result = 8'b00000000;
        endcase

        zero     = (result == 8'b00000000);
        sign     = result[7];
        overflow = (operand1[7] != operand2[7]) && (result[7] != operand1[7]);
    end
    flag = {zero, carry, overflow, sign}; // Output flags
end

endmodule

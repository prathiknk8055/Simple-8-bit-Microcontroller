module control_logic(
    input  logic [1:0] stage,
    input  logic [11:0] I,
    input  logic [3:0] SR,
    output logic PC_E, Acc_E, ALU_E, IR_E, SR_E,
    output logic DMem_E, DMem_WE, PMem_E, PMem_LE,
    output logic DR_E, mux1_sel, mux2_sel,
    output logic [3:0] ALU_mode
);
    typedef enum logic [1:0] {
        LOAD    = 2'b00,
        FETCH   = 2'b01,
        DECODE  = 2'b10,
        EXECUTE = 2'b11
    } state_t;

    state_t current_stage;

    always_comb begin
        current_stage = state_t'(stage);

        PC_E = 0; Acc_E = 0; ALU_E = 0; IR_E = 0; SR_E = 0;
        DMem_E = 0; DMem_WE = 0; PMem_E = 0; PMem_LE = 0;
        DR_E = 0; mux1_sel = 0; mux2_sel = 0; ALU_mode = 4'd0;

        case (current_stage)
            LOAD: begin
                PMem_E = 1;
                PMem_LE = 1;
            end

            FETCH: begin
                PMem_E = 1;
                IR_E = 1;
            end

            DECODE: begin
                if (I[11:9] == 3'b001) begin
                    DMem_E = 1;
                    DR_E = 1;
                end
            end

            EXECUTE: begin
                if (I[11] == 1) begin
                    PC_E = 1;
                    Acc_E = 1;
                    ALU_E = 1;
                    SR_E = 1;
                    ALU_mode = I[10:8];
                    mux1_sel = 1;
                    mux2_sel = 0;
                end else if (I[10] == 1) begin
                    PC_E = 1;
                    if (I[9:8] < 4)  // FIXED: prevent out-of-range index
                        mux1_sel = SR[I[9:8]];
                    else
                        mux1_sel = 1'b0;
                end else if (I[9] == 1) begin
                    PC_E = 1;
                    Acc_E = I[8];
                    ALU_E = 1;
                    ALU_mode = I[7:4];
                    SR_E = 1;
                    DMem_E = 1;
                    DMem_WE = !I[8];
                    mux1_sel = 1;
                    mux2_sel = 1;
                end else if (I[8] == 1) begin
                    PC_E = 1;
                    mux1_sel = 1;
                end else begin
                    PC_E = 1;
                    mux1_sel = 0;
                end
            end
        endcase
    end
endmodule

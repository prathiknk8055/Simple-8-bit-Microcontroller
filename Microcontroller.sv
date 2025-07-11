module MicroController(
    input logic clk,
    input logic rst
);

// FSM states
typedef enum logic [1:0] {
    LOAD    = 2'b00,
    FETCH   = 2'b01,
    DECODE  = 2'b10,
    EXECUTE = 2'b11
} state_t;

state_t current_state, next_state;

// Visible Registers
logic [7:0] PC, DR, Acc;
logic [11:0] IR;
logic [3:0] SR;

// Wires for register updates
logic [7:0] PC_updated, DR_updated;
logic [11:0] IR_updated;
logic [3:0] SR_updated;

// ALU interface
logic [7:0] ALU_Out, ALU_Operand2;
logic [3:0] ALU_Mode;
logic ALU_E;

// Control signals from control_logic
logic PC_E, Acc_E, SR_E, DR_E, IR_E;
logic PMem_E, DMem_E, DMem_WE, PMem_LE;
logic mux1_sel, mux2_sel;

// Loader control
logic [7:0] load_addr;
logic [11:0] load_instr;
logic load_done;

// Internal simulated instruction memory for loader
logic [11:0] program_mem [0:9]; // 10 instructions max
initial $readmemb("program_mem.dat", program_mem); // Load program from file

// ============ Component Instantiations ============ //

// Program Memory
program_mem pmem_inst (
    .clk(clk),
    .E(PMem_E),
    .addr(PC),
    .I(IR_updated),
    .load_en(PMem_LE),
    .load_addr(load_addr),
    .load_I(load_instr)
);

// Data Memory
data_memory dmem_inst (
    .clk(clk),
    .E(DMem_E),
    .WE(DMem_WE),
    .Addr(IR[3:0]),
    .Data_in(ALU_Out),
    .Data_out(DR_updated)
);

// ALU Operand2 MUX: selects between DR and IR[7:0]
mux mux2_inst (
    .in1(DR),
    .in2(IR[7:0]),
    .sel(mux2_sel),
    .out(ALU_Operand2)
);

// ALU unit
alu8bit alu_inst (
    .enable(ALU_E),
    .mode(ALU_Mode),
    .operand1(Acc),
    .operand2(ALU_Operand2),
    .result(ALU_Out),
    .flag(SR_updated)
);

// PC Adder: PC + 1
logic [7:0] pc_plus1;
adder pc_adder (
    .in(PC),
    .out(pc_plus1)
);

// MUX1: selects next PC (pc_plus1 or IR[7:0])
mux mux1_inst (
    .in1(pc_plus1),
    .in2(IR[7:0]),
    .sel(mux1_sel),
    .out(PC_updated)
);

// Control logic FSM
control_logic ctrl_inst (
    .stage(current_state),
    .I(IR),
    .SR(SR),
    .PC_E(PC_E),
    .Acc_E(Acc_E),
    .ALU_E(ALU_E),
    .IR_E(IR_E),
    .SR_E(SR_E),
    .DR_E(DR_E),
    .DMem_E(DMem_E),
    .DMem_WE(DMem_WE),
    .PMem_E(PMem_E),
    .PMem_LE(PMem_LE),
    .mux1_sel(mux1_sel),
    .mux2_sel(mux2_sel),
    .ALU_mode(ALU_Mode)
);

// ============ Loader FSM ============ //
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        load_addr <= 0;
        load_done <= 0;
    end else if (PMem_LE) begin
        load_addr <= load_addr + 1;
        load_done <= (load_addr == 8'd9); // After loading 10 instructions
    end
end

assign load_instr = (load_addr < 10) ? program_mem[load_addr] : 12'd0;

// ============ FSM State Update ============ //
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        current_state <= LOAD;
    else
        current_state <= next_state;
end

// ============ FSM Next State Logic ============ //
always_comb begin
    next_state = current_state;
    case (current_state)
        LOAD:    next_state = (load_done) ? FETCH : LOAD;
        FETCH:   next_state = DECODE;
        DECODE:  next_state = EXECUTE;
        EXECUTE: next_state = FETCH;
    endcase
end

// ============ Register Updates ============ //
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        PC  <= 0;
        Acc <= 0;
        SR  <= 0;
    end else begin
        if (PC_E)  PC  <= PC_updated;
        if (Acc_E) Acc <= ALU_Out;
        if (SR_E)  SR  <= SR_updated;
    end
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        DR <= 0;
        IR <= 0;
    end else begin
        if (DR_E) DR <= DR_updated;
        if (IR_E) IR <= IR_updated;
    end
end

endmodule

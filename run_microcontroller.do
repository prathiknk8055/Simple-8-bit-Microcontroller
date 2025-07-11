# Set working directory (adjust if needed)
# cd ./  ;# Assuming you're in the project folder

# 1. Create work library
vlib work

# 2. Compile all design and testbench files
vlog Control_logic.sv
vlog IR_Register.sv
vlog SR_Register.sv
vlog accumulator.sv
vlog adder.sv
vlog alu8bit.sv
vlog mux.sv
vlog data_memory.sv
vlog program_memory.sv
vlog Microcontroller.sv
vlog microcontroller_tb.sv

# 3. Load the testbench for simulation
vsim microcontroller_tb

# 4. Add useful signals to the waveform viewer

# -- Clock & Reset --
add wave -divider "Clock & Reset"
add wave /microcontroller_tb/clk
add wave /microcontroller_tb/rst

# -- FSM Control --
add wave -divider "FSM"
add wave /microcontroller_tb/uut/current_state
add wave /microcontroller_tb/uut/next_state

# -- Registers --
add wave -divider "Registers"
add wave /microcontroller_tb/uut/PC
add wave /microcontroller_tb/uut/IR
add wave /microcontroller_tb/uut/DR
add wave /microcontroller_tb/uut/Acc
add wave /microcontroller_tb/uut/SR

# -- ALU --
add wave -divider "ALU"
add wave /microcontroller_tb/uut/ALU_Out
add wave /microcontroller_tb/uut/ALU_Operand2
add wave /microcontroller_tb/uut/ALU_Mode

# -- Control Signals --
add wave -divider "Control Signals"
add wave /microcontroller_tb/uut/ctrl_inst/PC_E
add wave /microcontroller_tb/uut/ctrl_inst/Acc_E
add wave /microcontroller_tb/uut/ctrl_inst/ALU_E
add wave /microcontroller_tb/uut/ctrl_inst/IR_E
add wave /microcontroller_tb/uut/ctrl_inst/SR_E
add wave /microcontroller_tb/uut/ctrl_inst/DMem_E
add wave /microcontroller_tb/uut/ctrl_inst/DMem_WE
add wave /microcontroller_tb/uut/ctrl_inst/PMem_E
add wave /microcontroller_tb/uut/ctrl_inst/PMem_LE
add wave /microcontroller_tb/uut/ctrl_inst/DR_E
add wave /microcontroller_tb/uut/ctrl_inst/mux1_sel
add wave /microcontroller_tb/uut/ctrl_inst/mux2_sel

# 5. Run the simulation
run 1000ns

# 6. Optionally open the waveform window
view wave

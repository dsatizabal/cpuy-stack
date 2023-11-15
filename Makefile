# cocotb setup
# MODULE = test.test_stack
# export MODULE
TOPLEVEL = stack
VERILOG_SOURCES = stack.v

include $(shell cocotb-config --makefiles)/Makefile.sim

synth_stack:
	yosys -p "read_verilog stack.v; proc; opt; show -colors 2 -width -signed stack"

test_stack:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s tb -s dump -g2012 dump_stack.v stack.v tb.v
	PYTHONOPTIMIZE=${NOASSERT} MODULE = test.test_stack vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_gate_level:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s tb_gl -s dump_gl -g2012 stack_gl.v dump_stack_gl.v tb_gl.v -I $(PDK_ROOT)/sky130A
	PYTHONOPTIMIZE=${NOASSERT} MODULE = test.test_stack_gl vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

gtkwave_stack:
	gtkwave stack.vcd stack.gtkw

formal_stack:
	sby -f stack.sby

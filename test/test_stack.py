import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def normal_push_operation(dut):
    clock = Clock(dut.clk, 10, "us")
    cocotb.fork(clock.start())

    dut.enable.value = 1
    dut.operation.value = 0 # Pop

    dut.rst.value = 1
    await ClockCycles(dut.clk, 2)
    dut.rst.value = 0

    await ClockCycles(dut.clk, 2)
    assert dut.empty == 1, f"Expected EMPTY";

    dut.operation.value = 1 # Push
    dut.data_in.value = 43690 # AAAAh
    await ClockCycles(dut.clk, 2)
    dut.enable.value = 0
    assert dut.empty == 0, f"Expected NOT EMPTY";

@cocotb.test()
async def normal_pop_operation(dut):
    clock = Clock(dut.clk, 10, "us")
    cocotb.fork(clock.start())

    dut.enable.value = 1
    dut.operation.value = 0 # Pop

    dut.rst.value = 1
    await ClockCycles(dut.clk, 2)
    dut.rst.value = 0

    await ClockCycles(dut.clk, 2)
    assert dut.empty == 1, f"Expected EMPTY";

    dut.operation.value = 1 # Push
    dut.data_in.value = 43690 # AAAAh
    await ClockCycles(dut.clk, 2)
    assert dut.empty == 0, f"Expected NOT EMPTY";

    dut.operation.value = 0 # Pop
    await ClockCycles(dut.clk, 2)
    assert dut.empty == 0, f"Expected EMPTY AGAIN";
    assert dut.data_out == 43690, f"Expected popped address to be 43690, got {dut.data_out}";

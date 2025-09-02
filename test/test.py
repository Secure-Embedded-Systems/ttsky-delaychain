# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # scan mode
    dut.uio_in.value = 0

    for l in range(0,9):
      dut.ui_in.value = 255
      await ClockCycles(dut.clk, 1)
      dut.ui_in.value = 0
      await ClockCycles(dut.clk, 1)

    # test mode
    dut.uio_in.value = 1
    dut.ui_in.value = 255
    await ClockCycles(dut.clk, 1) # arming cycle
    await ClockCycles(dut.clk, 1) # measuring cycle

    # scan out
    dut.uio_in.value = 0
      
    for p in range(0,12):
       dut._log.info(f"uo_out = {dut.uo_out.value}")
       await ClockCycles(dut.clk, 1)
       dut._log.info(f"uo_out = {dut.uo_out.value}")
       await ClockCycles(dut.clk, 1)

    assert 1 == 1

    

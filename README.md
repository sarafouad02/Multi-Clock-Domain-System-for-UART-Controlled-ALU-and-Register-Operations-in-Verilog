# UART‑Driven Register File & ALU System

## Project Overview

This repository implements a **UART‑controlled processing system** that performs register file operations and ALU computations across two clock domains. An **asynchronous FIFO** bridges the clock-domain crossing between a 50 MHz reference clock and a 3.6864 MHz UART clock, ensuring reliable data transfer.

Key capabilities:

* Configuration and data transfer via UART frames
* Register file reads/writes
* Full ALU support (arithmetic, logic, comparison, shifts)
* Clock gating and synchronization modules

## Clock Domains & Synchronization

* **REF\_CLK (50 MHz)**: Drives `RegFile`, `ALU`, `SYS_CTRL`, and `Clock Gating` blocks.
* **UART\_CLK (3.6864 MHz)**: Drives `UART_RX`, `UART_TX`, `Pulse_Gen`, and `Clock Divider`.
* **Synchronization**:

  * `RST_Synchronizer` for reset alignment
  * `Data_Synchronizer` for single‑cycle pulses
  * `ASYNC_FIFO` for multi‑word data crossing fileciteturn2file0

## Top‑Level Blocks

1. **SYS\_CTRL**: Orchestrates all operations—parses UART commands, drives `RegFile` & `ALU`, and writes results back via UART.
2. **RegFile**: 16×8‑bit register file with read/write interface and `RdData_Valid` flag.
3. **ALU**: 8‑bit operands, 4‑bit function select, supports add, sub, mult, div, logic, compare, shift, etc.
4. **Clock Gating**: Enables/disables ALU clock based on `SYS_CTRL` signal.
5. **Clock Divider**: Generates UART\_CLK from REF\_CLK based on register‐programmable ratio.
6. **UART\_TX/RX**: Frame‐based serial interface with parity/strobe, connected through FIFO.
7. **Pulse\_Gen**: Converts level signals to pulses for FIFO reads.
8. **Synchronizers**: `RST_Sync`, `Data_Sync` for robust multi‑domain operation.
9. **ASYNC\_FIFO**: 8‑bit wide, depth configurable, with `full`/`empty` flags, bridging REF\_CLK→UART\_CLK domains.

## UART Command Protocol

Supported commands are sent as multi‑byte frames from the master testbench:

| Command                 | Opcode | Frames | Payload         |
| ----------------------- | ------ | ------ | --------------- |
| **RF Write**            | 0xAA   | 3      | \[Addr]\[Data]  |
| **RF Read**             | 0xBB   | 2      | \[Addr]         |
| **ALU Op w/ Operands**  | 0xCC   | 4      | \[A]\[B]\[Func] |
| **ALU Op w/o Operands** | 0xDD   | 2      | \[Func]         |

The system decodes each frame, performs the specified operation, then sends back result frames over UART.

## Supported Operations

* **Register File**: Read/Write to arbitrary addresses (0x4–0x15).
* **ALU**:

  * Arithmetic: `+`, `-`, `×`, `÷`
  * Logical: `AND`, `OR`, `NAND`, `NOR`, `XOR`, `XNOR`
  * Compare: `A==B`, `A>B`
  * Shift: `>>1`, `<<1`

Configuration registers (0x0–0x3) define parity, prescale, and division ratios for UART and clock divider. fileciteturn2file0

## Simulation & Testbench

* **UVM‑Based TB** under `tb/` generates UART frames, drives resets, and checks responses.
* **Sequence of Operation**:

  1. Initialize configuration registers via RF\_Write (addresses 0x2, 0x3)
  2. Send mixed stream of RF\_Read/Write and ALU commands
  3. Verify FIFO full/empty flags and data flow across domains
  4. Capture and validate UART\_TX result frames against expected values


## Getting Started

1. **Prerequisites**: SystemVerilog simulator (VCS/Questa/Xcelium), UVM installation.


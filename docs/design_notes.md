# Design Notes

## Week 1 — adder_rca

Completed:
- Parameterized signed ripple carry adder
- Signed overflow detection
- WIDTH = 8/16/32 verified
- Directed testbench created
- GTKWave verification completed

Verification:
- tests_run = 16
- failures = 0

Observations:
- Overflow flag behaves correctly
- RTL parameterization works across widths

---

## Week 1 — accumulator

Completed:
- Parameterized accumulator module
- Signed accumulation logic implemented
- Synchronous reset implemented
- valid_in controlled accumulation
- Hold behavior verified when valid_in = 0
- Sticky overflow flag implemented
- WIDTH = 8 verified
- WIDTH = 16 verified
- Directed testbench created
- VCD generation enabled

Verification:
- Reset functionality verified
- Hold functionality verified
- Multi-cycle accumulation verified
- Positive overflow verified
- Negative overflow verified
- Sticky overflow behavior verified
- All test cases passed

Accumulator Overflow Policy:
- When signed overflow is detected:
  - overflow_flag is asserted
  - overflow_flag remains asserted until reset
  - accumulator value is frozen
  - further accumulation is disabled

Observations:
- Sticky overflow mechanism behaves correctly
- Parameterization works across widths
- Freezing the accumulator after overflow prevents propagation of invalid accumulated results
- Design is suitable as the common accumulator block for all future MAC architecture variants

---

## Week 1 — multiplier_array

Completed:
- Parameterized array multiplier
- Signed multiplication support
- Shift-and-add partial product generation
- WIDTH = 8/16/32 verified
- Directed testbench created
- VCD generation enabled

Verification:
- Positive × Positive
- Positive × Negative
- Negative × Positive
- Negative × Negative
- Boundary condition testing completed
- All test cases passed

Observations:
- Signed magnitude conversion correctly handles two's-complement edge cases
- Parameterization works across widths
- Architecture will serve as the baseline multiplier for V1 MAC implementation

## Week 1 Summary

Verified Modules:

- adder_rca
- accumulator
- multiplier_array
- mac_top

Verification Status:

- Simulation passed
- Directed testing passed
- Waveforms reviewed

Verification Metrics:

- adder_rca: 16 directed tests passed
- accumulator: all directed tests passed
- multiplier_array: all directed tests passed
- mac_top: all integration tests passed

Waveforms:

- tb_adder_rca.vcd
- tb_accumulator.vcd
- tb_multiplier_array.vcd
- tb_mac_top.vcd

Architecture Status:

- V1 baseline architecture complete

Next Phase:

- Run synthesis on V1
- Collect area metrics
- Collect timing metrics
- Begin V2 implementation

---

## Week 1 — mac_top (V1 Integration)

Completed:
- Integrated multiplier_array and accumulator
- Created baseline V1 MAC datapath
- WIDTH = 8 verified
- WIDTH = 16 verified
- Directed integration testbench created
- VCD generation enabled

Verification:
- Positive multiplication accumulation verified
- Negative multiplication accumulation verified
- Multi-cycle accumulation verified
- Hold behavior verified
- Reset behavior verified
- Positive overflow verified
- Negative overflow verified
- Sticky overflow verified

Observations:
- Module interfaces integrated cleanly
- Accumulator overflow policy behaves as intended
- Baseline V1 architecture ready for synthesis

---

## Week 2 — V1 Synthesis Results

Tool:
- Yosys

Top Module:
- mac_top

Synthesis Statistics:

| Metric | Value |
|----------|----------|
| Total Cells | 37 |
| Total Wires | 56 |
| Wire Bits | 546 |

Multiplier:
- 25 cells

Accumulator:
- 12 cells

Observations:
- V1 MAC synthesizes successfully
- Baseline architecture established
- Area and timing improvements will be compared against this version

---

## Week 3 – CLA Adder

- Implemented parameterized carry lookahead adder
- Verified overflow detection
- Generated waveform validation

---

## Week 4 – Booth Multiplier

- Implemented signed Booth multiplier
- Fixed -128 × 127 corner case
- Verified signed arithmetic behavior

---

## Week 5 – V2 MAC Integration

- Integrated Booth multiplier and CLA accumulator
- Verified MAC operation
- Completed synthesis

---

### Verification

- CLA adder verified through directed testing
- Booth multiplier verified through directed testing
- Corner case (-128 × 127) verified
- MAC_TOP_V2 integration testbench created
- Multi-cycle accumulation verified
- Signed arithmetic verified
- Functional simulation passed

### Synthesis Results

Tool:
- Yosys

Top Module:
- mac_top_v2

| Metric | Value |
|----------|----------|
| Total Cells | 110 |
| Total Wires | 71 |
| Total Wire Bits | 593 |

### Architecture

- Booth Multiplier
- CLA Adder
- Accumulator V2

### Observations

- V2 synthesizes successfully
- CLA integrated into accumulation datapath
- Booth multiplier synthesizes correctly
- Functional verification matches expected results
- V2 introduces additional logic resources compared to V1
- V2 architecture is ready for FPGA implementation
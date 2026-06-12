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
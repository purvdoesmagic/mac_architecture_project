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
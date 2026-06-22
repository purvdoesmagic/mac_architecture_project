# Report Tables

## Table 1: Architecture Summary

| Feature | V1 | V2 |
|----------|----------|----------|
| Adder | Ripple Carry Adder (RCA) | Carry Lookahead Adder (CLA) |
| Multiplier | Array Multiplier | Booth Multiplier |
| Accumulator | Basic Accumulator | CLA-assisted Accumulator |
| Signed Arithmetic | Supported | Supported |
| Overflow Detection | Supported | Supported |
| Verification Status | Pass | Pass |
| Synthesis Status | Pass | Pass |

---

## Table 2: Area Metrics

| Metric | V1 | V2 |
|----------|----------:|----------:|
| Total Cells | 37 | 110 |
| Total Wires | 56 | 71 |
| Total Wire Bits | 546 | 593 |

---

## Table 3: Timing Metrics

| Metric | V1 | V2 |
|----------|----------|----------|
| Critical Path | TBD (FPGA Stage) | TBD (FPGA Stage) |
| Maximum Frequency | TBD (FPGA Stage) | TBD (FPGA Stage) |

---

## Table 4: Power Metrics

| Metric | V1 | V2 |
|----------|----------|----------|
| Dynamic Power | TBD (FPGA Stage) | TBD (FPGA Stage) |
| Static Power | TBD (FPGA Stage) | TBD (FPGA Stage) |

---

## Table 5: ADP Comparison

ADP = Area × Delay Product

| Architecture | Area | Delay | ADP |
|----------|----------|----------|----------|
| V1 | TBD | TBD | TBD |
| V2 | TBD | TBD | TBD |

---

## Table 6: Scalability Analysis

| Width | V1 Status | V2 Status |
|----------|----------|----------|
| 8-bit | Verified | Verified |
| 16-bit | Verified | RTL Parameterized |
| 32-bit | Verified | RTL Parameterized |

---

## Key Observations

- V2 replaces the Array Multiplier with a Booth Multiplier.
- V2 replaces the Ripple Carry Adder with a Carry Lookahead Adder.
- V2 introduces additional logic resources.
- V2 is expected to improve arithmetic performance at the cost of increased area.
- FPGA implementation will provide timing and power measurements.
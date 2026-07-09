# APB Protocol Verification using UVM

A complete **SystemVerilog UVM-based verification environment** for the **AMBA APB (Advanced Peripheral Bus)** protocol. This project verifies a multi-slave APB system using constrained-random verification, self-checking mechanisms, functional coverage, and SystemVerilog Assertions (SVA).

---

## Project Highlights

* UVM 1.2 based reusable verification environment
* Two APB slave peripherals
* Multi-slave APB architecture
* Constrained-random verification
* Self-checking scoreboard
* SystemVerilog Assertions (SVA)
* Functional & Cross Coverage
* 100% Functional Coverage Achieved
* Configurable wait-state (`PREADY`) support
* Error response (`PSLVERR`) verification

---

## Design Overview

### APB Slave 1

* 4 × 32-bit register-based peripheral
* Read/Write operations
* Address decoding
* Invalid address detection
* Configurable wait-state generation

### APB Slave 2

* 32 × 32-bit memory-based peripheral
* Memory read/write operations
* Address validation
* `PSLVERR` generation
* Configurable wait-state generation

---

## UVM Testbench Architecture

```text
                  +----------------------+
                  |        Test          |
                  +----------+-----------+
                             |
                  +----------v-----------+
                  |      Environment     |
                  +----------+-----------+
                             |
                      +------+------+
                      |             |
                 +----v----+   +----v----+
                 |  Agent  |   |Scoreboard|
                 +----+----+   +----+----+
                      |
         +------------+------------+
         |            |            |
   +------v------+ +---v----+ +-----v------+
   | Sequencer   | | Driver | |  Monitor   |
   +-------------+ +---+----+ +------+-----+
                        |              |
                        |              +--------------------+
                        |                                   |
                    APB Interface                     Coverage Collector
                        |
                        |
                    DUT (APB Slaves)
```

---

## Verification Features

* Register Read/Write Verification
* Memory Read/Write Verification
* Reset Verification
* Wait-State Verification
* Invalid Address Verification
* `PSLVERR` Validation
* Multi-Slave Transaction Verification
* Randomized APB Transactions
* Automatic Result Checking

---

## Assertions Implemented

* Setup → Access phase transition
* Signal stability during wait states
* Unknown (X/Z) signal detection
* Control signal validation
* APB protocol compliance
* Enable signal validation

---

## Functional Coverage

The functional coverage model includes:

* Slave Selection
* Address Coverage
* Register Access Coverage
* Memory Access Coverage
* Read/Write Coverage
* Error (`PSLVERR`) Coverage
* Address × Read/Write Cross Coverage
* Read/Write × Error Cross Coverage

**Coverage Result:** **100% Functional Coverage**

---

## Repository Structure

```text
.
├── rtl/
│   ├── APB_slave1.sv
│   └── APB_slave2.sv
│
├── tb/
│   ├── interface.sv
│   ├── packet.sv
│   ├── sequences.sv
│   ├── sequencer.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── coverage.sv
│   ├── agent.sv
│   ├── env.sv
│   ├── test.sv
│   └── testbench.sv
│
└── README.md
```

---

## Tools & Technologies

* SystemVerilog
* UVM 1.2
* QuestaSim / ModelSim
* EDA Playground & VIM
* Git & GitHub

---

## Skills Demonstrated

* AMBA APB Protocol Verification
* UVM Testbench Development
* Constrained-Random Verification
* Functional & Cross Coverage
* SystemVerilog Assertions (SVA)
* Self-Checking Scoreboard Design
* Multi-Slave Verification
* Protocol Compliance Verification

---

## Future Enhancements

* APB4 Support (`PSTRB`, `PPROT`)
* Register Abstraction Layer (UVM RAL)
* APB Protocol Checker
* Regression Automation Scripts
* Coverage-Driven Test Generation
* CI/CD Integration using GitHub Actions

---

## License

This project is licensed under the **MIT License**.

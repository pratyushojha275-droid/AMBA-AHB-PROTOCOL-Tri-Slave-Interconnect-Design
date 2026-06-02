# AMBA AHB PROTOCOL: Tri-Slave Interconnect Design

**Author:** Pratyush Ojha  
**Institution:** Motilal Nehru National Institute of Technology Allahabad  

## 🎯 Project Goal
The primary goal of this project is to design a high-performance, scalable AMBA AHB interconnect that reduces extra clock cycle delays after every burst and minimizes memory wastage. 

## 🧠 The Problem: Managing the Silicon "Lecture Hall"
System-on-Chip (SoC) designs require standardized communication as complexity grows. In the early days of electronics, chips were simple—just a processor and a memory connected together. It was like teaching a single student, where you just look at them and talk. 

Modern SoCs, however, contain CPUs, GPUs, RAM, and hardware accelerators (dedicated silicon hardwired to solve specific math perfectly) all crammed onto one chip. You aren't tutoring one student anymore; you are managing a 300-student lecture hall. If everyone talks at once without a strict rulebook, the system collapses into chaos. 

Furthermore, hardwiring a single Master to 3 Slaves would require roughly 100 physical microscopic copper wires per slave, forcing the Master to need 300 physical pins.

## 🛠️ The Solution: The AHB Architecture
AMBA AHB centralizes the routing using a master-slave contract, decoders, and multiplexers. This allows the Master's pin count to drop drastically, as it only needs one set of ~100 pins to access all slaves.

### System Components
* **The Master (The Initiator):** Generates addresses, selects burst types (SINGLE, INCR, WRAP), and manages control signals. The Master's read/write addresses are completely independent of its own internal memory.
* **The Decoder (The Post Office):** When the Master sends an address, the Decoder reads it and flips the correct `HSEL` switch to wake up *only* the targeted Slave.
* **The Multiplexer (The Traffic Cop):** When Slaves send data back, the MUX ensures only the selected Slave's data enters the Master's receiving lane, physically blocking collisions.

## 🗺️ Tri-Slave Memory Map
The Decoder takes the 32-bit address from the Master and decodes it to signal the correct slave.
* **Slave 1:** Addresses `0` to `124` ➔ `HSEL_1 = 1`, MUX `m_select = 0`
* **Slave 2:** Addresses `128` to `252` ➔ `HSEL_2 = 1`, MUX `m_select = 1`
* **Slave 3:** Addresses `256` to `380` ➔ `HSEL_3 = 1`, MUX `m_select = 2`

---

## ⚡ Key Engineering Optimizations & Features

### 1. Pipelining the MUX (`m_delayed`)
In a standard combinational MUX, when the Master changes the address to talk to a new slave, the MUX switches instantly. This causes the final data beat of the *previous* slave to get lost. 
* **The Fix:** A custom register (`m_delayed`) was implemented in the top module to delay the Decoder's `m_select` signal by exactly one clock cycle. This allows the final data of the previous burst to load safely before jumping to the new slave, preventing data loss without wasting cycles.

### 2. Independent Internal Memory & The `new` Signal
The Master has its own internal memory pointer (`HADDR_M`) which is strictly synchronized with the AHB bus address (`HADDR`). This synchronization ensures that when the bus is IDLE, the Master doesn't waste internal memory by counting up unnecessarily. 
* **The `new` Signal:** If you want the Master to suddenly fetch data from a completely different part of its internal memory mid-transfer, you pulse the `new = 1` input alongside the new target address (`add_m`). The Master instantly jumps to the new location. By dropping `new = 0` on the next clock, it resumes counting smoothly from the new location.

### 3. Zero-Delay Burst Chaining (`burst_done`)
If a Master waits until a burst is completely done and saturates (`burst_done = 1`), the user must reset the state by sending a transition signal (`trans = 2'b00`), which wastes 2 clock cycles. 
* **The Fix:** To maximize data processing speed, this architecture allows you to feed a new `burst_type` and initial address at the *exact negedge* of the previous burst's final address. This chains the bursts together with zero wasted clock cycles. *(Note: The INCR burst of unspecified length, `3'b001`, bypasses the `burst_done` logic completely, allowing the user to end it manually whenever they choose).*

### 4. The `again` Signal
If the user wants to repeat the exact same burst immediately, allowing the burst to finish normally would cost those 2 extra setup cycles. 
* **The Fix:** A dedicated `again` input signal was coded to instantly trigger the exact same burst over again without a single clock cycle of wastage.

---

## 🚦 Protocol States & Handshaking

### The Address Phase (`HTRANS`)
When a new burst begins, the Master alerts the Slave using `HTRANS`:
* **NONSEQ (`2'b10`):** The very first beat of a burst. Wakes up the Slave and provides the base address.
* **SEQ (`2'b11`):** All subsequent beats. The Slave automatically knows to increment or wrap the address based on the `HBURST` type.

* ## 📂 File Sequence (How to read this project)
To understand the architecture, please review the Verilog files in this logical order:

1. **`Top.v`** *(If you have one - The top-level wrapper connecting everything)*
2. **`MASTER_H.v`** *(The brain of the operation generating addresses and bursts)*
3. **`decoder.v`** *(The address decoder routing signals to slaves)*
4. **`H_MUX.v`** *(The pipelined multiplexer handling read data)*
5. **`M_data_mem.v`** *(The Master's internal memory)*
6. **`S_data_mem.v`, `S_data_mem1.v`, `S_data_mem2.v`** *(The three slave memory blocks)*
7. **`H_testbench.v`** *(The simulation environment to verify the protocol)*

### IDLE vs. BUSY
* **IDLE (`2'b00`):** Like hanging up the phone. The Master is saying, "I have no more data for you. Our conversation is over." To talk again, the Master must send a new `NONSEQ` command.
* **BUSY (`2'b01`):** Like putting the Slave on hold. The Master is saying, "We are in the middle of a burst... my internal brain needs a second to fetch the next word. DO NOT hang up, I will be right back." The burst resumes smoothly without dropping the connection.

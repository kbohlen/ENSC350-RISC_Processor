# ENSC350-RISC_Processor
VHDL design of a RISC processor architecture

## Description
This reduced instruction set computer (RISC) processor architecture is based on the Harvard memory model, meaning that it has seperate and independant access to data and instruction memory.

## Parametric Design
The bus widths for the processor are designed to be parametric in the code, and are defined in the package. This is currently using 20-bit instructions, with 16-bit data, and 16 registers.

## Instruction Set Architecture
The ISA for the processor is defined as follows and can be found in the package. Instructions can be of either a RRR or RRI format.

### Register Register Register (RRR)
    ---------------------------------------------------------------------------------------
    | 0000 (4-bits) | r1 (4 bits) | r2 (4 bits) | r3 (4-bits) | secondary opcode (4-bits) |
    ---------------------------------------------------------------------------------------
### Register Register Immediate (RRI)
    -------------------------------------------------------------------------
    | primary opcode (4-bits) | r1 (4 bits) | r2 (4 bits) | 8-bit immediate |
    -------------------------------------------------------------------------
### Supported Instructions

<table>
<tr>
  <th>RRR Instructions</th>
  <th>Description:</th>
</tr>
<tr><td><code>ADD Rd,Rs1,Rs2</code></td><td>Add Rs1 to Rs2</td></tr>
<tr><td><code>SUB Rd,Rs1,Rs2</code></td><td>Subtract Rs2 from Rs1</td></tr>
<tr><td><code>AND Rd,Rs1,Rs2</code></td><td>Bitwise AND Rs1 with Rs2</td></tr>
<tr><td><code>OR&nbsp; Rd,Rs1,Rs2</code></td><td>Bitwise OR Rs1 with Rs2</td></tr>
<tr><td><code>SLT Rd,Rs1,Rs2</code></td><td>Output = 1 if Rs1 &lt; Rs2</td></tr>
<tr><td><code>SLL Rd,Rs1,Rs2</code></td><td>Shift Left Logical Rs1 by Rs2 bits</td></tr>
<tr><td><code>SRL Rd,Rs1,Rs2</code></td><td>Shift Right Logical Rs1 by Rs2 bits</td></tr>
<tr><td><code>SRA Rd,Rs1,Rs2</code></td><td>Shift Right Arithmetic Rs1 by Rs2 bits</td></tr>
<tr><td><code>MUL Rd,Rs1,Rs2</code></td><td>Multiply Rs1 with Rs2</td></tr>
</table>
  
<table>  
<tr>
  <th>RRI Instructions</th>
  <th>Description:</th>
</tr>
<tr><td><code>ADDI Rd, Rs, Immediate</code></td><td>Add Rs to Immediate</td></tr>
<tr><td><code>ANDI Rd, Rs, Immediate</code></td><td>Bitwise AND Rs with Immediate</td></tr>
<tr><td><code>ORI&nbsp; Rd, Rs, Immediate</code></td><td>Bitwise OR Rs with Immediate</td></tr>
<tr><td><code>SLTI Rd, Rs, Immediate</code></td><td>Output = 1 if Rs &lt; Immediate</td></tr>
<tr><td><code>LUI&nbsp; Rd, Rs, Immediate</code></td><td>Load Immediate on upper 8-bits of Rs</td></tr>
<tr><td><code>J&nbsp;&nbsp;&nbsp; Rs</code></td><td>Jump to content of Rs</td></tr>
<tr><td><code>BEQ&nbsp; Rs1,Rs2,Immediate</code></td><td>Jump to PC + Immediate if Rs1 == Rs2</td></tr>
<tr><td><code>BNEQ Rs1,Rs2,Immediate</code></td><td>Jump to PC + Immediate if Rs1 != Rs2</td></tr>
<tr><td><code>LW&nbsp;&nbsp; Rd, Rs, Immediate</code></td><td>Load content of memory address Rs + Immediate onto Rd</td></tr>
<tr><td><code>SW&nbsp;&nbsp; Rs1,Rs2,Immediate</code></td><td>Store to memory address Rs2 + Immediate content of Rs1</td></tr>
</table>

## Memory Files
The imemory.mif and the dmemory.mif are the files for the processors instruction memory and data memory respectively. They are used for programming the processor to perform its various operations.

The 2 program files perform the exact same FIR calculation as ENSC350-FIR_Filter. In this case it is implemented in software rather than hardware. It can be noted that the hardware is more efficient in it's FIR calculation whereas the processor is programmable and versatile, able to perform many other tasks.

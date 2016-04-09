---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ensc350_package is

	constant daddr_size : positive := 12;
	constant iaddr_size : positive := 12;
	constant instr_size : positive := 20;
	constant data_size  : positive := 16;
	constant rf_addr_size : positive := 4;
	
   type alu_commands    is (alu_add, alu_addu, alu_sub, alu_subu, alu_slt, alu_sltu,
	                        alu_and, alu_or, alu_xor,alu_nor,alu_sll,alu_srl,alu_sra,alu_lui);
   type mul_commands    is (mul_nop, mul_mul);
   type mem_commands    is (mem_nop, mem_lw, mem_sw);
   type pc_commands     is (pc_carryon,pc_beq,pc_bneq,pc_jump);
   type operand_select  is (operand_rs2,operand_immed);
   type wb_select       is (wb_alu,wb_shift,wb_mul,wb_mem,wb_jal);
   
	------------------------------------------------------					  
	-- Instruction set for the ensc350 Processor
	-- Instruction Format: RRI Instructions
	-- |op   | Rd  | Rs1 | Immediate | 
	-- |4 bit|4 bit|4 bit|    8 bit  |
	-- Instruction Format: RRR Instructions
	-- |0000 | Rd  | Rs1 | Rs2 | 2op | 
	-- |4 bit|4 bit|4 bit|4 bit|4 bit|
    -- 	
	subtype up_instructions     is std_logic_vector(3 downto 0);
	subtype up_RRR_instructions is std_logic_vector(3 downto 0);

	  constant op_RRR  : up_instructions := "0000";
		constant op_addi : up_instructions := "0001";
		constant op_andi : up_instructions := "0010";
		constant op_ori  : up_instructions := "0011";
		constant op_slti : up_instructions := "0111";
		constant op_lui  : up_instructions := "1000";
		constant op_j    : up_instructions := "1010";
		constant op_beq  : up_instructions := "1100";
		constant op_bneq : up_instructions := "1101";
		constant op_lw   : up_instructions := "1110";
		constant op_sw   : up_instructions := "1111";
		
		constant op_add : up_RRR_instructions := "0001";
		constant op_sub : up_RRR_instructions := "0010";
		constant op_and : up_RRR_instructions := "0011";
		constant op_or  : up_RRR_instructions := "0100";
		constant op_slt : up_RRR_instructions := "0111";
		constant op_sll : up_RRR_instructions := "1100";
		constant op_srl : up_RRR_instructions := "1101";
		constant op_sra : up_RRR_instructions := "1110";
		constant op_mul : up_RRR_instructions := "1111";
		
end package;
---------------------------------------------------------------------------------------------

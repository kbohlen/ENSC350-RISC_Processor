library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ensc350_package.all;

entity instr_decode is
  port( idata_in : in std_logic_vector(instr_size-1 downto 0);
    Rs1 : out std_logic_vector(rf_addr_size-1 downto 0);
    Rs2 : out std_logic_vector(rf_addr_size-1 downto 0);
    Rd : out std_logic_vector(rf_addr_size-1 downto 0);
    
    alu_op : out alu_commands;
    mul_op : out mul_commands;
    mem_op : out mem_commands;
    pc_op : out pc_commands;
    
    immediate : out std_logic_vector(instr_size-13 downto 0);
    imm_sel : out operand_select;
    wb_sel : out wb_select );
end instr_decode;

architecture behavioral of instr_decode is

begin

  process(idata_in)
  begin
    Rd <= idata_in(instr_size-5 downto instr_size-8);
    Rs1 <= idata_in(instr_size-9 downto instr_size-12);
    Rs2 <= idata_in(instr_size-13 downto instr_size-16);
    
    imm_sel <= operand_immed;
    immediate <= idata_in(instr_size-13 downto 0);
    
    alu_op <= alu_add;
    mul_op <= mul_nop;
    mem_op <= mem_nop;
    pc_op <= pc_carryon;
    wb_sel <= wb_jal;
    
    if (idata_in(instr_size-1 downto instr_size-4) = op_RRR) then
      -- RRR = | 0000 (4-bits) | r1 (4 bits) | r2 (4 bits) | r3 (4-bits) | opcode (4-bits) |
      -- op_add := "0001" op_sub := "0010" op_and := "0011" op_or  := "0100" op_slt := "0101";
      -- op_sll := "1100" op_srl := "1101" op_sra := "1110" op_mul := "1111";
      imm_sel <= operand_rs2;
      if (idata_in(3 downto 0) = op_add) then
        alu_op <= alu_add;
        wb_sel <= wb_alu;
      elsif (idata_in(3 downto 0) = op_sub) then
        alu_op <= alu_sub;
        wb_sel <= wb_alu;
      elsif (idata_in(3 downto 0) = op_and) then
        alu_op <= alu_and;
        wb_sel <= wb_alu;
      elsif (idata_in(3 downto 0) = op_or) then
        alu_op <= alu_or;
        wb_sel <= wb_alu;
      elsif (idata_in(3 downto 0) = op_slt) then
        alu_op <= alu_slt;
        wb_sel <= wb_alu;
      elsif (idata_in(3 downto 0) = op_sll) then
        alu_op <= alu_sll;
        wb_sel <= wb_alu;
      elsif (idata_in(3 downto 0) = op_srl) then
        alu_op <= alu_srl;
        wb_sel <= wb_alu;
      elsif (idata_in(3 downto 0) = op_sra) then
        alu_op <= alu_sra;
        wb_sel <= wb_alu;
      elsif (idata_in(3 downto 0) = op_mul) then
        mul_op <= mul_mul;
        wb_sel <= wb_mul;
      end if;
        
    -- RRI = | primary opcode (4-bits) | r1 (4 bits) | r2 (4 bits) | 8-bit immediate |  
    -- op_RRR  := "0000" op_addi := "0001" op_andi := "0010" op_ori := "0011" op_slti := "0111" 
    -- op_lui  := "1000" op_j    := "1010"  op_beq := "1100" op_bneq:= "1101"; 
    -- op_lw   := "1110" op_sw   := "1111";    
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_addi) then
      alu_op <= alu_add;
      wb_sel <= wb_alu;
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_andi) then
      alu_op <= alu_and;
      wb_sel <= wb_alu;
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_ori) then
      alu_op <= alu_or;
      wb_sel <= wb_alu;
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_slti) then
      alu_op <= alu_slt;
      wb_sel <= wb_alu;
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_lui) then
      alu_op <= alu_lui;
      wb_sel <= wb_alu;
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_j) then
      pc_op <= pc_jump;
      rd <= (others=>'0');
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_beq) then
      alu_op <= alu_sub;
      pc_op <= pc_beq;
      rd <= (others=>'0');
      imm_sel <= operand_rs2;
      Rs1 <= idata_in(instr_size-5 downto instr_size-8);
      Rs2 <= idata_in(instr_size-9 downto instr_size-12);
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_bneq) then
      alu_op <= alu_sub; 
      pc_op <= pc_bneq;
      rd <= (others=>'0');
      imm_sel <= operand_rs2;
      Rs1 <= idata_in(instr_size-5 downto instr_size-8);
      Rs2 <= idata_in(instr_size-9 downto instr_size-12);      
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_lw) then 
      mem_op <= mem_lw;
      wb_sel <= wb_mem;
    elsif (idata_in(instr_size-1 downto instr_size-4) = op_sw) then --have to reconfigure ra and rb to pass to rfile
      Rs2 <= idata_in(instr_size-5 downto instr_size-8);
      mem_op <= mem_sw;
      wb_sel <= wb_mem;
    end if;
      
  end process;
  
end behavioral;
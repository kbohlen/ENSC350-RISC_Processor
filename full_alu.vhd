library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ensc350_package.all;

entity alu is
  port(in1 : in std_logic_vector(data_size-1 downto 0);
    in2 : in std_logic_vector(data_size-1 downto 0);
    immediate : in std_logic_vector((instr_size - 13) downto 0);
    imm_sel : in operand_select;
    alu_op : in alu_commands;
    condition : out std_logic;
    alu_out : out Std_logic_vector(data_size-1 downto 0));
end alu;  

architecture behavioral of alu is
  
  signal sum, diff : std_logic_vector(data_size-1 downto 0);
  signal cmp : std_logic_vector(data_size-1 downto 0);
  signal s1, s2 : std_logic_vector(data_size-1 downto 0);

begin
  
  s1 <= in1;
  s2 <= in2 when imm_sel = operand_rs2 else std_logic_vector(resize(signed(immediate), s2'length));  
  
  sum <= std_logic_vector(signed(s1) + signed(s2));
  diff <= std_logic_vector(signed(s2)-signed(s1));
  cmp(0) <= '1' when (signed(s1) < signed (s2)) else '0';
  cmp(data_size-1 downto 1) <= (others=>'0');

Condition_sig: condition <= '1' when signed(diff) = 0 else '0';

alu_mux : alu_out <= sum(data_size-1 downto 0) when alu_op=alu_add else
          diff(data_size-1 downto 0) when alu_op=alu_sub else
          cmp when alu_op=alu_slt else 
          s1 and s2 when alu_op=alu_and else
          s1 or s2 when alu_op=alu_or else
          s1 xor s2 when alu_op=alu_xor else
          s1 nor s2 when alu_op=alu_nor else
          std_logic_vector(shift_left(unsigned(s1), to_integer(unsigned(s2)) )) when alu_op=alu_sll else
          std_logic_vector(shift_right(unsigned(s1) , to_integer(unsigned(s2)) )) when alu_op=alu_srl else 
          std_logic_vector(shift_right(signed(s1) , to_integer(unsigned(s2)) ) )when alu_op=alu_sra else 
          s2(7 downto 0) & "00000000" when alu_op = alu_lui else
          (others=>'0');

end behavioral;

-------------------------------------------------------------------

entity mul is
  port(in1 : in std_logic_vector(data_size-1 downto 0);
    in2 : in std_logic_vector(data_size-1 downto 0);
    mul_op : in mul_commands;
    mul_out : out std_logic_vector(data_size-1 downto 0));
end mul;

architecture behavioral of mul is
  
  signal mul_temp : std_logic_vector(data_size*2-1 downto 0);
  
begin

  mul_temp <= std_logic_vector(signed(in1) * signed(in2)) when (mul_op = mul_mul) else (others=>'0');
  mul_out <= mul_temp(data_size-1 downto 0);
    
end behavioral;

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ensc350_package.all;

entity pc_calc is
    port ( clk, resetn, condition : in std_logic;
            pc_op : in pc_commands;								
			Rs1 : in std_logic_vector(data_size-1 downto 0); 								
			offset : in std_logic_vector(instr_size-13 downto 0); 
			iaddr_out : out std_logic_vector(iaddr_size-1 downto 0) );
end pc_calc;
	 
architecture behavioral of pc_calc is
  
 	signal curr_PC, next_PC, increment_1, increment_offset : std_logic_vector(iaddr_size-1 downto 0);
	
begin
  
 	--offset_resized <= offset(iaddr_size-1 downto 0);
	increment_1 <= std_logic_vector(unsigned(curr_PC) + 1);
	increment_offset <= std_logic_vector(signed(curr_PC) + signed(offset)); 
	
PC_MUX: process (increment_1, increment_offset, pc_op, condition, Rs1)

begin

	if pc_op = pc_carryon then
		next_PC <= increment_1;
	elsif pc_op = pc_beq then
		if condition = '1' then
			next_PC <= increment_offset;
		else
			next_PC <= increment_1;
		end if;
	elsif pc_op = pc_bneq then
		if condition = '0' then
			next_PC <= increment_offset;
		else
			next_PC <= increment_1;
		end if;
	elsif pc_op = pc_jump then
		next_PC <= Rs1(iaddr_size-1 downto 0);
	else
		next_PC <= (others=>'0');
	end if;
end process;


PROGRAM_COUNTER: process(clk, resetn)
begin
    if resetn='0' then 
      	curr_PC <= (others=>'1');
    else 
      	if clk'event and clk='1' then
        	curr_PC <= next_PC;
      	end if;
    end if;
end process;
  
  	iaddr_out <= next_pc; -- or is it curr_PC??
  
end behavioral;

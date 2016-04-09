library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ensc350_package.all;

entity mem_control is
  port( RS : in std_logic_vector(data_size-1 downto 0); 
    RB : in std_logic_vector(data_size-1 downto 0);
    RD_mem : out std_logic_vector(data_size-1 downto 0);
    offset : in std_logic_vector(instr_size-13 downto 0); -- the immediate
    ddata_in : in std_logic_vector(data_size-1 downto 0);
    ddata_out : out std_logic_vector(data_size-1 downto 0);
    daddr_out : out std_logic_vector(daddr_size-1 downto 0);
    mem_op : in mem_commands;
    MW : out std_logic;
    MR : out std_logic );
end mem_control;

architecture behavioral of mem_control is

  signal addr : std_logic_vector(data_size-1 downto 0);
  --signal resized : std_logic_vector(daddr_size-1 downto 0);

begin
  
  addr <= std_logic_vector(signed(RB) + signed(offset));
  daddr_out <= addr(daddr_size-1 downto 0);
  
  process(mem_op, ddata_in, RS)
  begin
    if (mem_op = mem_sw) then
      ddata_out <= RS;
      MW <= '1';
      MR <= '0';
    elsif (mem_op = mem_lw) then
      RD_mem <= ddata_in;
      MR <= '1';
      MW <= '0';
    else
      ddata_out <= (others => '0'); 
      MW <= '0';
      MR <= '0';
    end if;
  end process;
    
end behavioral;
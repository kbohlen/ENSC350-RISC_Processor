library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

use work.ensc350_package.all;

entity E is
end E;
architecture tb of E is

  component ensc350
	 port(  clk,resetn           : in  Std_logic;
			iaddr_out            : out Std_logic_vector(iaddr_size-1 downto 0);
			idata_in             : in  Std_logic_vector(instr_size-1 downto 0);
			daddr_out            : out Std_logic_vector(daddr_size-1 downto 0);
			dmem_read,dmem_write : out std_logic;
			ddata_in             : in  Std_logic_vector(data_size-1  downto 0);
			ddata_out            : out Std_logic_vector(data_size-1  downto 0));
  end component;
  
  constant half_period : time := 10 ns;
  constant size : positive := 16;
  signal clk,clkn,resetn    :  std_logic;
  signal iaddr_out          :  Std_logic_vector(iaddr_size-1 downto 0);
  signal daddr_out          :  Std_logic_vector(daddr_size-1 downto 0);
  signal idata_in           :  Std_logic_vector(instr_size-1 downto 0);
  signal ddata_in,ddata_out :  Std_logic_vector(data_size-1 downto 0);
  signal D_wen,D_ren,I_wen,I_ren : Std_logic;
  signal D_bitwen           : std_logic_vector(data_size-1 downto 0);               
  signal I_bitwen           : std_logic_vector(instr_size-1 downto 0);
  
begin
    IRAM : altsyncram
	GENERIC MAP ( clock_enable_input_a => "BYPASS",	clock_enable_output_a => "BYPASS",init_file => "imemory.mif",
		intended_device_family => "Cyclone IV GX", lpm_hint => "ENABLE_RUNTIME_MOD=NO",	lpm_type => "altsyncram",
		numwords_a => 2**iaddr_size, operation_mode => "SINGLE_PORT", outdata_aclr_a => "NONE",
		outdata_reg_a => "NONE", power_up_uninitialized => "FALSE", read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => iaddr_size, width_a => instr_size,	width_byteena_a => 1 )
	PORT MAP (	address_a=>iaddr_out, clock0=>clk, data_a=>idata_in, rden_a=>I_ren, wren_a=>I_wen, q_a=>idata_in);

	DRAM : altsyncram
	GENERIC MAP ( clock_enable_input_a => "BYPASS",	clock_enable_output_a => "BYPASS",init_file => "dmemory.mif",
		intended_device_family => "Cyclone IV GX", lpm_hint => "ENABLE_RUNTIME_MOD=NO",	lpm_type => "altsyncram",
		numwords_a => 2**daddr_size, operation_mode => "SINGLE_PORT", outdata_aclr_a => "NONE",
		outdata_reg_a => "NONE", power_up_uninitialized => "FALSE", read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => daddr_size, width_a => data_size,width_byteena_a => 1 )
	PORT MAP (	address_a=>daddr_out, clock0=>clkn, data_a=>ddata_out, rden_a=>D_ren, wren_a=>D_wen, q_a=>ddata_in);
	
	uut : ensc350 port map (clk, resetn,iaddr_out, idata_in, daddr_out,D_ren,D_wen,ddata_in, ddata_out );
			
	clkn <= not clk; I_wen <= '0'; I_ren <= '1';
	d_bitwen <= (others=>'1'); I_bitwen <= (others=>'0');
	
	clock: process -- clock signal, toggling between 0 and 1 with regular period
	begin 
	   clk <= '1';
		wait for half_period;
	   clk <= '0';
	   wait for half_period;
	   if daddr_out=x"f00" and ddata_out=x"1100" then wait; end if;
   	end process;
	
	reset: process   -- Keeping the circuit reset for 15 ns before starting computation
	begin
	  resetn <= '0';
	  wait for 15 ns;
	  resetn <= '1';
	  wait;
	end process; 
	
end tb;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ensc350_package.all;

entity ensc350 is
port( clk,resetn : in std_logic;
  iaddr_out : out std_logic_vector(iaddr_size-1 downto 0);
  idata_in : in std_logic_vector(instr_size-1 downto 0);
  daddr_out : out std_logic_vector(daddr_size-1 downto 0);
  dmem_read,dmem_write : out std_logic;
  ddata_in : in std_logic_vector(data_size-1 downto 0);
  ddata_out : out std_logic_vector(data_size-1 downto 0));
end ensc350;

architecture STRUCTURAL OF ensc350 IS

--component NAME
        --port statement just as it is in its own file
--end component;

component instr_decode
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
end component;

component rfile
  port( clk : in std_logic;
    resetn : in std_logic;
    ra : in std_logic_vector(rf_addr_size-1 downto 0);
    a_out : out std_logic_vector(data_size-1 downto 0);
    rb : in std_logic_vector(rf_addr_size-1 downto 0);
    b_out : out std_logic_vector(data_size-1 downto 0);
    rd1 : in std_logic_vector(rf_addr_size-1 downto 0);
    d1_in : in std_logic_vector(data_size-1 downto 0) );
end component;

component alu
  port(in1 : in std_logic_vector(data_size-1 downto 0);
    in2 : in std_logic_vector(data_size-1 downto 0);
    immediate : in std_logic_vector((instr_size - 13) downto 0);
    imm_sel : in operand_select;
    alu_op : in alu_commands;
    condition : out std_logic;
    alu_out : out Std_logic_vector(data_size-1 downto 0));
end component;  

component mul
  port(in1 : in std_logic_vector(data_size-1 downto 0);
    in2 : in std_logic_vector(data_size-1 downto 0);
    mul_op : in mul_commands;
    mul_out : out std_logic_vector(data_size-1 downto 0));
end component;

component mem_control
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
end component;

component pc_calc
  port( clk, resetn, condition : in std_logic;
	pc_op : in pc_commands;								
	Rs1 : in std_logic_vector(data_size-1 downto 0); 								
	offset : in std_logic_vector(instr_size-13 downto 0); 
	iaddr_out : out std_logic_vector(iaddr_size-1 downto 0) ); 
end component;


signal alu_op : alu_commands;
signal mul_op : mul_commands;
signal mem_op : mem_commands;
signal pc_op : pc_commands;
signal immediate : std_logic_vector(instr_size-13 downto 0);
signal imm_sel : operand_select;
signal wb_sel : wb_select;

signal ra : std_logic_vector(rf_addr_size-1 downto 0);
signal a_out : std_logic_vector(data_size-1 downto 0);
signal rb : std_logic_vector(rf_addr_size-1 downto 0);
signal b_out : std_logic_vector(data_size-1 downto 0);
signal rd : std_logic_vector(rf_addr_size-1 downto 0);
signal d_in : std_logic_vector(data_size-1 downto 0);
signal alu_out : std_logic_vector(data_size-1 downto 0);
signal mul_out : std_logic_vector(data_size-1 downto 0);

signal condition : std_logic;
signal mem_out : std_logic_vector(data_size-1 downto 0);


begin
    
--LABEL_NAME: NAME
  --port map(
  
  --);
  
DECODE: instr_decode port map( idata_in => idata_in,
	Rs1 => ra,
	Rs2 => rb,
	Rd => rd,
	alu_op => alu_op,
	mul_op => mul_op,
	mem_op => mem_op,
	pc_op => pc_op,
	immediate => immediate,
	imm_sel => imm_sel,
	wb_sel => wb_sel );

REG_FILE: rfile port map( clk => clk, 
  	resetn => resetn,
  	ra => ra,
  	a_out => a_out,
  	rb => rb,
  	b_out => b_out,
  	rd1 => rd,
  	d1_in  => d_in );
	
ALU_COMP: alu port map ( in1 => a_out,
  	in2 => b_out,
  	immediate => immediate,
  	imm_sel => imm_sel,
  	alu_op => alu_op,
  	condition => condition,
  	alu_out => alu_out );
 	
MUL_COMP: mul port map (in1 => a_out,
   	in2 => b_out,
   	mul_op => mul_op,
   	mul_out => mul_out);	
    
MEMORY: mem_control port map( RS => b_out,
	RB => a_out,
	RD_mem => mem_out,
	offset => immediate,
	ddata_in => ddata_in,
	ddata_out => ddata_out,
	daddr_out => daddr_out,
	mem_op => mem_op,
	MW => dmem_write,
	MR => dmem_read );
    
PROGRAMCOUNTER: pc_calc port map( clk => clk, 
  	resetn => resetn,
	condition => condition,
	pc_op => pc_op,
	Rs1 => a_out,
	offset => immediate,
	iaddr_out => iaddr_out );
    
WB_MUX: d_in <= mem_out when (wb_sel = wb_mem) else
                alu_out when (wb_sel = wb_alu) else 
                mul_out when (wb_sel = wb_mul) else
                (others => '0');

end STRUCTURAL;

library ieee;
use ieee.std_logic_1164.all;

entity segment7_conv is
port (  D : in std_logic_vector(3 downto 0);  -- HEX input
        O : out std_logic_vector(6 downto 0)  -- 7 bit decoded output.
     );
end segment7_conv;

architecture Behavioral of segment7_conv is

begin
PROCESS (D)
		BEGIN
			CASE D IS
				WHEN "0000"=> O<="1000000";
				WHEN "0001"=> O<="1111001";
				WHEN "0010"=> O<="0100100";
				WHEN "0011"=> O<="0110000";
				WHEN "0100"=> O<="0011001";
				WHEN "0101"=> O<="0010010";
				WHEN "0110"=> O<="0000010";
				WHEN "0111"=> O<="1111000";
				WHEN "1000"=> O<="0000000";
				WHEN "1001"=> O<="0010000";
				WHEN "1010"=> O<="0001000";
				WHEN "1011"=> O<="0000011";
				WHEN "1100"=> O<="1000110";
				WHEN "1101"=> O<="0100001";
				WHEN "1110"=> O<="0000110";
				WHEN "1111"=> O<="0001110";
				WHEN OTHERS=> O<="1111111";
			END CASE;
	END PROCESS;
 

end Behavioral;
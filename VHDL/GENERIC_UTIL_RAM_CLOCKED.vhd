----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:47:52 06/05/2017 
-- Design Name: 
-- Module Name:    GENERIC_UTIL_RAM_CLOCKED - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.VECTOR_STANDARD.ALL;

entity GENERIC_UTIL_RAM_CLOCKED is
	 Generic (N : natural := VecLen);
    Port ( RW : in  STD_LOGIC; 
			  --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
			  --Reading is only enhabled if Data is latched with (others => 'Z')
           Data : inout  STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
			  CLK : in STD_LOGIC);
end GENERIC_UTIL_RAM_CLOCKED;

architecture Behavioral of GENERIC_UTIL_RAM_CLOCKED is

constant ImpedeInternal : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => 'Z');
signal DataInternal : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');

begin

process(CLK)
begin
	if (rising_edge(CLK)) then
		if (RW = '1') then
			DataInternal <= Data;
			Data <= ImpedeInternal;
		elsif ((RW = '0') and ((Data = DataInternal) or (Data = ImpedeInternal))) then
			Data <= DataInternal;
		else
			Data <= ImpedeInternal;
		end if;
	end if;
end process;

end Behavioral;


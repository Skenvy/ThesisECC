----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:10:39 03/24/2017 
-- Design Name: 
-- Module Name:    STRUC_UTIL_RAM_256 - Behavioral 
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

entity STRUC_UTIL_RAM_256 is
	 Generic (N : natural := VecLen);
    Port ( RW : in  STD_LOGIC;
           Data : inout  STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
			  CLK : in STD_LOGIC);
end STRUC_UTIL_RAM_256;

architecture Behavioral of STRUC_UTIL_RAM_256 is

signal DataInternal : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;

begin

process(CLK)
begin
	if (rising_edge(CLK)) then
		if (RW = '1') then
			DataInternal <= Data;
			Data <= ImpedeVector;
		elsif ((RW = '0') and ((Data = DataInternal) or (Data = ImpedeVector))) then
			Data <= DataInternal;
		else
			Data <= ImpedeVector;
		end if;
	end if;
end process;

end Behavioral;


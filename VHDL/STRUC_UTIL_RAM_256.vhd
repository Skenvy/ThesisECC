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
    Port ( WE : in  STD_LOGIC;
			  RE : in  STD_LOGIC;
           Data : inout  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_UTIL_RAM_256;

architecture Behavioral of STRUC_UTIL_RAM_256 is

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

signal DataInternal : STD_LOGIC_VECTOR (255 downto 0);

begin

Data <= (others => 'Z') when (((WE = '1') or (RE = '0')) or ((WE = '0') and (RE = '1') and (not(Data = DataInternal)) and (not(Data = ImpedeVector)))) else DataInternal;

process(WE)
begin
	if rising_edge(WE) then
		DataInternal <= Data;
	end if;
end process;

end Behavioral;


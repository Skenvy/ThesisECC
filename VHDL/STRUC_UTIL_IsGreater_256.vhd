----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:48:43 03/13/2017 
-- Design Name: 
-- Module Name:    Utility_IsGreater_256 - Behavioral 
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
entity STRUC_UTIL_IsGreater_256 is
    Port ( A : in  STD_LOGIC_VECTOR (255 downto 0);
           B : in  STD_LOGIC_VECTOR (255 downto 0);
           IsGreater : out  STD_LOGIC); 
			  --1 iff A > B, else 0
end STRUC_UTIL_IsGreater_256;
architecture Behavioral of STRUC_UTIL_IsGreater_256 is
begin
IsGreater <= '1' when (A > B) else '0';
end Behavioral;


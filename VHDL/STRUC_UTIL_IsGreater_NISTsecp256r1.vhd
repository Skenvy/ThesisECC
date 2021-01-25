----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:04:03 03/13/2017 
-- Design Name: 
-- Module Name:    Utility_IsGreaterThan_NISTsecp256r1P - Behavioral 
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
use work.ECC_STANDARD.ALL;
entity STRUC_UTIL_IsGreater_NISTsecp256r1 is
    Port ( InVal : in  STD_LOGIC_VECTOR (256 downto 0);
           IsGreater : out  STD_LOGIC); 
			  --1 iff InVal > Prime, else 0
end STRUC_UTIL_IsGreater_NISTsecp256r1;
architecture Behavioral of STRUC_UTIL_IsGreater_NISTsecp256r1 is
constant Prime : STD_LOGIC_VECTOR (256 downto 0) := "0" & SECp256r1(0);
begin
IsGreater <= '1' when (InVal > Prime) else '0';
end Behavioral;


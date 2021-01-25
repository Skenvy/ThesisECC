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

entity STRUC_UTIL_IsGreater_NISTsecp256r1 is
    Port ( InVal : in  STD_LOGIC_VECTOR (256 downto 0);
           IsGreater : out  STD_LOGIC); --1 iff InVal > Prime, else 0
end STRUC_UTIL_IsGreater_NISTsecp256r1;

--Stub Entity: Currently implemented behaviourally, left to make structural.
architecture Behavioral of STRUC_UTIL_IsGreater_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (256 downto 0) := "0" & X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";

begin

IsGreater <= '1' when (InVal > Prime) else '0';

end Behavioral;


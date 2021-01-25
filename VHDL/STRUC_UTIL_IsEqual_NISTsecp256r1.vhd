----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:04:40 03/13/2017 
-- Design Name: 
-- Module Name:    Utility_IsEqualTo_NISTsecp256r1P - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Utility_IsEqualTo_NISTsecp256r1P
entity STRUC_UTIL_IsEqual_NISTsecp256r1 is
    Port ( InVal : in  STD_LOGIC_VECTOR (256 downto 0);
           IsEqual : out  STD_LOGIC); --1 iff InVal = Prime, else 0
end STRUC_UTIL_IsEqual_NISTsecp256r1;

--Stub Entity: Currently implemented behaviourally, left to make structural.
architecture Behavioral of STRUC_UTIL_IsEqual_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (256 downto 0) := "0" & X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";

begin

IsEqual <= '1' when (InVal = Prime) else '0';

end Behavioral;


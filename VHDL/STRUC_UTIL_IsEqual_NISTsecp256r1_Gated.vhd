----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:34 03/22/2017 
-- Design Name: 
-- Module Name:    STRUC_UTIL_IsEqual_NISTsecp256r1_Gated - Behavioral 
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

entity STRUC_UTIL_IsEqual_NISTsecp256r1_Gated is
    Port ( InVal : in  STD_LOGIC_VECTOR (256 downto 0);
           IsEqual : out  STD_LOGIC);
end STRUC_UTIL_IsEqual_NISTsecp256r1_Gated;

architecture Behavioral of STRUC_UTIL_IsEqual_NISTsecp256r1_Gated is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (256 downto 0) := "0" & X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";

begin



end Behavioral;


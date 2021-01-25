----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:47:09 03/13/2017 
-- Design Name: 
-- Module Name:    Utility_IsEqual_256 - Behavioral 
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

--Utility_IsEqual_256
entity STRUC_UTIL_IsEqual_256 is
    Port ( A : in  STD_LOGIC_VECTOR (255 downto 0);
           B : in  STD_LOGIC_VECTOR (255 downto 0);
           IsEqual : out  STD_LOGIC); --1 iff A = B, else 0
end STRUC_UTIL_IsEqual_256;

--Stub Entity: Currently implemented behaviourally, left to make structural.
architecture Behavioral of STRUC_UTIL_IsEqual_256 is

begin

IsEqual <= '1' when (A = B) else '0';

end Behavioral;

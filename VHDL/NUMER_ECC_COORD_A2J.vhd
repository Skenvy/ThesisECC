----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:46:29 03/23/2017 
-- Design Name: 
-- Module Name:    NUMER_ECC_COORD_A2J - Behavioral 
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

entity NUMER_ECC_COORD_A2J is
    Port ( PY : in  STD_LOGIC_VECTOR (255 downto 0);
           PX : in  STD_LOGIC_VECTOR (255 downto 0);
           QY : out  STD_LOGIC_VECTOR (255 downto 0);
           QX : out  STD_LOGIC_VECTOR (255 downto 0);
           QZ : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_ECC_COORD_A2J;

architecture Behavioral of NUMER_ECC_COORD_A2J is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

constant UnitVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";

begin

QX <= PX;
QY <= PY;
QZ <= UnitVector;

end Behavioral;


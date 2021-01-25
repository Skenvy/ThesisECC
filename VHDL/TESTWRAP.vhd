----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:52:10 03/23/2017 
-- Design Name: 
-- Module Name:    TESTWRAP - Behavioral 
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

entity TESTWRAP is
    Port ( ThisIn : in  STD_LOGIC;
           ThisOut : out  STD_LOGIC);
end TESTWRAP;

architecture Behavioral of TESTWRAP is

component NUMER_ECC_POINT_ADDITION_J1J2J is
    Port ( AX : in  STD_LOGIC_VECTOR (255 downto 0);
           AY : in  STD_LOGIC_VECTOR (255 downto 0);
           AZ : in  STD_LOGIC_VECTOR (255 downto 0);
           BX : in  STD_LOGIC_VECTOR (255 downto 0);
           BY : in  STD_LOGIC_VECTOR (255 downto 0);
           BZ : in  STD_LOGIC_VECTOR (255 downto 0);
           CX : out  STD_LOGIC_VECTOR (255 downto 0);
           CY : out  STD_LOGIC_VECTOR (255 downto 0);
           CZ : out  STD_LOGIC_VECTOR (255 downto 0));
end component;

component NUMER_ECC_POINT_DOUBLING_J2J is
    Port ( AX : in  STD_LOGIC_VECTOR (255 downto 0);
           AY : in  STD_LOGIC_VECTOR (255 downto 0);
           AZ : in  STD_LOGIC_VECTOR (255 downto 0);
           CX : out  STD_LOGIC_VECTOR (255 downto 0);
           CY : out  STD_LOGIC_VECTOR (255 downto 0);
           CZ : out  STD_LOGIC_VECTOR (255 downto 0));
end component;

signal a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p : STD_LOGIC_VECTOR (255 downto 0);

begin

ThisOb1 : NUMER_ECC_POINT_ADDITION_J1J2J port map (a, b, c, d, e, f, g, h, i);
ThisOb2 : NUMER_ECC_POINT_DOUBLING_J2J port map (j, k, l, m, n, o);

p <= g and h and i and m and n and o;

end Behavioral;


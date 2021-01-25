----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:49:00 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_RELATIONAL - Behavioral 
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

entity GENERIC_FAP_RELATIONAL is
	 Generic (N : Natural := VecLen;
				 VType : Natural := 1); --0 for just equality, 1 for Greater Than test : Default 1
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC;
           G : out  STD_LOGIC);
end GENERIC_FAP_RELATIONAL;

architecture Behavioral of GENERIC_FAP_RELATIONAL is

component GENERIC_FAP_INEQUALITY_OUTER
	 Generic (N : natural);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           G : out  STD_LOGIC;
			  E : out  STD_LOGIC);
end component;

component GENERIC_FAP_EQUALITY
	 Generic (N : natural);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC);
end component;

begin

EquiaGen : if (VType = 0) generate --make a copy of the equality checker
begin
	X : GENERIC_FAP_EQUALITY
		generic map (N => N)
		port map (A => A, B => B, E => E);
	G <= '0';
end generate EquiaGen;

GreatGen : if (VType = 1) generate --make a copy of the inequality checker
begin
	X : GENERIC_FAP_INEQUALITY_OUTER
		generic map (N => N)
		port map (A => A, B => B, G => G, E => E);
end generate GreatGen;

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:37:08 05/08/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_INEQUALITY_INNER - Behavioral 
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

entity GENERIC_FAP_INEQUALITY_INNER is
	 Generic (N : natural := VecLen); --
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           EquiAbove : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           G : out  STD_LOGIC);
end GENERIC_FAP_INEQUALITY_INNER;

architecture Behavioral of GENERIC_FAP_INEQUALITY_INNER is

component GENERIC_FAP_INEQUALITY_INNER
	 Generic (N : natural := VecLen); --
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           EquiAbove : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           G : out  STD_LOGIC);
end component;

signal GBit : STD_LOGIC;

begin

terminal_structure_1 : if (N = 1) generate
begin
	G <= (A(0) and (not B(0)));
end generate terminal_structure_1;

terminal_structure_2 : if (N = 2) generate
begin
	G <= (((A(0) and (not B(0))) and EquiAbove(1)) or ((A(1) and (not B(1)))));
end generate terminal_structure_2;

terminal_structure_3 : if (N = 3) generate
begin
	G <= (((A(0) and (not B(0))) and EquiAbove(1)) or ((A(1) and (not B(1))) and EquiAbove(2)) or ((A(2) and (not B(2)))));
end generate terminal_structure_3;

recursive_structure : if (N > 3) generate
begin
	GFIII : GENERIC_FAP_INEQUALITY_INNER
		generic map (N  => (N-3))
		port map (A => A((N-1) downto 3), 
					 B => B((N-1) downto 3),
					 EquiAbove => EquiAbove((N-1) downto 3),
					 G => GBit);
		G <= (((A(0) and (not B(0))) and EquiAbove(1)) or ((A(1) and (not B(1))) and EquiAbove(2)) or ((A(2) and (not B(2))) and EquiAbove(3)) or GBit);
	end generate recursive_structure;

end Behavioral;


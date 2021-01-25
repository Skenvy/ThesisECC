----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:50:20 05/08/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_INEQUALITY - Behavioral 
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

entity GENERIC_FAP_INEQUALITY is
	 Generic (N : natural := VecLen); --
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           G : out  STD_LOGIC);
end GENERIC_FAP_INEQUALITY;

architecture Behavioral of GENERIC_FAP_INEQUALITY is

component GENERIC_FAP_EQUALITY
	generic (N : natural);
	port (A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
         B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
         E : out  STD_LOGIC);
end component;

component GENERIC_FAP_INEQUALITY
	generic (N : natural);
	port (A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
         B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
         G : out  STD_LOGIC);
end component;

signal GRBits : STD_LOGIC_VECTOR (1 downto 0);

begin

terminal_structure_1 : if (N = 1) generate
begin
	G <= (A(0) and (not B(0)));
end generate terminal_structure_1;

terminal_structure_2 : if (N = 2) generate
begin
	G <= (((A(0) and (not B(0))) and (A(1) xnor B(1))) or ((A(1) and (not B(1)))));
end generate terminal_structure_2;

terminal_structure_3 : if (N = 3) generate
begin
	G <= (((A(0) and (not B(0))) and (A(1) xnor B(1)) and (A(2) xnor B(2))) or ((A(1) and (not B(1))) and (A(2) xnor B(2))) or ((A(2) and (not B(2)))));
end generate terminal_structure_3;

recursive_structure : if (N > 3) generate
begin
	GFE_RS : GENERIC_FAP_EQUALITY
		generic map (N  => (N-3))
		port map (A => A((N-1) downto 3), 
					 B => B((N-1) downto 3),
					 E => GRBits(0));
	GFI_RS : GENERIC_FAP_INEQUALITY
		generic map (N  => (N-3))
		port map (A => A((N-1) downto 3), 
					 B => B((N-1) downto 3), 
					 G => GRBits(1));
	G <= (((A(0) and (not B(0))) and (A(1) xnor B(1)) and (A(2) xnor B(2)) and GRBits(0)) or ((A(1) and (not B(1))) and (A(2) xnor B(2)) and GRBits(0)) or ((A(2) and (not B(2))) and GRBits(0))) or GRBits(1);
	--G <= (((A(0) and (not B(0))) and (A(1) xnor B(1))  and GRBits(0)) or ((A(1) and (not B(1)) and GRBits(0)))) or GRBits(1);
	--G <= (((A(0) and (not B(0)))) and GRBits(0)) or GRBits(1);	 
end generate recursive_structure;

end Behavioral;


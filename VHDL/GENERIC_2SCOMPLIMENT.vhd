----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:10:46 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_2SCOMPLIMENT - Behavioral 
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

entity GENERIC_2SCOMPLIMENT is
	 Generic (N : natural := VecLen);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           C : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end GENERIC_2SCOMPLIMENT;

architecture Behavioral of GENERIC_2SCOMPLIMENT is

component GENERIC_FAP_LINADDRMUX
	 Generic (N : natural);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           S : out  STD_LOGIC_VECTOR (N downto 0));
end component;

signal CTemp : STD_LOGIC_VECTOR (N downto 0);
signal AINV : STD_LOGIC_VECTOR ((N-1) downto 0);

begin

AINV <= (not A);

X : GENERIC_FAP_LINADDRMUX
		Generic map (N => N)
		Port map ( A => AINV,
					  B => UnitVector,
					  S => CTemp);

C <= CTemp((N-1) downto 0);

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:23:52 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODSUBT - Behavioral 
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

entity GENERIC_FAP_MODSUBT is
    Generic (N : natural := VecLen);
    Port ( Minuend : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Subtrahend : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0); --Modulo.
           Difference : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end GENERIC_FAP_MODSUBT;

architecture Behavioral of GENERIC_FAP_MODSUBT is

component GENERIC_FAP_LINADDRMUX
	 Generic (N : natural);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           S : out  STD_LOGIC_VECTOR (N downto 0));
end component;

component GENERIC_FAP_RELATIONAL
	 Generic (N : Natural;
				 VType : Natural); --0 for just equality, 1 for Greater Than test : Default 1
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC;
           G : out  STD_LOGIC);
end component;

component GENERIC_2SCOMPLIMENT
	 Generic (N : natural);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           C : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end component;

signal SubtrahendInv : STD_LOGIC_VECTOR ((N-1) downto 0);
signal FinalIn : STD_LOGIC_VECTOR ((N-1) downto 0);
signal Equia : STD_LOGIC;
signal Great : STD_LOGIC;
signal MinuendAndModulus : STD_LOGIC_VECTOR (N downto 0);
signal DInternal : STD_LOGIC_VECTOR (N downto 0);

begin

InvOfSubtrahend : GENERIC_2SCOMPLIMENT
	 Generic map (N => N)
    Port map ( A => Subtrahend,
					C => SubtrahendInv);

Relator : GENERIC_FAP_RELATIONAL
	 Generic map (N => N,
					  VType => 1)
    Port map ( A => Minuend,
					B => Subtrahend,
					E => Equia,
					G => Great);

MinandSubtrMap : GENERIC_FAP_LINADDRMUX
	 Generic map (N => N)
    Port  map ( A => Minuend,
					 B => Modulus,
					 S => MinuendAndModulus);

FinalsGen : for K in 0 to (N-1) generate
begin
	FinalIn(K) <= (Equia and Subtrahend(K)) or (Great and Minuend(K)) or ((not Equia) and (not Great) and MinuendAndModulus(K));
end generate FinalsGen;

MinsubSubtrMap : GENERIC_FAP_LINADDRMUX
	 Generic map (N => N)
    Port  map ( A => FinalIn,
					 B => SubtrahendInv,
					 S => DInternal);

Difference <= DInternal((N-1) downto 0);

end Behavioral;


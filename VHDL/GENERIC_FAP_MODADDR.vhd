----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:05:37 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODADDR - Behavioral 
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

entity GENERIC_FAP_MODADDR is
	 Generic (N : natural := VecLen;
				 M : natural := MultLen); --Terminal Length
    Port ( SummandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           SummandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0); --Modulo.
           Summation : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end GENERIC_FAP_MODADDR;

architecture Behavioral of GENERIC_FAP_MODADDR is

component GENERIC_FAP_LINADDRMUX
	 Generic (N : natural;
				 M : natural := MultLen); --Terminal Length
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

signal MInv : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MRel : STD_LOGIC_VECTOR (N downto 0);
signal AandB : STD_LOGIC_VECTOR (N downto 0);
signal AandBClipped : STD_LOGIC_VECTOR ((N-1) downto 0);
signal FinalIn : STD_LOGIC_VECTOR ((N-1) downto 0);
signal Equia : STD_LOGIC;
signal Great : STD_LOGIC;
signal SInternal : STD_LOGIC_VECTOR (N downto 0);

begin

InvOfModulus : GENERIC_2SCOMPLIMENT
	 Generic map (N => N)
    Port map ( A => Modulus,
					C => MInv);

AandBMap : GENERIC_FAP_LINADDRMUX
	 Generic map (N => N, M => M)
    Port  map ( A => SummandA,
					 B => SummandB,
					 S => AandB);

MRel <= '0' & Modulus;

Relator : GENERIC_FAP_RELATIONAL
	 Generic map (N => (N+1),
					  VType => 1)
    Port map ( A => AandB,
					B => MRel,
					E => Equia,
					G => Great);
					
FinalsGen : for K in 0 to (N-1) generate
begin
	FinalIn(K) <= ((Equia or Great) and MInv(K));
end generate FinalsGen;

AandBClipped <= AandB(N-1 downto 0);

ModAddr : GENERIC_FAP_LINADDRMUX
	 Generic map (N => N, M => M)
    Port  map ( A => AandBClipped,
					 B => FinalIn,
					 S => SInternal);
					 
Summation <= SInternal((N-1) downto 0);

end Behavioral;


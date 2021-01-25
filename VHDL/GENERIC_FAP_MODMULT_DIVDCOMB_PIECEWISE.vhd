----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:49:56 05/23/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_DIVDCOMB_PIECEWISE - Behavioral 
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

entity GENERIC_FAP_MODMULT_DIVDCOMB_PIECEWISE is
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen);
    Port ( ValueIn : in  STD_LOGIC_VECTOR (N downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           ValueModded : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           SubbedByM : out  STD_LOGIC;
           SubbedBy2M : out  STD_LOGIC;
           SubbedBy3M : out  STD_LOGIC);
end GENERIC_FAP_MODMULT_DIVDCOMB_PIECEWISE;

architecture Behavioral of GENERIC_FAP_MODMULT_DIVDCOMB_PIECEWISE is

component GENERIC_FAP_LINADDRMUX
	 Generic (N : natural;
				 M : natural);
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

signal ModulusOnce : STD_LOGIC_VECTOR (N downto 0);
signal ModulusTwice : STD_LOGIC_VECTOR (N downto 0);
signal ModulusThrice : STD_LOGIC_VECTOR ((N+1) downto 0); --If ModulusThrice(N+1) is 1 then this exceeds the range of the value in and SubbedBy3M is impossible.
signal ModulusOnceInv : STD_LOGIC_VECTOR (N downto 0);
signal ModulusTwiceInv : STD_LOGIC_VECTOR (N downto 0);
signal ModulusThriceInv : STD_LOGIC_VECTOR (N downto 0);
signal WasSubbedByM : STD_LOGIC;
signal WasSubbedBy2M : STD_LOGIC;
signal WasSubbedBy3M : STD_LOGIC;
signal Equia : STD_LOGIC_VECTOR (3 downto 0);
signal Great : STD_LOGIC_VECTOR (3 downto 0);
signal MODIN : STD_LOGIC_VECTOR (N downto 0);
signal MODOUT : STD_LOGIC_VECTOR ((N+1) downto 0);

begin

--Construct the three multiples of the Modulus to be compared to
ModulusOnce <= '0' & Modulus;
ModulusTwice <= Modulus & '0';
TripleModulus : GENERIC_FAP_LINADDRMUX
	Generic Map (N => (N+1),
					 M => M)
   Port Map ( A => ModulusOnce,
				  B => ModulusTwice,
				  S => ModulusThrice);
--Perform the comparisons on the three Modular multiples.
CompareOnce : GENERIC_FAP_RELATIONAL
	Generic Map (N => (N+1),
					 VType => 1) --0 for just equality, 1 for Greater Than test
   Port Map ( A => ValueIn,
				  B => ModulusOnce,
				  E => Equia(0),
				  G => Great(0));
CompareTwice : GENERIC_FAP_RELATIONAL
	Generic Map (N => (N+1),
					 VType => 1) --0 for just equality, 1 for Greater Than test
   Port Map ( A => ValueIn,
				  B => ModulusTwice,
				  E => Equia(1),
				  G => Great(1));
CompareThrice : GENERIC_FAP_RELATIONAL
	Generic Map (N => (N+1),
					 VType => 1) --0 for just equality, 1 for Greater Than test
   Port Map ( A => ValueIn,
				  B => ModulusThrice(N downto 0),
				  E => Equia(3),
				  G => Great(3));
--Buffer the actual Equia and Great for the 3*M check with whether the top bit is on or off;
Equia(2) <= (Equia(3) and (not ModulusThrice(N+1)));
Great(2) <= (Great(3) and (not ModulusThrice(N+1)));
--Universally compliment all three modular multiples
ComplimentOnce : GENERIC_2SCOMPLIMENT
	 Generic Map (N => (N+1))
    Port Map ( A => ModulusOnce,
               C => ModulusOnceInv);
ComplimentTwice : GENERIC_2SCOMPLIMENT
	 Generic Map (N => (N+1))
    Port Map ( A => ModulusTwice,
               C => ModulusTwiceInv);
ComplimentThrice : GENERIC_2SCOMPLIMENT
	 Generic Map (N => (N+1))
    Port Map ( A => ModulusThrice(N downto 0),
               C => ModulusThriceInv);
--Determine the 'Was Subbed By' outputs
WasSubbedByM <= ((Equia(0) or Great(0)) and (not WasSubbedBy2M) and (not WasSubbedBy3M));
WasSubbedBy2M <= ((Equia(1) or Great(1)) and (not WasSubbedBy3M));
WasSubbedBy3M <= (Equia(2) or Great(2));
--Determine the appropriate modular multiple from knowing the 'Equia' and 'Great' relations.
MODINGEN : for K in 0 to N generate
begin
	MODIN(K) <= ((ModulusOnceInv(K) and WasSubbedByM) or (ModulusTwiceInv(K) and WasSubbedBy2M) or (ModulusThriceInv(K) and WasSubbedBy3M));
end generate MODINGEN;
--Add the modular inverse for the apprpriate modular multiple
ModAddr : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => (N+1),
					  M => M)
    Port Map ( A => MODIN,
				   B => ValueIn,
					S => MODOUT);
--Put on the output
ValueModded <= MODOUT((N-1) downto 0);
SubbedByM <= WasSubbedByM;
SubbedBy2M <= WasSubbedBy2M;
SubbedBy3M <= WasSubbedBy3M;

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:18:05 03/14/2017 
-- Design Name: 
-- Module Name:    Subtraction_Modulo_256 - Behavioral 
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

--Subtraction_Modulo_256
entity STRUC_FAP_MOD_SUBT_NISTsecp256r1 is
    Port ( Minuend : in  STD_LOGIC_VECTOR (255 downto 0); --Assumed to be less than the prime, not tested
           Subtrahend : in  STD_LOGIC_VECTOR (255 downto 0); --Assumed to be less than the prime, not tested
           Difference : out  STD_LOGIC_VECTOR (255 downto 0)); --(Minuend - Subtrahend = Difference)
end STRUC_FAP_MOD_SUBT_NISTsecp256r1;

architecture Behavioral of STRUC_FAP_MOD_SUBT_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
--The 2's Compliment of the NIST-secp256r1-Prime
constant PrimeInverse : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
--A 256 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--256 Bit Adder
component STRUC_FAP_LIN_ADDR_RCAKS_256
	port( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
         Summation : out  STD_LOGIC_VECTOR (256 downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

--256 bit "Greater Than" Check (Included as component for future implementation as a structural unit, currently implemented behaviourally)
component STRUC_UTIL_IsGreater_256
	port( A : in  STD_LOGIC_VECTOR (255 downto 0);
         B : in  STD_LOGIC_VECTOR (255 downto 0);
         IsGreater : out  STD_LOGIC --1 iff A > B, else 0
		);
end component;

--256 bit "Equal To" Check (Included as component for future implementation as a structural unit, currently implemented behaviourally)
component STRUC_UTIL_IsEqual_256
	port( A : in  STD_LOGIC_VECTOR (255 downto 0);
         B : in  STD_LOGIC_VECTOR (255 downto 0);
         IsEqual : out  STD_LOGIC --1 iff A = B, else 0
		);
end component;

--256 bit 2's Complimenter (Included as component for future implementation as a structural unit, currently implemented semi-behaviourally)
component STRUC_UTIL_2sCompliment_256
	port( InVal : in  STD_LOGIC_VECTOR (255 downto 0);
         InComplimented : out  STD_LOGIC_VECTOR (255 downto 0)
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Carries the Sum of the Minuend and the Inverse of the Subtrahend
signal AandBInv : STD_LOGIC_VECTOR (256 downto 0);
--Carries the Sum of the Prime and the Inverse of the Subtrahend
signal PandBInv : STD_LOGIC_VECTOR (256 downto 0);
--Carries the Sum of the Minuend with the Sum of the Prime and the Inverse of the Subtrahend
signal AandPandBInv : STD_LOGIC_VECTOR (256 downto 0);
--Carries the result of the "equals when else" case select that determines what the output should be based on the 'GreaterThan' and 'EqualTo' checks.
signal InputToModulus : STD_LOGIC_VECTOR (256 downto 0);
--Carries the output of the 'IsGreater' Component
signal AGreaterThanB : STD_LOGIC;
--Carries the output of the 'IsEqual' Component
signal AEqualB : STD_LOGIC;
--Carries the output of the "2's Compliment" Component
signal SubtrahendInverted : STD_LOGIC_VECTOR (255 downto 0);
--Attaches to the 256'th bit of the Summation output from "ADDR256_Difference" as this cannot be left open.
signal wastageBit : STD_LOGIC;

begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

--If this cell's IsEqual is on, the subtractor's output is the zerovector constant
UTIL_IsEqual : STRUC_UTIL_IsEqual_256 port map (A(255 downto 0) => Minuend(255 downto 0),
														   B(255 downto 0) => Subtrahend(255 downto 0),
														   IsEqual => AEqualB);

--Computes the 2's Compliment of the Subtrahend.
SubtrahendInvertedCell : STRUC_UTIL_2sCompliment_256 port map (InVal(255 downto 0) => Subtrahend(255 downto 0),
															  InComplimented(255 downto 0) => SubtrahendInverted(255 downto 0));

--If the minuend is greater than the subtrahend, add 2's Compliment (Subtrahend) to the Minuend
--If the minuend is not greater than the subtrahend, replace the Subtrahend with "PandBinv"
UTIL_IsGreat : STRUC_UTIL_IsGreater_256 port map (A(255 downto 0) => Minuend(255 downto 0),
														     B(255 downto 0) => Subtrahend(255 downto 0),
														     IsGreater => AGreaterThanB);
---------------------------
--256 Bit Adder Port Maps--
---------------------------

--The result of AandBInv is only valid when AGreaterThanB, no need to mod. If A is greater than B, then only this adder's delay counts, along with the final adder's delay.
ADDR256_AandBInv : STRUC_FAP_LIN_ADDR_RCAKS_256 port map (SummandA(255 downto 0) => Minuend(255 downto 0),
													   SummandB(255 downto 0) => SubtrahendInverted(255 downto 0),
													   Summation(256 downto 0) => AandBInv(256 downto 0));

--If A is less than B, we need ((P+A)-B) > 0; or, (A+(P+(-B))). If A is less than B, two adder's delay is counted before the final adder; "PandBInv" and "AandPandBInv".
ADDR256_PandBInv : STRUC_FAP_LIN_ADDR_RCAKS_256 port map (SummandA(255 downto 0) => Prime(255 downto 0),
													   SummandB(255 downto 0) => SubtrahendInverted(255 downto 0),
													   Summation(256 downto 0) => PandBInv(256 downto 0));
														
ADDR256_AandPandBInv : STRUC_FAP_LIN_ADDR_RCAKS_256 port map (SummandA(255 downto 0) => Minuend(255 downto 0),
													       SummandB(255 downto 0) => PandBInv(255 downto 0),
													       Summation(256 downto 0) => AandPandBInv(256 downto 0));

--Sums either the result of "AandBInv" or "AandPandBInv" with the constant zerovector.
ADDR256_Difference : STRUC_FAP_LIN_ADDR_RCAKS_256 port map (SummandA(255 downto 0) => InputToModulus(255 downto 0), 
													     SummandB(255 downto 0) => ZeroVector(255 downto 0), 
													     Summation(255 downto 0) => Difference(255 downto 0),
														  Summation(256) => wastageBit);

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

--------------------------------
--Equals When Else Case Select--
--------------------------------

--Determines what to input to the final adder, "ADDR256_Difference"
InputToModulus(255 downto 0) <= ZeroVector(255 downto 0) when AEqualB = '1' else
									 AandBInv(255 downto 0) when AGreaterThanB = '1' else
									 AandPandBInv(255 downto 0) when ((AEqualB = '0') and (AGreaterThanB = '0')) else
									 ZeroVector;

end Behavioral;


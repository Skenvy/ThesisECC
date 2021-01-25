----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:51 03/27/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAP_SUBT - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use work.VECTOR_STANDARD.ALL;
use work.ECC_STANDARD.ALL;

entity EXAMPLE_M17_FAP_SUBT is
	port( Minuend : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Subtrahend : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Difference : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end EXAMPLE_M17_FAP_SUBT;

architecture Behavioral of EXAMPLE_M17_FAP_SUBT is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--256 Bit Adder
component EXAMPLE_M17_FAP_ADDR
	port( SummandA : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         SummandB : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Summation : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Carries the Sum of the Minuend and the Inverse of the Subtrahend
signal DifferenceMinLessSub : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal DifferenceMinGreatSub : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal PrimeAndNegB : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal NegB : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal DiffBeforeMod : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);

begin
--If A is less than B, we need ((P+A)-B) > 0; or, (A+(P+(-B))).
DifferenceMinGreatSub((VecLen - 1) downto 0) <= STD_LOGIC_VECTOR(unsigned(Minuend((VecLen - 1) downto 0)) - unsigned(Subtrahend((VecLen - 1) downto 0)));
NegB((VecLen - 1) downto 0) <= STD_LOGIC_VECTOR(unsigned(not Subtrahend((VecLen - 1) downto 0)) + unsigned(UnitVector((VecLen - 1) downto 0)));
PrimeAndNegB((VecLen - 1) downto 0) <= STD_LOGIC_VECTOR(unsigned(NegB((VecLen - 1) downto 0)) + unsigned(Prime((VecLen - 1) downto 0)));
DifferenceMinLessSub((VecLen - 1) downto 0) <= STD_LOGIC_VECTOR(unsigned(Minuend((VecLen - 1) downto 0)) + unsigned(PrimeAndNegB((VecLen - 1) downto 0)));

DiffBeforeMod <= DifferenceMinGreatSub when Minuend > Subtrahend else
				     DifferenceMinLessSub when Minuend < Subtrahend else
				     ZeroVector;
					  
Difference((VecLen - 1) downto 0) <= STD_LOGIC_VECTOR(unsigned(DiffBeforeMod) mod unsigned(Prime));


end Behavioral;


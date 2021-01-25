----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:38 03/23/2017 
-- Design Name: 
-- Module Name:    NUMER_FAP_MOD_SUBT_NISTsecp256r1 - Behavioral 
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

entity NUMER_FAP_MOD_SUBT_NISTsecp256r1 is
    Port ( Minuend : in  STD_LOGIC_VECTOR (255 downto 0);
           Subtrahend : in  STD_LOGIC_VECTOR (255 downto 0);
           Difference : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_FAP_MOD_SUBT_NISTsecp256r1;

architecture Behavioral of NUMER_FAP_MOD_SUBT_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
--The 2's Compliment of the NIST-secp256r1-Prime
constant PrimeInverse : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
--A 256 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
constant UnitVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--256 Bit Adder
component NUMER_FAP_MOD_ADDR_NISTsecp256r1
	port( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
         Summation : out  STD_LOGIC_VECTOR (256 downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Carries the Sum of the Minuend and the Inverse of the Subtrahend
signal DifferenceMinLessSub : STD_LOGIC_VECTOR (255 downto 0);
signal DifferenceMinGreatSub : STD_LOGIC_VECTOR (255 downto 0);
signal PrimeAndNegB : STD_LOGIC_VECTOR (255 downto 0);
signal NegB : STD_LOGIC_VECTOR (255 downto 0);
signal DiffBeforeMod : STD_LOGIC_VECTOR (255 downto 0);


begin
--If A is less than B, we need ((P+A)-B) > 0; or, (A+(P+(-B))).
DifferenceMinGreatSub(255 downto 0) <= STD_LOGIC_VECTOR(unsigned(Minuend(255 downto 0)) - unsigned(Subtrahend(255 downto 0)));
NegB(255 downto 0) <= STD_LOGIC_VECTOR(unsigned(not Subtrahend(255 downto 0)) + unsigned(UnitVector(255 downto 0)));
PrimeAndNegB(255 downto 0) <= STD_LOGIC_VECTOR(unsigned(NegB(255 downto 0)) + unsigned(Prime(255 downto 0)));
DifferenceMinLessSub(255 downto 0) <= STD_LOGIC_VECTOR(unsigned(Minuend(255 downto 0)) + unsigned(PrimeAndNegB(255 downto 0)));

DiffBeforeMod(255 downto 0) <= DifferenceMinGreatSub(255 downto 0) when Minuend > Subtrahend else
				     DifferenceMinLessSub(255 downto 0) when Minuend < Subtrahend else
				     ZeroVector(255 downto 0);
					  
Difference(255 downto 0) <= STD_LOGIC_VECTOR(unsigned(DiffBeforeMod) mod unsigned(Prime));

end Behavioral;


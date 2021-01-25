----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:53 03/14/2017 
-- Design Name: 
-- Module Name:    Divider_PiecewiseComparator - Behavioral 
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

--Divider_PiecewiseComparator
entity STRUC_FAP_MOD_DIVD_257byNISTsecp256r1 is
    Port ( ValueIn : in  STD_LOGIC_VECTOR (256 downto 0);
           ValueModded : out  STD_LOGIC_VECTOR (255 downto 0); --(ValueIn Mod Prime = ValueModded)
           SubbedBy2P : out  STD_LOGIC; --'1' iff (ValueModded = ValueIn - 2*Prime) else '0'
           SubbedByP : out  STD_LOGIC); --'1' iff (ValueModded = ValueIn - Prime) else '0'
end STRUC_FAP_MOD_DIVD_257byNISTsecp256r1;

architecture Behavioral of STRUC_FAP_MOD_DIVD_257byNISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime pre-concatenated by a 0
constant Prime : STD_LOGIC_VECTOR (256 downto 0) := "0" & X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
--NIST-secp256r1-Prime post-concatenated by a 0
constant Prime2 : STD_LOGIC_VECTOR (256 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF" & "0";
--The 2's Compliment of the (NIST-secp256r1-Prime pre-concatenated by a 0)
constant PrimeInverse : STD_LOGIC_VECTOR (256 downto 0) := "0" & X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
--The 2's Compliment of the (NIST-secp256r1-Prime post-concatenated by a 0)
constant PrimeInverse2 : STD_LOGIC_VECTOR (256 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001" & "0";
--A 256 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
--A 257 bit vector populated by only zeroes
constant ZeroVector1 : STD_LOGIC_VECTOR (256 downto 0) := "0" & X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--256 Bit Adder
component STRUC_FAP_LIN_ADDR_RCAKS_256
	port( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
         Summation : out  STD_LOGIC_VECTOR (256 downto 0)
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Internal buffer of the SubbedByP output
signal WasSubbedByP : STD_LOGIC;
--Internal buffer of the SubbedBy2P output
signal WasSubbedBy2P : STD_LOGIC;
--Carries whether the ValueIn is less than the Prime
signal ValueInLessP : STD_LOGIC_VECTOR (256 downto 0);
--Carries whether the ValueIn is less than the Prime*2
signal ValueInLess2P : STD_LOGIC_VECTOR (256 downto 0);
--Carries whether the ValueIn is equal to the Prime
signal ValueInEqualP : STD_LOGIC;
--Carries whether the ValueIn is equal to the Prime*2
signal ValueInEqual2P : STD_LOGIC;
--Carries the output of the 'equals when else case select' statement that determines what to add to the input value.
Signal ADDRInput : STD_LOGIC_VECTOR(255 downto 0);
--Carries the output of the ADDR256 cell.
Signal ADDROutput : STD_LOGIC_VECTOR(255 downto 0);
--Carries the signal used to select the zerovector as input to both the ADDRInput and the ValueModded
Signal ZeroVectorConditional : STD_LOGIC;
--Attaches to the 256'th bit of the Summation output from "Addition_256" as this cannot be left open.
signal wastageBit : STD_LOGIC;

begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

ADDR256 : STRUC_FAP_LIN_ADDR_RCAKS_256 port map (SummandA(255 downto 0) => ValueIn(255 downto 0), 
											SummandB(255 downto 0) => ADDRInput(255 downto 0), 
											Summation(255 downto 0) => ADDROutput,
											Summation(256) => wastageBit);

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

--------------------------------
--Equals When Else Case Select--
--------------------------------

--Determines the output
ValueModded <= ZeroVector when (ZeroVectorConditional = '1') else --does nothing is a multiple of the Prime, or zero
				   ADDROutput; --If not a muliple of the prime, all cases considered, output the value of the ADDR cell.

--Determines what to add to the input to generate the modded value.
ADDRInput <= ZeroVector when (ZeroVectorConditional = '1') else --does nothing is a multiple of the Prime, or zero
				 PrimeInverse(255 downto 0) when (WasSubbedByP = '1') else --Subtracts the Prime
				 PrimeInverse2(255 downto 0) when (WasSubbedBy2P = '1') else --Subtracts the Prime*2
				 ZeroVector; --when else unconditional end
				 
--Set the condition for the output of the zerovector.
ZeroVectorConditional <= '1' when ((ValueIn = ZeroVector1) or (ValueInEqualP = '1') or (ValueInEqual2P = '1') or (ValueIn < Prime)) else '0';
--Single bit outputs that indicate whether the comparator at this stage in the concatanation had to reduce by (2^j)*Prime
ValueInEqualP <= '1' when (ValueIn = Prime) else '0';
ValueInEqual2P <= '1' when (ValueIn = Prime2) else '0';
WasSubbedByP <= '1' when (((ValueIn > Prime) or (ValueInEqualP = '1')) and (WasSubbedBy2P = '0')) else '0'; --Internal Buffer
WasSubbedBy2P <= '1' when ((ValueIn > Prime2) or (ValueInEqual2P = '1')) else '0'; --Internal Buffer
SubbedByP <= WasSubbedByP; --Buffered Internally
SubbedBy2P <= WasSubbedBy2P; --Buffered Internally

end Behavioral;


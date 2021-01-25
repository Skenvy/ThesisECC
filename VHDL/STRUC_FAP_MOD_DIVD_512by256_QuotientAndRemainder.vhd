----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:56 03/14/2017 
-- Design Name: 
-- Module Name:    Divider_IntegerQuotientAndRemainder_512by256 - Behavioral 
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

--Divider_IntegerQuotientAndRemainder_512by256
entity STRUC_FAP_MOD_DIVD_512by256_QuotientAndRemainder is
    Port ( Dividend : in  STD_LOGIC_VECTOR (511 downto 0);
           Quotient : out  STD_LOGIC_VECTOR (255 downto 0); --(Floor[Dividend/Prime] = Quotient)
           Remainder : out  STD_LOGIC_VECTOR (255 downto 0)); --(Dividend - (Floor[Dividend/Prime]*Prime) = Remainder)
end STRUC_FAP_MOD_DIVD_512by256_QuotientAndRemainder;

architecture Behavioral of STRUC_FAP_MOD_DIVD_512by256_QuotientAndRemainder is

---------------------------
-----TYPE DECLARATIONS-----
---------------------------

--Declares a type for use in making 256 lots of a 256 bit vector
type PiecewiseData is array (255 downto 0) of STD_LOGIC_VECTOR(255 downto 0);

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--A component that examines 257 bits, and compares them to the Prime, outputs the mod Prime of the input, and whether the input was modded or not.
component STRUC_FAP_MOD_DIVD_257byNISTsecp256r1
	port(ValueIn : in  STD_LOGIC_VECTOR (256 downto 0);
        ValueModded : out  STD_LOGIC_VECTOR (255 downto 0);
        SubbedBy2P : out  STD_LOGIC;
        SubbedByP : out  STD_LOGIC);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Signal of the type declared to carry 256*(256 bit arrays).
signal PieceWiseDataBus : PieceWiseData;
--Carries all the signals from the individual comparator's "SubbedByP" outputs.
signal SubbedByP : STD_LOGIC_VECTOR(255 downto 0);
--Carries all the signals from the individual comparator's "SubbedBy2P" outputs.
signal SubbedBy2P : STD_LOGIC_VECTOR(255 downto 0);

begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

--Instantiate the first comparator with the highest 257 bits of the Dividend attached
PieceWiseCompare256 : STRUC_FAP_MOD_DIVD_257byNISTsecp256r1 port map (ValueIn => Dividend(511 downto 255),
																				ValueModded => PieceWiseDataBus(255),
																				SubbedByP => SubbedByP(255),
																				SubbedBy2P => SubbedBy2P(255));

--Generate the remaining 255 comparators, establishing all interconnections
PieceWiseCompare255 : for k in 254 downto 0 generate
begin
	PieceWiseCompareX : STRUC_FAP_MOD_DIVD_257byNISTsecp256r1 port map (ValueIn(256 downto 1) => PieceWiseDataBus(k+1),
																				 ValueIn(0) => Dividend(k),
																				 ValueModded => PieceWiseDataBus(k),
																				 SubbedByP => SubbedByP(k),
																				 SubbedBy2P => SubbedBy2P(k));
end generate PieceWiseCompare255;

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

--The remainder after integer division is the contents of the final modulo comparator.
Remainder <= PieceWiseDataBus(0);

--Now deal with the quotient from the SubbedBy signals. The first bit only looks at the SubbedByP of the last comparator, the rest use a generate.
Quotient(0) <= SubbedByP(0);
QuotientGenerate : for k in 1 to 255 generate
begin --note that this ignores the SubbedBy2P(255), which should be looked at in general, but we assume that this
		--component is used to find the quotient by a prime on a product of two multiplicands both less than the prime.
	Quotient(k) <= (SubbedByP(k) or SubbedBy2P(k-1));
end generate QuotientGenerate;

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:02:33 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_DIVDCOMB - Behavioral 
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

entity GENERIC_FAP_MODMULT_DIVDCOMB is
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen);
    Port ( Dividend : in  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
           Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Remainder : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Quotient : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end GENERIC_FAP_MODMULT_DIVDCOMB;

architecture Behavioral of GENERIC_FAP_MODMULT_DIVDCOMB is

component GENERIC_FAP_MODMULT_DIVDCOMB_PIECEWISE
	 Generic (N : Natural;
				 M : Natural);
    Port ( ValueIn : in  STD_LOGIC_VECTOR (N downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           ValueModded : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           SubbedByM : out  STD_LOGIC;
           SubbedBy2M : out  STD_LOGIC;
           SubbedBy3M : out  STD_LOGIC);
end component;

signal SubbedByM : STD_LOGIC_VECTOR ((N-1) downto 0);
signal SubbedBy2M : STD_LOGIC_VECTOR ((N-1) downto 0);
signal SubbedBy3M : STD_LOGIC_VECTOR ((N-1) downto 0);
type PiecewiseData is array ((N-1) downto 0) of STD_LOGIC_VECTOR((N-1) downto 0);
signal PieceWiseDataBus : PieceWiseData;

begin

--Instantiate the first comparator with the highest (N+1) bits of the Dividend attached
PieceWiseCompareN : GENERIC_FAP_MODMULT_DIVDCOMB_PIECEWISE 
	Generic Map (N => N, M => M)
	Port Map (ValueIn => Dividend(((2*N)-1) downto (N-1)),
				 Modulus => Modulus,
				 ValueModded => PieceWiseDataBus(N-1),
				 SubbedByM => SubbedByM(N-1),
				 SubbedBy2M => SubbedBy2M(N-1),
				 SubbedBy3M => SubbedBy3M(N-1));
--Generate the cascade of Piecewise Comparators
--Generate the remaining 255 comparators, establishing all interconnections
PieceWiseCompareXGen : for k in (N-2) downto 0 generate
begin
	PieceWiseCompareX : GENERIC_FAP_MODMULT_DIVDCOMB_PIECEWISE 
	Generic Map (N => N, M => M)
	Port Map (ValueIn(N downto 1) => PieceWiseDataBus(k+1),
				 ValueIn(0) => Dividend(k),
				 Modulus => Modulus,
				 ValueModded => PieceWiseDataBus(k),
				 SubbedByM => SubbedByM(k),
				 SubbedBy2M => SubbedBy2M(k),
				 SubbedBy3M => SubbedBy3M(k));
end generate PieceWiseCompareXGen;
--The remainder after integer division is the contents of the final modulo comparator.
Remainder <= PieceWiseDataBus(0);
--Now deal with the quotient from the SubbedBy signals. The first bit only looks at the SubbedByP of the last comparator, the rest use a generate.
Quotient(0) <= (SubbedByM(0) or SubbedBy3M(0));
QuotientGenerate : for k in 1 to (N-1) generate
begin --note that this ignores the SubbedBy2P(255), which should be looked at in general, but we assume that this
		--component is used to find the quotient by a modulus on a product of two multiplicands both less than the modulus.
	Quotient(k) <= (SubbedByM(k) or SubbedBy2M(k-1) or (SubbedBy3M(k-1) or SubbedBy3M(k)));
end generate QuotientGenerate;

end Behavioral;


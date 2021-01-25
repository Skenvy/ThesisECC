----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:00:35 05/23/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED - Behavioral 
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

entity GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED is
    Generic (N : Natural := VecLen;
				 M : Natural := MultLen;
				 CompDelay : Time := 30 ns);
    Port ( Dividend : in  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
           Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC;
           Remainder : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Quotient : out  STD_LOGIC_VECTOR ((N-1) downto 0);
			  StableOutput : out STD_LOGIC);
end GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED;

architecture Behavioral of GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED is

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

component GENERIC_FAP_RELATIONAL
	 Generic (N : Natural;
				 VType : Natural); --0 for just equality, 1 for Greater Than test : Default 1
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC;
           G : out  STD_LOGIC);
end component;

signal SubbedByM : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal SubbedBy2M : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal SubbedBy3M : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal LatchedProductSpace : STD_LOGIC_VECTOR (((2*N)-1) downto 0) := (others => '0');
signal LatchedDividend : STD_LOGIC_VECTOR (((2*N)-1) downto 0) := (others => '0');
signal LatchedModulus : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal StableCompare : STD_LOGIC := '0';
signal StableOutputInner : STD_LOGIC := '0';
signal LatchedValueIn : STD_LOGIC_VECTOR (N downto 0) := (others => '0');
signal LatchedValueModded : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal LatchedSubbedByM : STD_LOGIC := '0';
signal LatchedSubbedBy2M : STD_LOGIC := '0';
signal LatchedSubbedBy3M : STD_LOGIC := '0';
signal BitPositionVector : STD_LOGIC_VECTOR ((N-1) downto 0) := (0 => '1', others => '0');
Constant BitPositionVectorIsZero : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
Constant BitPositionVectorIsUnit : STD_LOGIC_VECTOR ((N-1) downto 0) := (0 => '1', others => '0');
signal InternalClock : STD_LOGIC := '0';
signal Equalities : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');

begin

StableOutput <= StableOutputInner;

RemGen : for K in 0 to (N-1) generate
begin
	Remainder(K) <= (LatchedProductSpace(K+(((2*N)-1)-N+1)) and StableOutputInner);
end generate RemGen;

InternalClock <= transport (not InternalClock) after CompDelay;

process(CLK)
begin
	if	(rising_edge(CLK)) then
		if ((Equalities(1) and Equalities(2)) = '1') then --comparator --comparator
			--Carry on the action with the next stage
			if(Equalities(0) = '0') then
				if (StableCompare = '0') then
					LatchedValueIn <= LatchedProductSpace(((2*N)-1) downto (((2*N)-1)-N));
					LatchedProductSpace <= LatchedProductSpace(((2*N)-2) downto 0) & '0';
					StableCompare <= '1';
				else
					LatchedProductSpace(((2*N)-2+1) downto (((2*N)-1)-N+1)) <= LatchedValueModded;
					BitPositionVector <= BitPositionVector((N-2) downto 0) & '0';
					StableCompare <= '0';
				end if;
			else
				StableOutputInner <= '1';
			end if;
		else
			--Reset to the new input and refresh the process
			LatchedDividend <= Dividend;
			LatchedProductSpace <= Dividend;
			LatchedModulus <= Modulus;
			StableOutputInner <= '0';
			StableCompare <= '0';
			BitPositionVector <= BitPositionVectorIsUnit;
		end if;
	end if;
end process;

COMP : GENERIC_FAP_MODMULT_DIVDCOMB_PIECEWISE
	Generic Map (N => N, M => M)
	Port Map (ValueIn => LatchedValueIn,
				 Modulus => Modulus,
				 ValueModded => LatchedValueModded,
				 SubbedByM => open,
				 SubbedBy2M => open,
				 SubbedBy3M => open);

EG0 : GENERIC_FAP_RELATIONAL
	Generic Map (N => N,
					 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
	Port Map ( A => BitPositionVector,
				  B => BitPositionVectorIsZero,
              E => Equalities(0),
              G => open);
				  
EG1 : GENERIC_FAP_RELATIONAL
	Generic Map (N => (2*N),
					 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
	Port Map ( A => Dividend,
				  B => LatchedDividend,
              E => Equalities(1),
              G => open);
				  
EG2 : GENERIC_FAP_RELATIONAL
	Generic Map (N => N,
					 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
	Port Map ( A => Modulus,
				  B => LatchedModulus,
              E => Equalities(2),
              G => open);
				  
end Behavioral;


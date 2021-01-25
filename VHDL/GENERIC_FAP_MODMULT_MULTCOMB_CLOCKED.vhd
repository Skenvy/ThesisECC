----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:37:24 05/19/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED - Behavioral 
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

entity GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED is
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
			  CLK : in STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED;

architecture Behavioral of GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED is

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

signal AndRegister : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal LatchedMultA : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal LatchedMultB : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal LatchedAddrA : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal LatchedAddrB : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal LatchedAddrS : STD_LOGIC_VECTOR (N downto 0) := (others => '0');
signal LatchedProduct : STD_LOGIC_VECTOR ((2*N) downto 0) := (others => '0');
signal StableAdder : STD_LOGIC := '0';
signal StableOutputInner : STD_LOGIC := '0';
signal BitPositionVector : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
Constant BitPositionVectorIsZero : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
Constant BitPositionVectorIsUnit : STD_LOGIC_VECTOR ((N-1) downto 0) := (1 => '1', others => '0');
signal InternalClock : STD_LOGIC := '0';
signal BitPositionBit : STD_LOGIC := '0' ;
signal BitPositionBitVector : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal Equalities : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin

StableOutput <= StableOutputInner;
LatchedAddrA <= AndRegister;

ProdGen : for K in 0 to ((2*N)-1) generate
begin
	Product(K) <= (LatchedProduct(K+1) and StableOutputInner);
end generate ProdGen;

AddrGen : for K in 0 to (N-1) generate
begin
	AndRegister(K) <= (MultiplicandB(K) and BitPositionBit);
end generate AddrGen;

BitPosGen : for K in 0 to (N-1) generate
begin
	BitPositionBitVector(K) <= MultiplicandA(K) and BitPositionVector(K);
end generate BitPosGen;

InternalClock <= transport (not InternalClock) after AddrDelay;

process(CLK)
begin
	if	(rising_edge(CLK)) then
		if ((Equalities(1) and Equalities(2)) = '1') then --comparator --comparator
			if (Equalities(3) = '0') then
				if (StableAdder = '0') then
					if (Equalities(0) = '1') then
						BitPositionBit <= '0';
					else
						BitPositionBit <= '1';
					end if;
					LatchedAddrB <= LatchedProduct((2*N) downto (N+1));
					LatchedProduct(((2*N)-1) downto 0) <= '0' & LatchedProduct(((2*N)-1) downto 1);
					StableAdder <= '1';
				else
					LatchedProduct((2*N) downto N) <= LatchedAddrS;
					BitPositionVector <= BitPositionVector((N-2) downto 0) & '0';
					StableAdder <= '0';
				end if;
			else
				StableOutputInner <= '1';
			end if;
		else
			LatchedMultA <= MultiplicandA;
			LatchedMultB <= MultiplicandB;
			StableOutputInner <= '0';
			StableAdder <= '0';
			BitPositionVector <= BitPositionVectorIsUnit;
			if (MultiplicandA(0) = '1') then
				LatchedProduct(2*N) <= '0';
				LatchedProduct(((2*N)-1) downto N) <= MultiplicandB;
				LatchedProduct((N-1) downto 0) <= (others => '0');
			else
				LatchedProduct <= (others => '0');
			end if;
		end if;
	end if;
end process;

ADDR : GENERIC_FAP_LINADDRMUX
	Generic Map (N => N, M => M)
	Port Map (A => LatchedAddrA, B => LatchedAddrB, S => LatchedAddrS);

EG0 : GENERIC_FAP_RELATIONAL
	Generic Map (N => N,
					 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
	Port Map ( A => BitPositionBitVector,
				  B => BitPositionVectorIsZero,
              E => Equalities(0),
              G => open);
				  
EG1 : GENERIC_FAP_RELATIONAL
	Generic Map (N => N,
					 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
	Port Map ( A => MultiplicandA,
				  B => LatchedMultA,
              E => Equalities(1),
              G => open);
				  
EG2 : GENERIC_FAP_RELATIONAL
	Generic Map (N => N,
					 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
	Port Map ( A => MultiplicandB,
				  B => LatchedMultB,
              E => Equalities(2),
              G => open);

EG3 : GENERIC_FAP_RELATIONAL
	Generic Map (N => N,
					 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
	Port Map ( A => BitPositionVector,
				  B => BitPositionVectorIsZero,
              E => Equalities(3),
              G => open);

end Behavioral;


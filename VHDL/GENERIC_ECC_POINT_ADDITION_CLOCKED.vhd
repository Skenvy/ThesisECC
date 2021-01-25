----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:19:23 05/26/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_POINT_ADDITION_CLOCKED - Behavioral 
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

entity GENERIC_ECC_POINT_ADDITION_CLOCKED is
	 Generic (NGen : natural := VecLen;
				 MGen : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( AX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_ECC_POINT_ADDITION_CLOCKED;

architecture Behavioral of GENERIC_ECC_POINT_ADDITION_CLOCKED is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component GENERIC_FAP_MODADDR
	 Generic (N : natural;
				 M : natural); --Terminal Length
    Port ( SummandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           SummandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0); --Modulo.
           Summation : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end component;

component GENERIC_FAP_MODSUBT
    Generic (N : natural;
				 M : natural);
    Port ( Minuend : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Subtrahend : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0); --Modulo.
           Difference : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end component;

component GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic (N : Natural;
				 M : Natural;
				 AddrDelay : Time;
				 CompDelay : Time;
				 Toomed : Boolean);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end component;

component GENERIC_FAP_RELATIONAL
	 Generic (N : Natural;
				 VType : Natural); --0 for just equality, 1 for Greater Than test : Default 1
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC;
           G : out  STD_LOGIC);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Generic
signal A : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal B : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal C : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal D : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal E : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal F : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal G : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal H : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal I : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal J : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal K : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal L : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal M : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal N : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal O : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal P : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal Q : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal R : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal S : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal T : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal STAGE_STABILITIES : STD_LOGIC_VECTOR(9 downto 0); --9th is the stable output
--BUFF's
signal XBUFF : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal YBUFF : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal ZBUFF : STD_LOGIC_VECTOR((NGen-1) downto 0);

--Travelling Multipliers
signal Mult1A : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult1B : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult1P : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal P1_Stability : STD_LOGIC;--
signal Mult2A : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult2B : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult2P : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal P2_Stability : STD_LOGIC;--
signal Mult3A : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult3B : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult3P : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal P3_Stability : STD_LOGIC;--
signal Mult4A : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult4B : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult4P : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal P4_Stability : STD_LOGIC;--
signal Mult5A : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult5B : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Mult5P : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal P5_Stability : STD_LOGIC;--
--Producing a period of four clock cycles of nop behaviour to allow the multipliers to effect the instability of the outputs.
signal CLK_Stability : STD_LOGIC_VECTOR(1 downto 0);
--Determining the stability of the inputs
signal AX_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal AY_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal AZ_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal BX_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal BY_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal BZ_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal AX_Stability : STD_LOGIC;
signal AY_Stability : STD_LOGIC;
signal AZ_Stability : STD_LOGIC;
signal BX_Stability : STD_LOGIC;
signal BY_Stability : STD_LOGIC;
signal BZ_Stability : STD_LOGIC;

signal AZ_Zero : STD_LOGIC;
signal BZ_Zero : STD_LOGIC;

begin

------------------------------
-----Stage X Mult's Ports-----
------------------------------

--1P(1A,1B)
MULT_1P : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => NGen,
					  M => MGen,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => Mult1A,
					MultiplicandB => Mult1B,
					Modulus => Modulus,
					Product => Mult1P,
					CLK => CLK,
					StableOutput => P1_Stability);

--2P(2A,2B)
MULT_2P : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => NGen,
					  M => MGen,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => Mult2A,
					MultiplicandB => Mult2B,
					Modulus => Modulus,
					Product => Mult2P,
					CLK => CLK,
					StableOutput => P2_Stability);

--3P(3A,3B)
MULT_3P : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => NGen,
					  M => MGen,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => Mult3A,
					MultiplicandB => Mult3B,
					Modulus => Modulus,
					Product => Mult3P,
					CLK => CLK,
					StableOutput => P3_Stability);

--4P(4A,4B)
MULT_4P : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => NGen,
					  M => MGen,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => Mult4A,
					MultiplicandB => Mult4B,
					Modulus => Modulus,
					Product => Mult4P,
					CLK => CLK,
					StableOutput => P4_Stability);

--5P(5A,5B)
MULT_5P : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => NGen,
					  M => MGen,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => Mult5A,
					MultiplicandB => Mult5B,
					Modulus => Modulus,
					Product => Mult5P,
					CLK => CLK,
					StableOutput => P5_Stability);

-----------------------------------
-----Stage 3 Addr-Subt's Ports-----
-----------------------------------

--F(D,C)
SUBT_F : GENERIC_FAP_MODSUBT
    Generic Map (N => NGen,
					  M => MGen)
    Port Map ( Minuend => D,
					Subtrahend => C,
					Modulus => Modulus, --Modulo.
					Difference => F);
--G(C,D)
ADDR_G : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => C,
					SummandB => D,
					Modulus => Modulus, --Modulo.
					Summation => G);
--P(N,O)
SUBT_P : GENERIC_FAP_MODSUBT
    Generic Map (N => NGen,
					  M => MGen)
    Port Map ( Minuend => N,
					Subtrahend => O,
					Modulus => Modulus, --Modulo.
					Difference => P);

-------------------------
-----Stage 6 X Port-----
-------------------------

--X(Q,I)
SUBT_X : GENERIC_FAP_MODSUBT
    Generic Map (N => NGen,
					  M => MGen)
    Port Map ( Minuend => Q,
					Subtrahend => I,
					Modulus => Modulus, --Modulo.
					Difference => XBUFF);

---------------------------
-----Stage 7 Subt Port-----
---------------------------

--S(K,XBUFF)
SUBT_S : GENERIC_FAP_MODSUBT
    Generic Map (N => NGen,
					  M => MGen)
    Port Map ( Minuend => K,
					Subtrahend => XBUFF,
					Modulus => Modulus, --Modulo.
					Difference => S);

-------------------------
-----Stage 9 Y Port-----
-------------------------

--Y(T,R)
SUBT_Y : GENERIC_FAP_MODSUBT
    Generic Map (N => NGen,
					  M => MGen)
    Port Map ( Minuend => T,
					Subtrahend => R,
					Modulus => Modulus, --Modulo.
					Difference => YBUFF);

-------------------------
-----Zero Check Port-----
-------------------------

AZZERO : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => AZ,
           B => ZeroVector,
           E => AZ_Zero,
           G => open);
			  
BZZERO : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => BZ,
           B => ZeroVector,
           E => BZ_Zero,
           G => open);
			  
AX_STABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => AX,
           B => AX_Previous,
           E => AX_Stability,
           G => open);
			  
AY_STABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => AY,
           B => AY_Previous,
           E => AY_Stability,
           G => open);
			  
AZ_STABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => AZ,
           B => AZ_Previous,
           E => AZ_Stability,
           G => open);
			  
BX_STABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => BX,
           B => BX_Previous,
           E => BX_Stability,
           G => open);
			  
BY_STABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => BY,
           B => BY_Previous,
           E => BY_Stability,
           G => open);
			  
BZ_STABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => BZ,
           B => BZ_Previous,
           E => BZ_Stability,
           G => open);

-------------------------
-----Control Process-----
-------------------------

OutGen : for K in 0 to (NGen-1) generate
begin
	CX(K) <= ((XBUFF(K) and (STAGE_STABILITIES(9) and (not AZ_Zero) and (not BZ_Zero))) or (BX(K) and AZ_Zero) or (AX(K) and BZ_Zero));
	CY(K) <= ((YBUFF(K) and (STAGE_STABILITIES(9) and (not AZ_Zero) and (not BZ_Zero))) or (BY(K) and AZ_Zero) or (AY(K) and BZ_Zero));
	CZ(K) <= ((ZBUFF(K) and (STAGE_STABILITIES(9) and (not AZ_Zero) and (not BZ_Zero))) or (BZ(K) and AZ_Zero) or (AZ(K) and BZ_Zero));
end generate OutGen;

StableOutput <= STAGE_STABILITIES(9);

process(CLK)
begin
	if(rising_edge(CLK)) then
		if ((AZ_Zero or BZ_Zero) = '1') then
			STAGE_STABILITIES <= (others => '1');
		elsif((AX_Stability and AY_Stability and AZ_Stability and BX_Stability and BY_Stability and BZ_Stability) = '1') then
			--Now when the inputs are stable.
			if(((not CLK_Stability(1)) and (not CLK_Stability(0))) = '1') then
				CLK_Stability(0) <= '1';
			elsif(((not CLK_Stability(1)) and (CLK_Stability(0))) = '1') then
				CLK_Stability(1) <= '1';
				CLK_Stability(0) <= '0';
			elsif(((CLK_Stability(1)) and (not CLK_Stability(0))) = '1') then
				CLK_Stability(0) <= '1';
			--Stage 9 Stabilities: YBUFF (Not Mult)
			elsif ((STAGE_STABILITIES(8) and (not STAGE_STABILITIES(9))) = '1') then
				STAGE_STABILITIES(9) <= '1';
				--Don't save anything, stability has been reached.
			--Stage 8 Stabilities: T, R (Mult)
			elsif ((STAGE_STABILITIES(7) and P1_Stability and P2_Stability) = '1') then
				STAGE_STABILITIES(8) <= '1';
				--Save TR
				T <= Mult1P;
				R <= Mult2P;
				--Don't make anything, next round is just subt.
				CLK_Stability <= "00";
			--Stage 7 Stabilities: S (Not Mult)
			elsif ((STAGE_STABILITIES(6) and (not STAGE_STABILITIES(7))) = '1') then
				STAGE_STABILITIES(7) <= '1';
				--Don't save anything
				--Make RT
				--T(P,S)
				Mult1A <= P;
				Mult1B <= S;
				--R(N,J)
				Mult2A <= N;
				Mult2B <= J;
				CLK_Stability <= "00";
			--Stage 6 Stabilities: XBUFF (Not Mult)
			elsif ((STAGE_STABILITIES(5) and (not STAGE_STABILITIES(6))) = '1') then
				STAGE_STABILITIES(6) <= '1';
				--Don't save anything
				--Don't make anything for the next round
				CLK_Stability <= "00";
			--Stage 5 Stabilities: I, J, K (All mults)
			elsif ((STAGE_STABILITIES(4) and P1_Stability and P2_Stability and P3_Stability) = '1') then
				STAGE_STABILITIES(5) <= '1';
				--Save IJK
				I <= Mult1P;
				J <= Mult2P;
				K <= Mult3P;
				--Don't make anything for the next round.
				CLK_Stability <= "00";
			--Stage 4 Stabilities: ZBUFF, H, Q (All mults)
			elsif ((STAGE_STABILITIES(3) and P1_Stability and P2_Stability and P3_Stability) = '1') then
				STAGE_STABILITIES(4) <= '1';
				--Save ZHQ
				ZBUFF <= Mult1P;
				H <= Mult2P;
				Q <= Mult3P;
				--Make IJK
				--I(G,H)
				Mult1A <= G;
				Mult1B <= Mult2P;
				--J(H,F)
				Mult2A <= Mult2P;
				Mult2B <= F;
				--K(D,H)
				Mult3A <= D;
				Mult3B <= Mult2P;
				CLK_Stability <= "00";
			--Stage 3 Stabilities: F, G, P (No mults)
			elsif ((STAGE_STABILITIES(2) and (not STAGE_STABILITIES(3))) = '1') then
				STAGE_STABILITIES(3) <= '1';
				--Nothing to save
				--Make ZHQ
				--ZBUFF--Z(F,E)
				Mult1A <= F;
				Mult1B <= E;
				--H(F,F)
				Mult2A <= F;
				Mult2B <= F;
				--Q(P,P)
				Mult3A <= P;
				Mult3B <= P;
				CLK_Stability <= "00";
			--Stage 2 Stabilities: C, D, N, O (All mults)
			elsif ((STAGE_STABILITIES(1) and P1_Stability and P2_Stability and P3_Stability and P4_Stability) = '1') then
				STAGE_STABILITIES(2) <= '1';
				--Save CDNO
				C <= Mult1P;
				D <= Mult2P;
				N <= Mult3P;
				O <= Mult4P;
				--Don't make anything for the next round, it's only subt/addr
				CLK_Stability <= "00";
			--Stage 1 Stabilities: A, B, E, L, M (All mults)
			elsif((STAGE_STABILITIES(0) and P1_Stability and P2_Stability and P3_Stability and P4_Stability and P5_Stability) = '1') then
				STAGE_STABILITIES(1) <= '1';
				--Save ABELM
				A <= Mult1P;
				B <= Mult2P;
				E <= Mult3P;
				L <= Mult4P;
				M <= Mult5P;
				--Make CDNO
				--C(A,BX)
				Mult1A <= Mult1P;
				Mult1B <= BX;
				--D(B,AX)
				Mult2A <= Mult2P;
				Mult2B <= AX;
				--N(L,B)
				Mult3A <= Mult4P;
				Mult3B <= Mult2P;
				--O(M,A)
				Mult4A <= Mult5P;
				Mult4B <= Mult1P;
				CLK_Stability <= "00";
			elsif (STAGE_STABILITIES(0) = '0') then
				STAGE_STABILITIES(0) <= '1';
			end if;
		else
			--If neither input is a point on the line at infinity, and the inputs have changed, then rehash the process.
			STAGE_STABILITIES <= (others => '0');
			AX_Previous <= AX;
			AY_Previous <= AY;
			AZ_Previous <= AZ;
			BX_Previous <= BX;
			BY_Previous <= BY;
			BZ_Previous <= BZ;
			--Stack the first lot on the stages
			--Make ABELM
			--A(AZ,AZ)
			Mult1A <= AZ;
			Mult1B <= AZ;
			--B(BZ,BZ)
			Mult2A <= BZ;
			Mult2B <= BZ;
			--E(AZ,BZ)
			Mult3A <= AZ;
			Mult3B <= BZ;
			--L(BZ,AY)
			Mult4A <= BZ;
			Mult4B <= AY;
			--M(AZ,BY)
			Mult5A <= AZ;
			Mult5B <= BY;
			CLK_Stability <= "00";
		end if;
	end if;
end process;

end Behavioral;


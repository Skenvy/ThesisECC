----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:28 06/01/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED - Behavioral 
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

entity GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED is
	 Generic (NGen : natural := VecLen;
				 MGen : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( AX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  ECC_A : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED;

architecture Behavioral of GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED is

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
signal U : STD_LOGIC_VECTOR((NGen-1) downto 0);--
signal STAGE_STABILITIES : STD_LOGIC_VECTOR(9 downto 0); --9th is the stable output
--BUFF's
signal XBUFF : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal YBUFF : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal ZBUFF : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');

--Travelling Multipliers
signal Mult1A : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal Mult1B : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal Mult1P : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal P1_Stability : STD_LOGIC;--
signal Mult2A : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal Mult2B : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal Mult2P : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal P2_Stability : STD_LOGIC;--
signal Mult3A : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal Mult3B : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal Mult3P : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal P3_Stability : STD_LOGIC;--
signal Mult4A : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal Mult4B : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal Mult4P : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal P4_Stability : STD_LOGIC;--
--Producing a period of four clock cycles of nop behaviour to allow the multipliers to effect the instability of the outputs.
signal CLK_Stability : STD_LOGIC_VECTOR(1 downto 0);
--Determining the stability of the inputs
signal AX_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal AY_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal AZ_Previous : STD_LOGIC_VECTOR((NGen-1) downto 0) := (others => '0');
signal AX_Stability : STD_LOGIC;
signal AY_Stability : STD_LOGIC;
signal AZ_Stability : STD_LOGIC;
signal AZ_Zero : STD_LOGIC;
signal AY_Zero : STD_LOGIC;

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

------------------------------
-----Stage 1 Addr's Ports-----
------------------------------

--O(AX,AX)
ADDR_O : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => AX,
					SummandB => AX,
					Modulus => Modulus, --Modulo.
					Summation => O);

------------------------------
-----Stage 2 Addr's Ports-----
------------------------------

--K(B,B)
ADDR_K : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => B,
					SummandB => B,
					Modulus => Modulus, --Modulo.
					Summation => K);

--P(O,O)
ADDR_P : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => O,
					SummandB => O,
					Modulus => Modulus, --Modulo.
					Summation => P);

--ZBUFF(A,A)
ADDR_Z : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => A,
					SummandB => A,
					Modulus => Modulus, --Modulo.
					Summation => ZBUFF);

------------------------------
-----Stage 3 Addr's Ports-----
------------------------------

--G(F,F)
ADDR_G : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => F,
					SummandB => F,
					Modulus => Modulus, --Modulo.
					Summation => G);

--L(K,B)
ADDR_L : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => K,
					SummandB => B,
					Modulus => Modulus, --Modulo.
					Summation => L);

--Q(P,P)
ADDR_Q : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => P,
					SummandB => P,
					Modulus => Modulus, --Modulo.
					Summation => Q);

------------------------------
-----Stage 4 Addr's Ports-----
------------------------------

--H(G,G)
ADDR_H : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => G,
					SummandB => G,
					Modulus => Modulus, --Modulo.
					Summation => H);

--M(L,J)
ADDR_M : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => L,
					SummandB => J,
					Modulus => Modulus, --Modulo.
					Summation => M);

-----------------------------
-----Stage 5 Addr's Port-----
-----------------------------

--I(H,H)
ADDR_I : GENERIC_FAP_MODADDR
	 Generic Map (N => NGen,
					  M => MGen) --Terminal Length
    Port Map ( SummandA => H,
					SummandB => H,
					Modulus => Modulus, --Modulo.
					Summation => I);

---------------------------
-----Stage 6 X's Ports-----
---------------------------

--XBUFF(N,R)
SUBT_X : GENERIC_FAP_MODSUBT
    Generic Map (N => NGen,
					  M => MGen)
    Port Map ( Minuend => N,
					Subtrahend => R,
					Modulus => Modulus, --Modulo.
					Difference => XBUFF);

----------------------------
-----Stage 7 Subt Ports-----
----------------------------

--T(S,XBUFF)
SUBT_T : GENERIC_FAP_MODSUBT
    Generic Map (N => NGen,
					  M => MGen)
    Port Map ( Minuend => S,
					Subtrahend => XBUFF,
					Modulus => Modulus, --Modulo.
					Difference => T);

---------------------------
-----Stage 9 Y's Ports-----
---------------------------

--YBUFF(U,I)
SUBT_Y : GENERIC_FAP_MODSUBT
    Generic Map (N => NGen,
					  M => MGen)
    Port Map ( Minuend => U,
					Subtrahend => I,
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
			  
AYZERO : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => AY,
           B => ZeroVector,
           E => AY_Zero,
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

-------------------------
-----Control Process-----
-------------------------

OutGen : for K in 0 to (NGen-1) generate
begin
	CX(K) <= (((XBUFF(K) and ((not AZ_Zero) and (not AY_Zero))) or (UnitVector(K) and (AZ_Zero or AY_Zero))) and STAGE_STABILITIES(9));
	CY(K) <= (((YBUFF(K) and ((not AZ_Zero) and (not AY_Zero))) or (UnitVector(K) and (AZ_Zero or AY_Zero))) and STAGE_STABILITIES(9));
	CZ(K) <= (((ZBUFF(K) and ((not AZ_Zero) and (not AY_Zero))) or (ZeroVector(K) and (AZ_Zero or AY_Zero))) and STAGE_STABILITIES(9));
end generate OutGen;

StableOutput <= STAGE_STABILITIES(9);

process(CLK)
begin
	if(rising_edge(CLK)) then
		if((AX_Stability and AY_Stability and AZ_Stability) = '1') then
			--Now when the inputs are stable.
			if(((not CLK_Stability(1)) and (not CLK_Stability(0))) = '1') then
				CLK_Stability(0) <= '1';
			elsif(((not CLK_Stability(1)) and (CLK_Stability(0))) = '1') then
				CLK_Stability(1) <= '1';
				CLK_Stability(0) <= '0';
			elsif(((CLK_Stability(1)) and (not CLK_Stability(0))) = '1') then
				CLK_Stability(0) <= '1';
			--Stage 9 Stabilities: Y (Subt)
			elsif ((STAGE_STABILITIES(8) and (not STAGE_STABILITIES(9))) = '1') then
				STAGE_STABILITIES(9) <= '1';
				--Save nothing
				--Make nothing
			--Stage 8 Stabilities: U (Mult);
			elsif ((STAGE_STABILITIES(7) and P1_Stability) = '1') then
				STAGE_STABILITIES(8) <= '1';
				--Save U
				U <= Mult1P;
				--Make nothing
				CLK_Stability <= "00";
			--Stage 7 Stabilities: T (Subt)
			elsif ((STAGE_STABILITIES(6) and (not STAGE_STABILITIES(7))) = '1') then
				STAGE_STABILITIES(7) <= '1';
				--Save nothing
				--Make U
				--U(T,M)
				Mult1A <= T;
				Mult1B <= M;
				CLK_Stability <= "00";
			--Stage 6 Stabilities: X (Subt)
			elsif ((STAGE_STABILITIES(5) and (not STAGE_STABILITIES(6))) = '1') then
				STAGE_STABILITIES(6) <= '1';
				--Save nothing
				--Make nothing
				CLK_Stability <= "00";
			--Stage 5 Stabilities: N (Mult); I (Addr)
			elsif ((STAGE_STABILITIES(4) and P1_Stability) = '1') then
				STAGE_STABILITIES(5) <= '1';
				--Save N
				N <= Mult1P;
				--Make nothing
				CLK_Stability <= "00";
			--Stage 4 Stabilities: R (Mult); H, M (Addrs)
			elsif ((STAGE_STABILITIES(3) and P1_Stability) = '1') then
				STAGE_STABILITIES(4) <= '1';
				--Save R
				R <= Mult1P;
				--Make N
				--N(M,M)
				Mult1A <= M;
				Mult1B <= M;
				CLK_Stability <= "00";
			--Stage 3 Stabilities: J, S (Mults); G, L, Q (Addrs)
			elsif ((STAGE_STABILITIES(2) and P1_Stability and P2_Stability) = '1') then
				STAGE_STABILITIES(3) <= '1';
				--Save JS
				J <= Mult1P;
				S <= Mult2P;
				--Make R
				--R(Q,C)
				Mult1A <= Q;
				Mult1B <= C;
				CLK_Stability <= "00";
			--Stage 2 Stabilities: E, F (Mults); K, P, Z (Addrs)
			elsif ((STAGE_STABILITIES(1) and P1_Stability and P2_Stability) = '1') then
				STAGE_STABILITIES(2) <= '1';
				--Save EF
				E <= Mult1P;
				F <= Mult2P;
				--Make JS
				--J(ECC_A,E)
				Mult1A <= ECC_A;
				Mult1B <= Mult1P;
				--S(P,C)
				Mult2A <= P;
				Mult2B <= C;
				CLK_Stability <= "00";
			--Stage 1 Stabilities: A, B, C, D (Mults); O (Addr)
			elsif((STAGE_STABILITIES(0) and P1_Stability and P2_Stability and P3_Stability and P4_Stability) = '1') then
				STAGE_STABILITIES(1) <= '1';
				--Save ABCD
				A <= Mult1P;
				B <= Mult2P;
				C <= Mult3P;
				D <= Mult4P;
				--Make EF
				--E(D,D)
				Mult1A <= Mult4P;
				Mult1B <= Mult4P;
				--F(C,C)
				Mult2A <= Mult3P;
				Mult2B <= Mult3P;
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
			--Stack the first lot on the stages
			--Make ABCD
			--A(AY,AZ)
			Mult1A <= AY;
			Mult1B <= AZ;
			--B(AX,AX)
			Mult2A <= AX;
			Mult2B <= AX;
			--C(AY,AY)
			Mult3A <= AY;
			Mult3B <= AY;
			--D(AZ,AZ)
			Mult4A <= AZ;
			Mult4B <= AZ;
			CLK_Stability <= "00";
		end if;
	end if;
end process;

end Behavioral;


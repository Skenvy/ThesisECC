----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:59 03/27/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_ECCPAJ1J2J - Behavioral 
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

entity EXAMPLE_M17_ECCPAJ1J2J is
    Port ( AX : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           BX : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           BY : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           BZ : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  CLK : IN STD_LOGIC);
end EXAMPLE_M17_ECCPAJ1J2J;

architecture Structural of EXAMPLE_M17_ECCPAJ1J2J is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component EXAMPLE_M17_FAP_ADDR
	port( SummandA : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         SummandB : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Summation : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

component EXAMPLE_M17_FAP_MULT
	port( MultiplicandA : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         MultiplicandB : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Product : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

component EXAMPLE_M17_FAP_SUBT
	port( Minuend : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Subtrahend : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Difference : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Generic
signal A : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal B : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal C : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal D : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal E : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal F : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal G : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal H : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal I : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal J : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal K : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal L : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal M : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal N : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal O : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal P : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal Q : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal R : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal S : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal T : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);--
signal A_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal B_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal C_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal D_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal E_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal F_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal G_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal H_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal I_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal J_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal K_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal L_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal M_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal N_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal O_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal P_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal Q_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal R_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal S_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal T_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
--BUFF's
signal XBUFF : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal YBUFF : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ZBUFF : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal XBUFF_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal YBUFF_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ZBUFF_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal StableOutputs : STD_LOGIC;
signal XOUT : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal YOUT : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ZOUT : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);

signal AX_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal AY_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal AZ_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal BX_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal BY_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal BZ_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);

begin

------------------------------
-----Stage 1 Mult's Ports-----
------------------------------

--A(AZ,AZ)
MULT_A : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => AZ,
													 MultiplicandB => AZ,
													 Product => A);									 
--B(BZ,BZ)
MULT_B : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => BZ,
													 MultiplicandB => BZ,
													 Product => B);
--E(AZ,BZ)
MULT_E : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => AZ,
													 MultiplicandB => BZ,
													 Product => E);
--L(BZ,AY)
MULT_L : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => BZ,
													 MultiplicandB => AY,
													 Product => L);
--M(AZ,BY)
MULT_M : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => AZ,
													 MultiplicandB => BY,
													 Product => M);

------------------------------
-----Stage 2 Mult's Ports-----
------------------------------

--C(A,BX)
MULT_C : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => A,
													 MultiplicandB => BX,
													 Product => C);
--D(B,AX)
MULT_D : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => B,
													 MultiplicandB => AX,
													 Product => D);
--N(L,B)
MULT_N : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => L,
													 MultiplicandB => B,
													 Product => N);
--O(M,A)
MULT_O : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => M,
													 MultiplicandB => A,
													 Product => O);

-----------------------------------
-----Stage 3 Addr-Subt's Ports-----
-----------------------------------

--F(D,C)
SUBT_F : EXAMPLE_M17_FAP_SUBT port map (Minuend => D,
													 Subtrahend => C,
													 Difference => F);
--G(C,D)
ADDR_G : EXAMPLE_M17_FAP_ADDR port map (SummandA => C,
													 SummandB => D,
													 Summation => G);
--P(N,O)
SUBT_P : EXAMPLE_M17_FAP_SUBT port map (Minuend => N,
													 Subtrahend => O,
													 Difference => P);

------------------------------
-----Stage 4 Mult's Ports-----
------------------------------

--H(F,F)
MULT_H : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => F,
													 MultiplicandB => F,
													 Product => H);
--Q(P,P)
MULT_Q : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => P,
													 MultiplicandB => P,
													 Product => Q);
-----Z Ports-----Z(F,E)
MULT_Z : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => F,
													 MultiplicandB => E,
													 Product => ZBUFF);

------------------------------
-----Stage 5 Mult's Ports-----
------------------------------

--I(G,H)
MULT_I : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => G,
													 MultiplicandB => H,
													 Product => I);
--J(H,F)
MULT_J : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => H,
													 MultiplicandB => F,
													 Product => J);
--K(D,H)
MULT_K : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => D,
													 MultiplicandB => H,
													 Product => K);

-------------------------
-----Stage 6 X Port-----
-------------------------

--X(Q,I)
SUBT_X : EXAMPLE_M17_FAP_SUBT port map (Minuend => Q,
													 Subtrahend => I,
													 Difference => XBUFF);

---------------------------
-----Stage 7 Subt Port-----
---------------------------

--S(K,XBUFF)
SUBT_S : EXAMPLE_M17_FAP_SUBT port map (Minuend => K,
													 Subtrahend => XBUFF,
													 Difference => S);

------------------------------
-----Stage 8 Mult's Ports-----
------------------------------

--R(N,J)
MULT_R : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => N,
													 MultiplicandB => J,
													 Product => R);
--T(P,S)
MULT_T : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => P,
													 MultiplicandB => S,
													 Product => T);

-------------------------
-----Stage 9 Y Port-----
-------------------------

--Y(T,R)
SUBT_Y : EXAMPLE_M17_FAP_SUBT port map (Minuend => T,
													 Subtrahend => R,
													 Difference => YBUFF);

CX <= XOUT when (StableOutputs = '1') else ImpedeVector;
CY <= YOUT when (StableOutputs = '1') else ImpedeVector;
CZ <= ZOUT when (StableOutputs = '1') else ImpedeVector;

process(CLK)
begin
	if(rising_edge(CLK)) then
		if (AZ = ZeroVector) then
			XOUT <= BX;
			YOUT <= BY;
			ZOUT <= BZ;
			StableOutputs <= '1';
		elsif (BZ = ZeroVector) then
			XOUT <= AX;
			YOUT <= AY;
			ZOUT <= AZ;
			StableOutputs <= '1';
		elsif((A = A_Previous) and (B = B_Previous) and (C = C_Previous) and (D = D_Previous) and (E = E_Previous) and (F = F_Previous) and (G = G_Previous)
		 and (H = H_Previous) and (I = I_Previous) and (J = J_Previous) and (K = K_Previous) and (L = L_Previous) and (M = M_Previous) and (N = N_Previous)
		 and (O = O_Previous) and (P = P_Previous) and (Q = Q_Previous) and (R = R_Previous) and (S = S_Previous) and (T = T_Previous)
		 and (XBUFF = XBUFF_Previous) and (YBUFF = YBUFF_Previous) and (ZBUFF = ZBUFF_Previous) and (AX = AX_Previous) and (AY = AY_Previous) and (AZ = AZ_Previous)
		 and (BX = BX_Previous) and (BY = BY_Previous) and (BZ = BZ_Previous)) then
			XOUT <= XBUFF;
			YOUT <= YBUFF;
			ZOUT <= ZBUFF;
			StableOutputs <= '1';
		else
			A_Previous <= A;
			B_Previous <= B;
			C_Previous <= C;
			D_Previous <= D;
			E_Previous <= E;
			F_Previous <= F;
			G_Previous <= G;
			H_Previous <= H;
			I_Previous <= I;
			J_Previous <= J;
			K_Previous <= K;
			L_Previous <= L;
			M_Previous <= M;
			N_Previous <= N;
			O_Previous <= O;
			P_Previous <= P;
			Q_Previous <= Q;
			R_Previous <= R;
			S_Previous <= S;
			T_Previous <= T;
			XBUFF_Previous <= XBUFF;
			YBUFF_Previous <= YBUFF;
			ZBUFF_Previous <= ZBUFF;
			AX_Previous <= AX;
			AY_Previous <= AY;
			AZ_Previous <= AZ;
			BX_Previous <= BX;
			BY_Previous <= BY;
			BZ_Previous <= BZ;
			StableOutputs <= '0';
		end if;
	end if;
end process;

end Structural;


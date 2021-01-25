----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:37:32 03/30/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_ECCPDJ2J - Behavioral 
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
use work.ECC_STANDARD.ALL;

entity EXAMPLE_M17_ECCPDJ2J is
    Port ( AX : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  CLK : IN STD_LOGIC);
end EXAMPLE_M17_ECCPDJ2J;

architecture Behavioral of EXAMPLE_M17_ECCPDJ2J is

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
signal A : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal B : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal C : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal D : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal E : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal F : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal G : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal H : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal I : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal J : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal K : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal L : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal M : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal N : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal O : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal P : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal Q : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal R : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal S : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal T : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal U : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
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
signal U_Previous : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
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


begin

------------------------------
-----Stage 1 Mult's Ports-----
------------------------------

--A(AY,AZ)
MULT_A : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => AY,
													 MultiplicandB => AZ,
													 Product => A);
--B(AX,AX)
MULT_B : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => AX,
													 MultiplicandB => AX,
													 Product => B);
--C(AY,AY)
MULT_C : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => AY,
													 MultiplicandB => AY,
													 Product => C);
--D(AZ,AZ)
MULT_D : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => AZ,
													 MultiplicandB => AZ,
													 Product => D);

------------------------------
-----Stage 1 Addr's Ports-----
------------------------------

--O(AX,AX)
ADDR_O : EXAMPLE_M17_FAP_ADDR port map (SummandA => AX,
													 SummandB => AX,
													 Summation => O);

------------------------------
-----Stage 2 Mult's Ports-----
------------------------------

--E(D,D)
MULT_E : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => D,
													 MultiplicandB => D,
													 Product => E);
--F(C,C)
MULT_F : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => C,
													 MultiplicandB => C,
													 Product => F);

------------------------------
-----Stage 2 Addr's Ports-----
------------------------------

--K(B,B)
ADDR_K : EXAMPLE_M17_FAP_ADDR port map (SummandA => B,
													 SummandB => B,
													 Summation => K);
--P(O,O)
ADDR_P : EXAMPLE_M17_FAP_ADDR port map (SummandA => O,
													 SummandB => O,
													 Summation => P);

-----ZBUFF-----
--ZBUFF(A,A)
ADDR_Z : EXAMPLE_M17_FAP_ADDR port map (SummandA => A,
													 SummandB => A,
													 Summation => ZBUFF);

------------------------------
-----Stage 3 Mult's Ports-----
------------------------------

--J(NISTA,E)
MULT_J : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => ECC_A,
													 MultiplicandB => E,
													 Product => J);
--S(P,C)
MULT_S : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => P,
													 MultiplicandB => C,
													 Product => S);

------------------------------
-----Stage 3 Addr's Ports-----
------------------------------

--G(F,F)
ADDR_G : EXAMPLE_M17_FAP_ADDR port map (SummandA => F,
													 SummandB => F,
													 Summation => G);
--L(K,B)
ADDR_L : EXAMPLE_M17_FAP_ADDR port map (SummandA => K,
													 SummandB => B,
													 Summation => L);
--Q(P,P)
ADDR_Q : EXAMPLE_M17_FAP_ADDR port map (SummandA => P,
													 SummandB => P,
													 Summation => Q);

-----------------------------
-----Stage 4 Mult's Port-----
-----------------------------

--R(Q,C)
MULT_R : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => Q,
													 MultiplicandB => C,
													 Product => R);

------------------------------
-----Stage 4 Addr's Ports-----
------------------------------

--H(G,G)
ADDR_H : EXAMPLE_M17_FAP_ADDR port map (SummandA => G,
													 SummandB => G,
													 Summation => H);
--M(L,J)
ADDR_M : EXAMPLE_M17_FAP_ADDR port map (SummandA => L,
													 SummandB => J,
													 Summation => M);

-----------------------------
-----Stage 5 Mult's Port-----
-----------------------------

--N(M,M)
MULT_N : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => M,
													 MultiplicandB => M,
													 Product => N);

-----------------------------
-----Stage 5 Addr's Port-----
-----------------------------

--I(H,H)
ADDR_I : EXAMPLE_M17_FAP_ADDR port map (SummandA => H,
													 SummandB => H,
													 Summation => I);

---------------------------
-----Stage 6 X's Ports-----
---------------------------

--XBUFF(N,R)
SUBT_X : EXAMPLE_M17_FAP_SUBT port map (Minuend => N,
													 Subtrahend => R,
													 Difference => XBUFF);

----------------------------
-----Stage 7 Subt Ports-----
----------------------------

--T(S,XBUFF)
SUBT_T : EXAMPLE_M17_FAP_SUBT port map (Minuend => S,
													 Subtrahend => XBUFF,
													 Difference => T);

----------------------------
-----Stage 8 Mult Port-----
----------------------------

--U(T,M)
MULT_U : EXAMPLE_M17_FAP_MULT port map (MultiplicandA => T,
													 MultiplicandB => M,
													 Product => U);

---------------------------
-----Stage 9 Y's Ports-----
---------------------------

--YBUFF(U,I)
SUBT_Y : EXAMPLE_M17_FAP_SUBT port map (Minuend => U,
													 Subtrahend => I,
													 Difference => YBUFF);

CX <= XOUT when (StableOutputs = '1') else ImpedeVector;
CY <= YOUT when (StableOutputs = '1') else ImpedeVector;
CZ <= ZOUT when (StableOutputs = '1') else ImpedeVector;

process(CLK)
begin
	if(rising_edge(CLK)) then
		if (AZ = ZeroVector) then
			XOUT <= AX;
			YOUT <= AY;
			ZOUT <= AZ;
			StableOutputs <= '1';
		elsif (AY = ZeroVector) then
			XOUT <= UnitVector;
			YOUT <= UnitVector;
			ZOUT <= ZeroVector;
			StableOutputs <= '1';
		elsif((A = A_Previous) and (B = B_Previous) and (C = C_Previous) and (D = D_Previous) and (E = E_Previous) and (F = F_Previous) and (G = G_Previous)
		 and (H = H_Previous) and (I = I_Previous) and (J = J_Previous) and (K = K_Previous) and (L = L_Previous) and (M = M_Previous) and (N = N_Previous)
		 and (O = O_Previous) and (P = P_Previous) and (Q = Q_Previous) and (R = R_Previous) and (S = S_Previous) and (T = T_Previous) and (U = U_Previous)
		 and (XBUFF = XBUFF_Previous) and (YBUFF = YBUFF_Previous) and (ZBUFF = ZBUFF_Previous) and (AX = AX_Previous) and (AY = AY_Previous) and (AZ = AZ_Previous)) then
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
			U_Previous <= U;
			XBUFF_Previous <= XBUFF;
			YBUFF_Previous <= YBUFF;
			ZBUFF_Previous <= ZBUFF;
			AX_Previous <= AX;
			AY_Previous <= AY;
			AZ_Previous <= AZ;
			StableOutputs <= '0';
		end if;
	end if;
end process;

end Behavioral;


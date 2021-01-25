----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:00:35 03/22/2017 
-- Design Name: 
-- Module Name:    NUMER_ECC_POINT_ADDITION_J1J2J - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NUMER_ECC_POINT_ADDITION_J1J2J is
    Port ( AX : in  STD_LOGIC_VECTOR (255 downto 0);
           AY : in  STD_LOGIC_VECTOR (255 downto 0);
           AZ : in  STD_LOGIC_VECTOR (255 downto 0);
           BX : in  STD_LOGIC_VECTOR (255 downto 0);
           BY : in  STD_LOGIC_VECTOR (255 downto 0);
           BZ : in  STD_LOGIC_VECTOR (255 downto 0);
           CX : out  STD_LOGIC_VECTOR (255 downto 0);
           CY : out  STD_LOGIC_VECTOR (255 downto 0);
           CZ : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_ECC_POINT_ADDITION_J1J2J;

architecture Behavioral of NUMER_ECC_POINT_ADDITION_J1J2J is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
--The 2's Compliment of the NIST-secp256r1-Prime
constant PrimeInverse : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
--A 256 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
--NIST-secp256r1-a
constant NISTA : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFC";
--NIST-secp256r1-b
constant NISTB : STD_LOGIC_VECTOR (255 downto 0) := X"5AC6_35D8_AA3A_93E7_B3EB_BD55_7698_86BC_651D_06B0_CC53_B0F6_3BCE_3C3E_27D2_604B";


--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component NUMER_FAP_MOD_ADDR_NISTsecp256r1
	port( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
         Summation : out  STD_LOGIC_VECTOR (255 downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

component NUMER_FAP_MOD_MULT_NISTsecp256r1
	port( MultiplicandA : in  STD_LOGIC_VECTOR (255 downto 0);
         MultiplicandB : in  STD_LOGIC_VECTOR (255 downto 0);
         Product : out  STD_LOGIC_VECTOR (255 downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

component NUMER_FAP_MOD_SUBT_NISTsecp256r1
	port( Minuend : in  STD_LOGIC_VECTOR (255 downto 0);
         Subtrahend : in  STD_LOGIC_VECTOR (255 downto 0);
         Difference : out  STD_LOGIC_VECTOR (255 downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Generic
signal A : STD_LOGIC_VECTOR (255 downto 0);
signal B : STD_LOGIC_VECTOR (255 downto 0);
signal C : STD_LOGIC_VECTOR (255 downto 0);
signal D : STD_LOGIC_VECTOR (255 downto 0);
signal E : STD_LOGIC_VECTOR (255 downto 0);
signal F : STD_LOGIC_VECTOR (255 downto 0);
signal G : STD_LOGIC_VECTOR (255 downto 0);
signal H : STD_LOGIC_VECTOR (255 downto 0);
signal I : STD_LOGIC_VECTOR (255 downto 0);
signal J : STD_LOGIC_VECTOR (255 downto 0);
signal K : STD_LOGIC_VECTOR (255 downto 0);
signal L : STD_LOGIC_VECTOR (255 downto 0);
signal M : STD_LOGIC_VECTOR (255 downto 0);
signal N : STD_LOGIC_VECTOR (255 downto 0);
signal O : STD_LOGIC_VECTOR (255 downto 0);
signal P : STD_LOGIC_VECTOR (255 downto 0);
signal Q : STD_LOGIC_VECTOR (255 downto 0);
signal R : STD_LOGIC_VECTOR (255 downto 0);
signal S : STD_LOGIC_VECTOR (255 downto 0);
signal T : STD_LOGIC_VECTOR (255 downto 0);
--BUFF's
signal XBUFF : STD_LOGIC_VECTOR (255 downto 0);
signal YBUFF : STD_LOGIC_VECTOR (255 downto 0);
signal ZBUFF : STD_LOGIC_VECTOR (255 downto 0);


begin

------------------------------
-----Stage 1 Mult's Ports-----
------------------------------

--A(AZ,AZ)
MULT_A : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AZ,
																	 MultiplicandB => AZ,
																	 Product => A);
--B(BZ,BZ)
MULT_B : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => BZ,
																	 MultiplicandB => BZ,
																	 Product => B);
--E(AZ,BZ)
MULT_E : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AZ,
																	 MultiplicandB => BZ,
																	 Product => E);
--L(BZ,AY)
MULT_L : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => BZ,
																	 MultiplicandB => AY,
																	 Product => L);
--M(AZ,BY)
MULT_M : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AZ,
																	 MultiplicandB => BY,
																	 Product => M);

------------------------------
-----Stage 2 Mult's Ports-----
------------------------------

--C(A,BX)
MULT_C : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => A,
																	 MultiplicandB => BX,
																	 Product => C);
--D(B,AX)
MULT_D : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => B,
																	 MultiplicandB => AX,
																	 Product => D);
--N(L,B)
MULT_N : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => L,
																	 MultiplicandB => B,
																	 Product => N);
--O(M,A)
MULT_O : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => M,
																	 MultiplicandB => A,
																	 Product => O);

-----------------------------------
-----Stage 3 Addr-Subt's Ports-----
-----------------------------------

--F(D,C)
SUBT_F : NUMER_FAP_MOD_SUBT_NISTsecp256r1 port map (Minuend => D,
																	 Subtrahend => C,
																	 Difference => F);
--G(C,D)
ADDR_G : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => C,
																	 SummandB => D,
																	 Summation => G);
--P(N,O)
SUBT_P : NUMER_FAP_MOD_SUBT_NISTsecp256r1 port map (Minuend => N,
																	 Subtrahend => O,
																	 Difference => P);

------------------------------
-----Stage 4 Mult's Ports-----
------------------------------

--H(F,F)
MULT_H : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => F,
																	 MultiplicandB => F,
																	 Product => H);
--Q(P,P)
MULT_Q : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => P,
																	 MultiplicandB => P,
																	 Product => Q);
-----Z Ports-----Z(F,E)
MULT_Z : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => F,
																	 MultiplicandB => E,
																	 Product => ZBUFF);

------------------------------
-----Stage 5 Mult's Ports-----
------------------------------

--I(G,H)
MULT_I : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => G,
																	 MultiplicandB => H,
																	 Product => I);
--J(H,F)
MULT_J : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => H,
																	 MultiplicandB => F,
																	 Product => J);
--K(D,H)
MULT_K : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => D,
																	 MultiplicandB => H,
																	 Product => K);

-------------------------
-----Stage 6 X Port-----
-------------------------

--X(Q,I)
SUBT_X : NUMER_FAP_MOD_SUBT_NISTsecp256r1 port map (Minuend => Q,
																	 Subtrahend => I,
																	 Difference => XBUFF);
--CX <= XBUFF;

---------------------------
-----Stage 7 Subt Port-----
---------------------------

--S(K,XBUFF)
SUBT_S : NUMER_FAP_MOD_SUBT_NISTsecp256r1 port map (Minuend => K,
																	 Subtrahend => XBUFF,
																	 Difference => S);

------------------------------
-----Stage 8 Mult's Ports-----
------------------------------

--R(N,J)
MULT_R : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => N,
																	 MultiplicandB => J,
																	 Product => R);
--T(P,S)
MULT_T : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => P,
																	 MultiplicandB => S,
																	 Product => T);

-------------------------
-----Stage 9 Y Port-----
-------------------------

--Y(T,R)
SUBT_Y : NUMER_FAP_MOD_SUBT_NISTsecp256r1 port map (Minuend => T,
																	 Subtrahend => R,
																	 Difference => YBUFF);


process(AX,AY,AZ,BX,BY,BZ)
begin
	if (AZ = ZeroVector) then
		CX <= BX;
		CY <= BY;
		CZ <= BZ;
	elsif (BZ = ZeroVector) then
		CX <= AX;
		CY <= AY;
		CZ <= AZ;
	else
		CX <= XBUFF;
		CY <= YBUFF;
		CZ <= ZBUFF;
	end if;
end process;

end Behavioral;


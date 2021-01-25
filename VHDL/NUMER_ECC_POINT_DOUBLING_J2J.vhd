----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:00:55 03/22/2017 
-- Design Name: 
-- Module Name:    NUMER_ECC_POINT_DOUBLING_J2J - Behavioral 
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

entity NUMER_ECC_POINT_DOUBLING_J2J is
    Port ( AX : in  STD_LOGIC_VECTOR (255 downto 0);
           AY : in  STD_LOGIC_VECTOR (255 downto 0);
           AZ : in  STD_LOGIC_VECTOR (255 downto 0);
           CX : out  STD_LOGIC_VECTOR (255 downto 0);
           CY : out  STD_LOGIC_VECTOR (255 downto 0);
           CZ : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_ECC_POINT_DOUBLING_J2J;

architecture Behavioral of NUMER_ECC_POINT_DOUBLING_J2J is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
--The 2's Compliment of the NIST-secp256r1-Prime
constant PrimeInverse : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
--A 256 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
--A 256 bit vector populated by only zeroes except for bit 0
constant UnitVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
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

--A (A is AYPOW2)
signal A : STD_LOGIC_VECTOR (255 downto 0);
--B
signal AXADD2 : STD_LOGIC_VECTOR (255 downto 0);
signal AXADD4 : STD_LOGIC_VECTOR (255 downto 0);
signal B : STD_LOGIC_VECTOR (255 downto 0);
--C
signal AYPOW4 : STD_LOGIC_VECTOR (255 downto 0);
signal YPOW4ADD2 : STD_LOGIC_VECTOR (255 downto 0);
signal YPOW4ADD4 : STD_LOGIC_VECTOR (255 downto 0);
signal C : STD_LOGIC_VECTOR (255 downto 0);
--D
signal AXPOW2 : STD_LOGIC_VECTOR (255 downto 0);
signal XPOW2ADD2 : STD_LOGIC_VECTOR (255 downto 0);
signal XPOW2ADD3 : STD_LOGIC_VECTOR (255 downto 0);
signal AZPOW2 : STD_LOGIC_VECTOR (255 downto 0);
signal AZPOW4 : STD_LOGIC_VECTOR (255 downto 0);
signal AbyAZPOW4 : STD_LOGIC_VECTOR (255 downto 0);
signal D : STD_LOGIC_VECTOR (255 downto 0);
--X
signal BADDB : STD_LOGIC_VECTOR (255 downto 0);
signal DPOW2 : STD_LOGIC_VECTOR (255 downto 0);
--Y
signal BMINX : STD_LOGIC_VECTOR (255 downto 0);
signal DBYBMINX : STD_LOGIC_VECTOR (255 downto 0);
--Z
signal AYmultAZ : STD_LOGIC_VECTOR (255 downto 0);
--BUFF's
signal XBUFF : STD_LOGIC_VECTOR (255 downto 0);
signal YBUFF : STD_LOGIC_VECTOR (255 downto 0);
signal ZBUFF : STD_LOGIC_VECTOR (255 downto 0);

begin

-----------------
-----A Ports-----
-----------------
--Y^2
MULT_YPOW2 : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AY,
																	    MultiplicandB => AY,
																	    Product => A);

-----------------
-----B Ports-----
-----------------
--4*X
ADDR_2X : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => AX,
																	 SummandB => AX,
																	 Summation => AXADD2);
ADDR_4X : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => AXADD2,
																	 SummandB => AXADD2,
																	 Summation => AXADD4);
--4*X*Y^2
MULT_4XYPOW2 : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AXADD4,
																	      MultiplicandB => A,
																	      Product => B);

-----------------
-----C Ports-----
-----------------
--Y^4
MULT_YPOW4 : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => A,
																	    MultiplicandB => A,
																	    Product => AYPOW4);
--8*Y^4
ADDR_2YPOW4 : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => AYPOW4,
																	     SummandB => AYPOW4,
																	     Summation => YPOW4ADD2);
ADDR_4YPOW4 : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => YPOW4ADD2,
																	     SummandB => YPOW4ADD2,
																	     Summation => YPOW4ADD4);
ADDR_8YPOW4 : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => YPOW4ADD4,
																	     SummandB => YPOW4ADD4,
																	     Summation => C);

-----------------
-----D Ports-----
-----------------
--Z^2
MULT_ZPOW2 : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AZ,
																	    MultiplicandB => AZ,
																	    Product => AZPOW2);
--Z^4
MULT_ZPOW4 : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AZPOW2,
																	    MultiplicandB => AZPOW2,
																	    Product => AZPOW4);
--a*Z^4
MULTAZPOW4 : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => NISTA,
																	    MultiplicandB => AZPOW4,
																	    Product => ABYAZPOW4);
--X^2
MULT_XPOW2 : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AX,
																	    MultiplicandB => AX,
																	    Product => AXPOW2);
--3*X^2
ADDR_2XPOW2 : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => AXPOW2,
																	     SummandB => AXPOW2,
																	     Summation => XPOW2ADD2);
ADDR_3XPOW2 : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => AXPOW2,
																	     SummandB => XPOW2ADD2,
																	     Summation => XPOW2ADD3);
--3*X^2+a*Z^4
ADDR_3XPOW2ADDAZPOW4 : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => XPOW2ADD3,
																					  SummandB => ABYAZPOW4,
																					  Summation => D);

-----------------
-----X Ports-----
-----------------

MULT_DBYD : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => D,
																	   MultiplicandB => D,
																	   Product => DPOW2);
ADDR_BBYB : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => B,
																	   SummandB => B,
																	   Summation => BADDB);
SUBT_BBYB : NUMER_FAP_MOD_SUBT_NISTsecp256r1 port map (Minuend => DPOW2,
																	   Subtrahend => BADDB,
																	   Difference => XBUFF);	

-----------------
-----Y Ports-----
-----------------

SUBT_BBYX : NUMER_FAP_MOD_SUBT_NISTsecp256r1 port map (Minuend => B,
																	   Subtrahend => XBUFF,
																	   Difference => BMINX);
MULT_DBYBMINX : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => D,
																			 MultiplicandB => BMINX,
																			 Product => DBYBMINX);
SUBT_DBYBMINXMINCX : NUMER_FAP_MOD_SUBT_NISTsecp256r1 port map (Minuend => DBYBMINX,
																					Subtrahend => C,
																					Difference => YBUFF);

-----------------
-----Z Ports-----
-----------------

MULT_Z1 : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => AY,
																	 MultiplicandB => AZ,
																	 Product => AYmultAZ);
ADDR_Z1 : NUMER_FAP_MOD_ADDR_NISTsecp256r1 port map (SummandA => AY,
																	 SummandB => AZ,
																	 Summation => ZBUFF);

process(AX,AY,AZ)
begin
	if (AZ = ZeroVector) then
		CX <= AX;
		CY <= AY;
		CZ <= AZ;
	elsif (AY = ZeroVector) then
		CX <= UnitVector;
		CY <= UnitVector;
		CZ <= ZeroVector;
	else
		CX <= XBUFF;
		CY <= YBUFF;
		CZ <= ZBUFF;
	end if;
end process;

end Behavioral;


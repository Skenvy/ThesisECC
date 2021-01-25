----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:28:59 03/27/2017 
-- Design Name: 
-- Module Name:    NUMER_ECC_POINT_MULTIPLY_NISTsecp256r1_2 - Behavioral 
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


entity NUMER_ECC_POINT_MULTIPLY_NISTsecp256r1_2 is
    Port ( k : in  STD_LOGIC_VECTOR (255 downto 0);
           PX : in  STD_LOGIC_VECTOR (255 downto 0);
           PY : in  STD_LOGIC_VECTOR (255 downto 0);
           QX : out  STD_LOGIC_VECTOR (255 downto 0);
           QY : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_ECC_POINT_MULTIPLY_NISTsecp256r1_2;

architecture Behavioral of NUMER_ECC_POINT_MULTIPLY_NISTsecp256r1_2 is

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

component NUMER_ECC_COORD_A2J is
    Port ( PY : in  STD_LOGIC_VECTOR (255 downto 0);
           PX : in  STD_LOGIC_VECTOR (255 downto 0);
           QY : out  STD_LOGIC_VECTOR (255 downto 0);
           QX : out  STD_LOGIC_VECTOR (255 downto 0);
           QZ : out  STD_LOGIC_VECTOR (255 downto 0));
end component;

component NUMER_ECC_COORD_J2A_NISTsecp256r1 is
    Port ( PX : in  STD_LOGIC_VECTOR (255 downto 0);
           PY : in  STD_LOGIC_VECTOR (255 downto 0);
           PZ : in  STD_LOGIC_VECTOR (255 downto 0);
           QX : out  STD_LOGIC_VECTOR (255 downto 0);
           QY : out  STD_LOGIC_VECTOR (255 downto 0));
end component;

component NUMER_ECC_POINT_DOUBLING_J2J is
    Port ( AX : in  STD_LOGIC_VECTOR (255 downto 0);
           AY : in  STD_LOGIC_VECTOR (255 downto 0);
           AZ : in  STD_LOGIC_VECTOR (255 downto 0);
           CX : out  STD_LOGIC_VECTOR (255 downto 0);
           CY : out  STD_LOGIC_VECTOR (255 downto 0);
           CZ : out  STD_LOGIC_VECTOR (255 downto 0));
end component;

component NUMER_ECC_POINT_ADDITION_J1J2J is
    Port ( AX : in  STD_LOGIC_VECTOR (255 downto 0);
           AY : in  STD_LOGIC_VECTOR (255 downto 0);
           AZ : in  STD_LOGIC_VECTOR (255 downto 0);
           BX : in  STD_LOGIC_VECTOR (255 downto 0);
           BY : in  STD_LOGIC_VECTOR (255 downto 0);
           BZ : in  STD_LOGIC_VECTOR (255 downto 0);
           CX : out  STD_LOGIC_VECTOR (255 downto 0);
           CY : out  STD_LOGIC_VECTOR (255 downto 0);
           CZ : out  STD_LOGIC_VECTOR (255 downto 0));
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--MemoryDataLine
signal MemDoublingX : STD_LOGIC_VECTOR (255 downto 0);
signal MemDoublingY : STD_LOGIC_VECTOR (255 downto 0);
signal MemDoublingZ : STD_LOGIC_VECTOR (255 downto 0);
signal MemAddingX : STD_LOGIC_VECTOR (255 downto 0);
signal MemAddingY : STD_LOGIC_VECTOR (255 downto 0);
signal MemAddingZ : STD_LOGIC_VECTOR (255 downto 0);
--InternalJacobianInputOutputs
signal JPX : STD_LOGIC_VECTOR (255 downto 0);
signal JPY : STD_LOGIC_VECTOR (255 downto 0);
signal JPZ : STD_LOGIC_VECTOR (255 downto 0);
signal JQX : STD_LOGIC_VECTOR (255 downto 0);
signal JQY : STD_LOGIC_VECTOR (255 downto 0);
signal JQZ : STD_LOGIC_VECTOR (255 downto 0);
--Temporal Adder Inputs and Outputs
signal ADDRAX : STD_LOGIC_VECTOR (255 downto 0);
signal ADDRAY : STD_LOGIC_VECTOR (255 downto 0);
signal ADDRAZ : STD_LOGIC_VECTOR (255 downto 0);
signal ADDRBX : STD_LOGIC_VECTOR (255 downto 0);
signal ADDRBY : STD_LOGIC_VECTOR (255 downto 0);
signal ADDRBZ : STD_LOGIC_VECTOR (255 downto 0);
signal ADDRCX : STD_LOGIC_VECTOR (255 downto 0);
signal ADDRCY : STD_LOGIC_VECTOR (255 downto 0);
signal ADDRCZ : STD_LOGIC_VECTOR (255 downto 0);
--Temporal Doubling Inputs and Outputs
signal DOUBAX : STD_LOGIC_VECTOR (255 downto 0);
signal DOUBAY : STD_LOGIC_VECTOR (255 downto 0);
signal DOUBAZ : STD_LOGIC_VECTOR (255 downto 0);
signal DOUBCX : STD_LOGIC_VECTOR (255 downto 0);
signal DOUBCY : STD_LOGIC_VECTOR (255 downto 0);
signal DOUBCZ : STD_LOGIC_VECTOR (255 downto 0);

signal StableOutput : STD_LOGIC;
signal PreviousK : STD_LOGIC_VECTOR(4 downto 0);
signal InternalJQX : STD_LOGIC_VECTOR(4 downto 0);
signal InternalJQY : STD_LOGIC_VECTOR(4 downto 0);
signal InternalJQZ : STD_LOGIC_VECTOR(4 downto 0);
signal PreviousJPX : STD_LOGIC_VECTOR(4 downto 0);
signal PreviousJPY : STD_LOGIC_VECTOR(4 downto 0);
signal PreviousJPZ : STD_LOGIC_VECTOR(4 downto 0);

signal Jindex : STD_LOGIC_VECTOR(4 downto 0);
signal JComplete : STD_LOGIC_VECTOR(4 downto 0);

begin

--Conversion In
ConvertIn : NUMER_ECC_COORD_A2J port map (PX => PX,
														PY => PY,
														QX => JPX,
														QY => JPY,
														QZ => JPZ);

--Conversion Out
ConvertOut : NUMER_ECC_COORD_J2A_NISTsecp256r1 port map (PX => JQX,
																			PY => JQY,
																			PZ => JQZ,
																			QX => QX,
																			QY => QY);

JQX <= InternalJQX when StableOutput = '1' else (others => 'Z');
JQY <= InternalJQY when StableOutput = '1' else (others => 'Z');
JQZ <= InternalJQZ when StableOutput = '1' else (others => 'Z');

ADDRAX <= MemAddingX;
ADDRAY <= MemAddingY;
ADDRAZ <= MemAddingZ;
ADDRBX <= MemDoublingX;
ADDRBY <= MemDoublingY;
ADDRBZ <= MemDoublingZ;
DOUBAX <= MemDoublingX;
DOUBAY <= MemDoublingY;
DOUBAZ <= MemDoublingZ;

process(CLK)
begin
	if	(rising_edge(CLK)) then
		if ((PreviousJPX = JPX) and (PreviousJPY = JPY) and (PreviousJPZ = JPZ) and (PreviousK = K)) then --If the Inputs are stable
			if (JComplete = K) then --If end condition met, put output
				InternalJQX <= MemAddingX;
				InternalJQY <= MemAddingY;
				InternalJQZ <= MemAddingZ;
				StableOutput <= '1';
			else --Else, if the inputs are stable, do the update.
				if ((Jindex and K) /= ZeroVector) then --if adding bit, then do the adding
					MemAddingX <= ADDRCX;
					MemAddingY <= ADDRCY;
					MemAddingZ <= ADDRCZ;
				end if; --Do the doubling unambiguously.
				MemDoublingX <= DOUBCX;
				MemDoublingY <= DOUBCY;
				MemDoublingZ <= DOUBCZ;
				Jindex <= STD_LOGIC_VECTOR(shift_left(unsigned(Jindex),1));
				JComplete <= STD_LOGIC_VECTOR(unsigned(JComplete) + unsigned(JIndex and K));
			end if;
		else --Else, reset the signals and begin updates again.
			--Stability Checkers
			PreviousJPX <= JPX;
			PreviousJPY <= JPY;
			PreviousJPZ <= JPZ;
			PreviousK <= K;
			StableOutput <= '0';
			--Inititialise N (Doubling Feedback) and Q (Adder Feedback) and the index
			MemDoublingX <= JPX;
			MemDoublingY <= JPY;
			MemDoublingZ <= JPZ;
			MemAddingX <= UnitVector;
			MemAddingY <= UnitVector;
			MemAddingZ <= ZeroVector;
			Jindex <= UnitVector;
			JComplete <= ZeroVector;
		end if;	
	end if;
end process;

--N ? P
--Q ? 0
--for i from 0 to m do
--   if di = 1 then
--       Q ? point_add(Q, N)
--   N ? point_double(N)
--return Q

--The adder cell
ADDR : NUMER_ECC_POINT_ADDITION_J1J2J port map (AX => ADDRAX,
																AY => ADDRAY,
																AZ => ADDRAZ,
																BX => ADDRBX,
																BY => ADDRBY,
																BZ => ADDRBZ,
																CX => ADDRCX,
																CY => ADDRCY,
																CZ => ADDRCZ);

--The doubling cell
DOUB : NUMER_ECC_POINT_DOUBLING_J2J port map (AX => DOUBAX,
															 AY => DOUBAY,
															 AZ => DOUBAZ,
															 CX => DOUBCX,
															 CY => DOUBCY,
															 CZ => DOUBCZ);


end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:44:27 03/23/2017 
-- Design Name: 
-- Module Name:    NUMER_ECC_POINT_MULTIPLY_NISTsecp256r1 - Behavioral 
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

entity NUMER_ECC_POINT_MULTIPLY_NISTsecp256r1 is
    Port ( k : in  STD_LOGIC_VECTOR (255 downto 0);
           PX : in  STD_LOGIC_VECTOR (255 downto 0);
           PY : in  STD_LOGIC_VECTOR (255 downto 0);
           QX : out  STD_LOGIC_VECTOR (255 downto 0);
           QY : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_ECC_POINT_MULTIPLY_NISTsecp256r1;

architecture Behavioral of NUMER_ECC_POINT_MULTIPLY_NISTsecp256r1 is

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

component STRUC_UTIL_RAM_256 is
    Port ( WE : in  STD_LOGIC;
			  RE : in  STD_LOGIC;
           Data : inout  STD_LOGIC_VECTOR (255 downto 0));
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
signal MemSideChanX : STD_LOGIC_VECTOR (255 downto 0);
signal MemSideChanY : STD_LOGIC_VECTOR (255 downto 0);
signal MemSideChanZ : STD_LOGIC_VECTOR (255 downto 0);
--MemoryCellControls
signal DoubleWE : STD_LOGIC;
signal DoubleRE : STD_LOGIC;
signal AddingWE : STD_LOGIC;
signal AddingRE : STD_LOGIC;
signal SideChanWE : STD_LOGIC;
signal SideChanRE : STD_LOGIC;
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

begin

--Memory Cells--
--Doubling
RamDoublingX : STRUC_UTIL_RAM_256 port map (WE => DoubleWE,
														  RE => DoubleRE,
														  Data => MemDoublingX);
RamDoublingY : STRUC_UTIL_RAM_256 port map (WE => DoubleWE,
														  RE => DoubleRE,
														  Data => MemDoublingY);
RamDoublingZ : STRUC_UTIL_RAM_256 port map (WE => DoubleWE,
														  RE => DoubleRE,
														  Data => MemDoublingZ);
--Adding
RamAddingX : STRUC_UTIL_RAM_256 port map (WE => AddingWE,
														RE => AddingRE,
														Data => MemAddingX);
RamAddingY : STRUC_UTIL_RAM_256 port map (WE => AddingWE,
														RE => AddingRE,
														Data => MemAddingY);
RamAddingZ : STRUC_UTIL_RAM_256 port map (WE => AddingWE,
														RE => AddingRE,
														Data => MemAddingZ);
--SideChanneling
RamSideChanX : STRUC_UTIL_RAM_256 port map (WE => SideChanWE,
														  RE => SideChanRE,
														  Data => MemSideChanX);
RamSideChanY : STRUC_UTIL_RAM_256 port map (WE => SideChanWE,
														  RE => SideChanRE,
														  Data => MemSideChanY);
RamSideChanZ : STRUC_UTIL_RAM_256 port map (WE => SideChanWE,
														  RE => SideChanRE,
														  Data => MemSideChanZ);

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

--Multiplication in Jacobian
process(DoubleWE,DoubleRE,AddingWE,AddingRE,SideChanWE,SideChanRE,k,JPX,JPY,JPZ,MemDoublingX,MemDoublingY,MemDoublingZ,
		  MemAddingX,MemAddingY,MemAddingZ,ADDRAX,ADDRAY,ADDRAZ,ADDRBX,ADDRBY,ADDRBZ,ADDRCX,ADDRCY,ADDRCZ,DOUBAX,DOUBAY,DOUBAZ,
		  DOUBCX,DOUBCY,DOUBCZ,MemAddingX,MemAddingY,MemAddingZ)
begin
	--Open for writing
	AddingWE <= '1';
	AddingRE <= '0';
	DoubleWE <= '1';
	DoubleRE <= '0';
	--Write
	MemDoublingX <= JPX;
	MemDoublingY <= JPY;
	MemDoublingZ <= JPZ;
	MemAddingX <= ZeroVector; --Make this the identity of Jacobian Projective Addition
	MemAddingY <= ZeroVector; --Make this the identity of Jacobian Projective Addition
	MemAddingZ <= ZeroVector; --Make this the identity of Jacobian Projective Addition
	--Close writing, open for reading
	AddingWE <= '0';
	AddingRE <= '1';
	DoubleWE <= '0';
	DoubleRE <= '1';
	--Force Impedence to allow reading
	MemDoublingX <= (others => 'Z');
	MemDoublingY <= (others => 'Z');
	MemDoublingZ <= (others => 'Z');
	MemAddingX <= (others => 'Z');
	MemAddingY <= (others => 'Z');
	MemAddingZ <= (others => 'Z');
	for H in 0 to 255 loop
		if (k(H) = '1') then
			--Read from the memory into the ports
			ADDRAX <= MemDoublingX;
			ADDRAY <= MemDoublingY;
			ADDRAZ <= MemDoublingZ;
			ADDRBX <= MemAddingX;
			ADDRBY <= MemAddingY;
			ADDRBZ <= MemAddingZ;
			--Open for writing
			AddingWE <= '1';
			AddingRE <= '0';
			--Write to
			MemAddingX <= ADDRCX;
			MemAddingY <= ADDRCY;
			MemAddingZ <= ADDRCZ;
			--Close Writing, open for reading
			AddingWE <= '0';
			AddingRE <= '1';
			--Force Impedence to allow reading
			MemAddingX <= (others => 'Z');
			MemAddingY <= (others => 'Z');
			MemAddingZ <= (others => 'Z');
		else --The else doesn't contribute to the algorithm, only depletes a side channel attack
			--Read from the memory into the ports
			ADDRAX <= MemDoublingX;
			ADDRAY <= MemDoublingY;
			ADDRAZ <= MemDoublingZ;
			ADDRBX <= MemAddingX;
			ADDRBY <= MemAddingY;
			ADDRBZ <= MemAddingZ;
			--Open for writing
			SideChanWE <= '1';
			SideChanRE <= '0';
			--Write to
			MemSideChanX <= ADDRCX;
			MemSideChanY <= ADDRCY;
			MemSideChanZ <= ADDRCZ;
			--Close Writing, open for reading
			SideChanWE <= '0';
			SideChanRE <= '1';
			--Force Impedence to allow reading
			MemSideChanX <= (others => 'Z');
			MemSideChanY <= (others => 'Z');
			MemSideChanZ <= (others => 'Z');
		end if;
		--Read from the memory into the ports
		DOUBAX <= MemDoublingX;
		DOUBAY <= MemDoublingY;
		DOUBAZ <= MemDoublingZ;
		--Open for writing
		DoubleWE <= '1';
		DoubleRE <= '0';
		--Write to
		MemDoublingX <= DOUBCX;
		MemDoublingY <= DOUBCY;
		MemDoublingZ <= DOUBCZ;
		--Close Writing, open for reading
		DoubleWE <= '0';
		DoubleRE <= '1';
		--Force Impedence to allow reading
		MemDoublingX <= (others => 'Z');
		MemDoublingY <= (others => 'Z');
		MemDoublingZ <= (others => 'Z');
	end loop;
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


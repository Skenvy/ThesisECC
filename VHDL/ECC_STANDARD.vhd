--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package ECC_STANDARD is

--NIST-secp256r1
constant Prime_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
constant Prime_NISTsecp256r1_2Compliment : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
constant A_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFC";
constant B_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"5AC6_35D8_AA3A_93E7_B3EB_BD55_7698_86BC_651D_06B0_CC53_B0F6_3BCE_3C3E_27D2_604B";

--Module over '17'
constant Prime_M17 : STD_LOGIC_VECTOR (4 downto 0) := "10001";
constant Prime_M17_2Compliment : STD_LOGIC_VECTOR (4 downto 0) := "01111";
constant A_M17 : STD_LOGIC_VECTOR (4 downto 0) := "00010";
constant B_M17 : STD_LOGIC_VECTOR (4 downto 0) := "00010";


----current standard being used;
--constant FieldLength : natural := 5;
--constant Prime :STD_LOGIC_VECTOR ((FieldLength - 1) downto 0) := Prime_M17;
--constant Prime_2Compliment :STD_LOGIC_VECTOR ((FieldLength - 1) downto 0) := Prime_M17_2Compliment;
--constant ECC_A :STD_LOGIC_VECTOR ((FieldLength - 1) downto 0) := A_M17;
--constant ECC_B :STD_LOGIC_VECTOR ((FieldLength - 1) downto 0) := B_M17;

--current standard being used;
constant FieldLength : natural := 256;
constant Prime :STD_LOGIC_VECTOR ((FieldLength - 1) downto 0) := Prime_NISTsecp256r1;
constant Prime_2Compliment :STD_LOGIC_VECTOR ((FieldLength - 1) downto 0) := Prime_NISTsecp256r1_2Compliment;
constant ECC_A :STD_LOGIC_VECTOR ((FieldLength - 1) downto 0) := A_NISTsecp256r1;
constant ECC_B :STD_LOGIC_VECTOR ((FieldLength - 1) downto 0) := B_NISTsecp256r1;


end ECC_STANDARD;

package body ECC_STANDARD is
 
end ECC_STANDARD;

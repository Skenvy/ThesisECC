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
use work.VECTOR_STANDARD.ALL;

package ECC_STANDARD is

--NIST-secp256r1
constant Prime_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
constant Prime_NISTsecp256r1_2Compliment : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
constant A_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFC";
constant B_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"5AC6_35D8_AA3A_93E7_B3EB_BD55_7698_86BC_651D_06B0_CC53_B0F6_3BCE_3C3E_27D2_604B";
constant GX_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"6B17_D1F2_E12C_4247_F8BC_E6E5_63A4_40F2_7703_7D81_2DEB_33A0_F4A1_3945_D898_C296";
constant GY_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"4FE3_42E2_FE1A_7F9B_8EE7_EB4A_7C0F_9E16_2BCE_3357_6B31_5ECE_CBB6_4068_37BF_51F5";
constant N_NISTsecp256r1 : STD_LOGIC_VECTOR (255 downto 0) := X"FFFFFFFF_00000000_FFFFFFFF_FFFFFFFF_BCE6FAAD_A7179E84_F3B9CAC2_FC632551";

--Declare types of generic size!

--NIST-secp224r1
constant Prime_NISTsecp224r1 : STD_LOGIC_VECTOR (224 downto 0) := X"FFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF_00000000_00000000_00000001";
--constant Prime_NISTsecp224r1_2Compliment : STD_LOGIC_VECTOR (224 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
--constant A_NISTsecp224r1 : STD_LOGIC_VECTOR (224 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFC";
--constant B_NISTsecp224r1 : STD_LOGIC_VECTOR (224 downto 0) := X"5AC6_35D8_AA3A_93E7_B3EB_BD55_7698_86BC_651D_06B0_CC53_B0F6_3BCE_3C3E_27D2_604B";
--constant GX_NISTsecp224r1 : STD_LOGIC_VECTOR (224 downto 0) := X"6B17_D1F2_E12C_4247_F8BC_E6E5_63A4_40F2_7703_7D81_2DEB_33A0_F4A1_3945_D898_C296";
--constant GY_NISTsecp224r1 : STD_LOGIC_VECTOR (224 downto 0) := X"4FE3_42E2_FE1A_7F9B_8EE7_EB4A_7C0F_9E16_2BCE_3357_6B31_5ECE_CBB6_4068_37BF_51F5";
--constant N_NISTsecp224r1 : STD_LOGIC_VECTOR (224 downto 0) := X"FFFFFFFF_00000000_FFFFFFFF_FFFFFFFF_BCE6FAAD_A7179E84_F3B9CAC2_FC632551";

--Module over '17'
constant Prime_M17 : STD_LOGIC_VECTOR (4 downto 0) := "10001";
constant Prime_M17_2Compliment : STD_LOGIC_VECTOR (4 downto 0) := "01111";
constant A_M17 : STD_LOGIC_VECTOR (4 downto 0) := "00010";
constant B_M17 : STD_LOGIC_VECTOR (4 downto 0) := "00010";
constant GX_M17 : STD_LOGIC_VECTOR (4 downto 0) := "00111";
constant GY_M17 : STD_LOGIC_VECTOR (4 downto 0) := "00110";

--current standard being used;
--constant Prime :STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := Prime_M17;
--constant Prime_2Compliment :STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := Prime_M17_2Compliment;
--constant ECC_A :STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := A_M17;
--constant ECC_B :STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := B_M17;

--current standard being used;
--constant Prime :STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := Prime_NISTsecp256r1;
--constant Prime_2Compliment :STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := Prime_NISTsecp256r1_2Compliment;
--constant ECC_A :STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := A_NISTsecp256r1;
--constant ECC_B :STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := B_NISTsecp256r1;


end ECC_STANDARD;

package body ECC_STANDARD is
 
end ECC_STANDARD;

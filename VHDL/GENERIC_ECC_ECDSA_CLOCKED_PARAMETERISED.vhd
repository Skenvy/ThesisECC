----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:11:46 06/05/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED - Behavioral 
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

entity GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED is
    Generic (N : natural := VecLen; --VecLen  must match Parameter Size
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false;
				 ParameterSet : ECC_Parameters_5 := M17); --Parameter Size must match VecLen
    Port ( DATABUS : inout  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
           RW : in STD_LOGIC;
			  --0: Reading From
			  --1: Writing To
           LacthToReadFrom : in STD_LOGIC_VECTOR (5 downto 0);
			  --0000: Curve_Prime [((2*N)-1) downto N] & Curve_A [(N-1) downto 0]
			  --0001: Curve_GX [((2*N)-1) downto N] & Curve_GY [(N-1) downto 0]
			  --0010: Curve_B [((2*N)-1) downto N] & Curve_N [(N-1) downto 0]
			  --0011: -
			  --0100: Key_Private [(N-1) downto 0]
			  --0101: Key_Public_X [((2*N)-1) downto N] & Key_Public_Y [(N-1) downto 0]
			  --		 Note this is the Public key corresponding to the private key
			  --0110: Key_Public_X [((2*N)-1) downto N] & Key_Public_Y [(N-1) downto 0]
			  --		 Note that this is not the public key corresponding to the private key
			  --		 It is another entity's public key for use in DHKE
			  --0111: Key_Shared_X [((2*N)-1) downto N] & Key_Shared_Y [(N-1) downto 0]
			  --1000: Signature_R [((2*N)-1) downto N] & Signature_S [(N-1) downto 0]
			  --1001: Signature_K
			  --		 A register that can hold a precomputed Signature_K
			  --1010: HASH Total
			  --		 A register that can hold a precomputed hash value
			  --1011: HASH Input
			  OtherUserRegister : in STD_LOGIC_VECTOR(3 downto 0);
			  --Indicates to the ECDH, Public and Shared Key registers what user is being flagged. 
			  HashStrobeIn : in STD_LOGIC;
			  --Indicates to the HASH next input is ready
			  HashStrobeOut : Out STD_LOGIC;
			  --Used by the HASH to request the next input
			  Precomputed : in STD_LOGIC_VECTOR (1 downto 0);
			  --Position 0: Precomputed Hash
			  --Position 1: Precomputed Signature_K
			  Command : in STD_LOGIC_VECTOR (2 downto 0);
			  --000: Not operating anything, In RW mode
			  --001: Generate Key_Private; PRNG(1,(N-1))
			  --010: Generate Key_Public
			  --011: ECDH
			  --100: HASH
			  --101: Generate Signature_K; PRNG(1,(N-1))
			  --110: ECDSA-SGA
			  --111: ECDSA_SVA
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC;
			  Error : out STD_LOGIC_VECTOR(3 downto 0));
end GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED;

architecture Behavioral of GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED is

COMPONENT GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED
Generic (N : natural;
			M : Natural;
			AddrDelay : Time;
			CompDelay : Time;
			Toomed : Boolean);
Port ( KEY : in  STD_LOGIC_VECTOR ((N-1) downto 0);
       APX : in STD_LOGIC_VECTOR ((N-1) downto 0);
       APY : in STD_LOGIC_VECTOR ((N-1) downto 0);
       AQX : out STD_LOGIC_VECTOR ((N-1) downto 0);
       AQY : out STD_LOGIC_VECTOR ((N-1) downto 0);
		 Modulus : In  STD_LOGIC_VECTOR ((N-1) downto 0);
		 ECC_A : In  STD_LOGIC_VECTOR ((N-1) downto 0);
		 CLK : IN STD_LOGIC;
		 StableOutput : out STD_LOGIC);
END COMPONENT;

component GENERIC_FAP_MODINVR_CLOCKED
	 Generic (N : natural := VecLen;
				 M : natural := MultLen;
				 AddrDelay : Time := 30 ns);
    Port ( Element : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Inverse : out  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC);
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

component GENERIC_FAP_MODADDR
	 Generic (N : natural;
				 M : natural); --Terminal Length
    Port ( SummandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           SummandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0); --Modulo.
           Summation : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end component;

begin


end Behavioral;


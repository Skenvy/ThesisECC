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
    Port ( DATABUS : inout  STD_LOGIC_VECTOR (((2*N)-1) downto 0) := (others => '0');
           RW : in STD_LOGIC;
			  --0: Reading From
			  --1: Writing To
           LacthToReadFrom : in STD_LOGIC_VECTOR (3 downto 0);
			  --0000: Curve_Prime [((2*N)-1) downto N] & Curve_A [(N-1) downto 0]
			  --0001: Curve_GX [((2*N)-1) downto N] & Curve_GY [(N-1) downto 0]
			  --0010: Curve_B [((2*N)-1) downto N] & Curve_N [(N-1) downto 0]
			  --0011: -
			  --0100: Key_Private [(N-1) downto 0]
			  --0101: Key_Public_User_X [((2*N)-1) downto N] & Key_Public_User_Y [(N-1) downto 0]
			  --		 Note this is the Public key corresponding to the private key
			  --0110: Key_Public_Other_X [((2*N)-1) downto N] & Key_Public_Other_Y [(N-1) downto 0]
			  --		 Note that this is not the public key corresponding to the private key
			  --		 It is another entity's public key for use in DHKE
			  --0111: Key_Shared_X [((2*N)-1) downto N] & Key_Shared_Y [(N-1) downto 0]
			  --1000: Signature_R [((2*N)-1) downto N] & Signature_S [(N-1) downto 0]
			  --1001: Signature_K [(N-1) downto 0]
			  --		 A register that can hold a precomputed Signature_K
			  --1010: HASH_Total [(N-1) downto 0]
			  --		 A register that can hold a precomputed hash value
			  --1011: HASH_Input [((2*N)-1) downto 0]
			  OtherUserRegister : in STD_LOGIC_VECTOR(3 downto 0);
			  --Indicates to the ECDH, Public and Shared Key registers what user is being flagged. 
			  HashStrobeIn : in STD_LOGIC_VECTOR(1 downto 0);
			  --Indicates to the HASH next input is ready (0), or that the the Last input is ready (1)
			  HashStrobeOut : Out STD_LOGIC;
			  --Used by the HASH to request the next input
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

component GENERIC_ECC_JACOBIAN_POINT_ADDITION_CLOCKED is
    Generic (NGen : natural;
				 MGen : Natural;
				 AddrDelay : Time;
				 CompDelay : Time;
				 Toomed : Boolean);
    Port ( AX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end component;

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

component GENERIC_UTIL_RAM_CLOCKED
	 Generic (N : natural);
    Port ( RW : in  STD_LOGIC; --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data : inout  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC);
end component;

signal DATABUSIN : STD_LOGIC_VECTOR (((2*N)-1) downto 0);
signal CLK_QUAD : STD_LOGIC_VECTOR (1 downto 0) := "00";

----------------------
--PM and Inverter IO--
----------------------

signal PM_KEY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_APX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_APY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_AQX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_AQY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_Modulus : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_ECC_A : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_StableOutput : STD_LOGIC;
signal INV_ELEMENT : STD_LOGIC_VECTOR ((N-1) downto 0) := UnitVector;
signal INV_INVERSE : STD_LOGIC_VECTOR ((N-1) downto 0);
signal INV_MODULUS : STD_LOGIC_VECTOR ((N-1) downto 0) := (1 => '1', others => '0');
signal DSA_INVERSE : STD_LOGIC_VECTOR ((N-1) downto 0); --Holds the output from the port map
signal INV_INVERSE_STABLE : STD_LOGIC;

-----------------------
--Command Stabilities--
-----------------------
signal COMMAND_STABILITY : STD_LOGIC;
signal COMMAND_PREVIOUS : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
--001: Generate_Key_Private; PRNG(1,(N-1)) 
signal STABILITY_Generate_Key_Private : STD_LOGIC := '0';
--010: Generate_Key_Public 
signal STABILITY_Generate_Key_Public : STD_LOGIC := '0';
--011: ECDH
signal STABILITY_ECDH : STD_LOGIC := '0';
--100: HASH 
signal STABILITY_HASH : STD_LOGIC := '0';
--101: Generate_Signature_K; PRNG(1,(N-1)) 
signal STABILITY_Generate_Signature_K : STD_LOGIC := '0';
--110: ECDSA_SGA 
signal STABILITY_ECDSA_SGA : STD_LOGIC := '0';
--111: ECDSA_SVA
signal STABILITY_ECDSA_SVA : STD_LOGIC := '0';
-----------------
--DSA Registers--
-----------------
--DSA ROUNDS
signal STABILITY_ECDSA_ROUNDS : STD_LOGIC_VECTOR(21 downto 0) := (others => '0');
signal DSA_PM_ByG_X : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_PM_ByG_Y : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_PM_ByQ_X : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_PM_ByQ_Y : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_PA_GwQ_X : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_PA_GwQ_Y : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTU_A : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTU_B : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTU_P : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTU_M : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_U : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTU_STABLE : STD_LOGIC;
signal DSA_MULTV_A : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTV_B : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTV_P : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTV_M : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_V : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTV_STABLE : STD_LOGIC;
signal DSA_ADDRW_A : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_ADDRW_B : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_ADDRW_S : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_W : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal SIGNATURE_STABLILITY_CHECK : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal SIGNATURE_STABLE : STD_LOGIC;
signal SIGNATURE_R : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JPA_JQX : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JPA_JQY : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JPA_JQZ : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JPA_STABLE : STD_LOGIC;
signal DSA_JQX : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JQY : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JQZ : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JQZ_INV : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JQZ_INV_SQUARED : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_JQZ_INV_CUBED : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal SIGNATURE_VERIFY : STD_LOGIC;
signal SIGNATURE_VERIFIED : STD_LOGIC;
signal OP_UNIVERSAL : STD_LOGIC := '0';
signal OP_PHASELOCK : STD_LOGIC_VECTOR (1 downto 0) := "11";
-------
--RW!--
-------
signal RW_MODE : STD_LOGIC := '0';
signal RW_UNIVERSAL : STD_LOGIC := '0';
signal RW_PHASELOCK : STD_LOGIC_VECTOR (1 downto 0) := "11";
signal RW_IO_TRADEOVER : STD_LOGIC := '0';
--0000: Curve_Prime [((2*N)-1) downto N] & Curve_A [(N-1) downto 0]
signal RW_Curve_Prime : STD_LOGIC := '0';
signal DATA_Curve_Prime : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
signal RW_Curve_A : STD_LOGIC := '0';
signal DATA_Curve_A : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--0001: Curve_GX [((2*N)-1) downto N] & Curve_GY [(N-1) downto 0]
signal RW_Curve_GX : STD_LOGIC := '0';
signal DATA_Curve_GX : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
signal RW_Curve_GY : STD_LOGIC := '0';
signal DATA_Curve_GY : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--0010: Curve_B [((2*N)-1) downto N] & Curve_N [(N-1) downto 0]
signal RW_Curve_B : STD_LOGIC := '0';
signal DATA_Curve_B : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
signal RW_Curve_N : STD_LOGIC := '0';
signal DATA_Curve_N : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--0100: Key_Private [(N-1) downto 0]
signal RW_Key_Private : STD_LOGIC := '0';
signal DATA_Key_Private : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--0101: Key_Public_User_X [((2*N)-1) downto N] & Key_Public_User_Y [(N-1) downto 0]
signal RW_Key_Public_User_X : STD_LOGIC := '0';
signal DATA_Key_Public_User_X : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
signal RW_Key_Public_User_Y : STD_LOGIC := '0';
signal DATA_Key_Public_User_Y : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--0110: Key_Public_Other_X [((2*N)-1) downto N] & Key_Public_Other_Y [(N-1) downto 0]
signal RW_Key_Public_Other_X : STD_LOGIC := '0';
signal DATA_Key_Public_Other_X : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
signal RW_Key_Public_Other_Y : STD_LOGIC := '0';
signal DATA_Key_Public_Other_Y : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--0111: Key_Shared_X [((2*N)-1) downto N] & Key_Shared_Y [(N-1) downto 0]
signal RW_Key_Shared_X : STD_LOGIC := '0';
signal DATA_Key_Shared_X : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
signal RW_Key_Shared_Y : STD_LOGIC := '0';
signal DATA_Key_Shared_Y : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--1000: Signature_R [((2*N)-1) downto N] & Signature_S [(N-1) downto 0]
signal RW_Signature_R : STD_LOGIC := '0';
signal DATA_Signature_R : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
signal RW_Signature_S : STD_LOGIC := '0';
signal DATA_Signature_S : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--1001: Signature_K [(N-1) downto 0]
signal RW_Signature_K : STD_LOGIC := '0';
signal DATA_Signature_K : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--1010: HASH_Total [((2*N)-1) downto 0]
signal RW_HASH_Total : STD_LOGIC := '0';
signal DATA_HASH_Total : STD_LOGIC_VECTOR ((N-1) downto 0) := ZeroVector;
--1011: HASH_Input [((2*N)-1) downto 0]
signal RW_HASH_Input : STD_LOGIC := '0';
signal DATA_HASH_Input : STD_LOGIC_VECTOR (((2*N)-1) downto 0) := (others => '0');

begin

--------------------------------------------------------------------------
---------------------------DATA CELLS: RW PINS----------------------------
--------------------------------------------------------------------------

RW_MODE <= ((not Command(0)) and (not Command(1)) and (not Command(2)));
RW_UNIVERSAL <= (RW and (RW_PHASELOCK(1) xor RW_PHASELOCK(0)) and RW_MODE);
OP_UNIVERSAL <= (OP_PHASELOCK(1) xor OP_PHASELOCK(0));
--0000: Curve_Prime [((2*N)-1) downto N] & Curve_A [(N-1) downto 0] --No Command Writes to these
RW_Curve_Prime <= (RW_UNIVERSAL and ((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0))));
RW_Curve_A <= (RW_UNIVERSAL and ((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0))));
--0001: Curve_GX [((2*N)-1) downto N] & Curve_GY [(N-1) downto 0] --No Command Writes to these
RW_Curve_GX <= (RW_UNIVERSAL and ((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and LacthToReadFrom(0)));
RW_Curve_GY <= (RW_UNIVERSAL and ((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and LacthToReadFrom(0)));
--0010: Curve_B [((2*N)-1) downto N] & Curve_N [(N-1) downto 0] --No Command Writes to these
RW_Curve_B <= (RW_UNIVERSAL and ((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and LacthToReadFrom(1) and (not LacthToReadFrom(0))));
RW_Curve_N <= (RW_UNIVERSAL and ((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and LacthToReadFrom(1) and (not LacthToReadFrom(0))));
--0100: Key_Private [(N-1) downto 0] --001: Generate_Key_Private; PRNG(1,(N-1)) STABILITY_Generate_Key_Private
RW_Key_Private <= ((RW_UNIVERSAL and ((not LacthToReadFrom(3)) and LacthToReadFrom(2) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0)))) or (OP_UNIVERSAL and STABILITY_Generate_Key_Private and (not command(2)) and (not command(1)) and command(0)));
--0101: Key_Public_User_X [((2*N)-1) downto N] & Key_Public_User_Y [(N-1) downto 0] --010: Generate Key_Public STABILITY_Generate_Key_Public
RW_Key_Public_User_X <= ((RW_UNIVERSAL and ((not LacthToReadFrom(3)) and LacthToReadFrom(2) and (not LacthToReadFrom(1)) and LacthToReadFrom(0))) or (OP_UNIVERSAL and STABILITY_Generate_Key_Public and (not command(2)) and command(1) and (not command(0))));
RW_Key_Public_User_Y <= ((RW_UNIVERSAL and ((not LacthToReadFrom(3)) and LacthToReadFrom(2) and (not LacthToReadFrom(1)) and LacthToReadFrom(0))) or (OP_UNIVERSAL and STABILITY_Generate_Key_Public and (not command(2)) and command(1) and (not command(0))));
--0110: Key_Public_Other_X [((2*N)-1) downto N] & Key_Public_Other_Y [(N-1) downto 0] --No Command Writes to these
RW_Key_Public_Other_X <= (RW_UNIVERSAL and ((not LacthToReadFrom(3)) and LacthToReadFrom(2) and LacthToReadFrom(1) and (not LacthToReadFrom(0))));
RW_Key_Public_Other_Y <= (RW_UNIVERSAL and ((not LacthToReadFrom(3)) and LacthToReadFrom(2) and LacthToReadFrom(1) and (not LacthToReadFrom(0))));
--0111: Key_Shared_X [((2*N)-1) downto N] & Key_Shared_Y [(N-1) downto 0] --011: Generate Key_Public STABILITY_ECDH
RW_Key_Shared_X <= ((RW_UNIVERSAL and ((not LacthToReadFrom(3)) and LacthToReadFrom(2) and LacthToReadFrom(1) and LacthToReadFrom(0))) or (OP_UNIVERSAL and STABILITY_ECDH and (not command(2)) and command(1) and command(0)));
RW_Key_Shared_Y <= ((RW_UNIVERSAL and ((not LacthToReadFrom(3)) and LacthToReadFrom(2) and LacthToReadFrom(1) and LacthToReadFrom(0))) or (OP_UNIVERSAL and STABILITY_ECDH and (not command(2)) and command(1) and command(0)));
--1000: Signature_R [((2*N)-1) downto N] & Signature_S [(N-1) downto 0] --110: ECDSA_SGA STABILITY_ECDSA_SGA
RW_Signature_R <= ((RW_UNIVERSAL and (LacthToReadFrom(3) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0)))) or (OP_UNIVERSAL and STABILITY_ECDSA_SGA and command(2) and command(1) and (not command(0))));
RW_Signature_S <= ((RW_UNIVERSAL and (LacthToReadFrom(3) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0)))) or (OP_UNIVERSAL and STABILITY_ECDSA_SGA and command(2) and command(1) and (not command(0))));
--1001: Signature_K [(N-1) downto 0] --101: Generate_Signature_K; PRNG(1,(N-1)) STABILITY_Generate_Signature_K
RW_Signature_K <= ((RW_UNIVERSAL and (LacthToReadFrom(3) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and LacthToReadFrom(0))) or (OP_UNIVERSAL and STABILITY_Generate_Signature_K and command(2) and (not command(1)) and command(0)));
--1010: HASH_Total [((2*N)-1) downto 0] --No Command Writes to this
RW_HASH_Total <= (RW_UNIVERSAL and (LacthToReadFrom(3) and (not LacthToReadFrom(2)) and LacthToReadFrom(1) and (not LacthToReadFrom(0))));
--1011: HASH_Input [((2*N)-1) downto 0] --100: HASH STABILITY_HASH
RW_HASH_Input <= ((RW_UNIVERSAL and (LacthToReadFrom(3) and (not LacthToReadFrom(2)) and LacthToReadFrom(1) and LacthToReadFrom(0))) or (OP_UNIVERSAL and STABILITY_HASH and command(2) and (not command(1)) and (not command(0))));

--------------------------------------------------------------------------
--------------------------DATA CELLS: DATA MUXS---------------------------
--------------------------------------------------------------------------
RW_IO_TRADEOVER <= ((RW_PHASELOCK(1) and (not RW_PHASELOCK(0))) or (OP_PHASELOCK(1) and (not OP_PHASELOCK(0))));
DATA_Curve_Prime <= DATABUSIN(((2*N)-1) downto N) when ((RW_Curve_Prime and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Curve_A <= DATABUSIN((N-1) downto 0) when ((RW_Curve_A and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Curve_GX <= DATABUSIN(((2*N)-1) downto N) when ((RW_Curve_GX and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Curve_GY <= DATABUSIN((N-1) downto 0) when ((RW_Curve_GY and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Curve_B <= DATABUSIN(((2*N)-1) downto N) when ((RW_Curve_B and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Curve_N <= DATABUSIN((N-1) downto 0) when ((RW_Curve_N and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Key_Private <= DATABUSIN((N-1) downto 0) when ((RW_Key_Private and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Key_Public_User_X <= DATABUSIN(((2*N)-1) downto N) when ((RW_Key_Public_User_X and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Key_Public_User_Y <= DATABUSIN((N-1) downto 0) when ((RW_Key_Public_User_Y and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Key_Public_Other_X <= DATABUSIN(((2*N)-1) downto N) when ((RW_Key_Public_Other_X and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Key_Public_Other_Y <= DATABUSIN((N-1) downto 0) when ((RW_Key_Public_Other_Y and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Key_Shared_X <= DATABUSIN(((2*N)-1) downto N) when ((RW_Key_Shared_X and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Key_Shared_Y <= DATABUSIN((N-1) downto 0) when ((RW_Key_Shared_Y and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Signature_R <= DATABUSIN(((2*N)-1) downto N) when ((RW_Signature_R and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Signature_S <= DATABUSIN((N-1) downto 0) when ((RW_Signature_S and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_Signature_K <= DATABUSIN((N-1) downto 0) when ((RW_Signature_K and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_HASH_Total <= DATABUSIN((N-1) downto 0) when ((RW_HASH_Total and RW_IO_TRADEOVER) = '1') else (others => 'Z');
DATA_HASH_Input <= DATABUSIN(((2*N)-1) downto 0) when ((RW_HASH_Input and RW_IO_TRADEOVER) = '1') else (others => 'Z');

--------------------------------------------------------------------------
--------------------------------DATA CELLS--------------------------------
--------------------------------------------------------------------------

RAM_Curve_Prime : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Curve_Prime, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Curve_Prime,
			  CLK => CLK);

RAM_Curve_A : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Curve_A, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Curve_A,
			  CLK => CLK);

RAM_Curve_GX : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Curve_GX, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Curve_GX,
			  CLK => CLK);

RAM_Curve_GY : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Curve_GY, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Curve_GY,
			  CLK => CLK);

RAM_Curve_B : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Curve_B, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Curve_B,
			  CLK => CLK);

RAM_Curve_N : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Curve_N, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Curve_N,
			  CLK => CLK);

RAM_Key_Private : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Key_Private, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Key_Private,
			  CLK => CLK);

RAM_Key_Public_User_X : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Key_Public_User_X, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Key_Public_User_X,
			  CLK => CLK);

RAM_Key_Public_User_Y : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Key_Public_User_Y, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Key_Public_User_Y,
			  CLK => CLK);

RAM_Key_Public_Other_X : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Key_Public_Other_X, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Key_Public_Other_X,
			  CLK => CLK);

RAM_Key_Public_Other_Y : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Key_Public_Other_Y, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Key_Public_Other_Y,
			  CLK => CLK);

RAM_Key_Shared_X : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Key_Shared_X, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Key_Shared_X,
			  CLK => CLK);

RAM_Key_Shared_Y : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Key_Shared_Y, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Key_Shared_Y,
			  CLK => CLK);

RAM_Signature_R : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Signature_R, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Signature_R,
			  CLK => CLK);

RAM_Signature_S : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Signature_S, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Signature_S,
			  CLK => CLK);

RAM_Signature_K : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_Signature_K, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_Signature_K,
			  CLK => CLK);

RAM_HASH_Total : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => N)
    Port Map ( RW => RW_HASH_Total, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_HASH_Total,
			  CLK => CLK);

RAM_HASH_Input : GENERIC_UTIL_RAM_CLOCKED
	 Generic Map (N => (2*N))
    Port Map ( RW => RW_HASH_Input, --RW is Writing High, Reading Low. To block 'X' collisions on rising_edge(CLK), 
										 --Reading is only enhabled if Data is latched with (others => 'Z')
           Data => DATA_HASH_Input,
			  CLK => CLK);
--

--------------------------------------------------------------------------
-------------AFFINE POINT MULTIPLIER and JACOBIAN POINT ADDER-------------
--------------------------------------------------------------------------

apm : GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED
Generic Map (N => N,
			M => M,
			AddrDelay => AddrDelay,
			CompDelay => CompDelay,
			Toomed => Toomed)
Port Map ( KEY => PM_KEY,
       APX => PM_APX,
       APY => PM_APY,
       AQX => PM_AQX,
       AQY => PM_AQY,
		 Modulus => PM_Modulus,
		 ECC_A => PM_ECC_A,
		 CLK => CLK,
		 StableOutput => PM_StableOutput);
		 
jpa : GENERIC_ECC_JACOBIAN_POINT_ADDITION_CLOCKED
    Generic Map (NGen => N,
				 MGen => M,
				 AddrDelay => AddrDelay,
				 CompDelay => CompDelay,
				 Toomed => Toomed)
    Port Map ( AX => DSA_PM_ByG_X,
           AY => DSA_PM_ByG_Y,
           AZ => UnitVector,
           BX => DSA_PM_ByQ_X,
           BY => DSA_PM_ByQ_Y,
           BZ => UnitVector,
           CX => DSA_JPA_JQX,
           CY => DSA_JPA_JQY,
           CZ => DSA_JPA_JQZ,
			  Modulus => DATA_Curve_Prime,
			  CLK => CLK,
			  StableOutput => DSA_JPA_STABLE);
		 
--------------------------------------------------------------------------
----------------------MODULO INVERTER and FAP RELATOR---------------------
--------------------------------------------------------------------------		 

inverter : GENERIC_FAP_MODINVR_CLOCKED
	 Generic Map (N => N,
				 M => M,
				 AddrDelay => AddrDelay)
    Port Map ( Element => INV_ELEMENT,
           Inverse => INV_INVERSE,
			  Modulus => INV_MODULUS,
			  CLK => CLK);
			  
inverter_stability : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => INV_INVERSE,
           B => ZeroVector,
           E => INV_INVERSE_STABLE,
           G => open);
			  
signature_stability : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => SIGNATURE_STABLILITY_CHECK,
           B => ZeroVector,
           E => SIGNATURE_STABLE,
           G => open);
			  
signature_verification : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => DSA_W,
           B => DATA_Signature_R,
           E => SIGNATURE_VERIFY,
           G => open);

--------------------------------------------------------------------------
--------------------------------MULTIPLIERS-------------------------------
--------------------------------------------------------------------------

multv : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => N,
				 M => M,
				 AddrDelay => AddrDelay,
				 CompDelay => CompDelay,
				 Toomed => Toomed)
    Port Map ( MultiplicandA => DSA_MULTV_A,
           MultiplicandB => DSA_MULTV_B,
			  Modulus => DSA_MULTV_M,
           Product => DSA_MULTV_P,
			  CLK => CLK,
			  StableOutput => DSA_MULTV_STABLE);

multu : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => N,
				 M => M,
				 AddrDelay => AddrDelay,
				 CompDelay => CompDelay,
				 Toomed => Toomed)
    Port Map ( MultiplicandA => DSA_MULTU_A,
           MultiplicandB => DSA_MULTU_B,
			  Modulus => DSA_MULTU_M,
           Product => DSA_MULTU_P,
			  CLK => CLK,
			  StableOutput => DSA_MULTU_STABLE);
			  
addrw : GENERIC_FAP_MODADDR
	 Generic Map (N => N,
				 M => M) --Terminal Length
    Port Map ( SummandA => DSA_ADDRW_A,
           SummandB => DSA_ADDRW_B,
			  Modulus => DATA_Curve_N, --Modulo.
           Summation => DSA_ADDRW_S);

--------------------------------------------------------------------------
------------------------------CONTROL PROCESS-----------------------------
--------------------------------------------------------------------------

CONTROL_PROCESS : process(CLK)
begin
	if (rising_edge(CLK)) then
		if (RW_PHASELOCK = "00") then
			DATABUSIN <= DATABUS;
			RW_PHASELOCK <= "01";
		elsif (RW_PHASELOCK = "01") then
			RW_PHASELOCK <= "10";
		elsif (RW_PHASELOCK = "10") then
			RW_PHASELOCK <= "11";
		elsif (OP_PHASELOCK = "00") then
			OP_PHASELOCK <= "01";
		elsif (OP_PHASELOCK = "01") then
			OP_PHASELOCK <= "10";
		elsif (OP_PHASELOCK = "10") then
			OP_PHASELOCK <= "11";
		elsif (Command(2) = '0') then
			if (((not Command(1)) and (not Command(0))) = '1') then
			--000: Not operating anything, In RW mode
				if (RW = '1') then
					DATABUS <= (others => 'Z');
					RW_PHASELOCK <= "00";
				elsif (((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0))) = '1') then
					DATABUS <= DATA_Curve_Prime & DATA_Curve_A; --Curve_Prime and Curve_A
				elsif (((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and LacthToReadFrom(0)) = '1') then
					DATABUS <= DATA_Curve_GX & DATA_Curve_GY; --Curve_GX and Curve_GY
				elsif (((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and LacthToReadFrom(1) and (not LacthToReadFrom(0))) = '1') then
					DATABUS <= DATA_Curve_B & DATA_Curve_N; --Curve_B and Curve_N
				elsif (((not LacthToReadFrom(3)) and LacthToReadFrom(2) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0))) = '1') then
					DATABUS <= ZeroVector & DATA_Key_Private; --Key_Private
				elsif (((not LacthToReadFrom(3)) and LacthToReadFrom(2) and (not LacthToReadFrom(1)) and LacthToReadFrom(0)) = '1') then
					DATABUS <= DATA_Key_Public_User_X & DATA_Key_Public_User_Y;
				elsif (((not LacthToReadFrom(3)) and LacthToReadFrom(2) and LacthToReadFrom(1) and (not LacthToReadFrom(0))) = '1') then
					DATABUS <= DATA_Key_Public_Other_X & DATA_Key_Public_Other_Y;
				elsif (((not LacthToReadFrom(3)) and LacthToReadFrom(2) and LacthToReadFrom(1) and LacthToReadFrom(0)) = '1') then
					DATABUS <= DATA_Key_Shared_X & DATA_Key_Shared_Y;
				elsif ((LacthToReadFrom(3) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0))) = '1') then
					DATABUS <= DATA_Signature_R & DATA_Signature_S;
				elsif ((LacthToReadFrom(3) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and LacthToReadFrom(0)) = '1') then
					DATABUS <= ZeroVector & DATA_Signature_K;
				elsif ((LacthToReadFrom(3) and (not LacthToReadFrom(2)) and LacthToReadFrom(1) and (not LacthToReadFrom(0))) = '1') then
					DATABUS <= ZeroVector & DATA_HASH_Total;
				elsif ((LacthToReadFrom(3) and (not LacthToReadFrom(2)) and LacthToReadFrom(1) and LacthToReadFrom(0)) = '1') then
					DATABUS <= DATA_HASH_Input;
				end if;
			elsif (((not Command(1)) and Command(0)) = '1') then
			--001: Generate Key_Private; PRNG(1,(N-1))
				--Functionality not Implemented, Left as skeleton
				--STABILITY_Generate_Key_Private <= $Stability Output of PRNG$;
			elsif ((Command(1) and (not Command(0))) = '1') then
			--010: Generate Key_Public
				PM_KEY <= DATA_Key_Private;
				PM_APX <= DATA_Curve_GX;
				PM_APY <= DATA_Curve_GY;
				DSA_U <= PM_AQX;
				DSA_V <= PM_AQY;
				PM_Modulus <= DATA_Curve_Prime;
				PM_ECC_A <= DATA_Curve_A;
				STABILITY_Generate_Key_Public <= PM_StableOutput;
				if (STABILITY_Generate_Key_Public = '1') then
					DATABUSIN <= DSA_U & DSA_V; --DATA_Key_Public_User_X --DATA_Key_Public_User_Y
					OP_PHASELOCK <= "00";
				end if;
			elsif ((Command(1) and Command(0)) = '1') then
			--011: ECDH
				PM_KEY <= DATA_Key_Private;
				PM_APX <= DATA_Key_Public_Other_X;
				PM_APY <= DATA_Key_Public_Other_Y;
				DSA_U <= PM_AQX; --DATA_Key_Shared_X
				DSA_V <= PM_AQY; --DATA_Key_Shared_X
				PM_Modulus <= DATA_Curve_Prime;
				PM_ECC_A <= DATA_Curve_A;
				STABILITY_ECDH <= PM_StableOutput;
				if (STABILITY_ECDH = '1') then
					DATABUSIN <= DSA_U & DSA_V; --DATA_Key_Public_User_X --DATA_Key_Public_User_Y
					OP_PHASELOCK <= "00";
				end if;
			end if;
		elsif (Command(2) = '1') then
			if (((not Command(1)) and (not Command(0))) = '1') then
			--100: HASH
				--Functionality not Implemented, Left as skeleton
				--STABILITY_HASH <= $Stability Output of HASH$;
			elsif (((not Command(1)) and Command(0)) = '1') then
			--101: Generate Signature_K; PRNG(1,(N-1))
				--Functionality not Implemented, Left as skeleton
				--STABILITY_Generate_Signature_K <= $Stability Output of PRNG$;
			elsif ((Command(1) and (not Command(0))) = '1') then
			--110: ECDSA-SGA
				STABILITY_ECDSA_SVA <= '0';
				--Implement ECDSA-SGA
				if (not (Command_Previous = Command)) then
					STABILITY_ECDSA_ROUNDS <= (others => '0');
				elsif (STABILITY_ECDSA_ROUNDS(15) = '1') then
					--Assert Signature_S != 0 (Recompute Signature_K otherwise)
					--CAPTURE OUTPUTS
					if ((not SIGNATURE_STABLE) = '1') then --for 'Not' Equal ZeroVector
						STABILITY_ECDSA_SGA <= '1';
						DATABUSIN <= Signature_R & DSA_U; --DATA_Signature_R --DATA_Signature_S
						OP_PHASELOCK <= "00";
						CLK_QUAD <= "00";
					else
						STABILITY_ECDSA_ROUNDS <= (others => '0');
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(14) = '1') then
					--Assert Signature_S != 0 (Recompute Signature_K otherwise)
					--SETUP INPUTS
					SIGNATURE_STABLILITY_CHECK <= DSA_U;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(15) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(13) = '1') then
					--Compute (MULT) Signature_S = (Signature_K * (E + (Key_Private * Signature_R))) mod Curve_N
					--CAPTURE OUTPUTS
					if ((DSA_MULTU_STABLE) = '1') then
						DSA_U <= DSA_MULTU_P; --DSA_U now contains Signature_S
						STABILITY_ECDSA_ROUNDS(14) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(12) = '1') then
					--Compute (MULT) Signature_S = (Signature_K * (E + (Key_Private * Signature_R))) mod Curve_N
					--SETUP INPUTS
					DSA_MULTU_A <= DSA_INVERSE;
					DSA_MULTU_B <= DSA_W;
					DSA_MULTU_M <= DATA_Curve_N;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(13) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(11) = '1') then
					--Compute (ADDR) (E + (Key_Private * Signature_R)) mod Curve_N
					--CAPTURE OUTPUTS
					DSA_W <= DSA_ADDRW_S; --DSA_W is now (E + (Key_Private * Signature_R))
					STABILITY_ECDSA_ROUNDS(12) <= '1';
					CLK_QUAD <= "00";
				elsif (STABILITY_ECDSA_ROUNDS(10) = '1') then
					--Compute (ADDR) (E + (Key_Private * Signature_R)) mod Curve_N
					--SETUP INPUTS
					DSA_ADDRW_A <= DATA_HASH_Total;
					DSA_ADDRW_B <= DSA_V;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(11) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(9) = '1') then
					--Compute (MULT) (Key_Private * Signature_R) mod Curve_N
					--CAPTURE OUTPUTS
					if ((DSA_MULTV_STABLE) = '1') then
						DSA_V <= DSA_MULTV_P;
						STABILITY_ECDSA_ROUNDS(10) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(8) = '1') then
					--Compute (MULT) (Key_Private * Signature_R) mod Curve_N
					--SETUP INPUTS
					DSA_MULTV_A <= DATA_Key_Private;
					DSA_MULTV_B <= SIGNATURE_R;
					DSA_MULTV_M <= DATA_Curve_N;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(9) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(7) = '1') then
					--Assert Signature_R != 0 (Recompute Signature_K otherwise)
					--CAPTURE OUTPUTS
					if ((not SIGNATURE_STABLE) = '1') then --for 'Not' Equal ZeroVector
						STABILITY_ECDSA_ROUNDS(8) <= '1';
						SIGNATURE_R <= DSA_W;
						CLK_QUAD <= "00";
					else
						STABILITY_ECDSA_ROUNDS <= (others => '0');
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(6) = '1') then
					--Assert Signature_R != 0 (Recompute Signature_K otherwise)
					--SETUP INPUTS
					SIGNATURE_STABLILITY_CHECK <= DSA_W;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(7) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(5) = '1') then
					--Compute Signature_R = (Signature_K * G).X mod Curve_N
					--CAPTURE OUTPUTS
					DSA_W <= DSA_ADDRW_S; --DSA_W is now Signature_R
					STABILITY_ECDSA_ROUNDS(6) <= '1';
					CLK_QUAD <= "00";
				elsif (STABILITY_ECDSA_ROUNDS(4) = '1') then
					--Compute Signature_R = (Signature_K * G).X mod Curve_N
					--SETUP INPUTS
					DSA_ADDRW_A <= DSA_PM_ByG_X;
					DSA_ADDRW_B <= ZeroVector;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(5) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(3) = '1') then
					--Compute 1 PM (over Curve) of (Signature_K * G)
					--CAPTURE OUTPUTS
					if (PM_StableOutput = '1') then
						DSA_PM_ByG_X <= PM_AQX;
						DSA_PM_ByG_Y <= PM_AQY;
						STABILITY_ECDSA_ROUNDS(4) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(2) = '1') then
					--Compute 1 PM (over Curve) of (Signature_K * G)
					--SETUP INPUTS
					PM_KEY <= DATA_Signature_K;
					PM_APX <= DATA_Curve_GX;
					PM_APY <= DATA_Curve_GY;
					PM_Modulus <= DATA_Curve_Prime;
					PM_ECC_A <= DATA_Curve_A;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(3) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(1) = '1') then
					--Compute Inverse (over Curve_N) of Signature_K
					--CAPTURE OUTPUTS
					if (INV_INVERSE_STABLE = '0') then
						DSA_INVERSE <= INV_INVERSE;
						STABILITY_ECDSA_ROUNDS(2) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(0) = '1') then
					--Compute Inverse (over Curve_N) of Signature_K
					--SETUP INPUTS
					INV_ELEMENT <= DATA_Signature_K;
					INV_MODULUS <= DATA_Curve_N;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(1) <= '1';
					end if;
				else
					--Take E from DATA_HASH_Total
					--Take Signature_K from DATA_Signature_K
					CLK_QUAD <= "00";
					STABILITY_ECDSA_ROUNDS(0) <= '1';
				end if;
			elsif ((Command(1) and Command(0)) = '1') then
			--111: ECDSA_SVA
				STABILITY_ECDSA_SGA <= '0';
				--Implement ECDSA-SVA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				if (not (Command_Previous = Command)) then
					STABILITY_ECDSA_ROUNDS <= (others => '0');
					SIGNATURE_VERIFIED <= '0';
				elsif (STABILITY_ECDSA_ROUNDS(21) = '1') then
					--Assert that r = w (if yes, then success)
					--CAPTURE OUTPUTS
					SIGNATURE_VERIFIED <= SIGNATURE_VERIFY;
					STABILITY_ECDSA_SVA <= '1';
					CLK_QUAD <= "00";
				elsif (STABILITY_ECDSA_ROUNDS(20) = '1') then
					--Assert that r = w (if yes, then success)
					--SETUP INPUTS
					--Inputs are fixed to the DSA_W and DATA_Signature_R registers, hold one round of the STABILITY_ECDSA to let Relator stabilise
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(21) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(19) = '1') then
					--Compute w = (uG+vQ).X mod Curve_N
					--CAPTURE OUTPUTS
					DSA_W <= DSA_ADDRW_S;
					STABILITY_ECDSA_ROUNDS(20) <= '1';
					CLK_QUAD <= "00";
				elsif (STABILITY_ECDSA_ROUNDS(18) = '1') then
					--Compute w = (uG+vQ).X mod Curve_N
					--SETUP INPUTS
					DSA_ADDRW_A <= DSA_U;
					DSA_ADDRW_B <= ZeroVector;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(19) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(17) = '1') then
					--Compute APX and APY (over Curve) between uG and vQ
					--CAPTURE OUTPUTS
					if ((DSA_MULTV_STABLE and DSA_MULTU_STABLE) = '1') then
						DSA_V <= DSA_MULTV_P; --DSA_V now contains APY
						DSA_U <= DSA_MULTU_P; --DSA_U now contains APX
						STABILITY_ECDSA_ROUNDS(18) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(16) = '1') then
					--Compute APX and APY (over Curve) between uG and vQ
					--SETUP INPUTS
					DSA_MULTU_A <= DSA_JQX;
					DSA_MULTU_B <= DSA_JQZ_INV_SQUARED;
					DSA_MULTU_M <= DATA_Curve_Prime;
					DSA_MULTV_A <= DSA_JQY;
					DSA_MULTV_B <= DSA_JQZ_INV_CUBED;
					DSA_MULTV_M <= DATA_Curve_Prime;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(17) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(15) = '1') then
					--Compute JPZ_INV_CUBED (over Curve) between uG and vQ
					--CAPTURE OUTPUTS
					if ((DSA_MULTV_STABLE) = '1') then
						DSA_JQZ_INV_CUBED <= DSA_MULTV_P;
						STABILITY_ECDSA_ROUNDS(16) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(14) = '1') then
					--Compute JPZ_INV_CUBED (over Curve) between uG and vQ
					--SETUP INPUTS
					DSA_MULTV_A <= DSA_JQZ_INV;
					DSA_MULTV_B <= DSA_JQZ_INV_SQUARED;
					DSA_MULTV_M <= DATA_Curve_Prime;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(15) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(13) = '1') then
					--Compute JPZ_INV_SQUARED (over Curve) between uG and vQ
					--CAPTURE OUTPUTS
					if ((DSA_MULTU_STABLE) = '1') then
						DSA_JQZ_INV_SQUARED <= DSA_MULTU_P;
						STABILITY_ECDSA_ROUNDS(14) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(12) = '1') then
					--Compute JPZ_INV_SQUARED (over Curve) between uG and vQ
					--SETUP INPUTS
					DSA_MULTU_A <= DSA_JQZ_INV;
					DSA_MULTU_B <= DSA_JQZ_INV;
					DSA_MULTU_M <= DATA_Curve_Prime;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(13) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(11) = '1') then
					--Compute JPZ_INV (over Curve) between uG and vQ
					--CAPTURE OUTPUTS
					if (INV_INVERSE_STABLE = '0') then
						DSA_JQZ_INV <= INV_INVERSE;
						STABILITY_ECDSA_ROUNDS(12) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(10) = '1') then
					--Compute JPZ_INV (over Curve) between uG and vQ
					--SETUP INPUTS
					INV_ELEMENT <= DSA_JQZ;
					INV_MODULUS <= DATA_Curve_Prime;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(11) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(9) = '1') then
					--Compute JPA (over Curve) between uG and vQ
					--CAPTURE OUTPUTS
					if (DSA_JPA_STABLE = '1') then 
						DSA_JQX <= DSA_JPA_JQX;
						DSA_JQY <= DSA_JPA_JQY;
						DSA_JQZ <= DSA_JPA_JQZ;
						STABILITY_ECDSA_ROUNDS(10) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(8) = '1') then
					--Compute JPA (over Curve) between uG and vQ
					--SETUP INPUTS
					--Inputs are fixed to the DSA_PM registers, hold one round of the STABILITY_ECDSA to let JPA stabilise
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(9) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(7) = '1') then
					--Compute PM (over Curve) of vQ (Q, the persons public key)
					--CAPTURE OUTPUTS
					if (PM_StableOutput = '1') then
						DSA_PM_ByQ_X <= PM_AQX;
						DSA_PM_ByQ_Y <= PM_AQY;
						STABILITY_ECDSA_ROUNDS(8) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(6) = '1') then
					--Compute PM (over Curve) of vQ (Q, the persons public key)
					--SETUP INPUTS
					PM_KEY <= DSA_V; --V = ((S Inverse) * R)
					PM_APX <= DATA_Key_Public_Other_X;
					PM_APY <= DATA_Key_Public_Other_Y;
					PM_Modulus <= DATA_Curve_Prime;
					PM_ECC_A <= DATA_Curve_A;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(7) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(5) = '1') then
					--Compute PM (over Curve) of uG
					--CAPTURE OUTPUTS
					if (PM_StableOutput = '1') then
						DSA_PM_ByG_X <= PM_AQX;
						DSA_PM_ByG_Y <= PM_AQY;
						STABILITY_ECDSA_ROUNDS(6) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(4) = '1') then
					--Compute PM (over Curve) of uG
					--SETUP INPUTS
					PM_KEY <= DSA_U; --U = ((S Inverse) * Hash)
					PM_APX <= DATA_Curve_GX;
					PM_APY <= DATA_Curve_GY;
					PM_Modulus <= DATA_Curve_Prime;
					PM_ECC_A <= DATA_Curve_A;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(5) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(3) = '1') then
					--Compute 2 MULTS (over Curve_N) of u(Signature_S_Inv * E) and v(Signature_S_Inv * Signature_R)
					--CAPTURE OUTPUTS
					if ((DSA_MULTV_STABLE and DSA_MULTU_STABLE) = '1') then
						DSA_U <= DSA_MULTU_P; --U = ((S Inverse) * Hash)
						DSA_V <= DSA_MULTV_P; --V = ((S Inverse) * R)
						STABILITY_ECDSA_ROUNDS(4) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(2) = '1') then
					--Compute 2 MULTS (over Curve_N) of u(Signature_S_Inv * E) and v(Signature_S_Inv * Signature_R)
					--SETUP INPUTS
					DSA_MULTV_A <= DSA_INVERSE;
					DSA_MULTV_B <= DATA_Signature_R;
					DSA_MULTV_M <= DATA_Curve_N;
					DSA_MULTU_A <= DSA_INVERSE;
					DSA_MULTU_B <= DATA_HASH_Total;
					DSA_MULTU_M <= DATA_Curve_N;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(3) <= '1';
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(1) = '1') then
					--Compute Inverse (over Curve_N) of Signature_S
					--CAPTURE OUTPUTS
					if (INV_INVERSE_STABLE = '0') then
						DSA_INVERSE <= INV_INVERSE;
						STABILITY_ECDSA_ROUNDS(2) <= '1';
						CLK_QUAD <= "00";
					end if;
				elsif (STABILITY_ECDSA_ROUNDS(0) = '1') then
					--Compute Inverse (over Curve_N) of Signature_S
					--SETUP INPUTS
					INV_ELEMENT <= DATA_Signature_S;
					INV_MODULUS <= DATA_Curve_N;
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						STABILITY_ECDSA_ROUNDS(1) <= '1';
					end if;
				else
					--Take E from DATA_HASH_Total
					--Take Signature_R from DATA_Signature_R
					--Take Signature_S from DATA_Signature_S
					CLK_QUAD <= "00";
					STABILITY_ECDSA_ROUNDS(0) <= '1';
				end if;
			end if;
		end if;
		Command_Previous <= Command;
	end if;
end process;


end Behavioral;


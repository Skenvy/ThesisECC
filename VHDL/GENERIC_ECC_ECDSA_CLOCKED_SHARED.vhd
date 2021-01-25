----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:52:41 06/10/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_ECDSA_CLOCKED_SHARED - Behavioral 
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

entity GENERIC_ECC_ECDSA_CLOCKED_SHARED is
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
			  --1100: -
			  --1101: -
			  --1110: -
			  --1111: -
			  OtherUserRegister : in STD_LOGIC_VECTOR(3 downto 0);
			  --Indicates to the ECDH, Public and Shared Key registers what user is being flagged. 
			  HashStrobeIn : in STD_LOGIC_VECTOR(1 downto 0);
			  --Indicates to the HASH next input is ready (0), or that the the Last input is ready (1)
			  HashStrobeOut : Out STD_LOGIC := '0';
			  --Used by the HASH to request the next input
			  Command : in STD_LOGIC_VECTOR (3 downto 0);
			  --0000: Not operating anything, In RW mode
			  --0001: Generate Key_Private; PRNG(1,(N-1))
			  --0010: Generate Key_Public
			  --0011: ECDH
			  --0100: HASH
			  --0101: Generate Signature_K; PRNG(1,(N-1))
			  --0110: ECDSA-SGA
			  --0111: ECDSA_SVA
			  --1000: 
			  --1001: 
			  --1010: 
			  --1011: 
			  --1100: Error Check: Key Parameters; Other's
			  --1101: Error Check: Key Parameters; User's
			  --1110: Error Check: Curve Parameters; ((4*A^3 + 27*B^2) mod Prime != 0)
			  --1111: Error Check: Curve Parameters; (N*(GX,GY) = infinity)
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC := '0';
			  Error : out STD_LOGIC_VECTOR(3 downto 0) := "0000"); --Errors are not reset, if something prompts an error
																	--The error response will stay latched on the errorbus
																	--Except for SGA/SVA errors that reset to zero on initialisation
			  --0000: Default (Nothing Wrong) (Note Flag)
			  --0001: Illegal Read Attempt Private Key flushed to Databus (Attack Flag: Flush 'Z' Drive recommended)
			  --0010: Invalid Curve Parameter: (N*(GX,GY) != infinity) (Error Flag: IRQ recommended)
			  --0011: Invalid Curve Parameter: ((4*A^3 + 27*B^2) mod Prime = 0) (Critical Error Flag: IRQ Mandatory)
			  --0100: Illegal Write Attempt: User's Public Key (Warning Flag [should use Generate Key_Public command])
			  --0101: Illegal Write Attempt: Shared Key (Warning Flag [should use ECDH command])
			  --0110: Invalid Public Key: User's (Error Flag: IRQ Recommended)
			  --0111: Invalid Public Key: Other's (Error Flag: IRQ Recommended)
			  --1000: Invalid SGA Attempt: Signature_K prompts Signature_R = 0 (Error Flag: IRQ requests new Signature_K)
			  --1001: Invalid SGA Attempt: Signature_K prompts Signature_S = 0 (Error Flag: IRQ requests new Signature_K)
			  --1010: Invalid SVA Attempt: Signature_R is 0 (Error Flag: IRQ requests Signature rewrite)
			  --1011: Invalid SVA Attempt: Signature_S is 0 (Error Flag: IRQ requests Signature rewrite)
			  --1100: Invalid SVA Attempt: Signature is Invalid (Message Flag)
			  --1101: Valid SVA Attempt: Signature is valid (Message Flag)
			  --1110: 
			  --1111: 
end GENERIC_ECC_ECDSA_CLOCKED_SHARED;

architecture Behavioral of GENERIC_ECC_ECDSA_CLOCKED_SHARED is

component GENERIC_ECC_JACOBIAN_POINT_ADDITION_CLOCKED
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

component GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED
    Generic (NGen : natural := VecLen;
				 MGen : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( AX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  ECC_A : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
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

-----------------------
--Command Stabilities--
-----------------------
signal COMMAND_STABILITY : STD_LOGIC;
signal COMMAND_PREVIOUS : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
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
signal DSA_U2 : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTU_STABLE : STD_LOGIC;
signal DSA_MULTV_A : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTV_B : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTV_P : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_MULTV_M : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_V : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal DSA_V2 : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
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
signal SGA_PHASELOCK : STD_LOGIC := '0';
signal SVA_PHASELOCK : STD_LOGIC := '0';
signal SGA_TERMINAL : STD_LOGIC := '0';
signal SVA_TERMINAL : STD_LOGIC := '0';
signal JPM_PHASELOCK : STD_LOGIC := '0';
signal APM_PHASELOCK : STD_LOGIC := '0';
signal APM_TERMINAL : STD_LOGIC := '0';
signal JPA_SVA_SPECIAL : STD_LOGIC;
----------------
--PM REGISTERS--
----------------
signal PM_Modulus : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_ECC_A : STD_LOGIC_VECTOR ((N-1) downto 0);
signal PM_StableOutput : STD_LOGIC;
signal PM_KEY : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_MOD : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_ECA : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_APX : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_APY : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_AQX : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_AQY : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_ASTO : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_JPX : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_JPY : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_JPZ : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_JQX : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_JQY : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_JQZ : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal PM_JSTO : STD_LOGIC_VECTOR((N-1) downto 0) := (others => '0');
signal INV_ELEMENT : STD_LOGIC_VECTOR ((N-1) downto 0) := UnitVector;
signal INV_INVERSE : STD_LOGIC_VECTOR ((N-1) downto 0);
signal INV_MODULUS : STD_LOGIC_VECTOR ((N-1) downto 0) := (1 => '1', others => '0');
signal DSA_INVERSE : STD_LOGIC_VECTOR ((N-1) downto 0); --Holds the output from the port map
signal INV_INVERSE_STABLE : STD_LOGIC;
signal APM_ROUNDS : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
--MemoryDataLine
signal MemDoublingX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MemDoublingY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MemDoublingZ : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MemAddingX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MemAddingY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MemAddingZ : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MemNonceX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MemNonceY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal MemNonceZ : STD_LOGIC_VECTOR ((N-1) downto 0);
--Temporal Adder Inputs and Outputs for the port map
signal ADDRAX : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal ADDRAY : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal ADDRAZ : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal ADDRBX : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal ADDRBY : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal ADDRBZ : STD_LOGIC_VECTOR ((N-1) downto 0) := (others => '0');
signal ADDRCX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal ADDRCY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal ADDRCZ : STD_LOGIC_VECTOR ((N-1) downto 0);
--Temporal Doubling Inputs and Outputs for the port map
signal DOUBAX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal DOUBAY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal DOUBAZ : STD_LOGIC_VECTOR ((N-1) downto 0);
signal DOUBCX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal DOUBCY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal DOUBCZ : STD_LOGIC_VECTOR ((N-1) downto 0);
--Used to control whether the stabalised outputs are displayed or not, turns to '1' when they are stable.
signal StableOutputJPM : STD_LOGIC;
--Used to record the previous state of the input, to reflush and restart the procedure when new inputs are given
signal PreviousJPX : STD_LOGIC_VECTOR((N-1) downto 0);
signal PreviousJPY : STD_LOGIC_VECTOR((N-1) downto 0);
signal PreviousJPZ : STD_LOGIC_VECTOR((N-1) downto 0);
signal PreviousKEY : STD_LOGIC_VECTOR((N-1) downto 0);
--Hold the index and used to check that the entirety of K has been realised
signal Jindex : STD_LOGIC_VECTOR((N-1) downto 0);
signal JComplete : STD_LOGIC_VECTOR((N-1) downto 0);
signal Jnext : STD_LOGIC_VECTOR((N-1) downto 0);
signal CLKDBL : STD_LOGIC; --Used to offset the input to output timing for inputs to the addr and doub cells, to place inputs on them in one clock cycle and then continuously check the output stability in every following clock cycles
--Stability
signal StableADDR : STD_LOGIC;
signal StableDOUB : STD_LOGIC;
signal J_Finished : STD_LOGIC;
signal Adding_Round : STD_LOGIC;
signal Adding_Round_Next : STD_LOGIC;
signal JK : STD_LOGIC_VECTOR((N-1) downto 0);
signal JKnext : STD_LOGIC_VECTOR((N-1) downto 0);
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

RW_MODE <= ((not Command(0)) and (not Command(1)) and (not Command(2)) and (not Command(3)));
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
			  
--------------------------------------------------
-----JACOBIAN POINT MULTIPLIER CELL PORT MAPS-----
--------------------------------------------------
			  
ADDRROUND : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => JK,
           B => ZeroVector,
           E => Adding_Round,
           G => open);
			  
ADDRROUNDNEXT : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => JKnext,
           B => ZeroVector,
           E => Adding_Round_Next,
           G => open);

--The adder cell
ADDR : GENERIC_ECC_JACOBIAN_POINT_ADDITION_CLOCKED
    Generic Map (NGen => N,
					  MGen => M,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( AX => ADDRAX,
					AY => ADDRAY,
					AZ => ADDRAZ,
					BX => ADDRBX,
					BY => ADDRBY,
					BZ => ADDRBZ,
					CX => ADDRCX,
					CY => ADDRCY,
					CZ => ADDRCZ,
					Modulus => PM_MOD,
					CLK => CLK,
					StableOutput => StableADDR);

--The doubling cell
DOUB : GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED
    Generic Map (NGen => N,
					  MGen => M,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( AX => DOUBAX,
					AY => DOUBAY,
					AZ => DOUBAZ,
					CX => DOUBCX,
					CY => DOUBCY,
					CZ => DOUBCZ,
					Modulus => PM_MOD,
					ECC_A => PM_ECA,
					CLK => CLK,
					StableOutput => StableDOUB);
					
--Connecting the data bus lines of the ports.

DOUBAX <= MemDoublingX;
DOUBAY <= MemDoublingY;
DOUBAZ <= MemDoublingZ;
JK <= (Jindex and PM_KEY);
JKnext <= (Jnext and PM_KEY);

--Determine the ADDR inputs each round
JPA_SVA_SPECIAL <= ((STABILITY_ECDSA_ROUNDS(8) and (not STABILITY_ECDSA_ROUNDS(10)) and (not Command(3))) and (Command(2) and Command(1) and Command(0)));
OutGen : for K in 0 to (N-1) generate
begin
	ADDRAX(K) <= ((((MemAddingX(K) and ((not Adding_Round) or (not Adding_Round_Next))) or (MemNonceX(K) and (Adding_Round and Adding_Round_Next))) and (not JPA_SVA_SPECIAL)) or (DSA_PM_ByQ_X(K) and JPA_SVA_SPECIAL));
	ADDRAY(K) <= ((((MemAddingY(K) and ((not Adding_Round) or (not Adding_Round_Next))) or (MemNonceY(K) and (Adding_Round and Adding_Round_Next))) and (not JPA_SVA_SPECIAL)) or (DSA_PM_ByQ_Y(K) and JPA_SVA_SPECIAL));
	ADDRAZ(K) <= ((((MemAddingZ(K) and ((not Adding_Round) or (not Adding_Round_Next))) or (MemNonceZ(K) and (Adding_Round and Adding_Round_Next))) and (not JPA_SVA_SPECIAL)) or (UnitVector(K) and JPA_SVA_SPECIAL));
	ADDRBX(K) <= ((MemDoublingX(K) and (not JPA_SVA_SPECIAL)) or (DSA_PM_ByG_X(K) and JPA_SVA_SPECIAL));
	ADDRBY(K) <= ((MemDoublingY(K) and (not JPA_SVA_SPECIAL)) or (DSA_PM_ByG_Y(K) and JPA_SVA_SPECIAL));
	ADDRBZ(K) <= ((MemDoublingZ(K) and (not JPA_SVA_SPECIAL)) or (UnitVector(K) and JPA_SVA_SPECIAL));
end generate OutGen;
		 
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
		elsif ((Command_Previous = Command) and (JPM_PHASELOCK = '1') and (APM_PHASELOCK = '1')) then
				--Do standard Jacobian PM
				if (J_Finished = '1') then --If end condition met, put output
					DSA_JQX <= MemAddingX;
					DSA_JQY <= MemAddingY;
					DSA_JQZ <= MemAddingZ;
					StableOutputJPM <= '1';
					if (CLK_QUAD = "00") then
						CLK_QUAD <= "01";
					elsif (CLK_QUAD = "01") then
						CLK_QUAD <= "10";
					elsif (CLK_QUAD = "10") then
						CLK_QUAD <= "11";
					else
						--At the end, switch off the JPM_PHASELOCK
						JPM_PHASELOCK <= '0';
						APM_ROUNDS <= (others => '0');
						CLK_QUAD <= "00";
					end if;
				elsif (CLKDBL = '0') then
					CLKDBL <= '1';
				elsif ((StableADDR and StableDOUB) = '1') then --Else, if the cells are stable, do the update.
					if (Adding_Round = '0') then --if adding bit, then do the adding (zero from 'not' equal to the ZSeroVector)
						MemAddingX <= ADDRCX;
						MemAddingY <= ADDRCY;
						MemAddingZ <= ADDRCZ;
					else
						MemNonceX <= ADDRCX;
						MemNonceY <= ADDRCY;
						MemNonceZ <= ADDRCZ;
					end if; 
					--Do the doubling unambiguously.
					MemDoublingX <= DOUBCX;
					MemDoublingY <= DOUBCY;
					MemDoublingZ <= DOUBCZ;
					if (Jindex(N-1) = '1') then
						J_Finished <= '1';
					end if;
					Jindex <= Jindex((N-2) downto 0) & "0";
					Jnext <= Jnext((N-2) downto 0) & "0";
					JComplete <= (JComplete or JK);
					CLKDBL <= '0';
				end if;
		elsif ((Command_Previous = Command) and (JPM_PHASELOCK = '0') and (APM_PHASELOCK = '1')) then
			--Do standard Affine PM using the JPM results
			if (APM_ROUNDS(6) = '1') then
				--Compute APX and APY (over Curve) between uG and vQ
				--CAPTURE OUTPUTS
				if ((DSA_MULTV_STABLE and DSA_MULTU_STABLE) = '1') then
					DSA_V <= DSA_MULTV_P; --DSA_V now contains APY
					DSA_U <= DSA_MULTU_P; --DSA_U now contains APX
					CLK_QUAD <= "11";
					--At the end, switch off the APM_PHASELOCK
					APM_PHASELOCK <= '0';
					--At the end, switch on the APM_TERMINAL
					APM_TERMINAL <= '1';
				end if;
			elsif (APM_ROUNDS(5) = '1') then
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
					APM_ROUNDS(6) <= '1';
				end if;
			elsif (APM_ROUNDS(4) = '1') then
				--Compute JPZ_INV_CUBED (over Curve) between uG and vQ
				--CAPTURE OUTPUTS
				if ((DSA_MULTV_STABLE) = '1') then
					DSA_JQZ_INV_CUBED <= DSA_MULTV_P;
					APM_ROUNDS(5) <= '1';
					CLK_QUAD <= "00";
				end if;
			elsif (APM_ROUNDS(3) = '1') then
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
					APM_ROUNDS(4) <= '1';
				end if;
			elsif (APM_ROUNDS(2) = '1') then
				--Compute JPZ_INV_SQUARED (over Curve) between uG and vQ
				--CAPTURE OUTPUTS
				if ((DSA_MULTU_STABLE) = '1') then
					DSA_JQZ_INV_SQUARED <= DSA_MULTU_P;
					APM_ROUNDS(3) <= '1';
					CLK_QUAD <= "00";
				end if;
			elsif (APM_ROUNDS(1) = '1') then
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
					APM_ROUNDS(2) <= '1';
				end if;
			elsif (APM_ROUNDS(0) = '1') then
				--Compute JPZ_INV (over Curve) between uG and vQ
				--CAPTURE OUTPUTS
				if (INV_INVERSE_STABLE = '0') then
					DSA_JQZ_INV <= INV_INVERSE;
					APM_ROUNDS(1) <= '1';
					CLK_QUAD <= "00";
				end if;
			else
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
					APM_ROUNDS(0) <= '1';
				end if;
			end if;
		elsif ((Command_Previous = Command) and (SGA_PHASELOCK = '1') and (SGA_TERMINAL = '0')) then
			--Implement ECDSA-SGA
			if (STABILITY_ECDSA_ROUNDS(15) = '1') then
				--Assert Signature_S != 0 (Recompute Signature_K otherwise)
				--CAPTURE OUTPUTS
				if ((not SIGNATURE_STABLE) = '1') then --for 'Not' Equal ZeroVector
					STABILITY_ECDSA_SGA <= '1';
					DATABUSIN <= Signature_R & DSA_U; --DATA_Signature_R --DATA_Signature_S
					OP_PHASELOCK <= "00";
					CLK_QUAD <= "00";
					StableOutput <= '1';
					SGA_TERMINAL <= '1';
				else
					Error <= "1001"; --1001: Invalid SGA Attempt: Signature_K prompts Signature_S = 0 (Error Flag: IRQ requests new Signature_K)
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
					Error <= "1000"; --1000: Invalid SGA Attempt: Signature_K prompts Signature_R = 0 (Error Flag: IRQ requests new Signature_K)
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
				if (APM_TERMINAL = '1') then
					DSA_PM_ByG_X <= DSA_U;
					DSA_PM_ByG_Y <= DSA_V;
					STABILITY_ECDSA_ROUNDS(4) <= '1';
					CLK_QUAD <= "00";
				end if;
			elsif (STABILITY_ECDSA_ROUNDS(2) = '1') then
				--Compute 1 PM (over Curve) of (Signature_K * G)
				--SETUP INPUTS
				if (CLK_QUAD = "00") then
					--Inputs to the APM: Select
					PM_KEY <= DATA_Signature_K; --K
					PM_MOD <= DATA_Curve_Prime;
					PM_ECA <= DATA_Curve_A;
					MemDoublingX <= DATA_Curve_GX; --APX
					MemDoublingY <= DATA_Curve_GY; --APY
					CLK_QUAD <= "01";
				elsif (CLK_QUAD = "01") then
					--Inputs to the JPM: Initiate
					MemDoublingZ <= UnitVector;
					MemAddingX <= UnitVector;
					MemAddingY <= UnitVector;
					MemAddingZ <= ZeroVector;
					MemNonceX <= UnitVector;
					MemNonceY <= UnitVector;
					MemNonceZ <= ZeroVector;
					Jindex <= UnitVector;
					JComplete <= ZeroVector;
					Jnext <= UnitVector((N-2) downto 0) & "0";
					CLKDBL <= '0';
					J_Finished <= '0';
					CLK_QUAD <= "10";
				elsif (CLK_QUAD = "10") then
					--Inputs to the APM: Initiate
					APM_PHASELOCK <= '1';
					JPM_PHASELOCK <= '1';
					APM_TERMINAL <= '0';
					StableOutputJPM <= '0';
					CLK_QUAD <= "11";
				elsif (APM_TERMINAL = '1') then
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
		elsif ((Command_Previous = Command) and (SVA_PHASELOCK = '1') and (SVA_TERMINAL = '0')) then
			--Implement the SVA
			if (STABILITY_ECDSA_ROUNDS(21) = '1') then
				--Assert that r = w (if yes, then success)
				--CAPTURE OUTPUTS
				SIGNATURE_VERIFIED <= SIGNATURE_VERIFY;
				STABILITY_ECDSA_SVA <= '1';
				StableOutput <= '1';
				SVA_TERMINAL <= '1';
				if (SIGNATURE_VERIFY = '0') then
					Error <= "1100"; --1100: Invalid SVA Attempt: Signature is Invalid (Message Flag)
				else
					Error <= "1101"; --1101: Valid SVA Attempt: Signature is valid (Message Flag)
				end if;
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
				if (StableADDR = '1') then 
					DSA_JQX <= ADDRCX;
					DSA_JQY <= ADDRCY;
					DSA_JQZ <= ADDRCZ;
					STABILITY_ECDSA_ROUNDS(10) <= '1';
					CLK_QUAD <= "00";
				end if;
			elsif (STABILITY_ECDSA_ROUNDS(8) = '1') then
				--Compute JPA (over Curve) between uG and vQ
				--SETUP INPUTS
				--Inputs tied permantently to the adder
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
				if (APM_TERMINAL = '1') then
					DSA_PM_ByQ_X <= DSA_U;
					DSA_PM_ByQ_Y <= DSA_V;
					STABILITY_ECDSA_ROUNDS(8) <= '1';
					CLK_QUAD <= "00";
				end if;
			elsif (STABILITY_ECDSA_ROUNDS(6) = '1') then
				--Compute PM (over Curve) of vQ (Q, the persons public key)
				--SETUP INPUTS
				if (CLK_QUAD = "00") then
					--Inputs to the APM: Select
					PM_KEY <= DSA_V2; --U = ((S Inverse) * Hash)
					PM_MOD <= DATA_Curve_Prime;
					PM_ECA <= DATA_Curve_A;
					MemDoublingX <= DATA_Key_Public_Other_X; --APX
					MemDoublingY <= DATA_Key_Public_Other_Y; --APY
					CLK_QUAD <= "01";
				elsif (CLK_QUAD = "01") then
					--Inputs to the JPM: Initiate
					MemDoublingZ <= UnitVector;
					MemAddingX <= UnitVector;
					MemAddingY <= UnitVector;
					MemAddingZ <= ZeroVector;
					MemNonceX <= UnitVector;
					MemNonceY <= UnitVector;
					MemNonceZ <= ZeroVector;
					Jindex <= UnitVector;
					JComplete <= ZeroVector;
					Jnext <= UnitVector((N-2) downto 0) & "0";
					CLKDBL <= '0';
					J_Finished <= '0';
					CLK_QUAD <= "10";
				elsif (CLK_QUAD = "10") then
					--Inputs to the APM: Initiate
					APM_PHASELOCK <= '1';
					JPM_PHASELOCK <= '1';
					APM_TERMINAL <= '0';
					StableOutputJPM <= '0';
					CLK_QUAD <= "11";
				elsif (APM_TERMINAL = '1') then
					--DSA_U & DSA_V; --vQ.X --vQ.Y
					STABILITY_ECDSA_ROUNDS(7) <= '1';
				end if;
			elsif (STABILITY_ECDSA_ROUNDS(5) = '1') then
				--Compute PM (over Curve) of uG
				--CAPTURE OUTPUTS
				if (APM_TERMINAL = '1') then
					DSA_PM_ByG_X <= DSA_U;
					DSA_PM_ByG_Y <= DSA_V;
					STABILITY_ECDSA_ROUNDS(6) <= '1';
					CLK_QUAD <= "00";
				end if;
			elsif (STABILITY_ECDSA_ROUNDS(4) = '1') then
				--Compute PM (over Curve) of uG
				--SETUP INPUTS
				if (CLK_QUAD = "00") then
					--Inputs to the APM: Select
					PM_KEY <= DSA_U2; --U = ((S Inverse) * Hash)
					PM_MOD <= DATA_Curve_Prime;
					PM_ECA <= DATA_Curve_A;
					MemDoublingX <= DATA_Curve_GX; --APX
					MemDoublingY <= DATA_Curve_GY; --APY
					CLK_QUAD <= "01";
				elsif (CLK_QUAD = "01") then
					--Inputs to the JPM: Initiate
					MemDoublingZ <= UnitVector;
					MemAddingX <= UnitVector;
					MemAddingY <= UnitVector;
					MemAddingZ <= ZeroVector;
					MemNonceX <= UnitVector;
					MemNonceY <= UnitVector;
					MemNonceZ <= ZeroVector;
					Jindex <= UnitVector;
					JComplete <= ZeroVector;
					Jnext <= UnitVector((N-2) downto 0) & "0";
					CLKDBL <= '0';
					J_Finished <= '0';
					CLK_QUAD <= "10";
				elsif (CLK_QUAD = "10") then
					--Inputs to the APM: Initiate
					APM_PHASELOCK <= '1';
					JPM_PHASELOCK <= '1';
					APM_TERMINAL <= '0';
					StableOutputJPM <= '0';
					CLK_QUAD <= "11";
				elsif (APM_TERMINAL = '1') then
					--DSA_U & DSA_V; --uG.X --uG.Y
					STABILITY_ECDSA_ROUNDS(5) <= '1';
				end if;
			elsif (STABILITY_ECDSA_ROUNDS(3) = '1') then
				--Compute 2 MULTS (over Curve_N) of u(Signature_S_Inv * E) and v(Signature_S_Inv * Signature_R)
				--CAPTURE OUTPUTS
				if ((DSA_MULTV_STABLE and DSA_MULTU_STABLE) = '1') then
					DSA_U2 <= DSA_MULTU_P; --U = ((S Inverse) * Hash)
					DSA_V2 <= DSA_MULTV_P; --V = ((S Inverse) * R)
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
				if (DATA_Signature_R = ZeroVector) then
					Error <= "1010"; --1010: Invalid SVA Attempt: Signature_R is 0 (Error Flag: IRQ requests Signature rewrite)
				elsif (DATA_Signature_S = ZeroVector) then
					Error <= "1011"; --1011: Invalid SVA Attempt: Signature_S is 0 (Error Flag: IRQ requests Signature rewrite)
				else
					CLK_QUAD <= "00";
					STABILITY_ECDSA_ROUNDS(0) <= '1';
				end if;
			end if;
		elsif (((not Command(3)) and (not Command(2))) = '1') then
			if (((not Command(1)) and (not Command(0))) = '1') then
			--000: Not operating anything, In RW mode
				SGA_PHASELOCK <= '0';
				SVA_PHASELOCK <= '0';
				if (RW = '1') then
					StableOutput <= '0';
					DATABUS <= (others => 'Z');
					if (((not LacthToReadFrom(3)) and LacthToReadFrom(2) and (not LacthToReadFrom(1)) and LacthToReadFrom(0)) = '1') then
						Error <= "0100"; --0100: Illegal Write Attempt: User's Public Key (Warning Flag [should use Generate Key_Public command])
					elsif (((not LacthToReadFrom(3)) and LacthToReadFrom(2) and LacthToReadFrom(1) and LacthToReadFrom(0)) = '1') then
						Error <= "0101"; --0101: Illegal Write Attempt: Shared Key (Warning Flag [should use ECDH command])
					end if;
					RW_PHASELOCK <= "00";
				else
					StableOutput <= '1';
					if (((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0))) = '1') then
						DATABUS <= DATA_Curve_Prime & DATA_Curve_A; --Curve_Prime and Curve_A
					elsif (((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and (not LacthToReadFrom(1)) and LacthToReadFrom(0)) = '1') then
						DATABUS <= DATA_Curve_GX & DATA_Curve_GY; --Curve_GX and Curve_GY
					elsif (((not LacthToReadFrom(3)) and (not LacthToReadFrom(2)) and LacthToReadFrom(1) and (not LacthToReadFrom(0))) = '1') then
						DATABUS <= DATA_Curve_B & DATA_Curve_N; --Curve_B and Curve_N
					elsif (((not LacthToReadFrom(3)) and LacthToReadFrom(2) and (not LacthToReadFrom(1)) and (not LacthToReadFrom(0))) = '1') then
						DATABUS <= ZeroVector & DATA_Key_Private; --Key_Private
						Error <= "0001"; --0001: Illegal Read Attempt Private Key flushed to Databus (Attack Flag: Flush 'Z' Drive recommended)
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
				end if;
			elsif (((not Command(1)) and Command(0)) = '1') then
			--001: Generate Key_Private; PRNG(1,(N-1))
				SGA_PHASELOCK <= '0';
				SVA_PHASELOCK <= '0';
				--Functionality not Implemented, Left as skeleton
				--STABILITY_Generate_Key_Private <= $Stability Output of PRNG$;
			elsif ((Command(1) and (not Command(0))) = '1') then
			--010: Generate Key_Public
				SGA_PHASELOCK <= '0';
				SVA_PHASELOCK <= '0';
				if (not (Command_Previous = Command)) then
					Error <= "0000";
					StableOutput <= '0';
					--Inputs to the APM: Initiate
					APM_PHASELOCK <= '1';
					JPM_PHASELOCK <= '1';
					APM_TERMINAL <= '0';
					StableOutputJPM <= '0';
					--Inputs to the JPM: Initiate
					MemDoublingZ <= UnitVector;
					MemAddingX <= UnitVector;
					MemAddingY <= UnitVector;
					MemAddingZ <= ZeroVector;
					MemNonceX <= UnitVector;
					MemNonceY <= UnitVector;
					MemNonceZ <= ZeroVector;
					Jindex <= UnitVector;
					JComplete <= ZeroVector;
					Jnext <= UnitVector((N-2) downto 0) & "0";
					CLKDBL <= '0';
					J_Finished <= '0';
					--Inputs to the APM: Select
					PM_KEY <= DATA_Key_Private;
					PM_MOD <= DATA_Curve_Prime;
					PM_ECA <= DATA_Curve_A;
					MemDoublingX <= DATA_Curve_GX; --APX
					MemDoublingY <= DATA_Curve_GY; --APY
				else
					if (APM_TERMINAL = '1') then
						STABILITY_Generate_Key_Public <= '1';
						StableOutput <= '1';
						DATABUSIN <= DSA_U & DSA_V; --DATA_Key_Public_User_X --DATA_Key_Public_User_Y
						OP_PHASELOCK <= "00";
					end if;
				end if;
			elsif ((Command(1) and Command(0)) = '1') then
			--011: ECDH
				SGA_PHASELOCK <= '0';
				SVA_PHASELOCK <= '0';
				if (not (Command_Previous = Command)) then
					Error <= "0000";
					StableOutput <= '0';
					STABILITY_ECDH <= '0';
					--Inputs to the APM: Initiate
					APM_PHASELOCK <= '1';
					JPM_PHASELOCK <= '1';
					APM_TERMINAL <= '0';
					StableOutputJPM <= '0';
					--Inputs to the JPM: Initiate
					MemDoublingZ <= UnitVector;
					MemAddingX <= UnitVector;
					MemAddingY <= UnitVector;
					MemAddingZ <= ZeroVector;
					MemNonceX <= UnitVector;
					MemNonceY <= UnitVector;
					MemNonceZ <= ZeroVector;
					Jindex <= UnitVector;
					JComplete <= ZeroVector;
					Jnext <= UnitVector((N-2) downto 0) & "0";
					CLKDBL <= '0';
					J_Finished <= '0';
					--Inputs to the APM: Select
					PM_KEY <= DATA_Key_Private;
					PM_MOD <= DATA_Curve_Prime;
					PM_ECA <= DATA_Curve_A;
					MemDoublingX <= DATA_Key_Public_Other_X; --APX
					MemDoublingY <= DATA_Key_Public_Other_Y; --APY
				else
					if (APM_TERMINAL = '1') then
						STABILITY_ECDH <= '1';
						StableOutput <= '1';
						DATABUSIN <= DSA_U & DSA_V; --DATA_Key_Public_User_X --DATA_Key_Public_User_Y
						OP_PHASELOCK <= "00";
					end if;
				end if;
			end if;
		elsif (((not Command(3)) and Command(2)) = '1') then
			if (((not Command(1)) and (not Command(0))) = '1') then
			--100: HASH
				SGA_PHASELOCK <= '0';
				SVA_PHASELOCK <= '0';
				--Functionality not Implemented, Left as skeleton
				--STABILITY_HASH <= $Stability Output of HASH$;
			elsif (((not Command(1)) and Command(0)) = '1') then
			--101: Generate Signature_K; PRNG(1,(N-1))
				SGA_PHASELOCK <= '0';
				SVA_PHASELOCK <= '0';
				--Functionality not Implemented, Left as skeleton
				--STABILITY_Generate_Signature_K <= $Stability Output of PRNG$;
			elsif ((Command(1) and (not Command(0))) = '1') then
			--110: ECDSA-SGA
				
				if (not (Command_Previous = Command)) then 
					SVA_PHASELOCK <= '0';
					STABILITY_ECDSA_SVA <= '0';
					--Prepare ECDSA registers
					STABILITY_ECDSA_ROUNDS <= (others => '0');
					Error <= "0000";
					StableOutput <= '0';
					--Switch on the SGA algorithm
					SGA_PHASELOCK <= '1';
					SGA_TERMINAL <= '0';
				end if;
			elsif ((Command(1) and Command(0)) = '1') then
			--111: ECDSA_SVA
				if (not (Command_Previous = Command)) then 
					SGA_PHASELOCK <= '0';
					STABILITY_ECDSA_SGA <= '0';
					--Prepare ECDSA registers
					STABILITY_ECDSA_ROUNDS <= (others => '0');
					StableOutput <= '0';
					Error <= "0000";
					SIGNATURE_VERIFIED <= '0';
					--Switch on the SVA algorithm
					SVA_PHASELOCK <= '1';
					SVA_TERMINAL <= '0';
				end if;
			end if;
		elsif (Command(3) = '1') then
			SGA_PHASELOCK <= '0';
			SVA_PHASELOCK <= '0';
			if (Command(2) = '1') then
				if (Command(1) = '1') then
					if (Command(0) = '1') then
						--Command "1111": Error Check: Curve Parameters; (N*(GX,GY) = infinity)
						if (not (Command_Previous = Command)) then
							Error <= "0000";
							--Inputs to the APM: Initiate
							APM_PHASELOCK <= '1';
							JPM_PHASELOCK <= '1';
							APM_TERMINAL <= '0';
							StableOutputJPM <= '0';
							--Inputs to the JPM: Initiate
							MemDoublingZ <= UnitVector;
							MemAddingX <= UnitVector;
							MemAddingY <= UnitVector;
							MemAddingZ <= ZeroVector;
							MemNonceX <= UnitVector;
							MemNonceY <= UnitVector;
							MemNonceZ <= ZeroVector;
							Jindex <= UnitVector;
							JComplete <= ZeroVector;
							Jnext <= UnitVector((N-2) downto 0) & "0";
							CLKDBL <= '0';
							J_Finished <= '0';
							--Inputs to the APM: Select
							PM_KEY <= DATA_Curve_N;
							PM_MOD <= DATA_Curve_Prime;
							PM_ECA <= DATA_Curve_A;
							MemDoublingX <= DATA_Curve_GX; --APX
							MemDoublingY <= DATA_Curve_GY; --APY
						else
							if (APM_TERMINAL = '1') then
								StableOutput <= '1';
								OP_PHASELOCK <= "00";
								if ((DSA_U or DSA_V) = ZeroVector) then
									Error <= "0000";
								else
									Error <= "0010"; --0010: Invalid Curve Parameter: (N*(GX,GY) != infinity) (Error Flag: IRQ recommended)
								end if;
							end if;
						end if;
					else
						--Command "1110": Error Check: Curve Parameters; ((4*A^3 + 27*B^2) mod Prime != 0)
						if (not (Command_Previous = Command)) then
							Error <= "0000";
						else
							--Error <= "0011"; --0011: Invalid Curve Parameter: ((4*A^3 + 27*B^2) mod Prime = 0) (Critical Error Flag: IRQ Mandatory)
							
						end if;
					end if;
				else
					if (Command(0) = '1') then
						--Command "1101": Error Check: Key Parameters; User's
						if (not (Command_Previous = Command)) then
							Error <= "0000";
						else
							--Error <= "0110"; --0110: Invalid Public Key: User's (Error Flag: IRQ Recommended)
							
						end if;
					else
						--Command "1100": Error Check: Key Parameters; Other's
						if (not (Command_Previous = Command)) then
							Error <= "0000";
						else
							--Error <= "0111"; --0111: Invalid Public Key: Other's (Error Flag: IRQ Recommended)
							
						end if;
					end if;
				end if;
			else
				if (Command(1) = '1') then
					if (Command(0) = '1') then
						--Command "1011"
						
					else
						--Command "1010"
						
					end if;
				else
					if (Command(0) = '1') then
						--Command "1001"
						
					else
						--Command "1000"
						
					end if;
				end if;
			end if;
		end if;
		if ((RW_PHASELOCK = "11") and (OP_PHASELOCK = "11")) then
			Command_Previous <= Command;
		end if;
	end if;
end process;

end Behavioral;


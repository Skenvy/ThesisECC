--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:38:57 06/05/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.VECTOR_STANDARD.ALL;
use work.ECC_STANDARD.ALL;
 
ENTITY GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED_TEST IS
END GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED_TEST;
 
ARCHITECTURE behavior OF GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED
    PORT(
         DATABUS : INOUT  std_logic_vector(((2*VecLen)-1) downto 0);
         RW : IN  std_logic;
			--0: Reading From
			--1: Writing To
         LacthToReadFrom : IN  std_logic_vector(3 downto 0);
			--0000: Curve_Prime [((2*N)-1) downto N] & Curve_A [(N-1) downto 0]
			--0001: Curve_GX [((2*N)-1) downto N] & Curve_GY [(N-1) downto 0]
			--0010: Curve_B [((2*N)-1) downto N] & Curve_N [(N-1) downto 0]
			--0011: -
			--0100: Key_Private [(N-1) downto 0]
			--0101: Key_Public_User_X [((2*N)-1) downto N] & Key_Public_User_Y [(N-1) downto 0]
			--		  Note this is the Public key corresponding to the private key
			--0110: Key_Public_Other_X [((2*N)-1) downto N] & Key_Public_Other_Y [(N-1) downto 0]
			--		  Note that this is not the public key corresponding to the private key
			--		  It is another entity's public key for use in DHKE
			--0111: Key_Shared_X [((2*N)-1) downto N] & Key_Shared_Y [(N-1) downto 0]
			--1000: Signature_R [((2*N)-1) downto N] & Signature_S [(N-1) downto 0]
			--1001: Signature_K [(N-1) downto 0]
			--		  A register that can hold a precomputed Signature_K
			--1010: HASH_Total [(N-1) downto 0]
			--		  A register that can hold a precomputed hash value
			--1011: HASH_Input [((2*N)-1) downto 0]
         OtherUserRegister : IN  std_logic_vector(3 downto 0);
         HashStrobeIn : IN  std_logic_vector(1 downto 0);
         HashStrobeOut : OUT  std_logic;
         Command : IN  std_logic_vector(2 downto 0);
			--000: Not operating anything, In RW mode
			--001: Generate Key_Private; PRNG(1,(N-1))
			--010: Generate Key_Public
			--011: ECDH
			--100: HASH
			--101: Generate Signature_K; PRNG(1,(N-1))
			--110: ECDSA-SGA
			--111: ECDSA_SVA
         CLK : IN  std_logic;
         StableOutput : OUT  std_logic;
         Error : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RW : std_logic := '0';
   signal LacthToReadFrom : std_logic_vector(3 downto 0) := (others => '0');
   signal OtherUserRegister : std_logic_vector(3 downto 0) := (others => '0');
   signal HashStrobeIn : std_logic_vector(1 downto 0) := "00";
   signal Command : std_logic_vector(2 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

	--BiDirs
   signal DATABUS : std_logic_vector(((2*VecLen)-1) downto 0);

 	--Outputs
   signal HashStrobeOut : std_logic;
   signal StableOutput : std_logic;
   signal Error : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 40 ns;
	
	--Input Read From
	signal Key_Public_Other_X : std_logic_vector((VecLen-1) downto 0) := "00000";--0
	signal Key_Public_Other_Y : std_logic_vector((VecLen-1) downto 0) := "01011";--11
	signal Key_Private : std_logic_vector((VecLen-1) downto 0) := "01101";--13
	signal HASH_TOTAL : std_logic_vector((VecLen-1) downto 0) := "10101";--21
	
	
	--Output Write To
	signal Key_Shared_X : std_logic_vector((VecLen-1) downto 0) := "00000";
	signal Key_Shared_Y : std_logic_vector((VecLen-1) downto 0) := "00000";
	signal Key_Public_User_X : std_logic_vector((VecLen-1) downto 0) := "00000";
	signal Key_Public_User_Y : std_logic_vector((VecLen-1) downto 0) := "00000";
	
	--Bidir IO RW
	signal Signature_R : std_logic_vector((VecLen-1) downto 0) := "00000";
	signal Signature_S : std_logic_vector((VecLen-1) downto 0) := "00000";
	signal Signature_K : std_logic_vector((VecLen-1) downto 0) := "00000";
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_ECC_ECDSA_CLOCKED_PARAMETERISED PORT MAP (
          DATABUS => DATABUS,
          RW => RW,
          LacthToReadFrom => LacthToReadFrom,
          OtherUserRegister => OtherUserRegister,
          HashStrobeIn => HashStrobeIn,
          HashStrobeOut => HashStrobeOut,
          Command => Command,
          CLK => CLK,
          StableOutput => StableOutput,
          Error => Error
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      Command <= "000";
		RW <= '0';
		--Write the Prime and A
		LacthToReadFrom <= "0000";
		DATABUS <= (others => '0');
      wait for 100 ns;	
		DATABUS <= M17(0) & M17(1);
		RW <= '1';
      wait for CLK_period*(VecLen*3);
		RW <= '0';
		DATABUS <= (others => 'Z');
		--Write the Curve Base Point
		wait for CLK_period*(VecLen*3);
		LacthToReadFrom <= "0001";
		wait for CLK_period*(VecLen*3);
		DATABUS <= M17(3) & M17(4);
		RW <= '1';
		wait for CLK_period*(VecLen*3);
		RW <= '0';
		DATABUS <= (others => 'Z');
		--Write the Curve B and N
		wait for CLK_period*(VecLen*3);
		LacthToReadFrom <= "0010";
		wait for CLK_period*(VecLen*3);
		DATABUS <= M17(2) & M17(5);
		RW <= '1';
		wait for CLK_period*(VecLen*3);
		RW <= '0';
		DATABUS <= (others => 'Z');
		--Write the Key_Public_Other
		wait for CLK_period*(VecLen*3);
		LacthToReadFrom <= "0110";
		wait for CLK_period*(VecLen*3);
		DATABUS <= Key_Public_Other_X & Key_Public_Other_Y;
		RW <= '1';
		wait for CLK_period*(VecLen*3);
		RW <= '0';
		DATABUS <= (others => 'Z');
		--Write the Key_Private
		wait for CLK_period*(VecLen*3);
		LacthToReadFrom <= "0100";
		wait for CLK_period*(VecLen*3);
		DATABUS <= ZeroVector & Key_Private;
		RW <= '1';
		wait for CLK_period*(VecLen*3);
		RW <= '0';
		DATABUS <= (others => 'Z');
		--Compute the user's public key
		wait for CLK_period*(VecLen*3);
		Command <= "010";
		wait for CLK_period*(VecLen*390);
		--Read out the user's public key
		wait for CLK_period*(VecLen*3);
		Command <= "000";
		LacthToReadFrom <= "0101";
		RW <= '0';
		wait for CLK_period*(VecLen*2);
		Key_Public_User_X <= DATABUS(((2*VecLen)-1) downto VecLen);
		Key_Public_User_Y <= DATABUS((VecLen-1) downto 0);
		--Compute the shared key
		wait for CLK_period*(VecLen*3);
		wait for CLK_period*(VecLen*3);
		Command <= "011";
		wait for CLK_period*(VecLen*390);
		--Read out the shared key
		wait for CLK_period*(VecLen*3);
		Command <= "000";
		LacthToReadFrom <= "0111";
		RW <= '0';
		wait for CLK_period*(VecLen*2);
		Key_Shared_X <= DATABUS(((2*VecLen)-1) downto VecLen);
		Key_Shared_Y <= DATABUS((VecLen-1) downto 0);
		
		
      wait;
   end process;

END;

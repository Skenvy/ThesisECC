--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:36:49 06/04/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED
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
 
ENTITY GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED_TEST IS
END GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED_TEST;
 
ARCHITECTURE behavior OF GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED
    PORT(
         KEY_PRIVATE : IN  std_logic_vector((VecLen-1) downto 0);
         KEY_PUBLIC : IN  std_logic_vector(((2*VecLen)-1) downto 0);
         SHARED_SECRET : OUT  std_logic_vector(((2*VecLen)-1) downto 0);
         CLK : IN  std_logic;
         StableOutput : OUT  std_logic
        );
    END COMPONENT;
	 
	 COMPONENT GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED
    Port ( KEY : in  STD_LOGIC_VECTOR ((VecLen-1) downto 0);
           AQX : out STD_LOGIC_VECTOR ((VecLen-1) downto 0);
           AQY : out STD_LOGIC_VECTOR ((VecLen-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
	 end COMPONENT;
	 
	 component GENERIC_FAP_RELATIONAL
	 Generic (N : Natural;
				 VType : Natural); --0 for just equality, 1 for Greater Than test : Default 1
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC;
           G : out  STD_LOGIC);
	 end component;
    

   --Inputs
   signal KEY_PRIVATE_U : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal KEY_PUBLIC_U : std_logic_vector(((2*VecLen)-1) downto 0) := (others => '0');
	signal KEY_PRIVATE_V : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal KEY_PUBLIC_V : std_logic_vector(((2*VecLen)-1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

	signal A_PRIVATE : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal A_PUBLIC : std_logic_vector(((2*VecLen)-1) downto 0) := (others => '0');
	signal A_STABLE : std_logic;
	
	signal B_PRIVATE : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal B_PUBLIC : std_logic_vector(((2*VecLen)-1) downto 0) := (others => '0');
	signal B_STABLE : std_logic;
	
 	--Outputs
   signal SHARED_SECRET_U : std_logic_vector(((2*VecLen)-1) downto 0);
	signal SHARED_SECRET_V : std_logic_vector(((2*VecLen)-1) downto 0);
   signal StableOutput_U : std_logic;
   signal StableOutput_V : std_logic;
	
	signal SecretsEqual : std_logic;
	signal SecretsSame : std_logic;
	
	signal SecretsThatMatch : Integer := 0;

   -- Clock period definitions
   constant CLK_period : time := 60 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED PORT MAP (
          KEY_PRIVATE => KEY_PRIVATE_U,
          KEY_PUBLIC => KEY_PUBLIC_U,
          SHARED_SECRET => SHARED_SECRET_U,
          CLK => CLK,
          StableOutput => StableOutput_U
        );
		  
	-- Instantiate the Unit Under Test (UUT)
   vut: GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED PORT MAP (
          KEY_PRIVATE => KEY_PRIVATE_V,
          KEY_PUBLIC => KEY_PUBLIC_V,
          SHARED_SECRET => SHARED_SECRET_V,
          CLK => CLK,
          StableOutput => StableOutput_V
        );
	
	at : GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED
    Port Map ( KEY => A_PRIVATE,
           AQX => A_PUBLIC(((2*VecLen)-1) downto VecLen),
           AQY => A_PUBLIC((VecLen-1) downto 0),
			  CLK => CLK,
			  StableOutput => A_STABLE);
	
	bt : GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED
    Port Map ( KEY => B_PRIVATE,
           AQX => B_PUBLIC(((2*VecLen)-1) downto VecLen),
           AQY => B_PUBLIC((VecLen-1) downto 0),
			  CLK => CLK,
			  StableOutput => B_STABLE);
			  
	KEY_PUBLIC_U <= A_PUBLIC;
	KEY_PRIVATE_U <= B_PRIVATE;
	KEY_PUBLIC_V <= B_PUBLIC;
	KEY_PRIVATE_V <= A_PRIVATE;
	
	eq : GENERIC_FAP_RELATIONAL
	 Generic Map (N => (2*VecLen),
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => SHARED_SECRET_U,
           B => SHARED_SECRET_V,
           E => SecretsEqual,
           G => open);
			  
	
	
   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
		SecretsSame <= (SecretsEqual and StableOutput_V and StableOutput_U and A_STABLE and B_STABLE);
   end process;
 
	count_proc: process(SecretsSame)
   begin	
		if (rising_edge(SecretsSame)) then
			SecretsThatMatch <= SecretsThatMatch + 1;
		end if;
	end process;

   -- Stimulus process
   stim_proc: process
   begin		
      A_PRIVATE <= "00000";
		B_PRIVATE <= "00000";
      wait for 100 ns;
		--Scan all 1's
		A_PRIVATE <= "00001";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 2's
		A_PRIVATE <= "00010";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 3's
		A_PRIVATE <= "00011";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 4's
		A_PRIVATE <= "00100";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 5's
		A_PRIVATE <= "00101";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 6's
		A_PRIVATE <= "00110";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 7's
		A_PRIVATE <= "00111";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 8's
		A_PRIVATE <= "01000";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 9's
		A_PRIVATE <= "01001";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 10's
		A_PRIVATE <= "01010";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 11's
		A_PRIVATE <= "01011";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 12's
		A_PRIVATE <= "01100";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 13's
		A_PRIVATE <= "01101";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 14's
		A_PRIVATE <= "01110";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 15's
		A_PRIVATE <= "01111";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 16's
		A_PRIVATE <= "10000";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 17's
		A_PRIVATE <= "10001";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 18's
		A_PRIVATE <= "10010";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		--Scan all 19's
		A_PRIVATE <= "10011";
		B_PRIVATE <= "00000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "00111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01011";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01100";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01101";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01110";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "01111";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10000";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10001";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10010";
		wait for CLK_period*(VecLen*375);
		B_PRIVATE <= "10011";
		wait for CLK_period*(VecLen*375);
		
      wait;
   end process;

END;

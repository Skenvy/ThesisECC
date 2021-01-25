--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:04:12 06/01/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED
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
 
ENTITY GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED_TEST IS
END GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED_TEST;
 
ARCHITECTURE behavior OF GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED
    PORT(
         KEY : IN  std_logic_vector((VecLen-1) downto 0);
         JPX : IN  std_logic_vector((VecLen-1) downto 0);
         JPY : IN  std_logic_vector((VecLen-1) downto 0);
         JPZ : IN  std_logic_vector((VecLen-1) downto 0);
         JQX : OUT  std_logic_vector((VecLen-1) downto 0);
         JQY : OUT  std_logic_vector((VecLen-1) downto 0);
         JQZ : OUT  std_logic_vector((VecLen-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         ECC_A : IN  std_logic_vector((VecLen-1) downto 0);
         CLK : IN  std_logic;
         StableOutput : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal KEY : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal JPX : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal JPY : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal JPZ : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal ECC_A : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal JQX : std_logic_vector((VecLen-1) downto 0);
   signal JQY : std_logic_vector((VecLen-1) downto 0);
   signal JQZ : std_logic_vector((VecLen-1) downto 0);
   signal StableOutput : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED PORT MAP (
          KEY => KEY,
          JPX => JPX,
          JPY => JPY,
          JPZ => JPZ,
          JQX => JQX,
          JQY => JQY,
          JQZ => JQZ,
          Modulus => Modulus,
          ECC_A => ECC_A,
          CLK => CLK,
          StableOutput => StableOutput
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
		Modulus <= "10001";
		ECC_A <= "00010";
      -- hold reset state for 100 ns.
      wait for 100 ns; --Expect (7,6,1)
		KEY <= "00001";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
      wait for CLK_period*(VecLen*400); --Expect (1,1,0)
		KEY <= "00000";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
		wait for CLK_period*(VecLen*400); --Expect (6,6,12)
		KEY <= "00010";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
		wait for CLK_period*(VecLen*400); --Expect (2,8,5)
		KEY <= "00011";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
		wait for CLK_period*(VecLen*400); --Expect (3,4,14)
		KEY <= "01111";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
      wait;
   end process;

END;

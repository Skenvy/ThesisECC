--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:21:25 06/04/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED
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
 
ENTITY GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED_TEST IS
END GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED_TEST;
 
ARCHITECTURE behavior OF GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED
    PORT(
         KEY : IN  std_logic_vector((VecLen-1) downto 0);
         AQX : OUT  std_logic_vector((VecLen-1) downto 0);
         AQY : OUT  std_logic_vector((VecLen-1) downto 0);
         CLK : IN  std_logic;
         StableOutput : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal KEY : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal AQX : std_logic_vector((VecLen-1) downto 0);
   signal AQY : std_logic_vector((VecLen-1) downto 0);
   signal StableOutput : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED PORT MAP (
          KEY => KEY,
          AQX => AQX,
          AQY => AQY,
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
      -- hold reset state for 100 ns.
      wait for 100 ns; --Expect (7,6)
		KEY <= "00001";
      wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00000";
		wait for CLK_period*(VecLen*500); --Expect (5,16)
		KEY <= "00010";
		wait for CLK_period*(VecLen*500); --Expect (13,7)
		KEY <= "00011";
		wait for CLK_period*(VecLen*500); --Expect (6,3)
		KEY <= "01111";
      wait;
   end process;

END;

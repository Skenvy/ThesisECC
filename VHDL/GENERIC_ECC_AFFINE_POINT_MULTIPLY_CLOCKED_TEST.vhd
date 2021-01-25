--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:20:18 06/01/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED
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
 
ENTITY GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_TEST IS
END GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_TEST;
 
ARCHITECTURE behavior OF GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED
    PORT(
         KEY : IN  std_logic_vector((VecLen-1) downto 0);
         APX : IN  std_logic_vector((VecLen-1) downto 0);
         APY : IN  std_logic_vector((VecLen-1) downto 0);
         AQX : OUT  std_logic_vector((VecLen-1) downto 0);
         AQY : OUT  std_logic_vector((VecLen-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         ECC_A : IN  std_logic_vector((VecLen-1) downto 0);
         CLK : IN  std_logic;
         StableOutput : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal KEY : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal APX : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal APY : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal ECC_A : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal AQX : std_logic_vector((VecLen-1) downto 0);
   signal AQY : std_logic_vector((VecLen-1) downto 0);
   signal StableOutput : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 60 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED PORT MAP (
          KEY => KEY,
          APX => APX,
          APY => APY,
          AQX => AQX,
          AQY => AQY,
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
      wait for 100 ns; 						 --Expect (7,6)
		KEY <= "00001";
		APX <= "00111";
		APY <= "00110";
      wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00000";
		APX <= "00111";
		APY <= "00110";
		wait for CLK_period*(VecLen*500); --Expect (5,16)
		KEY <= "00010";
		APX <= "00111";
		APY <= "00110";
		wait for CLK_period*(VecLen*500); --Expect (13,7)
		KEY <= "00011";
		APX <= "00111";
		APY <= "00110";
		wait for CLK_period*(VecLen*500); --Expect (6,3)
		KEY <= "01111";
		APX <= "00111";
		APY <= "00110";
		--Scan (7,6)
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00000";
		APX <= "00111";
		APY <= "00110";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00001";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00010";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00011";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00100";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00101";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00110";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "00111";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "01000";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "01001";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "01010";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "01011";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "01100";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "01101";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "01110";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "01111";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "10000";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "10001";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "10010";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "10011";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "10100";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "10101";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "10110";
		wait for CLK_period*(VecLen*500); --Expect (1,1,0)
		KEY <= "10111";
      wait;
   end process;

END;

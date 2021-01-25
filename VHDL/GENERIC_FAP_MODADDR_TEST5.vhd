--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:13:58 05/09/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_MODADDR_TEST5.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_MODADDR
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
 
ENTITY GENERIC_FAP_MODADDR_TEST5 IS
END GENERIC_FAP_MODADDR_TEST5;
 
ARCHITECTURE behavior OF GENERIC_FAP_MODADDR_TEST5 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_MODADDR
    PORT(
         SummandA : IN  std_logic_vector((VecLen-1) downto 0);
         SummandB : IN  std_logic_vector((VecLen-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         Summation : OUT  std_logic_vector((VecLen-1) downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal SummandA : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal SummandB : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');

 	--Outputs
   signal Summation : std_logic_vector((VecLen-1) downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_MODADDR PORT MAP (
          SummandA => SummandA,
          SummandB => SummandB,
          Modulus => Modulus,
          Summation => Summation
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns. Is Returning 0 (First Return)
		SummandA <= "00000";
		SummandB <= "00000";
		Modulus <= "00000";
      wait for 30 ns;
		--Check Return 0 (Second Return)
		SummandA <= "00000";
		SummandB <= "00000";
		Modulus <= "00110";
		wait for 30 ns;
		--Check Return 0 (Third Return)
		SummandA <= "00000";
		SummandB <= "00000";
		Modulus <= "10111";
		wait for 30 ns;
		--Check Return 15 (Fourth Return)
		SummandA <= "00100";
		SummandB <= "01011";
		Modulus <= "10111";
		wait for 30 ns;
		--Check Return 31-23=8="01000" (Fifth Return)
		SummandA <= "10100";
		SummandB <= "01011";
		Modulus <= "10111";
		
      wait;
   end process;

END;

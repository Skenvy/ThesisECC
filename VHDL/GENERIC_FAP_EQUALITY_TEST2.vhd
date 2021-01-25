--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:18:50 05/08/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_EQUALITY_TEST2.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_EQUALITY
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
 
ENTITY GENERIC_FAP_EQUALITY_TEST2 IS
END GENERIC_FAP_EQUALITY_TEST2;
 
ARCHITECTURE behavior OF GENERIC_FAP_EQUALITY_TEST2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_EQUALITY
    PORT(
         A : IN  std_logic_vector((VecLen-1) downto 0);
         B : IN  std_logic_vector((VecLen-1) downto 0);
         E : OUT  std_logic
        );
    END COMPONENT;
   
	--Generics

   --Inputs
   signal A : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal B : std_logic_vector((VecLen-1) downto 0) := (others => '0');
 	--Outputs
   signal E : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_EQUALITY
		PORT MAP (
          A => A,
          B => B,
          E => E
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns. Is Returning 1 (First Return)
      wait for 30 ns;
		--Check Return 0 (Second Return)
		--A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		--B <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		A <= "00000";
		B <= "00000";
		wait for 30 ns;
		--Check Return 0 (Third Return)
		--A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		--B <= X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
		A <= "01000";
		B <= "00010";
		wait for 30 ns;
		--Check Return 1 (Fourth Return)
		--A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		--B <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		A <= "11111";
		B <= "11111";
		wait for 30 ns;
		--Check Return 0 (Fifth Return)
		--A <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		--B <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0F00_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		A <= "11100";
		B <= "11100";
		wait for 30 ns;
		--Check Return 1 (Sixth Return)
		--A <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		--B <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		A <= "01110";
		B <= "01010";
      wait;
   end process;

END;

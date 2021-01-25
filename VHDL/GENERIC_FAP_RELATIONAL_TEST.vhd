--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:18:27 05/09/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_RELATIONAL_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_RELATIONAL
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
 
ENTITY GENERIC_FAP_RELATIONAL_TEST IS
END GENERIC_FAP_RELATIONAL_TEST;
 
ARCHITECTURE behavior OF GENERIC_FAP_RELATIONAL_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_RELATIONAL
    PORT(
         A : IN  std_logic_vector((VecLen-1) downto 0);
         B : IN  std_logic_vector((VecLen-1) downto 0);
         E : OUT  std_logic;
         G : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal B : std_logic_vector((VecLen-1) downto 0) := (others => '0');

 	--Outputs
   signal E : std_logic;
   signal G : std_logic;
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_RELATIONAL PORT MAP (
          A => A,
          B => B,
          E => E,
          G => G
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns. Is Returning 0 (First Return)
      wait for 30 ns;
		--Check Return 1 (Second Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 30 ns;
		--Check Return 1 (Third Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
		--Check Return 0 (Fourth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Check Return 0 (Fifth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0F00_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Check Return 0 (Sixth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Check Return 1 (Seventh Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0F00_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Check Return 1 (Eighth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0500_ABCD_0000_DEAD_0F00_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"FFFF_FFFF_0000_0001_0000_0300_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Check Return 1 (Eighth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0500_ABCD_0000_DEAD_0F00_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"DFFF_FFFF_0000_0001_0000_0300_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Check Return X (Ninth Return)
		A <= X"C000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		B <= X"8000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 30 ns;
		--Check Return X (Tenth Return)
		A <= X"E000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		B <= X"C000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 30 ns;
		--Check Return X (Eleventh Return)
		A <= X"FF00_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		B <= X"FC00_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
      wait;
   end process;

END;

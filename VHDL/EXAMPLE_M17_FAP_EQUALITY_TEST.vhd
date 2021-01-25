--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:23:37 05/08/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/EXAMPLE_M17_FAP_EQUALITY_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EXAMPLE_M17_FAP_EQUALITY
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY EXAMPLE_M17_FAP_EQUALITY_TEST IS
END EXAMPLE_M17_FAP_EQUALITY_TEST;
 
ARCHITECTURE behavior OF EXAMPLE_M17_FAP_EQUALITY_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXAMPLE_M17_FAP_EQUALITY
    PORT(
         A : IN  std_logic_vector(255 downto 0);
         B : IN  std_logic_vector(255 downto 0);
         Equal : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(255 downto 0) := (others => '0');
   signal B : std_logic_vector(255 downto 0) := (others => '0');

 	--Outputs
   signal Equal : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXAMPLE_M17_FAP_EQUALITY PORT MAP (
          A => A,
          B => B,
          Equal => Equal
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns. Is Returning 1 (First Return)
      wait for 30 ns;
		--Check Return 0 (Second Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 30 ns;
		--Check Return 0 (Third Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
		--Check Return 1 (Fourth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Check Return 0 (Fifth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0F00_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Check Return 1 (Sixth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"FFFF_FFFF_0000_0001_0000_0000_ABCD_0000_DEAD_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
      wait;
   end process;

END;

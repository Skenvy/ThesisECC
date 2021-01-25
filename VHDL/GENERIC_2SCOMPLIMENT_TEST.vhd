--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:16:28 05/09/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_2SCOMPLIMENT_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_2SCOMPLIMENT
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
 
ENTITY GENERIC_2SCOMPLIMENT_TEST IS
END GENERIC_2SCOMPLIMENT_TEST;
 
ARCHITECTURE behavior OF GENERIC_2SCOMPLIMENT_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_2SCOMPLIMENT
    PORT(
         A : IN  std_logic_vector((VecLen-1) downto 0);
         C : OUT  std_logic_vector((VecLen-1) downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector((VecLen-1) downto 0) := (others => '0');

 	--Outputs
   signal C : std_logic_vector((VecLen-1) downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_2SCOMPLIMENT PORT MAP (
          A => A,
          C => C
        );
		  
   -- Stimulus process
   stim_proc: process
   begin	
		-- hold reset state for 100 ns. Is Returning 0 (First Return)
      wait for 30 ns;
      --Check Return 1 (Third Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		--B <= X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
      --Check Return 1 (Third Return)
		A <= X"FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		--B <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
      --Check Return 1 (Third Return)
		A <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0005";
		--B <= X"FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFB";
		
      wait;
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:12:09 05/08/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_EQUALITY_TEST.vhd
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY GENERIC_FAP_EQUALITY_TEST IS
END GENERIC_FAP_EQUALITY_TEST;
 
ARCHITECTURE behavior OF GENERIC_FAP_EQUALITY_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_EQUALITY
    PORT(
         A : IN  std_logic_vector(-1 to 0);
         B : IN  std_logic_vector(-1 to 0);
         E : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(-1 to 0) := (others => '0');
   signal B : std_logic_vector(-1 to 0) := (others => '0');

 	--Outputs
   signal E : std_logic;
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_EQUALITY PORT MAP (
          A => A,
          B => B,
          E => E
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	


      wait;
   end process;

END;

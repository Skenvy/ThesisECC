--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:44:00 03/10/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/UTIL_2sComp_Test.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Utility_2sCompliment_256
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
 
 --UTIL_2sComp_Test
ENTITY STRUC_UTIL_2sCompliment_256_TEST IS
END STRUC_UTIL_2sCompliment_256_TEST;
 
ARCHITECTURE behavior OF STRUC_UTIL_2sCompliment_256_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT STRUC_UTIL_2sCompliment_256
    PORT(
         InVal : IN  std_logic_vector(255 downto 0);
         InComplimented : OUT  std_logic_vector(255 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal InVal : std_logic_vector(255 downto 0) := (others => '0');

 	--Outputs
   signal InComplimented : std_logic_vector(255 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: STRUC_UTIL_2sCompliment_256 PORT MAP (
          InVal => InVal,
          InComplimented => InComplimented
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 10 ns; --Insert Zero Vector, Check Return is Zero
		InVal <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 10 ns; --Insert Full Vector, Check Return is Unit
		InVal <= X"FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 10 ns; --Insert ~Full Vector, Check Return is ~010000000000000000
		InVal <= X"FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000";
		

      wait;
   end process;

END;

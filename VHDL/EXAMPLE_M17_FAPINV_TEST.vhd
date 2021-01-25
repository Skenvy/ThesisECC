--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:12:58 03/28/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/EXAMPLE_M17_FAPINV_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EXAMPLE_M17_FAPINV
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
USE ieee.numeric_std.ALL;
 
ENTITY EXAMPLE_M17_FAPINV_TEST IS
END EXAMPLE_M17_FAPINV_TEST;
 
ARCHITECTURE behavior OF EXAMPLE_M17_FAPINV_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXAMPLE_M17_FAPINV
    PORT(
         Element : IN  std_logic_vector(4 downto 0);
         Inverse : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Element : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal Inverse : std_logic_vector(4 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXAMPLE_M17_FAPINV PORT MAP (
          Element => Element,
          Inverse => Inverse
        );

   -- Stimulus process
   stim_proc: process
   begin	
		Element <= "00001";
      wait for 30 ns;	
		Element <= "00000";
		wait for 30 ns;	
		Element <= "00001";
		wait for 30 ns;	
		Element <= "00010";
		wait for 30 ns;	
		Element <= "00011";
		wait for 30 ns;	
		Element <= "00100";
		wait for 30 ns;	
		Element <= "00101";
		wait for 30 ns;	
		Element <= "00110";
		wait for 30 ns;	
		Element <= "00111";
		wait for 30 ns;	
		Element <= "01000";
		wait for 30 ns;	
		Element <= "01001";
		wait for 30 ns;	
		Element <= "01010";
		wait for 30 ns;	
		Element <= "01011";
		wait for 30 ns;	
		Element <= "01100";
		wait for 30 ns;	
		Element <= "01101";
		wait for 30 ns;	
		Element <= "01110";
		wait for 30 ns;	
		Element <= "01111";
		wait for 30 ns;	
		Element <= "10000";
		wait for 30 ns;	
		Element <= "10001";
		wait for 30 ns;	
		Element <= "10101";
		wait for 30 ns;	
		Element <= "11001";
		
      wait;
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:05:07 05/09/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_MODADDR_TEST3.vhd
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY GENERIC_FAP_MODADDR_TEST3 IS
END GENERIC_FAP_MODADDR_TEST3;
 
ARCHITECTURE behavior OF GENERIC_FAP_MODADDR_TEST3 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_MODADDR
    PORT(
         A : IN  std_logic_vector(255 downto 0);
         B : IN  std_logic_vector(255 downto 0);
         M : IN  std_logic_vector(255 downto 0);
         S : OUT  std_logic_vector(255 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(255 downto 0) := (others => '0');
   signal B : std_logic_vector(255 downto 0) := (others => '0');
   signal M : std_logic_vector(255 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(255 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_MODADDR PORT MAP (
          A => A,
          B => B,
          M => M,
          S => S
        );

   -- Clock process definitions
   <clock>_process :process
   begin
		<clock> <= '0';
		wait for <clock>_period/2;
		<clock> <= '1';
		wait for <clock>_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

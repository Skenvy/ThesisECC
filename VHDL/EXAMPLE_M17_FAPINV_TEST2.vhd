--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:25:18 03/31/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/EXAMPLE_M17_FAPINV_TEST2.vhd
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY EXAMPLE_M17_FAPINV_TEST2 IS
END EXAMPLE_M17_FAPINV_TEST2;
 
ARCHITECTURE behavior OF EXAMPLE_M17_FAPINV_TEST2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXAMPLE_M17_FAPINV
    PORT(
         Element : IN  std_logic_vector(4 downto 0);
         Inverse : OUT  std_logic_vector(4 downto 0);
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Element : std_logic_vector(4 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal Inverse : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXAMPLE_M17_FAPINV PORT MAP (
          Element => Element,
          Inverse => Inverse,
          CLK => CLK
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		Element <= "00001";
      wait for CLK_period*50;
		Element <= "00000";
		wait for CLK_period*50;	
		Element <= "00001";
		wait for CLK_period*50;	
		Element <= "00010";
		wait for CLK_period*50;	
		Element <= "00011";
		wait for CLK_period*50;	
		Element <= "00100";
		wait for CLK_period*50;	
		Element <= "00101";
		wait for CLK_period*50;	
		Element <= "00110";
		wait for CLK_period*50;	
		Element <= "00111";
		wait for CLK_period*50;
		Element <= "01000";
		wait for CLK_period*50;	
		Element <= "01001";
		wait for CLK_period*50;	
		Element <= "01010";
		wait for CLK_period*50;	
		Element <= "01011";
		wait for CLK_period*50;	
		Element <= "01100";
		wait for CLK_period*50;	
		Element <= "01101";
		wait for CLK_period*50;	
		Element <= "01110";
		wait for CLK_period*50;	
		Element <= "01111";
		wait for CLK_period*50;	
		Element <= "10000";
		wait for CLK_period*50;	
		Element <= "10001";
		wait for CLK_period*50;	
		Element <= "10101";
		wait for CLK_period*50;	
		Element <= "11001";
      wait;
   end process;

END;

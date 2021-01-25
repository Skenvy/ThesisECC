--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:27:41 03/31/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/EXAMPLE_M17_ECCPMULT_TEST2.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EXAMPLE_M17_PMULT_Jacobian
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
 
ENTITY EXAMPLE_M17_ECCPMULT_TEST2 IS
END EXAMPLE_M17_ECCPMULT_TEST2;
 
ARCHITECTURE behavior OF EXAMPLE_M17_ECCPMULT_TEST2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXAMPLE_M17_PMULT_Jacobian
    PORT(
         k : IN  std_logic_vector((VecLen - 1) downto 0);
         JPX : IN  std_logic_vector((VecLen - 1) downto 0);
         JPY : IN  std_logic_vector((VecLen - 1) downto 0);
         JPZ : IN  std_logic_vector((VecLen - 1) downto 0);
         JQX : OUT  std_logic_vector((VecLen - 1) downto 0);
         JQY : OUT  std_logic_vector((VecLen - 1) downto 0);
         JQZ : OUT  std_logic_vector((VecLen - 1) downto 0);
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal k : std_logic_vector((VecLen - 1) downto 0) := (others => '0');
   signal JPX : std_logic_vector((VecLen - 1) downto 0) := (others => '0');
   signal JPY : std_logic_vector((VecLen - 1) downto 0) := (others => '0');
   signal JPZ : std_logic_vector((VecLen - 1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal JQX : std_logic_vector((VecLen - 1) downto 0);
   signal JQY : std_logic_vector((VecLen - 1) downto 0);
   signal JQZ : std_logic_vector((VecLen - 1) downto 0);

   -- Clock period definitions
   constant CLK_period : time := 300 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXAMPLE_M17_PMULT_Jacobian PORT MAP (
          k => k,
          JPX => JPX,
          JPY => JPY,
          JPZ => JPZ,
          JQX => JQX,
          JQY => JQY,
          JQZ => JQZ,
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
		k <= "00001";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
      wait for CLK_period*10;
		k <= "00000";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
		wait for CLK_period*10;
		k <= "00010";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
		wait for CLK_period*10;
		k <= "00011";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
		wait for CLK_period*10;
		k <= "01111";
		JPX <= "00111";
		JPY <= "00110";
		JPZ <= "00001";
		wait for CLK_period*10;
		
      -- insert stimulus here 

      wait;
   end process;

END;

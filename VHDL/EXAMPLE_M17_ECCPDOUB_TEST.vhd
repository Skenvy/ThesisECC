--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:06:05 03/30/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/EXAMPLE_M17_ECCPDOUB_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EXAMPLE_M17_ECCPDJ2J
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
 
ENTITY EXAMPLE_M17_ECCPDOUB_TEST IS
END EXAMPLE_M17_ECCPDOUB_TEST;
 
ARCHITECTURE behavior OF EXAMPLE_M17_ECCPDOUB_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXAMPLE_M17_ECCPDJ2J
    PORT(
         AX : IN  std_logic_vector(4 downto 0);
         AY : IN  std_logic_vector(4 downto 0);
         AZ : IN  std_logic_vector(4 downto 0);
         CX : OUT  std_logic_vector(4 downto 0);
         CY : OUT  std_logic_vector(4 downto 0);
         CZ : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal AX : std_logic_vector(4 downto 0) := (others => '0');
   signal AY : std_logic_vector(4 downto 0) := (others => '0');
   signal AZ : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal CX : std_logic_vector(4 downto 0);
   signal CY : std_logic_vector(4 downto 0);
   signal CZ : std_logic_vector(4 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXAMPLE_M17_ECCPDJ2J PORT MAP (
          AX => AX,
          AY => AY,
          AZ => AZ,
          CX => CX,
          CY => CY,
          CZ => CZ
        );

   -- Stimulus process
   stim_proc: process
   begin	
		AX <= "00000";
		AY <= "00000";
		AZ <= "00000";
      wait for 100 ns;	--Show equal to (3,1)
		AX <= "00110";
		AY <= "00011";
		AZ <= "00001";
		wait for 100 ns;	--show equal to (5,16)
		AX <= "00111";
		AY <= "00110";
		AZ <= "00001";
		wait for 100 ns;	--show equal to (0,11)
		AX <= "10000";
		AY <= "00011";
		AZ <= "00001";
		
      wait;
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:29:49 03/24/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/STRUC_UTIL_RAM_256_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: STRUC_UTIL_RAM_256
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
 
ENTITY STRUC_UTIL_RAM_256_TEST IS
END STRUC_UTIL_RAM_256_TEST;
 
ARCHITECTURE behavior OF STRUC_UTIL_RAM_256_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT STRUC_UTIL_RAM_256
    PORT(
         WE : IN  std_logic;
         RE : IN  std_logic;
         Data : INOUT  std_logic_vector(255 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal WE : std_logic := '0';
   signal RE : std_logic := '0';
	signal trap : std_logic_vector(255 downto 0);
	--BiDirs
   signal Data : std_logic_vector(255 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: STRUC_UTIL_RAM_256 PORT MAP (
          WE => WE,
          RE => RE,
          Data => Data
        );

   stim_proc: process
   begin	
      wait for 10 ns;	
		Data <= X"0000_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		WE <= '0';
		RE <= '0';
		wait for 10 ns;
		Data <= X"0000_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		WE <= '1';
		RE <= '0';
		wait for 10 ns;
		Data <= X"FFFF_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF";
		WE <= '0';
		RE <= '1';
		wait for 10 ns;
		Data <= (others => 'Z');
		WE <= '0';
		RE <= '1';
		trap <= Data;
		wait for 10 ns;
		Data <= (others => 'Z');
		trap <= Data;
		WE <= '0';
		RE <= '1';
      wait;
		
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:21:49 05/09/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_LINADDRMUX_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_LINADDRMUX
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
 
ENTITY GENERIC_FAP_LINADDRMUX_TEST IS
END GENERIC_FAP_LINADDRMUX_TEST;
 
ARCHITECTURE behavior OF GENERIC_FAP_LINADDRMUX_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_LINADDRMUX
    PORT(
         A : IN  std_logic_vector(255 downto 0);
         B : IN  std_logic_vector(255 downto 0);
         S : OUT  std_logic_vector(256 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(255 downto 0) := (others => '0');
   signal B : std_logic_vector(255 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(256 downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_LINADDRMUX PORT MAP (
          A => A,
          B => B,
          S => S
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns. Is Returning ZeroVector (First Return)
      wait for 30 ns;
		--Add the Prime and Zero, Check Return ZeroVector (Second Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 30 ns;
		--Add the Prime and its inverse, Check Return "The inverse, as the inverse addition only equals zero inside the cell" (Third Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
		--Add the Prime and 1, Check Return 1 (Fourth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
		--Add the Prime and FFFF_FFFF, Check Return FFFF_FFFF (Fifth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		B <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_FFFF_FFFF";
		wait for 30 ns;
		--Add the (Prime-1) and 1, Check Return ZeroVector (Sixth Return)
		A <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFE";
		B <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
		--Add the (StringA) and (String5), Check Return StringF (Seventh Return)
		A <= X"0000_0000_0000_0000_0000_0000_0000_0000_3333_1111_0000_0000_0000_AAAA_AAAA_AAAA";
		B <= X"0000_0000_0000_0000_0000_0000_0000_0000_2222_7777_0000_0000_0000_5555_5555_5555";
		wait for 30 ns;
      wait;
   end process;

END;

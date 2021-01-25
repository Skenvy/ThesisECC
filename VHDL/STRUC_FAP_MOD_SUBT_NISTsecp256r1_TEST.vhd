--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:56:08 03/13/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/Subtraction_Mod_256.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Subtraction_Modulo_256
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
 
--Subtraction_Mod_256
ENTITY STRUC_FAP_MOD_SUBT_NISTsecp256r1_TEST IS
END STRUC_FAP_MOD_SUBT_NISTsecp256r1_TEST;
 
ARCHITECTURE behavior OF STRUC_FAP_MOD_SUBT_NISTsecp256r1_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT STRUC_FAP_MOD_SUBT_NISTsecp256r1
    PORT(
         Minuend : IN  std_logic_vector(255 downto 0);
         Subtrahend : IN  std_logic_vector(255 downto 0);
         Difference : OUT  std_logic_vector(255 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Minuend : std_logic_vector(255 downto 0) := (others => '0');
   signal Subtrahend : std_logic_vector(255 downto 0) := (others => '0');

 	--Outputs
   signal Difference : std_logic_vector(255 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: STRUC_FAP_MOD_SUBT_NISTsecp256r1 PORT MAP (
          Minuend => Minuend,
          Subtrahend => Subtrahend,
          Difference => Difference
	);
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 10 ns;	
		--Subtract zero from the Prime, Check Return ZeroVector (Second Return) [Returns Prime, subtraction is designed for less than Prime as inputs.]
		Minuend <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		Subtrahend <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 10 ns;	
		--Subtract 000F from the Prime, Check Return Prime ending with _FFF0 (Third Return)
		Minuend <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		Subtrahend <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_000F";
		wait for 10 ns;	
		--Subtract randomness from itself, Check Return ZeroVector (Fourth Return)
		Minuend <= X"0FFF_FFFF_ABCD_0001_0000_0000_5678_0000_9BC3_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		Subtrahend <= X"0FFF_FFFF_ABCD_0001_0000_0000_5678_0000_9BC3_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 10 ns;	
		--Subtract the Prime from zero, Check Return ZeroVector (Fifth Return)
		Subtrahend <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		Minuend <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 10 ns;
		--Subtract the Prime, less 000F from zero, Check Return 000F (Sixth Return)
		Subtrahend <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFF0";
		Minuend <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 10 ns;
		--Subtract zero from the Prime, Check Return ZeroVector (Seventh Return)
		Minuend <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		Subtrahend <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		
      wait;
   end process;

END;

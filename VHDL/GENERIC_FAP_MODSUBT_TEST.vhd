--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:49:28 05/09/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_MODSUBT_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_MODSUBT
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
 
ENTITY GENERIC_FAP_MODSUBT_TEST IS
END GENERIC_FAP_MODSUBT_TEST;
 
ARCHITECTURE behavior OF GENERIC_FAP_MODSUBT_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_MODSUBT
    PORT(
         Minuend : IN  std_logic_vector((VecLen-1) downto 0);
         Subtrahend : IN  std_logic_vector((VecLen-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         Difference : OUT  std_logic_vector((VecLen-1) downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Minuend : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Subtrahend : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');

 	--Outputs
   signal Difference : std_logic_vector((VecLen-1) downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_MODSUBT PORT MAP (
          Minuend => Minuend,
          Subtrahend => Subtrahend,
          Modulus => Modulus,
          Difference => Difference
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns. Is Returning 0 (First Return)
		Minuend <= "00000";
		Subtrahend <= "00000";
		Modulus <= "00000";
      wait for 30 ns;
		--Check Return 0 (Second Return)
		Minuend <= "00000";
		Subtrahend <= "00000";
		Modulus <= "00110";
		wait for 30 ns;
		--Check Return 0 (Third Return)
		Minuend <= "00000";
		Subtrahend <= "00000";
		Modulus <= "10111";
		wait for 30 ns;
		--Check Return (4-11=-7) mod 23 = 16 = "10000" (Fourth Return)
		Minuend <= "00100";
		Subtrahend <= "01011";
		Modulus <= "10111";
		wait for 30 ns;
		--Check Return (4-12=-8) mod 23 = 15 = "01111" (Fifth Return)
		Minuend <= "00100";
		Subtrahend <= "01100";
		Modulus <= "10111";
		wait for 30 ns;
		--Check Return (4-15=-11) mod 23 = 12 = "01100" (Sixth Return)
		Minuend <= "00100";
		Subtrahend <= "01111";
		Modulus <= "10111";
		wait for 30 ns;
		--Check Return (20-11=9)="01001" (Seventh Return)
		Minuend <= "10100";
		Subtrahend <= "01011";
		Modulus <= "10111";
		
      wait;
   end process;

END;

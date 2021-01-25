--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:13:58 05/09/2017
-- Design Name:   
-- Module Name:   C:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_MODADDR_TEST5.vhd
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
use work.VECTOR_STANDARD.ALL;
 
ENTITY GENERIC_FAP_MODADDR_TEST5 IS
END GENERIC_FAP_MODADDR_TEST5;
 
ARCHITECTURE behavior OF GENERIC_FAP_MODADDR_TEST5 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_MODADDR
    PORT(
         SummandA : IN  std_logic_vector((VecLen-1) downto 0);
         SummandB : IN  std_logic_vector((VecLen-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         Summation : OUT  std_logic_vector((VecLen-1) downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal SummandA : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal SummandB : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');

 	--Outputs
   signal Summation : std_logic_vector((VecLen-1) downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_MODADDR PORT MAP (
          SummandA => SummandA,
          SummandB => SummandB,
          Modulus => Modulus,
          Summation => Summation
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns. Is Returning 0 (First Return)
		--SummandA <= "00000";
		--SummandB <= "00000";
		--Modulus <= "00000";
      --wait for 30 ns;
		--Check Return 0 (Second Return)
		--SummandA <= "00000";
		--SummandB <= "00000";
		--Modulus <= "00110";
		--wait for 30 ns;
		--Check Return 0 (Third Return)
		--SummandA <= "00000";
		--SummandB <= "00000";
		--Modulus <= "10111";
		--wait for 30 ns;
		--Check Return 15 (Fourth Return)
		--SummandA <= "00100";
		--SummandB <= "01011";
		--Modulus <= "10111";
		--wait for 30 ns;
		--Check Return 31-23=8="01000" (Fifth Return)
		--SummandA <= "10100";
		--SummandB <= "01011";
		--Modulus <= "10111";
		Modulus <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		wait for 30 ns;
		--Add the Prime and Zero, Check Return ZeroVector (Second Return)
		SummandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		SummandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 30 ns;
		--Add the Prime and its inverse, Check Return "The inverse, as the inverse addition only equals zero inside the cell" (Third Return)
		SummandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		SummandB <= X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
		--Add the Prime and 1, Check Return 1 (Fourth Return)
		SummandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		SummandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
		--Add the Prime and FFFF_FFFF, Check Return FFFF_FFFF (Fifth Return)
		SummandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		SummandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_FFFF_FFFF";
		wait for 30 ns;
		--Add the (Prime-1) and 1, Check Return ZeroVector (Sixth Return)
		SummandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFE";
		SummandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
		wait for 30 ns;
		--Add the (StringA) and (String5), Check Return StringF (Seventh Return)
		SummandA <= X"0000_0000_0000_0000_0000_0000_0000_0000_3333_1111_0000_0000_0000_AAAA_AAAA_AAAA";
		SummandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_2222_7777_0000_0000_0000_5555_5555_5555";
		wait for 30 ns;
		
      wait;
   end process;

END;

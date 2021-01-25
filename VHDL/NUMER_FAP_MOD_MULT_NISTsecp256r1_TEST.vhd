--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:09:35 03/20/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/Numeric_Multiplier_ModP_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Numeric_Multiplier_ModP
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
 
 --Numeric_Multiplier_ModP_TEST
ENTITY NUMER_FAP_MOD_MULT_NISTsecp256r1_TEST IS
END NUMER_FAP_MOD_MULT_NISTsecp256r1_TEST;
 
ARCHITECTURE behavior OF NUMER_FAP_MOD_MULT_NISTsecp256r1_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT NUMER_FAP_MOD_MULT_NISTsecp256r1
    PORT(
         MultiplicandA : IN  std_logic_vector(255 downto 0);
         MultiplicandB : IN  std_logic_vector(255 downto 0);
         Product : OUT  std_logic_vector(255 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal MultiplicandA : std_logic_vector(255 downto 0) := (others => '0');
   signal MultiplicandB : std_logic_vector(255 downto 0) := (others => '0');

 	--Outputs
   signal Product : std_logic_vector(255 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: NUMER_FAP_MOD_MULT_NISTsecp256r1 PORT MAP (
          MultiplicandA => MultiplicandA,
          MultiplicandB => MultiplicandB,
          Product => Product
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		--Add the Prime and Zero, Check Return ZeroVector (Second Return)
		MultiplicandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		wait for 10 ns;
		--Add the Prime and its inverse, Check Return ZeroVector (Third Return)
		MultiplicandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		MultiplicandB <= X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
		wait for 10 ns;
		--Add the Prime and 1, Check Return 1 (Fourth Return)
		MultiplicandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
		wait for 10 ns;
		--Add the Prime and FFFF_FFFF, Check Return FFFF_FFFF (Fifth Return)
		MultiplicandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_FFFF_FFFF";
		wait for 10 ns;
		--Add the (Prime-1) and 1, Check Return ZeroVector (Sixth Return)
		MultiplicandA <= X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFE";
		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
		wait for 10 ns;
		--Add the (StringA) and (String5), Check Return StringF (Seventh Return)
		MultiplicandA <= X"0000_0000_0000_0000_0000_0000_0000_0000_3333_1111_0000_0000_0000_AAAA_AAAA_AAAA";
		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_2222_7777_0000_0000_0000_5555_5555_5555";
		wait for 10 ns;
      wait;
   end process;

END;

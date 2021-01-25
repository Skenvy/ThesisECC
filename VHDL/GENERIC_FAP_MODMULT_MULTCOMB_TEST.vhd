--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:30:26 05/16/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_MODMULT_MULTCOMB_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_MODMULT_MULTCOMB
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
 
ENTITY GENERIC_FAP_MODMULT_MULTCOMB_TEST IS
END GENERIC_FAP_MODMULT_MULTCOMB_TEST;
 
ARCHITECTURE behavior OF GENERIC_FAP_MODMULT_MULTCOMB_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_MODMULT_MULTCOMB
    PORT(
         MultiplicandA : IN  std_logic_vector((VecLen-1) downto 0);
         MultiplicandB : IN  std_logic_vector((VecLen-1) downto 0);
         Product : OUT  std_logic_vector((2*VecLen-1) downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal MultiplicandA : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal MultiplicandB : std_logic_vector((VecLen-1) downto 0) := (others => '0');

 	--Outputs
   signal Product : std_logic_vector((2*VecLen-1) downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_MODMULT_MULTCOMB PORT MAP (
          MultiplicandA => MultiplicandA,
          MultiplicandB => MultiplicandB,
          Product => Product
        );

   -- Stimulus process
   stim_proc: process
   begin
		MultiplicandA <= "000" & X"000";
		MultiplicandB <= "000" & X"000";
      wait for 30 ns;
		--Mult, Check Return ZeroVector (Second Return)
		MultiplicandA <= "000" & X"000";
		MultiplicandB <= "000" & X"000";
		wait for 30 ns;
		--Mult, Check Return ZeroVector (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"000";
		wait for 30 ns;
		--Mult, Check Return 0000_0101 (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"001";
		wait for 30 ns;
		--Mult, Check Return 0000_1010 (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"010";
		wait for 30 ns;
		--Mult, Check Return 0000_1010 (Second Return)
		MultiplicandA <= "001" & X"101";
		MultiplicandB <= "001" & X"010";
		
--		MultiplicandA <= "0000";
--		MultiplicandB <= "0000";
--      wait for 30 ns;
--		--Mult, Check Return ZeroVector (Second Return)
--		MultiplicandA <= "0000";
--		MultiplicandB <= "0000";
--		wait for 30 ns;
--		--Mult, Check Return ZeroVector (Second Return)
--		MultiplicandA <= "0101";
--		MultiplicandB <= "0000";
--		wait for 30 ns;
--		--Mult, Check Return 0000_0101 (Second Return)
--		MultiplicandA <= "0101";
--		MultiplicandB <= "0001";
--		wait for 30 ns;
--		--Mult, Check Return 0000_1010 (Second Return)
--		MultiplicandA <= "0101";
--		MultiplicandB <= "0010";
--		wait for 30 ns;
--		--Mult, Check Return 0000_1010 (Second Return)
--		MultiplicandA <= "1101";
--		MultiplicandB <= "1010";
		
      wait;
   end process;

END;

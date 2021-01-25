--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:30:01 05/19/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
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
 
ENTITY GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED_TEST IS
END GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED_TEST;
 
ARCHITECTURE behavior OF GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
    PORT(
         MultiplicandA : IN  std_logic_vector((VecLen-1) downto 0);
         MultiplicandB : IN  std_logic_vector((VecLen-1) downto 0);
         Product : OUT  std_logic_vector(((2*VecLen)-1) downto 0);
         CLK : IN  std_logic;
			StableOutput : out STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal MultiplicandA : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal MultiplicandB : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal Product : std_logic_vector(((2*VecLen)-1) downto 0);
	signal StableOutput : STD_LOGIC;

   -- Clock period definitions
   constant CLK_period : time := 60 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED PORT MAP (
          MultiplicandA => MultiplicandA,
          MultiplicandB => MultiplicandB,
          Product => Product,
          CLK => CLK,
			 StableOutput => StableOutput
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
		MultiplicandA <= "000" & X"000";
		MultiplicandB <= "000" & X"000";
		wait for CLK_period*VecLen*(2.1);
		--Mult, Check Return ZeroVector (Second Return)
		MultiplicandA <= "000" & X"000";
		MultiplicandB <= "000" & X"000";
		wait for CLK_period*VecLen*(2.1);
		--Mult, Check Return ZeroVector (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"000";
		wait for CLK_period*VecLen*(2.1);
		--Mult, Check Return 0000_0101 (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"001";
		wait for CLK_period*VecLen*(2.1);
		--Mult, Check Return 0000_1010 (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"010";
		wait for CLK_period*VecLen*(2.1);
		--Mult, Check Return 0000_1010 (Second Return)
		MultiplicandA <= "001" & X"101";
		MultiplicandB <= "001" & X"010";
      wait;
		
--		wait for 100 ns;
--		--Add the Prime and Zero, Check Return ZeroVector (Second Return)
--		MultiplicandA <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000_0100_F000";
--		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
--		wait for CLK_period*VecLen*(2.5);
--		--Add the Prime and its inverse, Check Return ZeroVector (Third Return)
--		MultiplicandA <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0500_010F";
--		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0050_0F00";
--		wait for CLK_period*VecLen*(2.5);
--		--Add the Prime and 1, Check Return 1 (Fourth Return)
--		MultiplicandA <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0008_0000_0700";
--		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_000B_00C0_0D00";
--		wait for CLK_period*VecLen*(2.5);
--		--Add the Prime and FFFF_FFFF, Check Return FFFF_FFFF (Fifth Return)
--		MultiplicandA <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_3333_0300";
--		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_5555_0000";
--		wait for CLK_period*VecLen*(2.5);
--		--Add the (Prime-1) and 1, Check Return ZeroVector (Sixth Return)
--		MultiplicandA <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1111";
--		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_FFFF";
--		wait for CLK_period*VecLen*(2.5);
--		--Add the (StringA) and (String5), Check Return StringF (Seventh Return)
--		MultiplicandA <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000_0010";
--		MultiplicandB <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0010_1000";
--		wait for CLK_period*VecLen*(2.5);
--      wait;
		
   end process;

END;

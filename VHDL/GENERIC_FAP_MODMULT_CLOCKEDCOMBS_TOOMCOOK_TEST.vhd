--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:44:16 05/26/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
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
 
ENTITY GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK_TEST IS
END GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK_TEST;
 
ARCHITECTURE behavior OF GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
    PORT(
         MultiplicandA : IN  std_logic_vector((VecLen-1) downto 0);
         MultiplicandB : IN  std_logic_vector((VecLen-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         Product : OUT  std_logic_vector((VecLen-1) downto 0);
         CLK : IN  std_logic;
         StableOutput : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal MultiplicandA : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal MultiplicandB : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal Product : std_logic_vector((VecLen-1) downto 0);
   signal StableOutput : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK PORT MAP (
          MultiplicandA => MultiplicandA,
          MultiplicandB => MultiplicandB,
          Modulus => Modulus,
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
		Modulus <= "000" & X"000";
		wait for CLK_period*VecLen*(3.8);
		--Mult, Check Return ZeroVector (Second Return)
		MultiplicandA <= "000" & X"000";
		MultiplicandB <= "000" & X"000";
		Modulus <= "101" & X"010";
		wait for CLK_period*VecLen*(3.8);
		--Mult, Check Return ZeroVector (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"000";
		Modulus <= "101" & X"001";
		wait for CLK_period*VecLen*(3.8);
		--Mult, Check Return 0000_0101 (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"001";
		Modulus <= "100" & X"001";
		wait for CLK_period*VecLen*(3.8);
		--Mult, Check Return 0000_1010 (Second Return)
		MultiplicandA <= "000" & X"101";
		MultiplicandB <= "000" & X"010";
		Modulus <= "111" & X"000";
		wait for CLK_period*VecLen*(3.8);
		--Mult, Check Return 0000_1010 (Second Return)
		MultiplicandA <= "001" & X"101";
		MultiplicandB <= "001" & X"010";
		Modulus <= "100" & X"110";
      wait;
   end process;

END;

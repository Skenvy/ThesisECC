--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:09:30 05/23/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED
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
 
ENTITY GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED_TEST IS
END GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED_TEST;
 
ARCHITECTURE behavior OF GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED
    PORT(
         Dividend : IN  std_logic_vector(((2*VecLen)-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         CLK : IN  std_logic;
         Remainder : OUT  std_logic_vector((VecLen-1) downto 0);
         Quotient : OUT  std_logic_vector((VecLen-1) downto 0);
         StableOutput : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Dividend : std_logic_vector(((2*VecLen)-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal Remainder : std_logic_vector((VecLen-1) downto 0);
   signal Quotient : std_logic_vector((VecLen-1) downto 0);
   signal StableOutput : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 60 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED PORT MAP (
          Dividend => Dividend,
          Modulus => Modulus,
          CLK => CLK,
          Remainder => Remainder,
          Quotient => Quotient,
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
		Modulus <= "000" & X"000";
		Dividend <= "00" & X"0000000";
      wait for 100 ns;
		Modulus <= "101" & X"010";
		Dividend <= "01" & X"0F0E030";
		wait for CLK_period*VecLen*(2.2);
		--Mult, Check Return ZeroVector (Second Return)
		Modulus <= "101" & X"001";
		Dividend <= "01" & X"0F0E030";
		wait for CLK_period*VecLen*(2.2);
		--Mult, Check Return ZeroVector (Second Return)
		Modulus <= "100" & X"001";
		Dividend <= "11" & X"0FFE530";
		wait for CLK_period*VecLen*(2.2);
		--Mult, Check Return 0000_0101 (Second Return)
		Modulus <= "111" & X"000";
		Dividend <= "11" & X"0FFE530";
		wait for CLK_period*VecLen*(2.2);
		--Mult, Check Return 0000_1010 (Second Return)
		Modulus <= "100" & X"110";
		Dividend <= "11" & X"0FFE530";
		wait for CLK_period*VecLen*(2.2);
		--Mult, Check Return 0000_1010 (Second Return)
		Modulus <= "100" & X"011";
		Dividend <= "11" & X"B7FE533";
      wait;
   end process;

END;

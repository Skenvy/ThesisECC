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
use work.VECTOR_STANDARD.ALL;
 
ENTITY STRUC_UTIL_RAM_256_TEST IS
END STRUC_UTIL_RAM_256_TEST;
 
ARCHITECTURE behavior OF STRUC_UTIL_RAM_256_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT STRUC_UTIL_RAM_256
	 Generic (N : natural);
    PORT(
         RW : IN  std_logic;
         Data : INOUT  std_logic_vector((VecLen-1) downto 0);
			CLK : in STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal RW : std_logic := '0';
	signal trap : std_logic_vector((VecLen-1) downto 0);
	signal CLK : std_logic := '0';
	
	--BiDirs
   signal Data : std_logic_vector((VecLen-1) downto 0);
   
	-- Clock period definitions
   constant CLK_period : time := 30 ns;
 
BEGIN
	
	-- Instantiate the Unit Under Test (UUT)
   uut: STRUC_UTIL_RAM_256 Generic Map (N => VecLen) 
			PORT MAP (
          RW => RW,
          Data => Data,
			 CLK => CLK
        );
		  
	-- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

   stim_proc: process
   begin
		Data <= X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
		RW <= '0';
      wait for CLK_period*4;	
		Data <= X"0000_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		RW <= '0';
		wait for CLK_period*4;
		Data <= X"0000_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
		RW <= '1';
		wait for CLK_period*4;
		Data <= X"FFFF_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF";
		RW <= '0';
		wait for CLK_period*4;
		Data <= X"FFFF_0000_0000_0001_AAAA_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF";
		RW <= '0';
		wait for CLK_period*4;
		Data <= X"FFFF_0000_0000_0001_0000_0000_0000_DDDD_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF";
		RW <= '0';
		wait for CLK_period*4;
		Data <= (others => 'Z');
		RW <= '0';
		trap <= Data;
		wait for CLK_period*4;
		Data <= (others => 'Z');
		trap <= Data;
		RW <= '0';
      wait;
		
   end process;

END;

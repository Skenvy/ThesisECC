--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:55:29 05/30/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_ECC_POINT_ADDITION_CLOCKED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_ECC_POINT_ADDITION_CLOCKED
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
 
ENTITY GENERIC_ECC_POINT_ADDITION_CLOCKED_TEST IS
END GENERIC_ECC_POINT_ADDITION_CLOCKED_TEST;
 
ARCHITECTURE behavior OF GENERIC_ECC_POINT_ADDITION_CLOCKED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_ECC_JACOBIAN_POINT_ADDITION_CLOCKED
    PORT(
         AX : IN  std_logic_vector((VecLen-1) downto 0);
         AY : IN  std_logic_vector((VecLen-1) downto 0);
         AZ : IN  std_logic_vector((VecLen-1) downto 0);
         BX : IN  std_logic_vector((VecLen-1) downto 0);
         BY : IN  std_logic_vector((VecLen-1) downto 0);
         BZ : IN  std_logic_vector((VecLen-1) downto 0);
         CX : OUT  std_logic_vector((VecLen-1) downto 0);
         CY : OUT  std_logic_vector((VecLen-1) downto 0);
         CZ : OUT  std_logic_vector((VecLen-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         CLK : IN  std_logic;
         StableOutput : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal AX : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal AY : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal AZ : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal BX : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal BY : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal BZ : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal CX : std_logic_vector((VecLen-1) downto 0);
   signal CY : std_logic_vector((VecLen-1) downto 0);
   signal CZ : std_logic_vector((VecLen-1) downto 0);
   signal StableOutput : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 30 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GENERIC_ECC_JACOBIAN_POINT_ADDITION_CLOCKED PORT MAP (
          AX => AX,
          AY => AY,
          AZ => AZ,
          BX => BX,
          BY => BY,
          BZ => BZ,
          CX => CX,
          CY => CY,
          CZ => CZ,
          Modulus => Modulus,
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
		Modulus <= "10001";
      wait for CLK_period*(VecLen*10);	
		AX <= "00000";--0
		AY <= "00000";--0
		AZ <= "00001";--1
		BX <= "00000";--0
		BY <= "00000";--0
		BZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (3,16)
		AX <= "10000";--16
		AY <= "00100";--4
		AZ <= "00001";--1
		BX <= "00110";--6
		BY <= "00011";--3
		BZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (16,13)
		AX <= "01010";--10
		AY <= "01011";--11
		AZ <= "00001";--1
		BX <= "00111";--7
		BY <= "00110";--6
		BZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (0,0)
		AX <= "00000";--0
		AY <= "01011";--11
		AZ <= "00001";--1
		BX <= "00000";--0
		BY <= "00110";--6
		BZ <= "00001";--1
		
      wait;
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:21:51 05/31/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/GENERIC_ECC_POINT_DOUBLE_CLOCKED_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GENERIC_ECC_POINT_DOUBLE_CLOCKED
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
 
ENTITY GENERIC_ECC_POINT_DOUBLE_CLOCKED_TEST IS
END GENERIC_ECC_POINT_DOUBLE_CLOCKED_TEST;
 
ARCHITECTURE behavior OF GENERIC_ECC_POINT_DOUBLE_CLOCKED_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED
    PORT(
         AX : IN  std_logic_vector((VecLen-1) downto 0);
         AY : IN  std_logic_vector((VecLen-1) downto 0);
         AZ : IN  std_logic_vector((VecLen-1) downto 0);
         CX : OUT  std_logic_vector((VecLen-1) downto 0);
         CY : OUT  std_logic_vector((VecLen-1) downto 0);
         CZ : OUT  std_logic_vector((VecLen-1) downto 0);
         Modulus : IN  std_logic_vector((VecLen-1) downto 0);
         ECC_A : IN  std_logic_vector((VecLen-1) downto 0);
         CLK : IN  std_logic;
         StableOutput : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal AX : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal AY : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal AZ : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal Modulus : std_logic_vector((VecLen-1) downto 0) := (others => '0');
   signal ECC_A : std_logic_vector((VecLen-1) downto 0) := (others => '0');
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
   uut: GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED PORT MAP (
          AX => AX,
          AY => AY,
          AZ => AZ,
          CX => CX,
          CY => CY,
          CZ => CZ,
          Modulus => Modulus,
          ECC_A => ECC_A,
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
		ECC_A <= "00010";
      wait for 100 ns;	
		wait for CLK_period*(VecLen*10); --Check equals (0,0)
		AX <= "00000";--0
		AY <= "00000";--0
		AZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (0,6)
		AX <= "10000";--16
		AY <= "00100";--4
		AZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (16,4)
		AX <= "01010";--10
		AY <= "01011";--11
		AZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (9,16)
		AX <= "00000";--0
		AY <= "01011";--11
		AZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (3,1)
		AX <= "00110";--6
		AY <= "00011";--3
		AZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (5,16)
		AX <= "00111";--7
		AY <= "00110";--6
		AZ <= "00001";--1
		wait for CLK_period*(VecLen*60); --Check equals (9,1)
		AX <= "00000";--0
		AY <= "00110";--6
		AZ <= "00001";--1
      wait;
   end process;

END;

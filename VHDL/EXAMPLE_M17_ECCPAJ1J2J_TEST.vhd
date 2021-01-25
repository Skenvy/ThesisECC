--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:25:02 03/27/2017
-- Design Name:   
-- Module Name:   D:/XILINX/PROG/FieldArithmeticProcessor/EXAMPLE_M17_ECCPAJ1J2J_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EXAMPLE_M17_ECCPAJ1J2J
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
 
ENTITY EXAMPLE_M17_ECCPAJ1J2J_TEST IS
END EXAMPLE_M17_ECCPAJ1J2J_TEST;
 
ARCHITECTURE behavior OF EXAMPLE_M17_ECCPAJ1J2J_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXAMPLE_M17_ECCPAJ1J2J
    PORT(
         AX : IN  std_logic_vector(4 downto 0);
         AY : IN  std_logic_vector(4 downto 0);
         AZ : IN  std_logic_vector(4 downto 0);
         BX : IN  std_logic_vector(4 downto 0);
         BY : IN  std_logic_vector(4 downto 0);
         BZ : IN  std_logic_vector(4 downto 0);
         CX : OUT  std_logic_vector(4 downto 0);
         CY : OUT  std_logic_vector(4 downto 0);
         CZ : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal AX : std_logic_vector(4 downto 0) := (others => '0');
   signal AY : std_logic_vector(4 downto 0) := (others => '0');
   signal AZ : std_logic_vector(4 downto 0) := (others => '0');
   signal BX : std_logic_vector(4 downto 0) := (others => '0');
   signal BY : std_logic_vector(4 downto 0) := (others => '0');
   signal BZ : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal CX : std_logic_vector(4 downto 0);
   signal CY : std_logic_vector(4 downto 0);
   signal CZ : std_logic_vector(4 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXAMPLE_M17_ECCPAJ1J2J PORT MAP (
          AX => AX,
          AY => AY,
          AZ => AZ,
          BX => BX,
          BY => BY,
          BZ => BZ,
          CX => CX,
          CY => CY,
          CZ => CZ
        );
 
   -- Stimulus process
   stim_proc: process
   begin	
      wait for 10 ns;	
		AX <= "00000";--0
		AY <= "00000";--0
		AZ <= "00001";--1
		BX <= "00000";--0
		BY <= "00000";--0
		BZ <= "00001";--1
		wait for 10 ns; --Check equals (3,16)
		AX <= "10000";--16
		AY <= "00100";--4
		AZ <= "00001";--1
		BX <= "00110";--6
		BY <= "00011";--3
		BZ <= "00001";--1
		wait for 10 ns; --Check equals (16,13)
		AX <= "01010";--10
		AY <= "01011";--11
		AZ <= "00001";--1
		BX <= "00111";--7
		BY <= "00110";--6
		BZ <= "00001";--1
		wait for 10 ns; --Check equals (0,0)
		AX <= "00000";--0
		AY <= "01011";--11
		AZ <= "00001";--1
		BX <= "00000";--0
		BY <= "00110";--6
		BZ <= "00001";--1
		
      wait;
   end process;

END;

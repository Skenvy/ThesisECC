--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:47:23 03/28/2017
-- Design Name:   
-- Module Name:   E:/XILINX/PROG/FieldArithmeticProcessor/EXAMPLE_M17_FAPINV_INTERNAL_TEST.vhd
-- Project Name:  FieldArithmeticProcessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EXAMPLE_M17_FAPINV_INTERNAL
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
 
ENTITY EXAMPLE_M17_FAPINV_INTERNAL_TEST IS
END EXAMPLE_M17_FAPINV_INTERNAL_TEST;
 
ARCHITECTURE behavior OF EXAMPLE_M17_FAPINV_INTERNAL_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXAMPLE_M17_FAPINV_INTERNAL
    PORT(
         U : IN  std_logic_vector(4 downto 0);
         V : IN  std_logic_vector(4 downto 0);
         X : IN  std_logic_vector(4 downto 0);
         Y : IN  std_logic_vector(4 downto 0);
         Uout : OUT  std_logic_vector(4 downto 0);
         Vout : OUT  std_logic_vector(4 downto 0);
         Xout : OUT  std_logic_vector(4 downto 0);
         Yout : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal U : std_logic_vector(4 downto 0) := (others => '0');
   signal V : std_logic_vector(4 downto 0) := (others => '0');
   signal X : std_logic_vector(4 downto 0) := (others => '0');
   signal Y : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal Uout : std_logic_vector(4 downto 0);
   signal Vout : std_logic_vector(4 downto 0);
   signal Xout : std_logic_vector(4 downto 0);
   signal Yout : std_logic_vector(4 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXAMPLE_M17_FAPINV_INTERNAL PORT MAP (
          U => U,
          V => V,
          X => X,
          Y => Y,
          Uout => Uout,
          Vout => Vout,
          Xout => Xout,
          Yout => Yout
        );

   -- Stimulus process
   stim_proc: process
   begin		
      wait for 10 ns;	
		U <= "11000";
		V <= "11111";
		X <= "00111";
		Y <= "10101";
		wait for 10 ns;	
		U <= "11111";
		V <= "00111";
		X <= "10101";
		Y <= "11000";
		
      wait;
   end process;

END;

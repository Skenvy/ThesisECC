----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:16:33 06/01/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_POINT_MULTIPLY_CLOCKED - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.VECTOR_STANDARD.ALL;

entity GENERIC_ECC_POINT_MULTIPLY_CLOCKED is
	 Generic (NGen : natural := VecLen;
				 MGen : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( k : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           JPX : in STD_LOGIC_VECTOR ((NGen-1) downto 0);
           JPY : in STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  JPZ : in STD_LOGIC_VECTOR ((NGen-1) downto 0);
           JQX : out STD_LOGIC_VECTOR ((NGen-1) downto 0);
           JQY : out STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  JQZ : out STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  CLK : IN STD_LOGIC);
end GENERIC_ECC_POINT_MULTIPLY_CLOCKED;

architecture Behavioral of GENERIC_ECC_POINT_MULTIPLY_CLOCKED is

begin


end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:01:07 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_MULTCOMB - Behavioral 
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

entity GENERIC_FAP_MODMULT_MULTCOMB is
	 Generic (N : Natural := VecLen);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0));
end GENERIC_FAP_MODMULT_MULTCOMB;

architecture Behavioral of GENERIC_FAP_MODMULT_MULTCOMB is

begin


end Behavioral;


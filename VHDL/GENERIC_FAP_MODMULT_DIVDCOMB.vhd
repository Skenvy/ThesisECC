----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:02:33 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_DIVDCOMB - Behavioral 
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

entity GENERIC_FAP_MODMULT_DIVDCOMB is
	 Generic (N : Natural := VecLen);
    Port ( ProductSpace : in  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
           Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Remainder : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Quotient : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end GENERIC_FAP_MODMULT_DIVDCOMB;

architecture Behavioral of GENERIC_FAP_MODMULT_DIVDCOMB is

begin


end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:55 05/25/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_MULTCOMB_KARATSUBAwCLOCK - Behavioral 
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

entity GENERIC_FAP_MODMULT_MULTCOMB_KARATSUBAwCLOCK is
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
			  CLK : in STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_FAP_MODMULT_MULTCOMB_KARATSUBAwCLOCK;

architecture Behavioral of GENERIC_FAP_MODMULT_MULTCOMB_KARATSUBAwCLOCK is

begin


end Behavioral;


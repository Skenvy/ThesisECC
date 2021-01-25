----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:18 03/27/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAP_ADDR - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use work.VECTOR_STANDARD.ALL;
use work.ECC_STANDARD.ALL;


entity EXAMPLE_M17_FAP_ADDR is
	port( SummandA : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         SummandB : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Summation : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end EXAMPLE_M17_FAP_ADDR;

architecture Behavioral of EXAMPLE_M17_FAP_ADDR is

signal SummationInternal : STD_LOGIC_VECTOR ((VecLen) downto 0);

begin

SummationInternal((VecLen) downto 0) <= STD_LOGIC_VECTOR(unsigned("0" & SummandA((VecLen - 1) downto 0)) + unsigned("0" & SummandB((VecLen - 1) downto 0)));
Summation <= STD_LOGIC_VECTOR(unsigned(SummationInternal) mod unsigned(Prime));

end Behavioral;


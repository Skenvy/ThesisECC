----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:04:04 03/27/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAP_MULT - Behavioral 
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

entity EXAMPLE_M17_FAP_MULT is
	port( MultiplicandA : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         MultiplicandB : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
         Product : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end EXAMPLE_M17_FAP_MULT;

architecture Behavioral of EXAMPLE_M17_FAP_MULT is

signal ProductInternal : STD_LOGIC_VECTOR ((2*VecLen - 1) downto 0);

begin

ProductInternal((2*VecLen - 1) downto 0) <= STD_LOGIC_VECTOR(unsigned(MultiplicandA((VecLen - 1) downto 0)) * unsigned(MultiplicandB((VecLen - 1) downto 0)));
Product <= STD_LOGIC_VECTOR(unsigned(ProductInternal) mod unsigned(Prime));

end Behavioral;


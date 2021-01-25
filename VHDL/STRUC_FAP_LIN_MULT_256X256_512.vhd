----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:56:40 03/14/2017 
-- Design Name: 
-- Module Name:    Multiplication_256X256_512 - Behavioral 
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

--Multiplication_256X256_512
entity STRUC_FAP_LIN_MULT_256X256_512 is
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR (255 downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR (255 downto 0);
           Product : out  STD_LOGIC_VECTOR (511 downto 0)); --(MultiplicandA + MultiplicandB = Product)
end STRUC_FAP_LIN_MULT_256X256_512;

--Stub Entity: Currently implemented behaviourally, left to make structural.
architecture Behavioral of STRUC_FAP_LIN_MULT_256X256_512 is

begin

Product(511 downto 0) <= STD_LOGIC_VECTOR(unsigned(MultiplicandA(255 downto 0)) * unsigned(MultiplicandB(255 downto 0)));

end Behavioral;


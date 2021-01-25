----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:17:14 03/13/2017
-- Design Name: 
-- Module Name:    Multiplication_Modulo_256 - Behavioral 
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

--Multiplication_Modulo_256
entity STRUC_FAP_MOD_MULT_256 is
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR (255 downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR (255 downto 0);
           Product : out  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_FAP_MOD_MULT_256;

architecture Behavioral of STRUC_FAP_MOD_MULT_256 is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--(256Bit*256Bit = 512Bit) Multiplier
component STRUC_FAP_LIN_MULT_256X256_512
	port(MultiplicandA : in  STD_LOGIC_VECTOR (255 downto 0);
        MultiplicandB : in  STD_LOGIC_VECTOR (255 downto 0);
        Product : out  STD_LOGIC_VECTOR (511 downto 0)); --(MultiplicandA + MultiplicandB = Product)
end component;

--(512Bit/256Bit = 256Bit) Integer Divider (Fixed to a constant divider, the Prime)
component STRUC_FAP_MOD_DIVD_512by256_QuotientAndRemainder
	port(Dividend : in  STD_LOGIC_VECTOR (511 downto 0);
        Quotient : out  STD_LOGIC_VECTOR (255 downto 0); --(Floor[Dividend/Prime] = Quotient)
        Remainder : out  STD_LOGIC_VECTOR (255 downto 0)); --(Dividend - (Floor[Dividend/Prime]*Prime) = Remainder)
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Carries the output of the multiplication component, connects it to the Dividend input of the divider cell
signal ProductOfMult : STD_LOGIC_VECTOR(511 downto 0);

begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

--Multiply the two input multiplicands
MULT : STRUC_FAP_LIN_MULT_256X256_512 port map(MultiplicandA => MultiplicandA,
														 MultiplicandB => MultiplicandB,
														 Product => ProductOfMult);

--Takes the product of the multiplication and divides it by the Prime.
DIVD : STRUC_FAP_MOD_DIVD_512by256_QuotientAndRemainder port map(Dividend => ProductOfMult,
																				 Quotient => open, --this implementation doesn't need the quotient
																				 Remainder => Product); --The modulo Prime of the Product is the remainder after this division.

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

end Behavioral;


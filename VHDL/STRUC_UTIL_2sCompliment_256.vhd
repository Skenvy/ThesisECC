----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:04:00 03/13/2017 
-- Design Name: 
-- Module Name:    Utility_2sCompliment_256 - Behavioral 
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

entity STRUC_UTIL_2sCompliment_256 is
    Port ( InVal : in  STD_LOGIC_VECTOR (255 downto 0);
           InComplimented : out  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_UTIL_2sCompliment_256;

architecture Behavioral of STRUC_UTIL_2sCompliment_256 is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--256 Bit Adder
component STRUC_FAP_LIN_ADDR_RCAKS_256
	port( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
         Summation : out  STD_LOGIC_VECTOR (256 downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Carries the inverse (not) of the input, the 1's complement.
signal ComplementedOnce : STD_LOGIC_VECTOR (255 downto 0);
--Attaches to the 256'th bit of the Summation output from "ADDR256_AandB" as this cannot be left open.
signal wastageBit : STD_LOGIC;

begin

--Begin by inverting the input to obtain the 1's complement form
ComplementedOnce <= not InVal;

--Add 1, the unit vector, to the 1's complement to obtain the 2's complement.
ADDR256_AandB : STRUC_FAP_LIN_ADDR_RCAKS_256 port map (SummandA => ComplementedOnce, 
													SummandB => UnitVector, 
													Summation(255 downto 0) => InComplimented,
													Summation(256) => wastageBit);


end Behavioral;


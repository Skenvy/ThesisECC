----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:01:24 03/20/2017 
-- Design Name: 
-- Module Name:    Numeric_Multiplier_ModP - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Numeric_Multiplier_ModP
entity NUMER_FAP_MOD_MULT_NISTsecp256r1 is
	Port ( MultiplicandA : in  STD_LOGIC_VECTOR (255 downto 0);
          MultiplicandB : in  STD_LOGIC_VECTOR (255 downto 0);
          Product : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_FAP_MOD_MULT_NISTsecp256r1;

architecture Behavioral of NUMER_FAP_MOD_MULT_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

signal ProductInternal : STD_LOGIC_VECTOR (511 downto 0);

begin

ProductInternal(511 downto 0) <= STD_LOGIC_VECTOR(unsigned(MultiplicandA(255 downto 0)) * unsigned(MultiplicandB(255 downto 0)));
Product <= STD_LOGIC_VECTOR(unsigned(ProductInternal) mod unsigned(Prime));

end Behavioral;


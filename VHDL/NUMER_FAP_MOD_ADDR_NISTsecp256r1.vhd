----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:32:40 03/22/2017 
-- Design Name: 
-- Module Name:    NUMER_FAP_MOD_ADDR_NISTsecp256r1 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NUMER_FAP_MOD_ADDR_NISTsecp256r1 is
    Port ( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
           SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
           Summation : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_FAP_MOD_ADDR_NISTsecp256r1;

architecture Behavioral of NUMER_FAP_MOD_ADDR_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

signal SummationInternal : STD_LOGIC_VECTOR (256 downto 0);

begin

SummationInternal(256 downto 0) <= STD_LOGIC_VECTOR(unsigned("0" & SummandA(255 downto 0)) + unsigned("0" & SummandB(255 downto 0)));
Summation <= STD_LOGIC_VECTOR(unsigned(SummationInternal) mod unsigned(Prime));

end Behavioral;


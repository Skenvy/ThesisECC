----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:09:58 03/08/2017 
-- Design Name: 
-- Module Name:    ModularAddition - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ModularAddition is
    Port ( IntegerA : in  STD_LOGIC_VECTOR (255 downto 0); --Assumed less than the modulus
           IntegerB : in  STD_LOGIC_VECTOR (255 downto 0); --Assumed less than the modulus
			  IntegerMod : in  STD_LOGIC_VECTOR (255 downto 0); --Assumed to be {(2^255) < Modulus < (2^256 - 1)}
           IntegerOut : out  STD_LOGIC_VECTOR (255 downto 0));
end ModularAddition;

architecture Behavioral of ModularAddition is

signal InternalSum: STD_LOGIC_VECTOR (256 downto 0);

component FullAdder
	port(	A : in STD_LOGIC_VECTOR;
			B : in  STD_LOGIC;
			CarryIn : in  STD_LOGIC;
			Sum : out  STD_LOGIC;
			CarryOut : out  STD_LOGIC);
end component;

begin

process
	for k in 0 to 255 loop

	end loop;
end process;

end Behavioral;


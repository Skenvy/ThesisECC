----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:20:07 03/13/2017 
-- Design Name: 
-- Module Name:    Inversion_Modulo_256 - Behavioral 
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

--Inversion_Modulo_256
entity STRUC_FAP_MOD_INVR_NISTsecp256r1 is
    Port ( Element : in  STD_LOGIC_VECTOR (255 downto 0);
           Inverse : out  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_FAP_MOD_INVR_NISTsecp256r1;

architecture Behavioral of STRUC_FAP_MOD_INVR_NISTsecp256r1 is

begin


end Behavioral;


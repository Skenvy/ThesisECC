----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:45:42 03/23/2017 
-- Design Name: 
-- Module Name:    NUMER_ECC_COORD_J2A_NISTsecp256r1 - Behavioral 
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

entity NUMER_ECC_COORD_J2A_NISTsecp256r1 is
    Port ( PX : in  STD_LOGIC_VECTOR (255 downto 0);
           PY : in  STD_LOGIC_VECTOR (255 downto 0);
           PZ : in  STD_LOGIC_VECTOR (255 downto 0);
           QX : out  STD_LOGIC_VECTOR (255 downto 0);
           QY : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_ECC_COORD_J2A_NISTsecp256r1;

architecture Behavioral of NUMER_ECC_COORD_J2A_NISTsecp256r1 is


--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component NUMER_FAP_MOD_MULT_NISTsecp256r1
	port( MultiplicandA : in  STD_LOGIC_VECTOR (255 downto 0);
         MultiplicandB : in  STD_LOGIC_VECTOR (255 downto 0);
         Product : out  STD_LOGIC_VECTOR (255 downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

component NUMER_FAP_MOD_INVR_NISTsecp256r1 is
    Port ( Element : in  STD_LOGIC_VECTOR (255 downto 0);
           Inverse : out  STD_LOGIC_VECTOR (255 downto 0));
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

signal ZInv : STD_LOGIC_VECTOR (255 downto 0);
signal ZInvSquared : STD_LOGIC_VECTOR (255 downto 0);
signal ZInvAndPY : STD_LOGIC_VECTOR (255 downto 0);

begin

InvertZ : NUMER_FAP_MOD_INVR_NISTsecp256r1 port map (Element => PZ,
																	  Inverse => ZInv);

MULT_SQUA : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => ZInv,
																		 MultiplicandB => ZInv,
																		 Product => ZInvSquared);

MULT_PYZI : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => PY,
																		 MultiplicandB => ZInv,
																		 Product => ZInvAndPY);

MULT_Y : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => ZInvAndPY,
																	 MultiplicandB => ZInvSquared,
																	 Product => QY);
																		 
MULT_X : NUMER_FAP_MOD_MULT_NISTsecp256r1 port map (MultiplicandA => PX,
																	 MultiplicandB => ZInvSquared,
																	 Product => QX);

end Behavioral;


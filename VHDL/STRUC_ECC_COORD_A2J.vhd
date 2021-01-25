----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:20 03/20/2017 
-- Design Name: 
-- Module Name:    CoordinateConversion_AffineToJacobian - Behavioral 
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

--CoordinateConversion_AffineToJacobian
entity STRUC_ECC_COORD_A2J is
    Port ( AffineX : in  STD_LOGIC_VECTOR (255 downto 0);
           AffineY : in  STD_LOGIC_VECTOR (255 downto 0);
           JacobianX : out  STD_LOGIC_VECTOR (255 downto 0);
           JacobianY : out  STD_LOGIC_VECTOR (255 downto 0);
           JacobianZ : out  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_ECC_COORD_A2J;

architecture Behavioral of STRUC_ECC_COORD_A2J is

begin


end Behavioral;


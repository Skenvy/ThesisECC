----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:31:09 03/20/2017 
-- Design Name: 
-- Module Name:    CoordinateConversion_JacobianToAffine - Behavioral 
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

--CoordinateConversion_JacobianToAffine
entity STRUC_ECC_COORD_J2A is
    Port ( JacobianX : in  STD_LOGIC_VECTOR (255 downto 0);
           JacobianY : in  STD_LOGIC_VECTOR (255 downto 0);
           JacobianZ : in  STD_LOGIC_VECTOR (255 downto 0);
           AffineX : out  STD_LOGIC_VECTOR (255 downto 0);
           AffineY : out  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_ECC_COORD_J2A;

architecture Behavioral of STRUC_ECC_COORD_J2A is

begin


end Behavioral;


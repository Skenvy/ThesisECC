----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:33:20 03/20/2017 
-- Design Name: 
-- Module Name:    PointMultiplication_Jacobian_ToJacobian - Behavioral 
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

--PointMultiplication_Jacobian_ToJacobian
entity STRUC_ECC_POINT_MULTIPLY_J2J is
    Port ( Coefficient : in  STD_LOGIC_VECTOR (255 downto 0);
           X_In : in  STD_LOGIC_VECTOR (255 downto 0);
           Y_In : in  STD_LOGIC_VECTOR (255 downto 0);
           Z_In : in  STD_LOGIC_VECTOR (255 downto 0);
           X_Out : out  STD_LOGIC_VECTOR (255 downto 0);
           Y_Out : out  STD_LOGIC_VECTOR (255 downto 0);
           Z_Out : out  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_ECC_POINT_MULTIPLY_J2J;

architecture Behavioral of STRUC_ECC_POINT_MULTIPLY_J2J is

begin


end Behavioral;


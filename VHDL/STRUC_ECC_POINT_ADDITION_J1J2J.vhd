----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:27:53 03/20/2017 
-- Design Name: 
-- Module Name:    PointAddition_JacobionAndJacobian_ToJacobian - Behavioral 
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

--PointAddition_JacobionAndJacobian_ToJacobian
entity STRUC_ECC_POINT_ADDITION_J1J2J is
    Port ( AX : in  STD_LOGIC_VECTOR (255 downto 0);
           AY : in  STD_LOGIC_VECTOR (255 downto 0);
           AZ : in  STD_LOGIC_VECTOR (255 downto 0);
           BX : in  STD_LOGIC_VECTOR (255 downto 0);
           BY : in  STD_LOGIC_VECTOR (255 downto 0);
           BZ : in  STD_LOGIC_VECTOR (255 downto 0);
           CX : out  STD_LOGIC_VECTOR (255 downto 0);
           CY : out  STD_LOGIC_VECTOR (255 downto 0);
           CZ : out  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_ECC_POINT_ADDITION_J1J2J;

architecture Behavioral of STRUC_ECC_POINT_ADDITION_J1J2J is

begin


end Behavioral;


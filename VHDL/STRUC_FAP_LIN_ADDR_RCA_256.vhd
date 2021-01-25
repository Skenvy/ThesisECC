----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:32:49 03/22/2017 
-- Design Name: 
-- Module Name:    STRUC_FAP_LIN_ADDR_RCA_256 - Behavioral 
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

entity STRUC_FAP_LIN_ADDR_RCA_256 is
    Port ( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
           SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
           Summation : out  STD_LOGIC_VECTOR (256 downto 0));
end STRUC_FAP_LIN_ADDR_RCA_256;

architecture Behavioral of STRUC_FAP_LIN_ADDR_RCA_256 is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component STRUC_FAP_LIN_ADDR_FullAdder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           Sum : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Propogates the internal Carry signals from one FA cell to the next; The 'Ripple'
signal InternalCarry : STD_LOGIC_VECTOR (254 downto 0); 

begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

FA0 : STRUC_FAP_LIN_ADDR_FullAdder Port Map (A => SummandA(0),
															B => SummandB(0),
															Cin => '0',
															Sum => Summation(0),
															Cout => InternalCarry(0));

RCAGenerate : for k in 1 to 254 generate
begin
	FAX : STRUC_FAP_LIN_ADDR_FullAdder Port Map (A => SummandA(k),
																B => SummandB(k),
																Cin => InternalCarry(k-1),
																Sum => Summation(k),
																Cout => InternalCarry(k));
end generate RCAGenerate;

FA255 : STRUC_FAP_LIN_ADDR_FullAdder Port Map (A => SummandA(255),
															  B => SummandB(255),
															  Cin => InternalCarry(254),
															  Sum => Summation(255),
															  Cout => Summation(256));

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

end Behavioral;


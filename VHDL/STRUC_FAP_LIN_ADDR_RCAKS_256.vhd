----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:45:18 03/13/2017 
-- Design Name: 
-- Module Name:    Addition_256 - Behavioral 
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

--Addition_256
entity STRUC_FAP_LIN_ADDR_RCAKS_256 is
    Port ( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
           SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
           Summation : out  STD_LOGIC_VECTOR (256 downto 0)); --(SummandA + SummandB = Summation)
end STRUC_FAP_LIN_ADDR_RCAKS_256;

architecture Behavioral of STRUC_FAP_LIN_ADDR_RCAKS_256 is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--64 Bit Adder
component STRUC_FAP_LIN_ADDR_MUXRCAKS_64
	port( SummandA : in  STD_LOGIC_VECTOR (63 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (63 downto 0);
         Summation : out  STD_LOGIC_VECTOR (63 downto 0); --(SummandA + SummandB = Summation)
         CarryIn : in  STD_LOGIC;
         CarryOut : out  STD_LOGIC
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Propogates the internal Carry signals from one ADDR cell to the next; The 'Ripple'
signal InternalCarry : STD_LOGIC_VECTOR (2 downto 0);

begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

--Four '64 Bit Adders' in series
ADDR64_0 : STRUC_FAP_LIN_ADDR_MUXRCAKS_64 port map (SummandA(63 downto 0) => SummandA(63 downto 0), 
													 SummandB(63 downto 0) => SummandB(63 downto 0), 
													 Summation(63 downto 0) => Summation(63 downto 0), 
													 CarryIn => '0',
													 CarryOut => InternalCarry(0));
ADDR64_1 : STRUC_FAP_LIN_ADDR_MUXRCAKS_64 port map (SummandA(63 downto 0) => SummandA(127 downto 64), 
													 SummandB(63 downto 0) => SummandB(127 downto 64), 
													 Summation(63 downto 0) => Summation(127 downto 64), 
													 CarryIn => InternalCarry(0),
													 CarryOut => InternalCarry(1));
ADDR64_2 : STRUC_FAP_LIN_ADDR_MUXRCAKS_64 port map (SummandA(63 downto 0) => SummandA(191 downto 128), 
													 SummandB(63 downto 0) => SummandB(191 downto 128), 
													 Summation(63 downto 0) => Summation(191 downto 128), 
													 CarryIn => InternalCarry(1),
													 CarryOut => InternalCarry(2));
ADDR64_3 : STRUC_FAP_LIN_ADDR_MUXRCAKS_64 port map (SummandA(63 downto 0) => SummandA(255 downto 192), 
													 SummandB(63 downto 0) => SummandB(255 downto 192), 
													 Summation(63 downto 0) => Summation(255 downto 192), 
													 CarryIn => InternalCarry(2),
													 CarryOut => Summation(256));

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:09:38 03/13/2017 
-- Design Name: 
-- Module Name:    Addition_64Bits_Muxd - Behavioral 
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

--Addition_64Bits_Muxd
entity STRUC_FAP_LIN_ADDR_MUXRCAKS_64 is
    Port ( SummandA : in  STD_LOGIC_VECTOR (63 downto 0);
           SummandB : in  STD_LOGIC_VECTOR (63 downto 0);
           Summation : out  STD_LOGIC_VECTOR (63 downto 0); --(SummandA + SummandB = Summation)
           CarryIn : in  STD_LOGIC;
           CarryOut : out  STD_LOGIC);
end STRUC_FAP_LIN_ADDR_MUXRCAKS_64;

architecture Behavioral of STRUC_FAP_LIN_ADDR_MUXRCAKS_64 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--A 64 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (63 downto 0) := X"0000_0000_0000_0000";

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--
component STRUC_FAP_LIN_ADDR_MUXRCAKS_16
	port( SummandA : in  STD_LOGIC_VECTOR (15 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (15 downto 0);
         Summation : out  STD_LOGIC_VECTOR (15 downto 0); --(SummandA + SummandB = Summation)
         CarryIn : in  STD_LOGIC;
         CarryOut : out  STD_LOGIC
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Propogates the internal Carry signals from one ADDR cell to the next; The 'Ripple'; Assuming CarryIn = 1
signal InternalCarryCarrySet : STD_LOGIC_VECTOR (3 downto 0); 
--Propogates the internal Carry signals from one ADDR cell to the next; The 'Ripple'; Assuming CarryIn = 0
signal InternalCarryCarryOff : STD_LOGIC_VECTOR (3 downto 0);
--Carries the result of the RCKSA with CarryIn = 1
signal InternalSummationCarrySet : STD_LOGIC_VECTOR (63 downto 0);
--Carries the result of the RCKSA with CarryIn = 0
signal InternalSummationCarryOff : STD_LOGIC_VECTOR (63 downto 0);


begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
--Ripple-Carry-Kogge-Stone 64Bit Adder, Implemented Assuming the CarryIn is equal to 1--
----------------------------------------------------------------------------------------

--Four '16 Bit Adders' in series
ADDR16_0_CarrySet : STRUC_FAP_LIN_ADDR_MUXRCAKS_16 port map (SummandA(15 downto 0) => SummandA(15 downto 0), 
													 SummandB(15 downto 0) => SummandB(15 downto 0), 
													 Summation(15 downto 0) => InternalSummationCarrySet(15 downto 0), 
													 CarryIn => '1',
													 CarryOut => InternalCarryCarrySet(0));
ADDR16_1_CarrySet : STRUC_FAP_LIN_ADDR_MUXRCAKS_16 port map (SummandA(15 downto 0) => SummandA(31 downto 16), 
													 SummandB(15 downto 0) => SummandB(31 downto 16), 
													 Summation(15 downto 0) => InternalSummationCarrySet(31 downto 16), 
													 CarryIn => InternalCarryCarrySet(0),
													 CarryOut => InternalCarryCarrySet(1));
ADDR16_2_CarrySet : STRUC_FAP_LIN_ADDR_MUXRCAKS_16 port map (SummandA(15 downto 0) => SummandA(47 downto 32), 
													 SummandB(15 downto 0) => SummandB(47 downto 32), 
													 Summation(15 downto 0) => InternalSummationCarrySet(47 downto 32), 
													 CarryIn => InternalCarryCarrySet(1),
													 CarryOut => InternalCarryCarrySet(2));
ADDR16_3_CarrySet : STRUC_FAP_LIN_ADDR_MUXRCAKS_16 port map (SummandA(15 downto 0) => SummandA(63 downto 48), 
													 SummandB(15 downto 0) => SummandB(63 downto 48), 
													 Summation(15 downto 0) => InternalSummationCarrySet(63 downto 48), 
													 CarryIn => InternalCarryCarrySet(2),
													 CarryOut => InternalCarryCarrySet(3));

----------------------------------------------------------------------------------------
--Ripple-Carry-Kogge-Stone 64Bit Adder, Implemented Assuming the CarryIn is equal to 0--
----------------------------------------------------------------------------------------

--Four '16 Bit Adders' in series
ADDR16_0_CarryOff : STRUC_FAP_LIN_ADDR_MUXRCAKS_16 port map (SummandA(15 downto 0) => SummandA(15 downto 0), 
													 SummandB(15 downto 0) => SummandB(15 downto 0), 
													 Summation(15 downto 0) => InternalSummationCarryOff(15 downto 0), 
													 CarryIn => '0',
													 CarryOut => InternalCarryCarryOff(0));
ADDR16_1_CarryOff : STRUC_FAP_LIN_ADDR_MUXRCAKS_16 port map (SummandA(15 downto 0) => SummandA(31 downto 16), 
													 SummandB(15 downto 0) => SummandB(31 downto 16), 
													 Summation(15 downto 0) => InternalSummationCarryOff(31 downto 16), 
													 CarryIn => InternalCarryCarryOff(0),
													 CarryOut => InternalCarryCarryOff(1));
ADDR16_2_CarryOff : STRUC_FAP_LIN_ADDR_MUXRCAKS_16 port map (SummandA(15 downto 0) => SummandA(47 downto 32), 
													 SummandB(15 downto 0) => SummandB(47 downto 32), 
													 Summation(15 downto 0) => InternalSummationCarryOff(47 downto 32), 
													 CarryIn => InternalCarryCarryOff(1),
													 CarryOut => InternalCarryCarryOff(2));
ADDR16_3_CarryOff : STRUC_FAP_LIN_ADDR_MUXRCAKS_16 port map (SummandA(15 downto 0) => SummandA(63 downto 48), 
													 SummandB(15 downto 0) => SummandB(63 downto 48), 
													 Summation(15 downto 0) => InternalSummationCarryOff(63 downto 48), 
													 CarryIn => InternalCarryCarryOff(2),
													 CarryOut => InternalCarryCarryOff(3));

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

SummationGenerate : for k in 0 to 63 generate
begin 
	Summation(k) <= (InternalSummationCarrySet(k) and CarryIn) or (InternalSummationCarryOff(k) and (not CarryIn));
end generate SummationGenerate;

CarryOut <= (InternalCarryCarrySet(3) and CarryIn) or (InternalCarryCarryOff(3) and (not CarryIn));

end Behavioral;


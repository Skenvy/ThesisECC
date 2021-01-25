----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:39:08 03/13/2017 
-- Design Name: 
-- Module Name:    Addition_16Bits_Muxd - Behavioral 
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

--Addition_16Bits_Muxd
entity STRUC_FAP_LIN_ADDR_MUXRCAKS_16 is
    Port ( SummandA : in  STD_LOGIC_VECTOR (15 downto 0);
           SummandB : in  STD_LOGIC_VECTOR (15 downto 0);
           Summation : out  STD_LOGIC_VECTOR (15 downto 0); --(SummandA + SummandB = Summation)
           CarryIn : in  STD_LOGIC;
           CarryOut : out  STD_LOGIC);
end STRUC_FAP_LIN_ADDR_MUXRCAKS_16;

architecture Behavioral of STRUC_FAP_LIN_ADDR_MUXRCAKS_16 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--A 16 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (15 downto 0) := X"0000";

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component STRUC_FAP_LIN_ADDR_MUXKS_4
	port( SummandA : in  STD_LOGIC_VECTOR (3 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (3 downto 0);
         Summation : out  STD_LOGIC_VECTOR (3 downto 0); --(SummandA + SummandB = Summation)
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
signal InternalSummationCarrySet : STD_LOGIC_VECTOR (15 downto 0);
--Carries the result of the RCKSA with CarryIn = 0
signal InternalSummationCarryOff : STD_LOGIC_VECTOR (15 downto 0);



begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
--Ripple-Carry-Kogge-Stone 16Bit Adder, Implemented Assuming the CarryIn is equal to 1--
----------------------------------------------------------------------------------------

--Four '4 Bit Adders' in series
ADDR4_0_CarrySet : STRUC_FAP_LIN_ADDR_MUXKS_4 port map (SummandA(3 downto 0) => SummandA(3 downto 0), 
													 SummandB(3 downto 0) => SummandB(3 downto 0), 
													 Summation(3 downto 0) => InternalSummationCarrySet(3 downto 0), 
													 CarryIn => '1',
													 CarryOut => InternalCarryCarrySet(0));
ADDR4_1_CarrySet : STRUC_FAP_LIN_ADDR_MUXKS_4 port map (SummandA(3 downto 0) => SummandA(7 downto 4), 
													 SummandB(3 downto 0) => SummandB(7 downto 4), 
													 Summation(3 downto 0) => InternalSummationCarrySet(7 downto 4), 
													 CarryIn => InternalCarryCarrySet(0),
													 CarryOut => InternalCarryCarrySet(1));
ADDR4_2_CarrySet : STRUC_FAP_LIN_ADDR_MUXKS_4 port map (SummandA(3 downto 0) => SummandA(11 downto 8), 
													 SummandB(3 downto 0) => SummandB(11 downto 8), 
													 Summation(3 downto 0) => InternalSummationCarrySet(11 downto 8), 
													 CarryIn => InternalCarryCarrySet(1),
													 CarryOut => InternalCarryCarrySet(2));
ADDR4_3_CarrySet : STRUC_FAP_LIN_ADDR_MUXKS_4 port map (SummandA(3 downto 0) => SummandA(15 downto 12), 
													 SummandB(3 downto 0) => SummandB(15 downto 12), 
													 Summation(3 downto 0) => InternalSummationCarrySet(15 downto 12), 
													 CarryIn => InternalCarryCarrySet(2),
													 CarryOut => InternalCarryCarrySet(3));
													 
----------------------------------------------------------------------------------------
--Ripple-Carry-Kogge-Stone 16Bit Adder, Implemented Assuming the CarryIn is equal to 0--
----------------------------------------------------------------------------------------

--Four '4 Bit Adders' in series
ADDR4_0_CarryOff : STRUC_FAP_LIN_ADDR_MUXKS_4 port map (SummandA(3 downto 0) => SummandA(3 downto 0), 
													 SummandB(3 downto 0) => SummandB(3 downto 0), 
													 Summation(3 downto 0) => InternalSummationCarryOff(3 downto 0), 
													 CarryIn => '0',
													 CarryOut => InternalCarryCarryOff(0));
ADDR4_1_CarryOff : STRUC_FAP_LIN_ADDR_MUXKS_4 port map (SummandA(3 downto 0) => SummandA(7 downto 4), 
													 SummandB(3 downto 0) => SummandB(7 downto 4), 
													 Summation(3 downto 0) => InternalSummationCarryOff(7 downto 4), 
													 CarryIn => InternalCarryCarryOff(0),
													 CarryOut => InternalCarryCarryOff(1));
ADDR4_2_CarryOff : STRUC_FAP_LIN_ADDR_MUXKS_4 port map (SummandA(3 downto 0) => SummandA(11 downto 8), 
													 SummandB(3 downto 0) => SummandB(11 downto 8), 
													 Summation(3 downto 0) => InternalSummationCarryOff(11 downto 8), 
													 CarryIn => InternalCarryCarryOff(1),
													 CarryOut => InternalCarryCarryOff(2));
ADDR4_3_CarryOff : STRUC_FAP_LIN_ADDR_MUXKS_4 port map (SummandA(3 downto 0) => SummandA(15 downto 12), 
													 SummandB(3 downto 0) => SummandB(15 downto 12), 
													 Summation(3 downto 0) => InternalSummationCarryOff(15 downto 12), 
													 CarryIn => InternalCarryCarryOff(2),
													 CarryOut => InternalCarryCarryOff(3));

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

SummationGenerate : for k in 0 to 15 generate
begin 
	Summation(k) <= (InternalSummationCarrySet(k) and CarryIn) or (InternalSummationCarryOff(k) and (not CarryIn));
end generate SummationGenerate;

--Summation(0) <= (InternalSummationCarrySet(0) and CarryIn) or (InternalSummationCarryOff(0) and (not CarryIn));
--Summation(1) <= (InternalSummationCarrySet(1) and CarryIn) or (InternalSummationCarryOff(1) and (not CarryIn));
--Summation(2) <= (InternalSummationCarrySet(2) and CarryIn) or (InternalSummationCarryOff(2) and (not CarryIn));
--Summation(3) <= (InternalSummationCarrySet(3) and CarryIn) or (InternalSummationCarryOff(3) and (not CarryIn));
--Summation(4) <= (InternalSummationCarrySet(4) and CarryIn) or (InternalSummationCarryOff(4) and (not CarryIn));
--Summation(5) <= (InternalSummationCarrySet(5) and CarryIn) or (InternalSummationCarryOff(5) and (not CarryIn));
--Summation(6) <= (InternalSummationCarrySet(6) and CarryIn) or (InternalSummationCarryOff(6) and (not CarryIn));
--Summation(7) <= (InternalSummationCarrySet(7) and CarryIn) or (InternalSummationCarryOff(7) and (not CarryIn));
--Summation(8) <= (InternalSummationCarrySet(8) and CarryIn) or (InternalSummationCarryOff(8) and (not CarryIn));
--Summation(9) <= (InternalSummationCarrySet(9) and CarryIn) or (InternalSummationCarryOff(9) and (not CarryIn));
--Summation(10) <= (InternalSummationCarrySet(10) and CarryIn) or (InternalSummationCarryOff(10) and (not CarryIn));
--Summation(11) <= (InternalSummationCarrySet(11) and CarryIn) or (InternalSummationCarryOff(11) and (not CarryIn));
--Summation(12) <= (InternalSummationCarrySet(12) and CarryIn) or (InternalSummationCarryOff(12) and (not CarryIn));
--Summation(13) <= (InternalSummationCarrySet(13) and CarryIn) or (InternalSummationCarryOff(13) and (not CarryIn));
--Summation(14) <= (InternalSummationCarrySet(14) and CarryIn) or (InternalSummationCarryOff(14) and (not CarryIn));
--Summation(15) <= (InternalSummationCarrySet(15) and CarryIn) or (InternalSummationCarryOff(15) and (not CarryIn));

CarryOut <= (InternalCarryCarrySet(3) and CarryIn) or (InternalCarryCarryOff(3) and (not CarryIn));

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:21:57 03/13/2017 
-- Design Name: 
-- Module Name:    Addition_4Bits_Muxd - Behavioral 
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

--Addition_4Bits_Muxd
entity STRUC_FAP_LIN_ADDR_MUXKS_4 is
    Port ( SummandA : in  STD_LOGIC_VECTOR (3 downto 0);
           SummandB : in  STD_LOGIC_VECTOR (3 downto 0);
           Summation : out  STD_LOGIC_VECTOR (3 downto 0); --(SummandA + SummandB = Summation)
           CarryIn : in  STD_LOGIC;
           CarryOut : out  STD_LOGIC);
end STRUC_FAP_LIN_ADDR_MUXKS_4;

architecture Logic of STRUC_FAP_LIN_ADDR_MUXKS_4 is

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Carries the result of the summation if the carry were set
signal SummationCarryInSet : STD_LOGIC_VECTOR (3 downto 0); 
--Carries the result of the CarryOut if the carry were set
signal CarryOutCarryInSet : STD_LOGIC;								
--Carries the result of the summation if the carry were off
signal SummationCarryInOff : STD_LOGIC_VECTOR (3 downto 0); 
--Carries the result of the CarryOut if the carry were off
signal CarryOutCarryInOff : STD_LOGIC;								


begin

--------------------------------------------------------------------------
--Kogge-Stone 4Bit Adder, Implemented Assuming the CarryIn is equal to 1--
--------------------------------------------------------------------------

SummationCarryInSet(0) <= (SummandA(0) xnor SummandB(0)); --xor'ing with '1' is equivalent to xnor
SummationCarryInSet(1) <= SummandA(1) xor SummandB(1) xor ((SummandA(0) and SummandB(0)) or (SummandA(0) or SummandB(0)));
SummationCarryInSet(2) <= SummandA(2) xor SummandB(2) xor ((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0)) or (SummandA(0) or SummandB(0))) and (SummandA(1) or SummandB(1))));
SummationCarryInSet(3) <= SummandA(3) xor SummandB(3) xor ((SummandA(2) and SummandB(2)) or (((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0)) or (SummandA(0) or SummandB(0))) and (SummandA(1) or SummandB(1)))) and (SummandA(2) or SummandB(2))));
CarryOutCarryInSet <= ((SummandA(3) and SummandB(3)) or (((SummandA(2) and SummandB(2)) or (((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0)) or (SummandA(0) or SummandB(0))) and (SummandA(1) or SummandB(1)))) and (SummandA(2) or SummandB(2)))) and (SummandA(3) or SummandB(3))));

--------------------------------------------------------------------------
--Kogge-Stone 4Bit Adder, Implemented Assuming the CarryIn is equal to 0--
--------------------------------------------------------------------------

SummationCarryInOff(0) <= (SummandA(0) xor SummandB(0)); --xor'ing with '0' is equivalent to xor
SummationCarryInOff(1) <= SummandA(1) xor SummandB(1) xor ((SummandA(0) and SummandB(0)));
SummationCarryInOff(2) <= SummandA(2) xor SummandB(2) xor ((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0))) and (SummandA(1) or SummandB(1))));
SummationCarryInOff(3) <= SummandA(3) xor SummandB(3) xor ((SummandA(2) and SummandB(2)) or (((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0))) and (SummandA(1) or SummandB(1)))) and (SummandA(2) or SummandB(2))));
CarryOutCarryInOff <= ((SummandA(3) and SummandB(3)) or (((SummandA(2) and SummandB(2)) or (((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0))) and (SummandA(1) or SummandB(1)))) and (SummandA(2) or SummandB(2)))) and (SummandA(3) or SummandB(3))));

---------------------------------------------------------------------------------------------
--Multiplexed Output, Selecting either of the above KS Summation's, Selected by the CarryIn--
---------------------------------------------------------------------------------------------

Summation(0) <= (CarryIn and SummationCarryInSet(0)) or ((not CarryIn) and SummationCarryInOff(0));
Summation(1) <= (CarryIn and SummationCarryInSet(1)) or ((not CarryIn) and SummationCarryInOff(1));
Summation(2) <= (CarryIn and SummationCarryInSet(2)) or ((not CarryIn) and SummationCarryInOff(2));
Summation(3) <= (CarryIn and SummationCarryInSet(3)) or ((not CarryIn) and SummationCarryInOff(3));
CarryOut <= (CarryIn and CarryOutCarryInSet) or ((not CarryIn) and CarryOutCarryInOff);

end Logic;


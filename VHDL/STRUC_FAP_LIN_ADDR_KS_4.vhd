----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:09:40 03/13/2017 
-- Design Name: 
-- Module Name:    Addition_4Bits - Behavioral 
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

--Addition_4Bits
entity STRUC_FAP_LIN_ADDR_KS_4 is
    Port ( SummandA : in  STD_LOGIC_VECTOR (3 downto 0);
           SummandB : in  STD_LOGIC_VECTOR (3 downto 0);
           Summation : out  STD_LOGIC_VECTOR (3 downto 0);
           Carryin : in  STD_LOGIC;
           CarryOut : out  STD_LOGIC);
end STRUC_FAP_LIN_ADDR_KS_4;

architecture Logic of STRUC_FAP_LIN_ADDR_KS_4 is

begin

Summation(0) <= SummandA(0) xor SummandB(0) xor CarryIn; --CarryOut is ((SummandA(0) and SummandB(0)) or (CarryIn and (SummandA(0) or SummandB(0))))
Summation(1) <= SummandA(1) xor SummandB(1) xor ((SummandA(0) and SummandB(0)) or (CarryIn and (SummandA(0) or SummandB(0)))); --CarryOut is ((SummandA(1) and SummandB(1)) or (CarryIn and (SummandA(1) or SummandB(1))))
Summation(2) <= SummandA(2) xor SummandB(2) xor ((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0)) or (CarryIn and (SummandA(0) or SummandB(0)))) and (SummandA(1) or SummandB(1)))); --CarryOut is ((SummandA(2) and SummandB(2)) or (CarryIn and (SummandA(2) or SummandB(2))))
Summation(3) <= SummandA(3) xor SummandB(3) xor ((SummandA(2) and SummandB(2)) or (((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0)) or (CarryIn and (SummandA(0) or SummandB(0)))) and (SummandA(1) or SummandB(1)))) and (SummandA(2) or SummandB(2)))); --CarryOut is ((SummandA(3) and SummandB(3)) or (CarryIn and (SummandA(3) or SummandB(3))))
CarryOut <= ((SummandA(3) and SummandB(3)) or (((SummandA(2) and SummandB(2)) or (((SummandA(1) and SummandB(1)) or (((SummandA(0) and SummandB(0)) or (CarryIn and (SummandA(0) or SummandB(0)))) and (SummandA(1) or SummandB(1)))) and (SummandA(2) or SummandB(2)))) and (SummandA(3) or SummandB(3))));


end Behavioral;


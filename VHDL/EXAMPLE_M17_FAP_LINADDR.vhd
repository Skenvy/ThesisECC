----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:45:43 05/07/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAP_LINADDR - Behavioral 
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
use work.VECTOR_STANDARD.ALL;

entity EXAMPLE_M17_FAP_LINADDR is
    Port ( A : in  STD_LOGIC_VECTOR ((VecLen-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((VecLen-1) downto 0);
           S : out  STD_LOGIC_VECTOR ((VecLen) downto 0));
end EXAMPLE_M17_FAP_LINADDR;

architecture Behavioral of EXAMPLE_M17_FAP_LINADDR is

signal SummationInternal : STD_LOGIC_VECTOR ((VecLen) downto 0);
signal CarryInternal : STD_LOGIC_VECTOR ((VecLen-1) downto 0);

begin

CarryInternal(0) <= (A(0) and B(0));
SummationInternal(0) <= (A(0) xor B(0));
CarryGenerate : for k in 1 to (VecLen-1) generate
begin
	CarryInternal(k) <= ((A(k) and B(k)) or (A(k) and CarryInternal(k-1)) or (B(k) and CarryInternal(k-1)));
	SummationInternal(k) <= (A(k) xor B(k) xor CarryInternal(k-1));
end generate CarryGenerate;
SummationInternal(VecLen) <= CarryInternal(VecLen-1);

S <= SummationInternal;

end Behavioral;


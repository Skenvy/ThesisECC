----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:46:05 03/13/2017
-- Design Name: 
-- Module Name:    FullAdder - Behavioral 
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

--FullAdder
entity STRUC_FAP_LIN_ADDR_FullAdder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           Sum : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end STRUC_FAP_LIN_ADDR_FullAdder;

architecture Logic of STRUC_FAP_LIN_ADDR_FullAdder is

begin

Sum <= A xor B xor Cin;
Cout <= (A and B) or ((A or B) and Cin);

end Logic;


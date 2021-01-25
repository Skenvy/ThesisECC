----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:29:44 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_LINADDRMUX - Behavioral 
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

entity GENERIC_FAP_LINADDRMUX is
	 Generic (N : natural := VecLen;
				 M : natural := MultLen); --Terminal Length
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           S : out  STD_LOGIC_VECTOR (N downto 0));
end GENERIC_FAP_LINADDRMUX;

architecture Behavioral of GENERIC_FAP_LINADDRMUX is

component GENERIC_FAP_LINADDRMUX_INTERNALRCA
	 Generic (N : natural;
				 M : natural); --Terminal Length
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cout : out  STD_LOGIC);
end component;

begin

X : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => N, M => M)
		Port map (A => A, B => B, Cin => '0', S => S((N-1) downto 0), Cout => S(N));

end Behavioral;


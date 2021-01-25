----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:35:16 05/09/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_LINADDRMUX_INTERNALRCA - Behavioral 
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

entity GENERIC_FAP_LINADDRMUX_INTERNALRCA is
	 Generic (N : natural := VecLen;
				 M : natural := MultLen); --Terminal Length
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cout : out  STD_LOGIC);
end GENERIC_FAP_LINADDRMUX_INTERNALRCA;

architecture Behavioral of GENERIC_FAP_LINADDRMUX_INTERNALRCA is

component GENERIC_FAP_LINADDRMUX_INTERNALRCA
	 Generic (N : natural := VecLen;
				 M : natural := MultLen); --Terminal Length
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cout : out  STD_LOGIC);
end component;

signal CarryOn : STD_LOGIC;
signal CarryOff : STD_LOGIC;
signal CarryInternalTerminal : STD_LOGIC_VECTOR ((M-1) downto 0);
signal CarryInternalSplit : STD_LOGIC;
signal SummationOn : STD_LOGIC_VECTOR ((N-1) downto (N/2));
signal SummationOff : STD_LOGIC_VECTOR ((N-1) downto (N/2));

begin

terminal_structure_FA : if (N = 1) generate
begin
	Cout <= ((A(0) and B(0)) or (A(0) and Cin) or (B(0) and Cin));
	S(0) <= (A(0) xor B(0) xor Cin);
end generate terminal_structure_FA;

terminal_structure : if ((N <= M) and (N > 1)) generate
begin
	CarryInternalTerminal(0) <= ((A(0) and B(0)) or (A(0) and Cin) or (B(0) and Cin));
	S(0) <= (A(0) xor B(0) xor Cin);
	ADDRGen : for K in 1 to (N-2) generate
	begin
		CarryInternalTerminal(K) <= ((A(K) and B(K)) or (A(K) and CarryInternalTerminal(K-1)) or (B(K) and CarryInternalTerminal(K-1)));
		S(K) <= (A(K) xor B(K) xor CarryInternalTerminal(K-1));
	end generate ADDRGen;
	Cout <= ((A(N-1) and B(N-1)) or (A(N-1) and CarryInternalTerminal(N-2)) or (B(N-1) and CarryInternalTerminal(N-2)));
	S(N-1) <= (A(N-1) xor B(N-1) xor CarryInternalTerminal(N-2));
end generate terminal_structure;

--Recursively break into halves
recursive_structure : if (N > M) generate
begin
	--Make one copy of the first block
	ADDR1 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => (N/2))
		Port map ( A => A(((N/2)-1) downto 0),
					  B => B(((N/2)-1) downto 0),
					  Cin => Cin,
					  S => S(((N/2)-1) downto 0),
					  Cout => CarryInternalSplit);
	--Make the "OFF" Carry Block
	ADDR2_0 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => (N/2))
		Port map ( A => A(((2*(N/2))-1) downto (N/2)),
					  B => B(((2*(N/2))-1) downto (N/2)),
					  Cin => '0',
					  S => SummationOff(((2*(N/2))-1) downto (N/2)),
					  Cout => CarryOff);
	--Make the "ON" Carry Block
	ADDR2_1 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => (N/2))
		Port map ( A => A(((2*(N/2))-1) downto (N/2)),
					  B => B(((2*(N/2))-1) downto (N/2)),
					  Cin => '1',
					  S => SummationOn(((2*(N/2))-1) downto (N/2)),
					  Cout => CarryOn);
	--
	Cout <= (CarryInternalSplit and CarryOn) or ((not CarryInternalSplit) and CarryOff);
	--
	SumGen1 : for K in (N/2) to ((2*(N/2))-1) generate
	begin
		S(K) <= (CarryInternalSplit and SummationOn(K)) or ((not CarryInternalSplit) and SummationOff(K));
	end generate SumGen1;

end generate recursive_structure;



end Behavioral;


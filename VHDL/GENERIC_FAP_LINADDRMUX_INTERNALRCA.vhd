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
	 Generic (N : natural := VecLen);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cout : out  STD_LOGIC);
end GENERIC_FAP_LINADDRMUX_INTERNALRCA;

architecture Behavioral of GENERIC_FAP_LINADDRMUX_INTERNALRCA is

component GENERIC_FAP_LINADDRMUX_INTERNALRCA
	 Generic (N : natural := VecLen);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Cout : out  STD_LOGIC);
end component;

signal CarryChainOn : STD_LOGIC_VECTOR (3 downto 1);
signal CarryChainOff : STD_LOGIC_VECTOR (3 downto 1);
signal CarryInternal : STD_LOGIC_VECTOR (3 downto 0);
signal SummationOn : STD_LOGIC_VECTOR ((N-1) downto (N/4));
signal SummationOff : STD_LOGIC_VECTOR ((N-1) downto (N/4));

begin

terminal_structure_FA : if (N = 1) generate
begin
	Cout <= ((A(0) and B(0)) or (A(0) and Cin) or (B(0) and Cin));
	S(0) <= (A(0) xor B(0) xor Cin);
end generate terminal_structure_FA;

terminal_structure : if ((N <= 4) and (N > 1)) generate
begin
	CarryInternal(0) <= ((A(0) and B(0)) or (A(0) and Cin) or (B(0) and Cin));
	S(0) <= (A(0) xor B(0) xor Cin);
	ADDRGen : for K in 1 to (N-2) generate
	begin
		CarryInternal(K) <= ((A(K) and B(K)) or (A(K) and CarryInternal(K-1)) or (B(K) and CarryInternal(K-1)));
		S(K) <= (A(K) xor B(K) xor CarryInternal(K-1));
	end generate ADDRGen;
	Cout <= ((A(N-1) and B(N-1)) or (A(N-1) and CarryInternal(N-2)) or (B(N-1) and CarryInternal(N-2)));
	S(N-1) <= (A(N-1) xor B(N-1) xor CarryInternal(N-2));
end generate terminal_structure;

--Recursively break into quadrants
recursive_structure : if (N > 4) generate
begin
	--Make one copy of the first block
	ADDR1 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => (N/4))
		Port map ( A => A(((N/4)-1) downto 0),
					  B => B(((N/4)-1) downto 0),
					  Cin => Cin,
					  S => S(((N/4)-1) downto 0),
					  Cout => CarryInternal(0));
	--Make the "OFF" Carry Blocks
	ADDR2_0 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => (N/4))
		Port map ( A => A(((2*(N/4))-1) downto (N/4)),
					  B => B(((2*(N/4))-1) downto (N/4)),
					  Cin => '0', --CarryChain(0)
					  S => SummationOff(((2*(N/4))-1) downto (N/4)),
					  Cout => CarryChainOff(1));
	ADDR3_0 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => (N/4))
		Port map ( A => A(((3*(N/4))-1) downto (2*(N/4))),
					  B => B(((3*(N/4))-1) downto (2*(N/4))),
					  Cin => '0', --CarryChain(1)
					  S => SummationOff(((3*(N/4))-1) downto (2*(N/4))),
					  Cout => CarryChainOff(2));
	ADDR4_0 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => ((N/4)+(N-(4*(N/4)))))
		Port map ( A => A((N-1) downto (3*(N/4))),
					  B => B((N-1) downto (3*(N/4))),
					  Cin => '0', --CarryChain(2)
					  S => SummationOff((N-1) downto (3*(N/4))),
					  Cout => CarryChainOff(3));
	--Make the "ON" Carry Blocks
	ADDR2_1 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => (N/4))
		Port map ( A => A(((2*(N/4))-1) downto (N/4)),
					  B => B(((2*(N/4))-1) downto (N/4)),
					  Cin => '1', --CarryChain(0)
					  S => SummationOn(((2*(N/4))-1) downto (N/4)),
					  Cout => CarryChainOn(1));
	ADDR3_1 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => (N/4))
		Port map ( A => A(((3*(N/4))-1) downto (2*(N/4))),
					  B => B(((3*(N/4))-1) downto (2*(N/4))),
					  Cin => '1', --CarryChain(1)
					  S => SummationOn(((3*(N/4))-1) downto (2*(N/4))),
					  Cout => CarryChainOn(2));
	ADDR4_1 : GENERIC_FAP_LINADDRMUX_INTERNALRCA
		Generic map (N => ((N/4)+(N-(4*(N/4)))))
		Port map ( A => A((N-1) downto (3*(N/4))),
					  B => B((N-1) downto (3*(N/4))),
					  Cin => '1', --CarryChain(2)
					  S => SummationOn((N-1) downto (3*(N/4))),
					  Cout => CarryChainOn(3));
					  
	CarryGen : for K in 1 to 3 generate --0 to 3 : 4 ; 16
	begin
		CarryInternal(K) <= (CarryInternal(K-1) and CarryChainOn(K)) or ((not CarryInternal(K-1)) and CarryChainOff(K));
	end generate CarryGen;
	Cout <= CarryInternal(3);
	
	SumGen1 : for K in (N/4) to ((2*(N/4))-1) generate --0 to 3 : 4 ; 16
	begin
		S(K) <= (CarryInternal(0) and SummationOn(K)) or ((not CarryInternal(0)) and SummationOff(K));
		S(K+(N/4)) <= (CarryInternal(1) and SummationOn(K+(N/4))) or ((not CarryInternal(1)) and SummationOff(K+(N/4)));
	end generate SumGen1;
	SumGen2 : for K in (3*(N/4)) to (N-1) generate --0 to 3 : 4 ; 16
	begin
		S(K) <= (CarryInternal(2) and SummationOn(K)) or ((not CarryInternal(2)) and SummationOff(K));
	end generate SumGen2;
end generate recursive_structure;



end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:36:42 05/08/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_EQUALITY - Behavioral 
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

entity GENERIC_FAP_EQUALITY is
	 Generic (N : natural := VecLen); --
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC);
end GENERIC_FAP_EQUALITY;

architecture Behavioral of GENERIC_FAP_EQUALITY is

component GENERIC_FAP_EQUALITY
	generic (N : natural);
	port (A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
         B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
         E : out  STD_LOGIC);
end component;

signal EQBits : STD_LOGIC_VECTOR (2 downto 0);

begin

terminal_structure_1 : if (N = 1) generate
begin
	E <= A(0) xnor B(0);
end generate terminal_structure_1;

terminal_structure_2 : if (N = 2) generate
begin
	E <= (A(0) xnor B(0)) and (A(1) xnor B(1));
end generate terminal_structure_2;

terminal_structure_3 : if (N = 3) generate
begin
	E <= (A(0) xnor B(0)) and (A(1) xnor B(1)) and (A(2) xnor B(2));
end generate terminal_structure_3;

recursive_structure_trip : if (((N mod 3) = 0) and (N > 3)) generate
begin
	GFE_RSE_Lower : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A(((N/3)-1) downto 0), 
					 B => B(((N/3)-1) downto 0), 
					 E => EQBits(0));
	GFE_RSE_Middr : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A(((2*N/3)-1) downto (N/3)), 
					 B => B(((2*N/3)-1) downto (N/3)), 
					 E => EQBits(1));
	GFE_RSE_Upper : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A((N-1) downto (2*N/3)), 
					 B => B((N-1) downto (2*N/3)), 
					 E => EQBits(2));
	E <= EQBits(0) and EQBits(1) and EQBits(2);	 
end generate recursive_structure_trip;

recursive_structure_trip_uni : if (((N mod 3) = 1) and (N > 3)) generate
begin
	GFE_RSE_Lower : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A((((N-1)/3)-1) downto 0), 
					 B => B((((N-1)/3)-1) downto 0), 
					 E => EQBits(0));
	GFE_RSE_Middr : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A(((2*(N-1)/3)-1) downto ((N-1)/3)), 
					 B => B(((2*(N-1)/3)-1) downto ((N-1)/3)), 
					 E => EQBits(1));
	GFE_RSE_Upper : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A(((N-1)-1) downto (2*(N-1)/3)), 
					 B => B(((N-1)-1) downto (2*(N-1)/3)), 
					 E => EQBits(2));
	E <= EQBits(0) and EQBits(1) and EQBits(2) and (A(N-1) xnor B(N-1));
end generate recursive_structure_trip_uni;

recursive_structure_trip_duo : if (((N mod 3) = 2) and (N > 3)) generate
begin
	GFE_RSE_Lower : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A((((N-2)/3)-1) downto 0), 
					 B => B((((N-2)/3)-1) downto 0), 
					 E => EQBits(0));
	GFE_RSE_Middr : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A(((2*(N-2)/3)-1) downto ((N-2)/3)), 
					 B => B(((2*(N-2)/3)-1) downto ((N-2)/3)), 
					 E => EQBits(1));
	GFE_RSE_Upper : GENERIC_FAP_EQUALITY
		generic map (N  => (N/3))
		port map (A => A(((N-2)-1) downto (2*(N-2)/3)), 
					 B => B(((N-2)-1) downto (2*(N-2)/3)), 
					 E => EQBits(2));
	E <= EQBits(0) and EQBits(1) and EQBits(2) and (A(N-1) xnor B(N-1)) and (A(N-2) xnor B(N-2));
end generate recursive_structure_trip_duo;

end Behavioral;


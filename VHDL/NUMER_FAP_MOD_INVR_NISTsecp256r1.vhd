----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:49:20 03/23/2017 
-- Design Name: 
-- Module Name:    NUMER_FAP_MOD_INVR_NISTsecp256r1 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;


entity NUMER_FAP_MOD_INVR_NISTsecp256r1 is
    Port ( Element : in  STD_LOGIC_VECTOR (255 downto 0);
           Inverse : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_FAP_MOD_INVR_NISTsecp256r1;

architecture Behavioral of NUMER_FAP_MOD_INVR_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
--A 256 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
--A 256 bit vector populated by only zeroes except the first bit
constant UnitVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component NUMER_FAP_MOD_INVR_INTERNAL_NISTsecp256r1 is
    Port ( U : in  STD_LOGIC_VECTOR (255 downto 0);
           V : in  STD_LOGIC_VECTOR (255 downto 0);
           X : in  STD_LOGIC_VECTOR (255 downto 0);
           Y : in  STD_LOGIC_VECTOR (255 downto 0);
           Uout : out  STD_LOGIC_VECTOR (255 downto 0);
           Vout : out  STD_LOGIC_VECTOR (255 downto 0);
           Xout : out  STD_LOGIC_VECTOR (255 downto 0);
           Yout : out  STD_LOGIC_VECTOR (255 downto 0));
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

signal U : STD_LOGIC_VECTOR (255 downto 0);
signal V : STD_LOGIC_VECTOR (255 downto 0);
signal X : STD_LOGIC_VECTOR (255 downto 0);
signal Y : STD_LOGIC_VECTOR (255 downto 0);
signal Uout : STD_LOGIC_VECTOR (255 downto 0);
signal Vout : STD_LOGIC_VECTOR (255 downto 0);
signal Xout : STD_LOGIC_VECTOR (255 downto 0);
signal Yout : STD_LOGIC_VECTOR (255 downto 0);
signal ULast : STD_LOGIC_VECTOR (255 downto 0);
signal VLast : STD_LOGIC_VECTOR (255 downto 0);
signal XLast : STD_LOGIC_VECTOR (255 downto 0);
signal YLast : STD_LOGIC_VECTOR (255 downto 0);

begin

InternalPart : NUMER_FAP_MOD_INVR_INTERNAL_NISTsecp256r1 port map (U => U, V => V, X => X, Y => Y, Uout => Uout, Vout => Vout, Xout => Xout, Yout => Yout);

process(Element)
begin
	U <= Element;
	V <= Prime;
	X <= UnitVector;
	Y <= ZeroVector;
	for K in 0 to 511 loop
		if ((U /= UnitVector) or (V /= UnitVector)) then
			ULast <= Uout;
			VLast <= Vout;
			XLast <= Xout;
			YLast <= Yout;
			U <= ULast;
			V <= VLast;
			X <= XLast;
			Y <= YLast;
		end if;
	end loop;
	if (U = UnitVector) then 
		Inverse <= STD_LOGIC_VECTOR(unsigned(X) mod unsigned(Prime));
	else
		Inverse <= STD_LOGIC_VECTOR(unsigned(Y) mod unsigned(Prime));
	end if;
end process;

--process(U, V, X, Y, Element)
--begin
--	U <= Element;
--	V <= Prime;
--	X <= UnitVector;
--	Y <= ZeroVector;
--	while (("0" & U) /= ZeroVector) loop
--		for k in 0 to 255 loop
--			UZERO <= U(0);
--			VZERO <= V(0);
--			XZERO <= X(0);
--			YZERO <= Y(0);
--			if (U(0) = '0') then
--				U <= STD_LOGIC_VECTOR(shift_right(unsigned(U),1));
--				if (X(0) = '0') then
--					X <= STD_LOGIC_VECTOR(shift_right(unsigned(X),1));
--				else
--					X <= STD_LOGIC_VECTOR(shift_right((unsigned(X) + unsigned(Prime)),1));
--				end if;
--			end if;
--			if (V(0) = '0') then
--				V <= STD_LOGIC_VECTOR(shift_right(unsigned(V),1));
--				if (Y(0) = '0') then
--					Y <= STD_LOGIC_VECTOR(shift_right(unsigned(Y),1));
--				else
--					Y <= STD_LOGIC_VECTOR(shift_right(unsigned(Y) + unsigned(Prime),1));
--				end if;
--			end if;
--		end loop;
--		if (U >= V) then 
--			U <= STD_LOGIC_VECTOR(unsigned(U) - unsigned(V));
--			if (X > Y) then 
--				X <= STD_LOGIC_VECTOR(unsigned(X) - unsigned(Y));
--			else
--				X <= STD_LOGIC_VECTOR(unsigned(X) + unsigned(Prime) - unsigned(Y));
--			end if;
--		else 
--			V <= STD_LOGIC_VECTOR(unsigned(V) - unsigned(U));
--			if (Y > X) then 
--				Y <= STD_LOGIC_VECTOR(unsigned(Y) - unsigned(X));
--			else 
--				Y <= STD_LOGIC_VECTOR(unsigned(Y) + unsigned(Prime) - unsigned(X));
--			end if;
--		end if;
--	end loop;
--	if (("0" & U) = UnitVector) then 
--		Inverse <= STD_LOGIC_VECTOR(unsigned(X) mod unsigned(Prime));
--	else 
--		Inverse <= STD_LOGIC_VECTOR(unsigned(Y) mod unsigned(Prime));
--	end if;
--	
--end process;

end Behavioral;


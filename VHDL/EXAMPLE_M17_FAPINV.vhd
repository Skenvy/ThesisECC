----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:05:56 03/28/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAPINV - Behavioral 
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
use work.VECTOR_STANDARD.ALL;
use work.ECC_STANDARD.ALL;

entity EXAMPLE_M17_FAPINV is
    Port ( Element : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Inverse : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  CLK : in STD_LOGIC);
end EXAMPLE_M17_FAPINV;

architecture Behavioral of EXAMPLE_M17_FAPINV is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component EXAMPLE_M17_FAPINV_INTERNAL is
    Port ( U : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           V : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           X : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Y : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Uout : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Vout : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Xout : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Yout : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  CLK : in STD_LOGIC);
end component;
	 
-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

signal U : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal V : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal X : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal Y : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal Uout : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal Vout : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal Xout : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal Yout : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);

signal StableInverse : STD_LOGIC;
signal InternalInverse : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
signal PreviousElement : STD_LOGIC_VECTOR((VecLen - 1) downto 0);


begin

InternalPart : EXAMPLE_M17_FAPINV_INTERNAL port map (U => U, V => V, X => X, Y => Y, Uout => Uout, Vout => Vout, Xout => Xout, Yout => Yout, CLK => CLK);

Inverse <= InternalInverse when StableInverse = '1' else (others => 'Z');

process(CLK)
begin
	if	(rising_edge(CLK)) then
		if (Element = PreviousElement)  then
			if (Uout = UnitVector) then --If end condition met and inputs are stable, put output
				InternalInverse <= STD_LOGIC_VECTOR(unsigned(Xout) mod unsigned(Prime));
				StableInverse <= '1';
			elsif (Vout = UnitVector) then --If end condition met and inputs are stable, put output
				InternalInverse <= STD_LOGIC_VECTOR(unsigned(Yout) mod unsigned(Prime));
				StableInverse <= '1';
			end if;
			U <= Uout;
			V <= Vout;
			X <= Xout;
			Y <= Yout;
		else --Else, reset the signals and begin updates again.
			PreviousElement <= Element;
			U <= Element;
			V <= Prime;
			X <= UnitVector;
			Y <= ZeroVector;
			StableInverse <= '0';
		end if;	
	end if;
end process;

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:57:51 06/01/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODINVR_CLOCKED - Behavioral 
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

entity GENERIC_FAP_MODINVR_CLOCKED is
	 Generic (N : natural := VecLen;
				 M : natural := MultLen;
				 AddrDelay : Time := 30 ns);
    Port ( Element : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Inverse : out  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC);
end GENERIC_FAP_MODINVR_CLOCKED;

architecture Behavioral of GENERIC_FAP_MODINVR_CLOCKED is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component GENERIC_FAP_MODINVR_INTERNAL_CLOCKED
	 Generic (N : natural;
				 M : natural;
				 AddrDelay : Time);
    Port ( U : in STD_LOGIC_VECTOR((N-1) downto 0);
           V : in STD_LOGIC_VECTOR((N-1) downto 0);
           X : in STD_LOGIC_VECTOR((N-1) downto 0);
           Y : in STD_LOGIC_VECTOR((N-1) downto 0);
           Uout : out STD_LOGIC_VECTOR((N-1) downto 0);
           Vout : out STD_LOGIC_VECTOR((N-1) downto 0);
           Xout : out STD_LOGIC_VECTOR((N-1) downto 0);
           Yout : out STD_LOGIC_VECTOR((N-1) downto 0);
			  Modulus : in STD_LOGIC_VECTOR((N-1) downto 0);
			  CLK : in STD_LOGIC);
end component;

component GENERIC_FAP_RELATIONAL
	 Generic (N : Natural;
				 VType : Natural); --0 for just equality, 1 for Greater Than test : Default 1
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC;
           G : out  STD_LOGIC);
end component;

component GENERIC_FAP_MODADDR
	 Generic (N : natural;
				 M : natural); --Terminal Length
    Port ( SummandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           SummandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0); --Modulo.
           Summation : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end component;
	 
-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

signal U : STD_LOGIC_VECTOR ((N-1) downto 0);
signal V : STD_LOGIC_VECTOR ((N-1) downto 0);
signal X : STD_LOGIC_VECTOR ((N-1) downto 0);
signal Y : STD_LOGIC_VECTOR ((N-1) downto 0);
signal Uout : STD_LOGIC_VECTOR ((N-1) downto 0);
signal Vout : STD_LOGIC_VECTOR ((N-1) downto 0);
signal Xout : STD_LOGIC_VECTOR ((N-1) downto 0);
signal Yout : STD_LOGIC_VECTOR ((N-1) downto 0);

signal StableInverse : STD_LOGIC;
signal InternalInverse : STD_LOGIC_VECTOR((N-1) downto 0);
signal PreviousElement : STD_LOGIC_VECTOR((N-1) downto 0);
signal PreviousModulus : STD_LOGIC_VECTOR((N-1) downto 0);
signal StableElement : STD_LOGIC;
signal StableModulus : STD_LOGIC;
signal UnitaryU : STD_LOGIC;
signal UnitaryV : STD_LOGIC;

signal XoutModded : STD_LOGIC_VECTOR ((N-1) downto 0);
signal YoutModded : STD_LOGIC_VECTOR ((N-1) downto 0);

begin

STABLEELE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => Element,
           B => PreviousElement,
           E => StableElement,
           G => open);

STABLEMOD : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => Modulus,
           B => PreviousModulus,
           E => StableModulus,
           G => open);
			  
UISUNIT : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => Uout,
           B => UnitVector,
           E => UnitaryU,
           G => open);

VISUNIT : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => Vout,
           B => UnitVector,
           E => UnitaryV,
           G => open);

XOUTMOD : GENERIC_FAP_MODADDR
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( SummandA => Xout,
					SummandB => ZeroVector,
					Modulus => Modulus,
					Summation => XoutModded);


YOUTMOD : GENERIC_FAP_MODADDR
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( SummandA => Yout,
					SummandB => ZeroVector,
					Modulus => Modulus,
					Summation => YoutModded);

InternalPart : GENERIC_FAP_MODINVR_INTERNAL_CLOCKED 
	Generic Map (N => N, M => M, AddrDelay => AddrDelay) 
	Port Map (U => U, V => V, X => X, Y => Y, 
				 Uout => Uout, Vout => Vout, Xout => Xout, 
				 Yout => Yout, Modulus => Modulus, CLK => CLK);

InvGen : for K in 0 to (N-1) generate
begin
	Inverse(K) <= (InternalInverse(K) and StableInverse);
end generate InvGen;

process(CLK)
begin
	if	(rising_edge(CLK)) then
		if ((StableElement and StableModulus) = '1')  then
			if (UnitaryU = '1') then --If end condition met and inputs are stable, put output
				InternalInverse <= XoutModded;
				StableInverse <= '1';
			elsif (UnitaryV = '1') then --If end condition met and inputs are stable, put output
				InternalInverse <= YoutModded;
				StableInverse <= '1';
			else
				U <= Uout;
				V <= Vout;
				X <= Xout;
				Y <= Yout;
			end if;
		else --Else, reset the signals and begin updates again.
			PreviousElement <= Element;
			PreviousModulus <= Modulus;
			U <= Element;
			V <= Modulus;
			X <= UnitVector;
			Y <= ZeroVector;
			StableInverse <= '0';
		end if;	
	end if;
end process;

end Behavioral;


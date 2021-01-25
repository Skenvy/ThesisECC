----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:58:20 06/01/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODINVR_INTERNAL_CLOCKED - Behavioral 
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

entity GENERIC_FAP_MODINVR_INTERNAL_CLOCKED is
	 Generic (N : natural := VecLen;
				 M : natural := MultLen;
				 AddrDelay : Time := 30 ns);
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
end GENERIC_FAP_MODINVR_INTERNAL_CLOCKED;

architecture Behavioral of GENERIC_FAP_MODINVR_INTERNAL_CLOCKED is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component GENERIC_FAP_RELATIONAL
	 Generic (N : Natural;
				 VType : Natural); --0 for just equality, 1 for Greater Than test : Default 1
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC;
           G : out  STD_LOGIC);
end component;

component GENERIC_FAP_LINADDRMUX
	 Generic (N : natural;
				 M : natural); --Terminal Length
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           S : out  STD_LOGIC_VECTOR (N downto 0));
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Inverses
signal NotU : STD_LOGIC_VECTOR ((N-1) downto 0);
signal NotV : STD_LOGIC_VECTOR ((N-1) downto 0);
signal NotX : STD_LOGIC_VECTOR ((N-1) downto 0);
signal NotY : STD_LOGIC_VECTOR ((N-1) downto 0);
signal InvU : STD_LOGIC_VECTOR (N downto 0);
signal InvV : STD_LOGIC_VECTOR (N downto 0);
signal InvX : STD_LOGIC_VECTOR (N downto 0);
signal InvY : STD_LOGIC_VECTOR (N downto 0);

--Output signals for U and V
signal UsumInvV : STD_LOGIC_VECTOR (N downto 0);
signal VsumInvU : STD_LOGIC_VECTOR (N downto 0);

--Output signals for X
signal XsumInvY : STD_LOGIC_VECTOR (N downto 0);
signal XsumPrime : STD_LOGIC_VECTOR (N downto 0);
signal XsumPrimeShift : STD_LOGIC_VECTOR (N downto 0);
signal XsumPrimesumInvY : STD_LOGIC_VECTOR (N downto 0);

--Output signals for Y
signal YsumInvX : STD_LOGIC_VECTOR (N downto 0);
signal YsumPrime : STD_LOGIC_VECTOR (N downto 0);
signal YsumPrimeShift : STD_LOGIC_VECTOR (N downto 0);
signal YsumPrimesumInvX : STD_LOGIC_VECTOR (N downto 0);

--Output control signals
signal Control_UorVEven : STD_LOGIC;
signal Control_UgoreV : STD_LOGIC;
signal Control_UgV : STD_LOGIC;
signal Control_UeV : STD_LOGIC;
signal Control_XgY : STD_LOGIC;
signal Control_XeY : STD_LOGIC;
signal Control_YgX : STD_LOGIC;
signal Control_UorVEqualUnit : STD_LOGIC;
signal Control_UeUnit : STD_LOGIC;
signal Control_VeUnit : STD_LOGIC;

begin

NotU <= (not U);
NotV <= (not V);
NotX <= (not X);
NotY <= (not Y);

INVRU : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => NotU,
					B => UnitVector,
					S => InvU);
INVRV : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => NotV,
					B => UnitVector,
					S => InvV);
INVRX : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => NotX,
					B => UnitVector,
					S => InvX);
INVRY : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => NotY,
					B => UnitVector,
					S => InvY);

--Output signals for U and V
UINVV : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => U,
					B => InvV((N-1) downto 0),
					S => UsumInvV);
VINVU : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => V,
					B => InvU((N-1) downto 0),
					S => VsumInvU);

--Output signals for X
XINVY : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => X,
					B => InvY((N-1) downto 0),
					S => XsumInvY);
XPRIME : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => X,
					B => Modulus,
					S => XsumPrime);
XPRIMEINVY : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => XsumPrime((N-1) downto 0),
					B => InvY((N-1) downto 0),
					S => XsumPrimesumInvY);
XsumPrimeShift <= "0" & XsumPrime(N downto 1);

--Output signals for Y
YINVX : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => Y,
					B => InvX((N-1) downto 0),
					S => YsumInvX);
YPRIME : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => Y,
					B => Modulus,
					S => YsumPrime);
YPRIMEINVX : GENERIC_FAP_LINADDRMUX
	 Generic Map (N => N,
					  M => M) --Terminal Length
    Port Map ( A => YsumPrime((N-1) downto 0),
					B => InvX((N-1) downto 0),
					S => YsumPrimesumInvX);
YsumPrimeShift <= "0" & YsumPrime(N downto 1);

--Output control signals; COMPARE [U>=V], [X>=Y] in Greater Than
Control_UorVEven <= ((not U(0)) or (not V(0)));
UVGreat : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 1) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => U,
           B => V,
           E => Control_UeV,
           G => Control_UgV);  
XYGreat : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 1) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => X,
           B => Y,
           E => Control_XeY,
           G => Control_XgY);
UisUnit : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => U,
           B => UnitVector,
           E => Control_UeUnit,
           G => open);
VisUnit : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => U,
           B => UnitVector,
           E => Control_VeUnit,
           G => open);
Control_UgoreV <= (Control_UgV or Control_UeV);	
Control_YgX <= ((not Control_XgY) and (not Control_XeY));
Control_UorVEqualUnit <= (Control_UeUnit or Control_VeUnit);

process(CLK)
begin
if (rising_edge(CLK)) then 
	if ((Control_UorVEven and (not U(0)) and (not Control_UorVEqualUnit)) = '1') then
		Uout <= "0" & U((N-1) downto 1);
	elsif (((not Control_UorVEven) and Control_UgoreV and (not Control_UorVEqualUnit)) = '1') then
		Uout <= UsumInvV((N-1) downto 0);
	else
		Uout <= U;
	end if;
	if ((Control_UorVEven and (not V(0)) and (not Control_UorVEqualUnit)) = '1') then
		Vout <= "0" & V((N-1) downto 1);
	elsif (((not Control_UorVEven) and (not Control_UgoreV) and (not Control_UorVEqualUnit)) = '1') then
		Vout <= VsumInvU((N-1) downto 0);
	else
		Vout <= V;
	end if;
	if ((Control_UorVEven and (not U(0)) and (not X(0)) and (not Control_UorVEqualUnit)) = '1') then
		Xout <= "0" & X((N-1) downto 1);
	elsif ((Control_UorVEven and (not U(0)) and X(0) and (not Control_UorVEqualUnit)) = '1') then
		Xout <= XsumPrimeShift((N-1) downto 0);
	elsif (((not Control_UorVEven) and Control_UgoreV and Control_XgY and (not Control_UorVEqualUnit)) = '1') then
		Xout <= XsumInvY((N-1) downto 0);
	elsif (((not Control_UorVEven) and Control_UgoreV and (not Control_XgY) and (not Control_UorVEqualUnit)) = '1') then
		Xout <= XsumPrimesumInvY((N-1) downto 0);
	else
		Xout <= X;
	end if;
	if ((Control_UorVEven and (not V(0)) and (not Y(0)) and (not Control_UorVEqualUnit)) = '1') then
		Yout <= "0" & Y((N-1) downto 1);
	elsif ((Control_UorVEven and (not V(0)) and Y(0) and (not Control_UorVEqualUnit)) = '1') then
		Yout <= YsumPrimeShift((N-1) downto 0);
	elsif (((not Control_UorVEven) and (not Control_UgoreV) and Control_YgX and (not Control_UorVEqualUnit)) = '1') then
		Yout <= YsumInvX((N-1) downto 0);
	elsif (((not Control_UorVEven) and (not Control_UgoreV) and (not Control_YgX) and (not Control_UorVEqualUnit)) = '1') then
		Yout <= YsumPrimesumInvX((N-1) downto 0);
	else
		Yout <= Y;
	end if;
end if;
end process;

end Behavioral;


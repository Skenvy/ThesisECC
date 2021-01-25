----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:14 03/28/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAPINV_INTERNAL - Behavioral 
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

entity EXAMPLE_M17_FAPINV_INTERNAL is
    Port ( U : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           V : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           X : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Y : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Uout : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Vout : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Xout : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Yout : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  CLK : in STD_LOGIC);
end EXAMPLE_M17_FAPINV_INTERNAL;

architecture Behavioral of EXAMPLE_M17_FAPINV_INTERNAL is

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Output signals for U and V
signal UsumInvV : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal VsumInvU : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);

--Output signals for X
signal XsumInvY : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal XsumPrime : STD_LOGIC_VECTOR (VecLen downto 0);
signal XsumPrimeShift : STD_LOGIC_VECTOR (VecLen downto 0);
signal XsumPrimesumInvY : STD_LOGIC_VECTOR (VecLen downto 0);

--Output signals for Y
signal YsumInvX : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal YsumPrime : STD_LOGIC_VECTOR (VecLen downto 0);
signal YsumPrimeShift : STD_LOGIC_VECTOR (VecLen downto 0);
signal YsumPrimesumInvX : STD_LOGIC_VECTOR (VecLen downto 0);

--Output control signals
signal Control_UorVEven : STD_LOGIC;
signal Control_UgoreV : STD_LOGIC;
signal Control_XgY : STD_LOGIC;
signal Control_YgX : STD_LOGIC;
signal Control_UorVEqualUnit : STD_LOGIC;

begin
--Output signals for U and V
UsumInvV <= STD_LOGIC_VECTOR(unsigned(U) + unsigned(not V) + 1);
VsumInvU <= STD_LOGIC_VECTOR(unsigned(V) + unsigned(not U) + 1);

--Output signals for X
XsumInvY <= STD_LOGIC_VECTOR(unsigned(X) + unsigned(not Y) + 1);
XsumPrime <= STD_LOGIC_VECTOR(unsigned("0" & X) + unsigned("0" & Prime));
XsumPrimesumInvY <= STD_LOGIC_VECTOR(unsigned(XsumPrime) + unsigned(not Y) + 1);
XsumPrimeShift <= STD_LOGIC_VECTOR(shift_right(unsigned(XsumPrime),1));

--Output signals for Y
YsumInvX <= STD_LOGIC_VECTOR(unsigned(Y) + unsigned(not X) + 1);
YsumPrime <= STD_LOGIC_VECTOR(unsigned("0" & Y) + unsigned("0" & Prime));
YsumPrimesumInvX <= STD_LOGIC_VECTOR(unsigned(YsumPrime) + unsigned(not X) + 1);
YsumPrimeShift <= STD_LOGIC_VECTOR(shift_right(unsigned(YsumPrime),1));

--Output control signals
Control_UorVEven <= '1' when ((U(0) = '0') or (V(0) = '0')) else '0';
Control_UgoreV <= '1' when (U >= V) else '0';
Control_XgY <= '1' when (X > Y) else '0';
Control_YgX <= '1' when (Y > X) else '0';
Control_UorVEqualUnit <= '1' when ((U or V) = UnitVector) else '0'; -- (U or V) = Unit "is equi to" (U = unit) or (V = unit)

process(CLK)
begin
if (rising_edge(CLK)) then 
	if ((Control_UorVEven = '1') and (U(0) = '0') and (Control_UorVEqualUnit = '0')) then
		Uout <= STD_LOGIC_VECTOR(shift_right(unsigned(U),1));
	elsif ((not (Control_UorVEven = '1')) and ((Control_UgoreV = '1')) and (Control_UorVEqualUnit = '0')) then
		Uout <= UsumInvV;
	else
		Uout <= U;
	end if;
	if ((Control_UorVEven = '1') and (V(0) = '0') and (Control_UorVEqualUnit = '0')) then
		Vout <= STD_LOGIC_VECTOR(shift_right(unsigned(V),1));
	elsif ((not (Control_UorVEven = '1')) and (not (Control_UgoreV = '1')) and (Control_UorVEqualUnit = '0')) then
		Vout <= VsumInvU;
	else
		Vout <= V;
	end if;
	if ((Control_UorVEven = '1') and (U(0) = '0') and (X(0) = '0') and (Control_UorVEqualUnit = '0')) then
		Xout <= STD_LOGIC_VECTOR(shift_right(unsigned(X),1));
	elsif ((Control_UorVEven = '1') and (U(0) = '0') and (X(0) = '1') and (Control_UorVEqualUnit = '0')) then
		Xout <= XsumPrimeShift((VecLen - 1) downto 0);
	elsif ((not (Control_UorVEven = '1')) and ((Control_UgoreV = '1')) and ((Control_XgY = '1')) and (Control_UorVEqualUnit = '0')) then
		Xout <= XsumInvY;
	elsif ((not (Control_UorVEven = '1')) and ((Control_UgoreV = '1')) and (not (Control_XgY = '1')) and (Control_UorVEqualUnit = '0')) then
		Xout <= XsumPrimesumInvY((VecLen - 1) downto 0);
	else
		Xout <= X;
	end if;
	if ((Control_UorVEven = '1') and (V(0) = '0') and (Y(0) = '0') and (Control_UorVEqualUnit = '0')) then
		Yout <= STD_LOGIC_VECTOR(shift_right(unsigned(Y),1));
	elsif ((Control_UorVEven = '1') and (V(0) = '0') and (Y(0) = '1') and (Control_UorVEqualUnit = '0')) then
		Yout <= YsumPrimeShift((VecLen - 1) downto 0);
	elsif ((not (Control_UorVEven = '1')) and (not (Control_UgoreV = '1')) and ((Control_YgX = '1')) and (Control_UorVEqualUnit = '0')) then
		Yout <= YsumInvX;
	elsif ((not (Control_UorVEven = '1')) and (not (Control_UgoreV = '1')) and (not (Control_YgX = '1')) and (Control_UorVEqualUnit = '0')) then
		Yout <= YsumPrimesumInvX((VecLen - 1) downto 0);
	else
		Yout <= Y;
	end if;
end if;
end process;

end Behavioral;


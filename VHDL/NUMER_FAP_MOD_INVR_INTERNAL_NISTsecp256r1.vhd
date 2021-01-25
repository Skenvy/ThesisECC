----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:02:00 03/28/2017 
-- Design Name: 
-- Module Name:    NUMER_FAP_MOD_INVR_INTERNAL_NISTsecp256r1 - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NUMER_FAP_MOD_INVR_INTERNAL_NISTsecp256r1 is
    Port ( U : in  STD_LOGIC_VECTOR (255 downto 0);
           V : in  STD_LOGIC_VECTOR (255 downto 0);
           X : in  STD_LOGIC_VECTOR (255 downto 0);
           Y : in  STD_LOGIC_VECTOR (255 downto 0);
           Uout : out  STD_LOGIC_VECTOR (255 downto 0);
           Vout : out  STD_LOGIC_VECTOR (255 downto 0);
           Xout : out  STD_LOGIC_VECTOR (255 downto 0);
           Yout : out  STD_LOGIC_VECTOR (255 downto 0));
end NUMER_FAP_MOD_INVR_INTERNAL_NISTsecp256r1;

architecture Behavioral of NUMER_FAP_MOD_INVR_INTERNAL_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

signal UsumInvV : STD_LOGIC_VECTOR (255 downto 0);
signal VsumInvU : STD_LOGIC_VECTOR (255 downto 0);
signal XsumInvY : STD_LOGIC_VECTOR (255 downto 0);
signal YsumInvX : STD_LOGIC_VECTOR (255 downto 0);
signal XsumPrime : STD_LOGIC_VECTOR (255 downto 0);
signal YsumPrime : STD_LOGIC_VECTOR (255 downto 0);
signal XsumPrimesumInvY : STD_LOGIC_VECTOR (255 downto 0);
signal YsumPrimesumInvX : STD_LOGIC_VECTOR (255 downto 0);
signal Control_UorVEven : STD_LOGIC;
signal Control_UgoreV : STD_LOGIC;
signal Control_XgY : STD_LOGIC;
signal Control_YgX : STD_LOGIC;

begin

UsumInvV <= STD_LOGIC_VECTOR(unsigned(U) + unsigned(not V) + 1);
VsumInvU <= STD_LOGIC_VECTOR(unsigned(V) + unsigned(not U) + 1);
XsumInvY <= STD_LOGIC_VECTOR(unsigned(X) + unsigned(not Y) + 1);
YsumInvX <= STD_LOGIC_VECTOR(unsigned(Y) + unsigned(not X) + 1);
XsumPrime <= STD_LOGIC_VECTOR(unsigned(X) + unsigned(Prime));
YsumPrime <= STD_LOGIC_VECTOR(unsigned(Y) + unsigned(Prime));
XsumPrimesumInvY <= STD_LOGIC_VECTOR(unsigned(XsumPrime) + unsigned(not Y) + 1);
YsumPrimesumInvX <= STD_LOGIC_VECTOR(unsigned(YsumPrime) + unsigned(not X) + 1);

Control_UorVEven <= '1' when ((U(0) = '0') or (V(0) = '0')) else '0';
Control_UgoreV <= '1' when (U >= V) else '0';
Control_XgY <= '1' when (X > Y) else '0';
Control_YgX <= '1' when (Y > X) else '0';

Uout <= STD_LOGIC_VECTOR(shift_right(unsigned(U),1)) when ((Control_UorVEven = '1') and (U(0) = '0')) else  
		  UsumInvV when ((not (Control_UorVEven = '1')) and ((Control_UgoreV = '1'))) else U;
Vout <= STD_LOGIC_VECTOR(shift_right(unsigned(V),1)) when ((Control_UorVEven = '1') and (V(0) = '0')) else  
		  VsumInvU when ((not (Control_UorVEven = '1')) and (not (Control_UgoreV = '1'))) else V;
		  
Xout <= STD_LOGIC_VECTOR(shift_right(unsigned(X),1)) when ((Control_UorVEven = '1') and (U(0) = '0') and (X(0) = '0')) else
		  STD_LOGIC_VECTOR(shift_right(unsigned(XsumPrime),1)) when ((Control_UorVEven = '1') and (U(0) = '0') and (X(0) = '1')) else
		  XsumInvY when ((not (Control_UorVEven = '1')) and ((Control_UgoreV = '1')) and ((Control_XgY = '1'))) else
		  XsumPrimesumInvY when ((not (Control_UorVEven = '1')) and ((Control_UgoreV = '1')) and (not (Control_XgY = '1'))) else X;	  

Yout <= STD_LOGIC_VECTOR(shift_right(unsigned(Y),1)) when ((Control_UorVEven = '1') and (V(0) = '0') and (Y(0) = '0')) else
		  STD_LOGIC_VECTOR(shift_right(unsigned(YsumPrime),1)) when ((Control_UorVEven = '1') and (V(0) = '0') and (Y(0) = '1')) else
		  YsumInvX when ((not (Control_UorVEven = '1')) and (not (Control_UgoreV = '1')) and ((Control_YgX = '1'))) else
		  YsumPrimesumInvX when ((not (Control_UorVEven = '1')) and (not (Control_UgoreV = '1')) and (not (Control_YgX = '1'))) else Y;	
		  
end Behavioral;


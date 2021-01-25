----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:59:21 05/07/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAP_LINADDRMUX - Behavioral 
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

entity EXAMPLE_M17_FAP_LINADDRMUX is
    Port ( A : in  STD_LOGIC_VECTOR ((VecLen-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((VecLen-1) downto 0);
           S : out  STD_LOGIC_VECTOR ((VecLen) downto 0));
end EXAMPLE_M17_FAP_LINADDRMUX;

architecture Behavioral of EXAMPLE_M17_FAP_LINADDRMUX is

constant OuterSize : natural := 4; --4 for 256
constant MiddleSize : natural := 4; --2 for 256

signal SummationInternal : STD_LOGIC_VECTOR ((VecLen) downto 0);
signal CarryInternal : STD_LOGIC_VECTOR ((OuterSize*MiddleSize-1) downto 0);

signal SummationInternalFC1 : STD_LOGIC_VECTOR ((VecLen) downto 0);
signal CarryInternalFC1 : STD_LOGIC_VECTOR ((VecLen-1) downto 0);

signal SummationInternalFC0 : STD_LOGIC_VECTOR ((VecLen) downto 0);
signal CarryInternalFC0 : STD_LOGIC_VECTOR ((VecLen-1) downto 0);

begin

--Generate in word sizes
OuterGen : for J in 0 to (OuterSize-1) generate --0 to 3 : 4
begin
	MiddleGen : for K in 0 to (MiddleSize-1) generate --0 to 3 : 4 ; 16
	begin
		CarryInternalFC0(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) <= ((A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) and B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize)))) or (A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) and '0') or (B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) and '0'));
		SummationInternalFC0(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) <= (A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) xor B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) xor '0');
		CarryInternalFC1(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) <= ((A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) and B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize)))) or (A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) and '1') or (B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) and '1'));
		SummationInternalFC1(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) <= (A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) xor B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))) xor '1');
		InnerGen : for L in 1 to ((VecLen/(OuterSize*MiddleSize))-1) generate --1 to 15 : 15 ; 256
		begin
			CarryInternalFC0(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) <= ((A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) and B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L)) or (A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) and CarryInternalFC0(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L-1)) or (B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) and CarryInternalFC0(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L-1)));
			SummationInternalFC0(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) <= (A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) xor B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) xor CarryInternalFC0(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L-1));
			CarryInternalFC1(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) <= ((A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) and B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L)) or (A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) and CarryInternalFC1(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L-1)) or (B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) and CarryInternalFC1(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L-1)));
			SummationInternalFC1(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) <= (A(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) xor B(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L) xor CarryInternalFC1(J*(VecLen/OuterSize)+K*(VecLen/(OuterSize*MiddleSize))+L-1));
		end generate InnerGen;
	end generate MiddleGen;
end generate OuterGen;
SummationInternalFC0(VecLen) <= CarryInternalFC0(VecLen-1);
SummationInternalFC1(VecLen) <= CarryInternalFC1(VecLen-1);
--Generate Carry Cells
CarryInternal(0) <= CarryInternalFC0((VecLen/(OuterSize*MiddleSize))-1);
CarryGen : for J in 1 to (OuterSize*MiddleSize-1) generate --0 to 3 : 4 ; 16
begin
	CarryInternal(J) <= (CarryInternal(J-1) and CarryInternalFC1((((J+1)*VecLen)/(OuterSize*MiddleSize))-1)) or 
							  ((not CarryInternal(J-1)) and CarryInternalFC0((((J+1)*VecLen)/(OuterSize*MiddleSize))-1));
end generate CarryGen;
--Generate Sum
SummationGenInnerF : for K in 0 to ((VecLen/(OuterSize*MiddleSize))-1) generate --0 to 3 : 4 ; 16
begin
	SummationInternal(K) <= SummationInternalFC0(K);
end generate SummationGenInnerF;
SummationGenOuter : for J in 1 to (OuterSize*MiddleSize-1) generate --0 to 3 : 4 ; 16
begin
	SummationGenInner : for K in 0 to ((VecLen/(OuterSize*MiddleSize))-1) generate --0 to 3 : 4 ; 16
	begin
		SummationInternal((J*OuterSize*MiddleSize) + K) <= (CarryInternal(J-1) and SummationInternalFC1((J*OuterSize*MiddleSize) + K)) or 
																			((not CarryInternal(J-1)) and SummationInternalFC0((J*OuterSize*MiddleSize) + K));
	end generate SummationGenInner;
end generate SummationGenOuter;
SummationInternal(VecLen) <= (CarryInternal(OuterSize*MiddleSize-1) and SummationInternalFC1(VecLen)) or 
									  ((not CarryInternal(OuterSize*MiddleSize-1)) and SummationInternalFC0(VecLen));
--Place on the output
S <= SummationInternal;

end Behavioral;


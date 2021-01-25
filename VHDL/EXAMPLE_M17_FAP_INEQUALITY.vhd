----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:05:44 05/07/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAP_INEQUALITY - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity EXAMPLE_M17_FAP_INEQUALITY is
    Port ( A : in  STD_LOGIC_VECTOR ((VecLen) downto 0);
           B : in  STD_LOGIC_VECTOR ((VecLen) downto 0);
           GreaterAB : out  STD_LOGIC);
end EXAMPLE_M17_FAP_INEQUALITY;

architecture Behavioral of EXAMPLE_M17_FAP_INEQUALITY is

signal XNORTable : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal AonBoffTable : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal AgBatBitTable : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);

signal AboveEquiTable : STD_LOGIC_VECTOR ((VecLen) downto 0);
signal AgBTable : STD_LOGIC_VECTOR ((VecLen) downto 0);

signal ANDTable1 : STD_LOGIC_VECTOR ((VecLen/2) downto 0);
signal ANDTable2 : STD_LOGIC_VECTOR ((VecLen/4) downto 0);
signal ANDTable3 : STD_LOGIC_VECTOR ((VecLen/8) downto 0);
signal ANDTable4 : STD_LOGIC_VECTOR ((VecLen/16) downto 0);
signal IndexR : STD_LOGIC_VECTOR (1 downto 0); -- serves to return a logic value from a logical index

begin

IndexR(0) <= '0'; IndexR(1) <= '1';
AboveEquiTable(VecLen) <= '1';
AgBTable(VecLen) <= '0';
ANDTable1(VecLen/2) <= '1';
ANDTable2(VecLen/4) <= '1';
ANDTable3(VecLen/8) <= '1';
ANDTable4(VecLen/16) <= '1';
STNGen : for K in 0 to (VecLen - 1) generate
begin
	XNORTable(K) <= A(K) xnor B(K);
	AonBoffTable(K) <= A(K) and (not B(K));
	AgBatBitTable(K) <= AonBoffTable(K) and AboveEquiTable(K+1);
	AgBTable(K) <= AgBTable(K+1) or AgBatBitTable(K);
	
	AND1Gen : if ((K mod 2) = 0) generate
	begin
		ANDTable1(K/2) <= XNORTable(K) and XNORTable(K+1);
	end generate AND1Gen;

	AND2Gen : if ((K mod 4) = 0) generate
	begin
		ANDTable2(K/4) <= ANDTable1(K/2) and ANDTable1((K/2)+1);
	end generate AND2Gen;
	
	AND3Gen : if ((K mod 8) = 0) generate
	begin
		ANDTable3(K/8) <= ANDTable2(K/4) and ANDTable2((K/4)+1);
	end generate AND3Gen;
	
	AND4Gen : if ((K mod 16) = 0) generate
	begin
		ANDTable4(K/16) <= (ANDTable3(K/8) and ANDTable3((K/8)+1)) and ANDTable4((K/16)+1);
	end generate AND4Gen;
end generate STNGen;

AETGen0 : for K in 0 to (VecLen/16 - 1) generate
begin
	AETGen1 : for J in 0 to 1 generate
	begin
		AETGen2 : for H in 0 to 1 generate
		begin
			AETGen3 : for G in 0 to 1 generate
			begin
				AETGen4 : for L in 0 to 1 generate
				begin
					AETIFGen1 : if ((J=0) and (H=0) and (G=0) and (L=0)) generate
					begin
						AboveEquiTable(K*16) <= ANDTable4(K);
					end generate AETIFGen1;
					AETIFGen2 : if ((J=1) or (H=1) or (G=1) or (L=1)) generate
					begin
						AboveEquiTable(K*16+J*8+H*4+G*2+L) <= (((XNORTable(K*16+J*8+H*4+G*2+L) and ANDTable1(K*8+J*4+H*2+G+L)) and 
																		  (((not IndexR(G)) and (not IndexR(L)) and ANDTable2(K*4+J*2+H)) or ((IndexR(G) or IndexR(L)) and ANDTable2(K*4+J*2+H+1)))) and 
																		  ((((not IndexR(H)) and (not IndexR(G)) and (not IndexR(L)) and ANDTable3(K*2+J)) or (((IndexR(H)) or (IndexR(G)) or (IndexR(L))) and ANDTable3(K*2+J+1))) and ANDTable4(K+1)));
					end generate AETIFGen2;
				end generate AETGen4;
			end generate AETGen3;
		end generate AETGen2;
	end generate AETGen1;
end generate AETGen0;

GreaterAB <= (A(VecLen) and (not B(VecLen))) or AgBTable(0);

end Behavioral;


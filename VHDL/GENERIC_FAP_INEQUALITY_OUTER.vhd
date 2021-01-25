----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:35:02 05/08/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_INEQUALITY_OUTER - Behavioral 
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

entity GENERIC_FAP_INEQUALITY_OUTER is
	 Generic (N : natural := VecLen); --
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           G : out  STD_LOGIC;
			  E : out  STD_LOGIC);
end GENERIC_FAP_INEQUALITY_OUTER;

architecture Behavioral of GENERIC_FAP_INEQUALITY_OUTER is

signal EquiAbove : STD_LOGIC_VECTOR (((((N/16)+1)*16)-1) downto 0);
signal XNORTable : STD_LOGIC_VECTOR (((((N/16)+1)*16)-1) downto 0);
signal ANDTable1 : STD_LOGIC_VECTOR (((((N/16)+1)*8)) downto 0);
signal ANDTable2 : STD_LOGIC_VECTOR (((((N/16)+1)*4)) downto 0);
signal ANDTable3 : STD_LOGIC_VECTOR (((((N/16)+1)*2)) downto 0);
signal ANDTable4 : STD_LOGIC_VECTOR ((N/16)+1 downto 0);
signal IndexR : STD_LOGIC_VECTOR (1 downto 0); -- serves to return a logic value from a logical index

component GENERIC_FAP_INEQUALITY_INNER
	 Generic (N : natural := VecLen); --
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           EquiAbove : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           G : out  STD_LOGIC);
end component;

begin

ANDTable4(N/16 + 1) <= '1';
ANDTable3((((N/16)+1)*2)) <= '1';
ANDTable2((((N/16)+1)*4)) <= '1';
ANDTable1((((N/16)+1)*8)) <= '1';
IndexR(0) <= '0'; IndexR(1) <= '1';

EquiAboveGen : for K in 0 to ((((N/16)+1)*16)-1) generate
begin
	EquiAboveGenLess : if (K < N) generate --If in actual range
	begin
		XNORTable(K) <= A(K) xnor B(K); --use natural
	end generate EquiAboveGenLess;
	
	EquiAboveGenGrEq : if (K >= N) generate --If above actual range
	begin
		XNORTable(K) <= '1'; --use padding
	end generate EquiAboveGenGrEq;
	
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
end generate EquiAboveGen;

AETGen0 : for K in 0 to (N/16) generate
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
						EquiAbove(K*16) <= ANDTable4(K);
					end generate AETIFGen1;
					AETIFGen2 : if ((J=1) or (H=1) or (G=1) or (L=1)) generate
					begin
						EquiAbove(K*16+J*8+H*4+G*2+L) <= (((XNORTable(K*16+J*8+H*4+G*2+L) and ANDTable1(K*8+J*4+H*2+G+L)) and 
																	(((not IndexR(G)) and (not IndexR(L)) and ANDTable2(K*4+J*2+H)) or ((IndexR(G) or IndexR(L)) and ANDTable2(K*4+J*2+H+1)))) and 
																	((((not IndexR(H)) and (not IndexR(G)) and (not IndexR(L)) and ANDTable3(K*2+J)) or (((IndexR(H)) or (IndexR(G)) or (IndexR(L))) and ANDTable3(K*2+J+1))) and ANDTable4(K+1)));
					end generate AETIFGen2;
				end generate AETGen4;
			end generate AETGen3;
		end generate AETGen2;
	end generate AETGen1;
end generate AETGen0;

E <= EquiAbove(0);

--The above generates the EquiAbove vector to hand to the inner cell which calls itself recursively,
--to prevent the inner cell from generating an entire equality check structure for each bit length
GFII : GENERIC_FAP_INEQUALITY_INNER
	 Generic map (N => N)
    Port map (A => A, 
				  B => B,
				  EquiAbove => EquiAbove(N-1 downto 0),
				  G => G);

end Behavioral;


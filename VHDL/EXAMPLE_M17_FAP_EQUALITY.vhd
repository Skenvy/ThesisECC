----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:51:10 05/07/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_FAP_EQUALITY - Behavioral 
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

entity EXAMPLE_M17_FAP_EQUALITY is
    Port ( A : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           B : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           Equal : out  STD_LOGIC);
end EXAMPLE_M17_FAP_EQUALITY;

architecture Behavioral of EXAMPLE_M17_FAP_EQUALITY is

signal XNORTable : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ANDTable1 : STD_LOGIC_VECTOR ((VecLen/2 -1) downto 0);
signal ANDTable2 : STD_LOGIC_VECTOR ((VecLen/4 -1) downto 0);
signal ANDTable3 : STD_LOGIC_VECTOR ((VecLen/8 -1) downto 0);
signal ANDTable4 : STD_LOGIC_VECTOR ((VecLen/16 -1) downto 0);

begin

XORGen : for K in 0 to (VecLen - 1) generate
begin
	XNORTable(K) <= A(K) xnor B(K);
end generate XORGen;

AND1Gen : for K in 0 to (VecLen/2 - 1) generate
begin
	ANDTable1(K) <= XNORTable(2*K) and XNORTable(2*K+1);
end generate AND1Gen;

AND2Gen : for K in 0 to (VecLen/4 - 1) generate
begin
	ANDTable2(K) <= ANDTable1(2*K) and ANDTable1(2*K+1);
end generate AND2Gen;

AND3Gen : for K in 0 to (VecLen/8 - 1) generate
begin
	ANDTable3(K) <= ANDTable2(2*K) and ANDTable2(2*K+1);
end generate AND3Gen;

ANDTable4(0) <= ANDTable3(0) and ANDTable3(1);
AND4Gen : for K in 1 to (VecLen/16 - 1) generate
begin
	ANDTable4(K) <= ANDTable3(2*K) and ANDTable3(2*K+1) and ANDTable4(K-1);
end generate AND4Gen;

Equal <= ANDTable4(VecLen/16 - 1);

end Behavioral;


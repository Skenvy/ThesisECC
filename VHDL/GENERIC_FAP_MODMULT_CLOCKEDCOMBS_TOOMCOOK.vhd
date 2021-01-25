----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:41 05/25/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK - Behavioral 
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

entity GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK is
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK;

architecture Behavioral of GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK is

component GENERIC_FAP_MODMULT_MULTCOMB_TOOMCOOKwCLOCK
	 Generic (N : Natural;
				 M : Natural;
				 AddrDelay : Time);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
			  CLK : in STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end component;

component GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
	 Generic (N : Natural;
				 M : Natural;
				 AddrDelay : Time);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
			  CLK : in STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end component;

component GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED
    Generic (N : Natural;
				 M : Natural;
				 CompDelay : Time);
    Port ( Dividend : in  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
           Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC;
           Remainder : out  STD_LOGIC_VECTOR ((N-1) downto 0);
           Quotient : out  STD_LOGIC_VECTOR ((N-1) downto 0);
			  StableOutput : out STD_LOGIC);
end component;

signal ProductofMultComb : STD_LOGIC_VECTOR (((2*N)-1) downto 0);
signal StableMultComb : STD_LOGIC;
signal StableDivdComb : STD_LOGIC;
signal StableTradeOver : STD_LOGIC;

begin

ToomGen : if (Toomed) generate
begin
	MULTCELL : GENERIC_FAP_MODMULT_MULTCOMB_TOOMCOOKwCLOCK
		Generic Map (N => N,
						 M => M,
						 AddrDelay => AddrDelay)
		Port Map ( MultiplicandA => MultiplicandA,
					  MultiplicandB => MultiplicandB,
				     Product => ProductofMultComb,
				     CLK => CLK,
				     StableOutput => StableMultComb);
end generate ToomGen;

NotToomGen : if (not Toomed) generate
begin
	MULTCELL : GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
		Generic Map (N => N,
						 M => M,
						 AddrDelay => AddrDelay)
		Port Map ( MultiplicandA => MultiplicandA,
					  MultiplicandB => MultiplicandB,
				     Product => ProductofMultComb,
				     CLK => CLK,
				     StableOutput => StableMultComb);
end generate NotToomGen;

DIVDCELL : GENERIC_FAP_MODMULT_DIVDCOMB_CLOCKED
	Generic Map (N => N,
					 M => M,
					 CompDelay => CompDelay)
	Port Map ( Dividend => ProductofMultComb,
				  Modulus => Modulus,
				  CLK => CLK,
				  Remainder => Product,
				  Quotient => open,
				  StableOutput => StableDivdComb);

process(CLK)
begin
	if(rising_edge(CLK)) then
		if ((StableTradeOver and StableDivdComb and StableMultComb) = '1') then
			StableOutput <= '1';
		else
			StableTradeOver <= (StableDivdComb and StableMultComb);
			StableOutput <= '0';
		end if;
	end if;
end process;

end Behavioral;


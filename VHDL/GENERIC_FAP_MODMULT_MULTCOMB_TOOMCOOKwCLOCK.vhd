----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:17:16 05/25/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_MULTCOMB_TOOMCOOKwCLOCK - Behavioral 
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

entity GENERIC_FAP_MODMULT_MULTCOMB_TOOMCOOKwCLOCK is
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
			  CLK : in STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_FAP_MODMULT_MULTCOMB_TOOMCOOKwCLOCK;

architecture Behavioral of GENERIC_FAP_MODMULT_MULTCOMB_TOOMCOOKwCLOCK is

component GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0);
			  CLK : in STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end component;

component GENERIC_FAP_LINADDRMUX
	 Generic (N : natural;
				 M : natural := MultLen); --Terminal Length
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           S : out  STD_LOGIC_VECTOR (N downto 0));
end component;

--Used in splitting length calculations.
signal ProductLALB : STD_LOGIC_VECTOR((2*(N/2)-1) downto 0);
signal ProductMAMB : STD_LOGIC_VECTOR((2*(N-(N/2))-1) downto 0);
signal ProductLAMB : STD_LOGIC_VECTOR((2*(N-(N/2))-1) downto 0);
signal ProductMALB : STD_LOGIC_VECTOR((2*(N-(N/2))-1) downto 0);
signal LowerAPadded : STD_LOGIC_VECTOR(((N-(N/2))-1) downto 0);
signal LowerBPadded : STD_LOGIC_VECTOR(((N-(N/2))-1) downto 0);
signal ProductLALBconcatMAMB : STD_LOGIC_VECTOR(((2*N)-1) downto 0);
signal AddrLMandMLPadded : STD_LOGIC_VECTOR(((2*N)-1) downto 0);
signal AddrLMandML : STD_LOGIC_VECTOR((2*(N-(N/2))) downto 0);
constant Padding : STD_LOGIC_VECTOR(((2*N)-1) downto 0) := (others => '0');
signal ProductInternal : STD_LOGIC_VECTOR((2*N) downto 0);
signal stableMults : STD_LOGIC_VECTOR(3 downto 0);

begin

StableOutput <= stableMults(0) and stableMults(1) and stableMults(2) and stableMults(3);

--Multiply the lower half of A with the lower half of B
SplittingTCMultLALB : GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
	Generic Map (N => (N/2),
					 M => M,
					 AddrDelay => AddrDelay)
	Port Map ( MultiplicandA => MultiplicandA(((N/2)-1) downto 0),
				  MultiplicandB => MultiplicandB(((N/2)-1) downto 0),
				  Product => ProductLALB,
				  CLK => CLK,
				  StableOutput => stableMults(0));
--Multiply the upper half of A with the upper half of B
SplittingTCMultMAMB : GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
	Generic Map (N => (N-(N/2)),
					 M => M,
					 AddrDelay => AddrDelay)
	Port Map ( MultiplicandA => MultiplicandA((N-1) downto (N/2)),
				  MultiplicandB => MultiplicandB((N-1) downto (N/2)),
				  Product => ProductMAMB,
				  CLK => CLK,
				  StableOutput => stableMults(1)); --(2*(N-(N/2)) in size
--Concatenate the result of multiplying the two top halves and the two bottom halves.
ProductLALBconcatMAMB <= ProductMAMB & ProductLALB;
--Establish inputs to the Toom-Cook Mults: When N is even, copy the natural lengthed lower halves which is the same as the natural lengthed upper halves.
SplittingTCIfNEven : if ((N mod 2) = 0) generate
begin
	LowerAPadded <= MultiplicandA(((N/2)-1) downto 0);
	LowerBPadded <= MultiplicandB(((N/2)-1) downto 0);
end generate SplittingTCIfNEven;
--Establish inputs to the Toom-Cook Mults: When N is odd, copy the natural lengthed lower halves, padded to the natural lengthed upper halves.
SplittingTCIfNOdd : if ((N mod 2) = 1) generate
begin
	LowerAPadded <= ('0' & MultiplicandA(((N/2)-1) downto 0));
	LowerBPadded <= ('0' & MultiplicandB(((N/2)-1) downto 0));
end generate SplittingTCIfNOdd;
--Multiply the lower half of A with the upper half of B
SplittingTCMultLAMB : GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
	Generic Map (N => (N-(N/2)),
					 M => M,
					 AddrDelay => AddrDelay)
	Port Map ( MultiplicandA => LowerAPadded,
				  MultiplicandB => MultiplicandB((N-1) downto (N/2)),
				  Product => ProductLAMB,
				  CLK => CLK,
				  StableOutput => stableMults(2)); --(2*(N-(N/2)) in size
--Multiply the upper half of A with the lower half of B
SplittingTCMultMALB : GENERIC_FAP_MODMULT_MULTCOMB_CLOCKED
	Generic Map (N => (N-(N/2)),
					 M => M,
					 AddrDelay => AddrDelay)
	Port Map ( MultiplicandA => MultiplicandA((N-1) downto (N/2)),
				  MultiplicandB => LowerBPadded,
				  Product => ProductMALB,
				  CLK => CLK,
				  StableOutput => stableMults(3)); --(2*(N-(N/2)) in size
--Do the additions on each of the padded halves piecewise
SplittingTCAddrMMandML : GENERIC_FAP_LINADDRMUX
	Generic Map (N => (2*(N-(N/2))), M => M)
	Port Map (A => ProductMALB, 
				 B => ProductLAMB, 
				 S => AddrLMandML);
AddrLMandMLPadded <= Padding(((2*N)-1) downto ((N/2)+(2*(N-(N/2)))+1)) & AddrLMandML & Padding(((N/2)-1) downto 0);
--Do the total addition overall for the whole thing.
SplittingTCAddrLLandLMandMLandMM : GENERIC_FAP_LINADDRMUX
	Generic Map (N => 2*N, M => M)
	Port Map (A => ProductLALBconcatMAMB, 
				 B => AddrLMandMLPadded, 
				 S => ProductInternal);
--Put the lengthed Product on the output.
Product <= ProductInternal((2*N-1) downto 0);

end Behavioral;


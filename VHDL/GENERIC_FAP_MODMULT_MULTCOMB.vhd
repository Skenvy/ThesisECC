----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:55 05/17/2017 
-- Design Name: 
-- Module Name:    GENERIC_FAP_MODMULT_MULTCOMB - Behavioral 
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

entity GENERIC_FAP_MODMULT_MULTCOMB is
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen;
				 T : Natural := 2); --TYPE CASTS: 0: Does concatenated addition only, 1 (default) Karatsuba-Ofman reuction, 2 Toom-Cook reduction, 3 Mixed KS on TC, 4 Mixed TC on KS
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0));
end GENERIC_FAP_MODMULT_MULTCOMB;

architecture Behavioral of GENERIC_FAP_MODMULT_MULTCOMB is

component GENERIC_FAP_MODMULT_MULTCOMB
	 Generic (N : Natural := VecLen;
				 M : Natural := MultLen;
				 T : Natural := 1);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR (((2*N)-1) downto 0));
end component;

component GENERIC_FAP_LINADDRMUX
	 Generic (N : natural;
				 M : natural);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           S : out  STD_LOGIC_VECTOR (N downto 0));
end component;

component GENERIC_2SCOMPLIMENT
	 Generic (N : natural);
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           C : out  STD_LOGIC_VECTOR ((N-1) downto 0));
end component;

--Used in Terminal Length Calculations
signal ClipATerminalLength : STD_LOGIC_VECTOR((M-1) downto 0);
signal ClipBTerminalLength : STD_LOGIC_VECTOR((M-1) downto 0);
signal ClipPTerminalLength : STD_LOGIC_VECTOR(((2*M)-1) downto 0);
type AndArray is array ((M-1) downto 0) of STD_LOGIC_VECTOR((M-1) downto 0);
signal AndArr : AndArray;
type AddrArray is array ((M-2) downto 0) of STD_LOGIC_VECTOR(M downto 0);
signal AddrArr : AddrArray;

--Used in splitting length calculations.
signal ProductLALB : STD_LOGIC_VECTOR((2*(N/2)-1) downto 0);
signal ProductMAMB : STD_LOGIC_VECTOR((2*(N-(N/2))-1) downto 0);
signal ProductLAMB : STD_LOGIC_VECTOR((2*(N-(N/2))-1) downto 0);
signal ProductMALB : STD_LOGIC_VECTOR((2*(N-(N/2))-1) downto 0);
signal LowerAPadded : STD_LOGIC_VECTOR(((N-(N/2))-1) downto 0);
signal LowerBPadded : STD_LOGIC_VECTOR(((N-(N/2))-1) downto 0);
--TC
signal AddrLMandML : STD_LOGIC_VECTOR((2*(N-(N/2))) downto 0);
signal AddrLMandMLPadded : STD_LOGIC_VECTOR(((2*N)-1) downto 0);
--KO
signal AdditionLAMA : STD_LOGIC_VECTOR((N-(N/2)) downto 0);
signal AdditionLBMB : STD_LOGIC_VECTOR((N-(N/2)) downto 0);
signal AdditionLLMM : STD_LOGIC_VECTOR((2*(N-(N/2))) downto 0);
signal AdditionLLMMInAPort : STD_LOGIC_VECTOR(((2*(N-(N/2)))-1) downto 0);
signal ProductLALBconcatMAMB : STD_LOGIC_VECTOR(((2*N)-1) downto 0);
signal ProductADDRLAMAandLBMB : STD_LOGIC_VECTOR(((2*(N-(N/2)+1))-1) downto 0);
signal ProductMixedDifferenceSubtrahend : STD_LOGIC_VECTOR((2*N-1) downto 0);
signal ProductMixedDifferenceSubtrahendInv : STD_LOGIC_VECTOR((2*N-1) downto 0);
signal ProductMixedDifference : STD_LOGIC_VECTOR(((2*(N-(N/2)+1))-1) downto 0);
signal ProductMixedDifferencePadded : STD_LOGIC_VECTOR(((2*N)-1) downto 0);
constant Padding : STD_LOGIC_VECTOR(((2*N)-1) downto 0) := (others => '0');
signal ProductLLMMLMLM : STD_LOGIC_VECTOR((2*N) downto 0);
signal ProductInternal : STD_LOGIC_VECTOR((2*N) downto 0);
constant CappedModulus : STD_LOGIC_VECTOR((2*N-1) downto 0) := (others => '1'); 

begin

TerminalGenNoReduction : if (T = 0) generate
begin
	--If T is 0 then put all the inputs onto a port map that maps M to N and 
	--changes T such that this calls the TerminalGenReduction on the whole length
	TerminalMultNoReductionPortal : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => N,
						 M => N,
						 T => 1)
		Port Map ( MultiplicandA => MultiplicandA,
					  MultiplicandB => MultiplicandB,
					  Product => Product);
end generate TerminalGenNoReduction;

TerminalGenReduction : if ((N <= M) and ((T = 1) or (T = 2) or (T = 3) or (T = 4))) generate
begin
	--
	ClipToLengthUpTo : for K in 0 to (N-1) generate
	begin
		ClipATerminalLength(K) <= MultiplicandA(K);
		ClipBTerminalLength(K) <= MultiplicandB(K);
	end generate ClipToLengthUpTo;
	ClipToLengthUpFrom : for K in N to (M-1) generate
	begin
		ClipATerminalLength(K) <= '0';
		ClipBTerminalLength(K) <= '0';
	end generate ClipToLengthUpFrom;
	--
	AndArrGenK : for K in 0 to (M-1) generate
	begin
		AndArrGenJ : for J in 0 to (M-1) generate
		begin
			AndArr(K)(J) <= ClipATerminalLength(K) and ClipBTerminalLength(J);
		end generate AndArrGenJ;
	end generate AndArrGenK;
	AddrArr(0) <= ('0' & AndArr(0));
	--
	TerminalAddrGen : for K in 0 to (M-3) generate
	begin
		TerminalAddrX : GENERIC_FAP_LINADDRMUX
			Generic Map (N => M, M => M)
			Port Map (A => AddrArr(K)(M downto 1),
						 B => AndArr(K+1),
						 S => AddrArr(K+1));
		ClipPTerminalLength(K) <= AddrArr(K)(0);
	end generate TerminalAddrGen;
	--
	ClipPTerminalLength(M-2) <= AddrArr(M-2)(0);
	--
	TerminalAddrFinal : GENERIC_FAP_LINADDRMUX
			Generic Map (N => M, M => M)
			Port Map (A => AddrArr(M-2)(M downto 1),
						 B => AndArr(M-1),
						 S => ClipPTerminalLength(((2*M)-1) downto M-1));
	--
	Product <= ClipPTerminalLength(((2*N)-1) downto 0);
end generate TerminalGenReduction;

SplittingGenKaratsubaOfman : if ((N > M) and (T = 1)) generate
begin
	--Multiply the lower half of A with the lower half of B
	SplittingKOMultLALB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N/2),
						 M => M,
						 T => T)
		Port Map ( MultiplicandA => MultiplicandA(((N/2)-1) downto 0),
					  MultiplicandB => MultiplicandB(((N/2)-1) downto 0),
					  Product => ProductLALB);
	--Multiply the upper half of A with the upper half of B
	SplittingKOMultMAMB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)),
						 M => M,
						 T => T)
		Port Map ( MultiplicandA => MultiplicandA((N-1) downto (N/2)),
					  MultiplicandB => MultiplicandB((N-1) downto (N/2)),
					  Product => ProductMAMB);
	--Concatenate the result of multiplying the two top halves and the two bottom halves.
	ProductLALBconcatMAMB <= ProductMAMB & ProductLALB;
	--Establish inputs to the Karatsuba Adders: When N is even, copy the natural lengthed lower halves which is the same as the natural lengthed upper halves.
	SplittingKOIfNEven : if ((N mod 2) = 0) generate
	begin
		LowerAPadded <= MultiplicandA(((N/2)-1) downto 0);
		LowerBPadded <= MultiplicandB(((N/2)-1) downto 0);
		AdditionLLMMInAPort <= ProductLALB;
	end generate SplittingKOIfNEven;
	--Establish inputs to the Karatsuba Adders: When N is odd, copy the natural lengthed lower halves, padded to the natural lengthed upper halves.
	SplittingKOIfNOdd : if ((N mod 2) = 1) generate
	begin
		LowerAPadded <= ('0' & MultiplicandA(((N/2)-1) downto 0));
		LowerBPadded <= ('0' & MultiplicandB(((N/2)-1) downto 0));
		AdditionLLMMInAPort <= ("00" & ProductLALB);
	end generate SplittingKOIfNOdd;
	--Add the upper half and lower half of A
	SplittingKOAddrAHALVES : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (N-(N/2)), M => M)
			Port Map (A => MultiplicandA((N-1) downto (N/2)),
						 B => LowerAPadded,
						 S => AdditionLAMA);
	--Add the upper half and lower half of B
	SplittingKOAddrBHALVES : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (N-(N/2)), M => M)
			Port Map (A => MultiplicandB((N-1) downto (N/2)),
						 B => LowerBPadded,
						 S => AdditionLBMB);
	--Multiply these additions of the two halves each of A and B.
	SplittingKOMultADDRHALVES : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)+1),
						 M => M,
						 T => T)
		Port Map ( MultiplicandA => AdditionLAMA,
					  MultiplicandB => AdditionLBMB,
					  Product => ProductADDRLAMAandLBMB);
	--Add together the result of multiplying the lower halves and the upper halves each by themselves.
	SplittingAddrLLandMM : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (2*(N-(N/2))), M => M)
			Port Map (A => AdditionLLMMInAPort,
						 B => ProductMAMB,
						 S => AdditionLLMM);
	--Pad the length of the results of the previous addition and multiplication to be at their appropriate bit locations.
	ProductMixedDifferencePadded <= Padding((2*N-1) downto ((N/2)+(2*(N-(N/2)+1)))) & ProductADDRLAMAandLBMB & Padding(((N/2)-1) downto 0);
	ProductMixedDifferenceSubtrahend <= (Padding((2*N-1) downto ((N/2)+(2*(N-(N/2))+1))) & AdditionLLMM & Padding(((N/2)-1) downto 0));
	--Add the result of the concatenated upper and lower multiples with the result of multiplying the upper and lower halves added to each other.
	SplittingKOAddrLALBMAMBandLAMALBMB : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (2*N), M => M)
			Port Map (A => ProductLALBconcatMAMB,
						 B => ProductMixedDifferencePadded,
						 S => ProductLLMMLMLM);
	--Take the additive inverse of the sum of the lower and upper multiples
	InverterKO : GENERIC_2SCOMPLIMENT
			Generic Map (N => (2*N))
			Port Map (A => ProductMixedDifferenceSubtrahend,
						 C => ProductMixedDifferenceSubtrahendInv);
	--Add (Subtract) this inverse of the sum of the lower and upper multiples from the result 
	--of the concatenation added with the multiple of the upper and lower halves multiplying each other.
	SplittingKOSubtADDRHALVESbyLLandMM : GENERIC_FAP_LINADDRMUX
		Generic Map (N => (2*N), M => M)
		Port Map (A => ProductLLMMLMLM(((2*N)-1) downto 0),
					 B => ProductMixedDifferenceSubtrahendInv,
					 S => ProductInternal);
	--Put the lengthed Product on the output.
	Product <= ProductInternal((2*N-1) downto 0);
end generate SplittingGenKaratsubaOfman;

SplittingGenToomCook : if ((N > M) and (T = 2)) generate
begin
	--Multiply the lower half of A with the lower half of B
	SplittingTCMultLALB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N/2),
						 M => M,
						 T => T)
		Port Map ( MultiplicandA => MultiplicandA(((N/2)-1) downto 0),
					  MultiplicandB => MultiplicandB(((N/2)-1) downto 0),
					  Product => ProductLALB);
	--Multiply the upper half of A with the upper half of B
	SplittingTCMultMAMB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)),
						 M => M,
						 T => T)
		Port Map ( MultiplicandA => MultiplicandA((N-1) downto (N/2)),
					  MultiplicandB => MultiplicandB((N-1) downto (N/2)),
					  Product => ProductMAMB); --(2*(N-(N/2)) in size
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
	SplittingTCMultLAMB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)),
						 M => M,
						 T => T)
		Port Map ( MultiplicandA => LowerAPadded,
					  MultiplicandB => MultiplicandB((N-1) downto (N/2)),
					  Product => ProductLAMB); --(2*(N-(N/2)) in size
	--Multiply the upper half of A with the lower half of B
	SplittingTCMultMALB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)),
						 M => M,
						 T => T)
		Port Map ( MultiplicandA => MultiplicandA((N-1) downto (N/2)),
					  MultiplicandB => LowerBPadded,
					  Product => ProductMALB); --(2*(N-(N/2)) in size
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
end generate SplittingGenToomCook;

SplittingGenMixedKSEdgesTCMiddle : if ((N > M) and (T = 3)) generate
begin
	--Multiply the lower half of A with the lower half of B
	SplittingKOMultLALB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N/2),
						 M => M,
						 T => 1)
		Port Map ( MultiplicandA => MultiplicandA(((N/2)-1) downto 0),
					  MultiplicandB => MultiplicandB(((N/2)-1) downto 0),
					  Product => ProductLALB);
	--Multiply the upper half of A with the upper half of B
	SplittingKOMultMAMB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)),
						 M => M,
						 T => 1)
		Port Map ( MultiplicandA => MultiplicandA((N-1) downto (N/2)),
					  MultiplicandB => MultiplicandB((N-1) downto (N/2)),
					  Product => ProductMAMB);
	--Concatenate the result of multiplying the two top halves and the two bottom halves.
	ProductLALBconcatMAMB <= ProductMAMB & ProductLALB;
	--Establish inputs to the Karatsuba Adders: When N is even, copy the natural lengthed lower halves which is the same as the natural lengthed upper halves.
	SplittingKOIfNEven : if ((N mod 2) = 0) generate
	begin
		LowerAPadded <= MultiplicandA(((N/2)-1) downto 0);
		LowerBPadded <= MultiplicandB(((N/2)-1) downto 0);
		AdditionLLMMInAPort <= ProductLALB;
	end generate SplittingKOIfNEven;
	--Establish inputs to the Karatsuba Adders: When N is odd, copy the natural lengthed lower halves, padded to the natural lengthed upper halves.
	SplittingKOIfNOdd : if ((N mod 2) = 1) generate
	begin
		LowerAPadded <= ('0' & MultiplicandA(((N/2)-1) downto 0));
		LowerBPadded <= ('0' & MultiplicandB(((N/2)-1) downto 0));
		AdditionLLMMInAPort <= ("00" & ProductLALB);
	end generate SplittingKOIfNOdd;
	--Add the upper half and lower half of A
	SplittingKOAddrAHALVES : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (N-(N/2)), M => M)
			Port Map (A => MultiplicandA((N-1) downto (N/2)),
						 B => LowerAPadded,
						 S => AdditionLAMA);
	--Add the upper half and lower half of B
	SplittingKOAddrBHALVES : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (N-(N/2)), M => M)
			Port Map (A => MultiplicandB((N-1) downto (N/2)),
						 B => LowerBPadded,
						 S => AdditionLBMB);
	--Multiply these additions of the two halves each of A and B.
	SplittingKOMultADDRHALVES : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)+1),
						 M => M,
						 T => 2)
		Port Map ( MultiplicandA => AdditionLAMA,
					  MultiplicandB => AdditionLBMB,
					  Product => ProductADDRLAMAandLBMB);
	--Add together the result of multiplying the lower halves and the upper halves each by themselves.
	SplittingAddrLLandMM : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (2*(N-(N/2))), M => M)
			Port Map (A => AdditionLLMMInAPort,
						 B => ProductMAMB,
						 S => AdditionLLMM);
	--Pad the length of the results of the previous addition and multiplication to be at their appropriate bit locations.
	ProductMixedDifferencePadded <= Padding((2*N-1) downto ((N/2)+(2*(N-(N/2)+1)))) & ProductADDRLAMAandLBMB & Padding(((N/2)-1) downto 0);
	ProductMixedDifferenceSubtrahend <= (Padding((2*N-1) downto ((N/2)+(2*(N-(N/2))+1))) & AdditionLLMM & Padding(((N/2)-1) downto 0));
	--Add the result of the concatenated upper and lower multiples with the result of multiplying the upper and lower halves added to each other.
	SplittingKOAddrLALBMAMBandLAMALBMB : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (2*N), M => M)
			Port Map (A => ProductLALBconcatMAMB,
						 B => ProductMixedDifferencePadded,
						 S => ProductLLMMLMLM);
	--Take the additive inverse of the sum of the lower and upper multiples
	InverterKO : GENERIC_2SCOMPLIMENT
			Generic Map (N => (2*N))
			Port Map (A => ProductMixedDifferenceSubtrahend,
						 C => ProductMixedDifferenceSubtrahendInv);
	--Add (Subtract) this inverse of the sum of the lower and upper multiples from the result 
	--of the concatenation added with the multiple of the upper and lower halves multiplying each other.
	SplittingKOSubtADDRHALVESbyLLandMM : GENERIC_FAP_LINADDRMUX
		Generic Map (N => (2*N), M => M)
		Port Map (A => ProductLLMMLMLM(((2*N)-1) downto 0),
					 B => ProductMixedDifferenceSubtrahendInv,
					 S => ProductInternal);
	--Put the lengthed Product on the output.
	Product <= ProductInternal((2*N-1) downto 0);
end generate SplittingGenMixedKSEdgesTCMiddle;

SplittingGenMixedTCEdgesKSMiddle : if ((N > M) and (T = 4)) generate
begin
	--Multiply the lower half of A with the lower half of B
	SplittingKOMultLALB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N/2),
						 M => M,
						 T => 2)
		Port Map ( MultiplicandA => MultiplicandA(((N/2)-1) downto 0),
					  MultiplicandB => MultiplicandB(((N/2)-1) downto 0),
					  Product => ProductLALB);
	--Multiply the upper half of A with the upper half of B
	SplittingKOMultMAMB : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)),
						 M => M,
						 T => 2)
		Port Map ( MultiplicandA => MultiplicandA((N-1) downto (N/2)),
					  MultiplicandB => MultiplicandB((N-1) downto (N/2)),
					  Product => ProductMAMB);
	--Concatenate the result of multiplying the two top halves and the two bottom halves.
	ProductLALBconcatMAMB <= ProductMAMB & ProductLALB;
	--Establish inputs to the Karatsuba Adders: When N is even, copy the natural lengthed lower halves which is the same as the natural lengthed upper halves.
	SplittingKOIfNEven : if ((N mod 2) = 0) generate
	begin
		LowerAPadded <= MultiplicandA(((N/2)-1) downto 0);
		LowerBPadded <= MultiplicandB(((N/2)-1) downto 0);
		AdditionLLMMInAPort <= ProductLALB;
	end generate SplittingKOIfNEven;
	--Establish inputs to the Karatsuba Adders: When N is odd, copy the natural lengthed lower halves, padded to the natural lengthed upper halves.
	SplittingKOIfNOdd : if ((N mod 2) = 1) generate
	begin
		LowerAPadded <= ('0' & MultiplicandA(((N/2)-1) downto 0));
		LowerBPadded <= ('0' & MultiplicandB(((N/2)-1) downto 0));
		AdditionLLMMInAPort <= ("00" & ProductLALB);
	end generate SplittingKOIfNOdd;
	--Add the upper half and lower half of A
	SplittingKOAddrAHALVES : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (N-(N/2)), M => M)
			Port Map (A => MultiplicandA((N-1) downto (N/2)),
						 B => LowerAPadded,
						 S => AdditionLAMA);
	--Add the upper half and lower half of B
	SplittingKOAddrBHALVES : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (N-(N/2)), M => M)
			Port Map (A => MultiplicandB((N-1) downto (N/2)),
						 B => LowerBPadded,
						 S => AdditionLBMB);
	--Multiply these additions of the two halves each of A and B.
	SplittingKOMultADDRHALVES : GENERIC_FAP_MODMULT_MULTCOMB
		Generic Map (N => (N-(N/2)+1),
						 M => M,
						 T => 1)
		Port Map ( MultiplicandA => AdditionLAMA,
					  MultiplicandB => AdditionLBMB,
					  Product => ProductADDRLAMAandLBMB);
	--Add together the result of multiplying the lower halves and the upper halves each by themselves.
	SplittingAddrLLandMM : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (2*(N-(N/2))), M => M)
			Port Map (A => AdditionLLMMInAPort,
						 B => ProductMAMB,
						 S => AdditionLLMM);
	--Pad the length of the results of the previous addition and multiplication to be at their appropriate bit locations.
	ProductMixedDifferencePadded <= Padding((2*N-1) downto ((N/2)+(2*(N-(N/2)+1)))) & ProductADDRLAMAandLBMB & Padding(((N/2)-1) downto 0);
	ProductMixedDifferenceSubtrahend <= (Padding((2*N-1) downto ((N/2)+(2*(N-(N/2))+1))) & AdditionLLMM & Padding(((N/2)-1) downto 0));
	--Add the result of the concatenated upper and lower multiples with the result of multiplying the upper and lower halves added to each other.
	SplittingKOAddrLALBMAMBandLAMALBMB : GENERIC_FAP_LINADDRMUX
			Generic Map (N => (2*N), M => M)
			Port Map (A => ProductLALBconcatMAMB,
						 B => ProductMixedDifferencePadded,
						 S => ProductLLMMLMLM);
	--Take the additive inverse of the sum of the lower and upper multiples
	InverterKO : GENERIC_2SCOMPLIMENT
			Generic Map (N => (2*N))
			Port Map (A => ProductMixedDifferenceSubtrahend,
						 C => ProductMixedDifferenceSubtrahendInv);
	--Add (Subtract) this inverse of the sum of the lower and upper multiples from the result 
	--of the concatenation added with the multiple of the upper and lower halves multiplying each other.
	SplittingKOSubtADDRHALVESbyLLandMM : GENERIC_FAP_LINADDRMUX
		Generic Map (N => (2*N), M => M)
		Port Map (A => ProductLLMMLMLM(((2*N)-1) downto 0),
					 B => ProductMixedDifferenceSubtrahendInv,
					 S => ProductInternal);
	--Put the lengthed Product on the output.
	Product <= ProductInternal((2*N-1) downto 0);
end generate SplittingGenMixedTCEdgesKSMiddle;

end Behavioral;


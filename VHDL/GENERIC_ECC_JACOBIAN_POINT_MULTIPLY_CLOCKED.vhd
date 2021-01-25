----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:25:40 06/01/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED - Behavioral 
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

entity GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED is
	 Generic (NGen : natural := VecLen;
				 MGen : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( KEY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           JPX : in STD_LOGIC_VECTOR ((NGen-1) downto 0);
           JPY : in STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  JPZ : in STD_LOGIC_VECTOR ((NGen-1) downto 0);
           JQX : out STD_LOGIC_VECTOR ((NGen-1) downto 0);
           JQY : out STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  JQZ : out STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  ECC_A : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED;

architecture Behavioral of GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED is
    Generic (NGen : natural := VecLen;
				 MGen : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( AX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  ECC_A : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end component;

component GENERIC_ECC_JACOBIAN_POINT_ADDITION_CLOCKED is
    Generic (NGen : natural := VecLen;
				 MGen : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( AX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BX : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BY : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           BZ : in  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((NGen-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end component;

component GENERIC_FAP_RELATIONAL
	 Generic (N : Natural;
				 VType : Natural); --0 for just equality, 1 for Greater Than test : Default 1
    Port ( A : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           B : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           E : out  STD_LOGIC;
           G : out  STD_LOGIC);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--MemoryDataLine
signal MemDoublingX : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal MemDoublingY : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal MemDoublingZ : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal MemAddingX : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal MemAddingY : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal MemAddingZ : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal MemNonceX : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal MemNonceY : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal MemNonceZ : STD_LOGIC_VECTOR ((NGen-1) downto 0);
--Temporal Adder Inputs and Outputs for the port map
signal ADDRAX : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal ADDRAY : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal ADDRAZ : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal ADDRBX : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal ADDRBY : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal ADDRBZ : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal ADDRCX : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal ADDRCY : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal ADDRCZ : STD_LOGIC_VECTOR ((NGen-1) downto 0);
--Temporal Doubling Inputs and Outputs for the port map
signal DOUBAX : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal DOUBAY : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal DOUBAZ : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal DOUBCX : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal DOUBCY : STD_LOGIC_VECTOR ((NGen-1) downto 0);
signal DOUBCZ : STD_LOGIC_VECTOR ((NGen-1) downto 0);
--Used to hold the result of the 'stable' output
signal InternalJQX : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal InternalJQY : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal InternalJQZ : STD_LOGIC_VECTOR((NGen-1) downto 0);
--Used to control whether the stabalised outputs are displayed or not, turns to '1' when they are stable.
signal StableOutputInner : STD_LOGIC;
--Used to record the previous state of the input, to reflush and restart the procedure when new inputs are given
signal PreviousJPX : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal PreviousJPY : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal PreviousJPZ : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal PreviousKEY : STD_LOGIC_VECTOR((NGen-1) downto 0);
--Hold the index and used to check that the entirety of K has been realised
signal Jindex : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal JComplete : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal Jnext : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal CLKDBL : STD_LOGIC; --Used to offset the input to output timing for inputs to the addr and doub cells, to place inputs on them in one clock cycle and then continuously check the output stability in every following clock cycles
--Stability
signal StableADDR : STD_LOGIC;
signal StableDOUB : STD_LOGIC;
signal JPX_Stable : STD_LOGIC;
signal JPY_Stable : STD_LOGIC;
signal JPZ_Stable : STD_LOGIC;
signal KEY_Stable : STD_LOGIC;
signal J_Finished : STD_LOGIC;
signal Adding_Round : STD_LOGIC;
signal Adding_Round_Next : STD_LOGIC;
signal JK : STD_LOGIC_VECTOR((NGen-1) downto 0);
signal JKnext : STD_LOGIC_VECTOR((NGen-1) downto 0);

begin

------------------------------
-----Stability Check Port-----
------------------------------

JPXSTABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => JPX,
           B => PreviousJPX,
           E => JPX_Stable,
           G => open);
			  
JPYSTABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => JPY,
           B => PreviousJPY,
           E => JPY_Stable,
           G => open);
			  
JPZSTABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => JPZ,
           B => PreviousJPZ,
           E => JPZ_Stable,
           G => open);
			  
KSTABLE : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => KEY,
           B => PreviousKEY,
           E => KEY_Stable,
           G => open);
			  
--TERMEQUI : GENERIC_FAP_RELATIONAL
--	 Generic Map (N => NGen,
--				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
--    Port Map ( A => KEY,
--           B => JComplete,
--           E => J_Finished,
--           G => open);
			  
ADDRROUND : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => JK,
           B => ZeroVector,
           E => Adding_Round,
           G => open);
			  
ADDRROUNDNEXT : GENERIC_FAP_RELATIONAL
	 Generic Map (N => NGen,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => JKnext,
           B => ZeroVector,
           E => Adding_Round_Next,
           G => open);

-------------------------
-----Control Process-----
-------------------------

--Display the internnal outputs only when they are stable
OutGen : for K in 0 to (NGen-1) generate
begin	
	JQX(K) <= (InternalJQX(K) and StableOutputInner);
	JQY(K) <= (InternalJQY(K) and StableOutputInner);
	JQZ(K) <= (InternalJQZ(K) and StableOutputInner);
	ADDRAX(K) <= ((MemAddingX(K) and ((not Adding_Round) or (not Adding_Round_Next))) or (MemNonceX(K) and (Adding_Round and Adding_Round_Next)));
	ADDRAY(K) <= ((MemAddingY(K) and ((not Adding_Round) or (not Adding_Round_Next))) or (MemNonceY(K) and (Adding_Round and Adding_Round_Next)));
	ADDRAZ(K) <= ((MemAddingZ(K) and ((not Adding_Round) or (not Adding_Round_Next))) or (MemNonceZ(K) and (Adding_Round and Adding_Round_Next)));
end generate OutGen;

StableOutput <= StableOutputInner;

--Connecting the data bus lines of the ports.
ADDRBX <= MemDoublingX;
ADDRBY <= MemDoublingY;
ADDRBZ <= MemDoublingZ;
DOUBAX <= MemDoublingX;
DOUBAY <= MemDoublingY;
DOUBAZ <= MemDoublingZ;
JK <= (Jindex and KEY);
JKnext <= (Jnext and KEY);

process(CLK)
begin
	if	(rising_edge(CLK)) then
		if ((JPX_Stable and JPY_Stable and JPZ_Stable and KEY_Stable) = '1') then --If the Inputs are stable
			if (J_Finished = '1') then --If end condition met, put output
				InternalJQX <= MemAddingX;
				InternalJQY <= MemAddingY;
				InternalJQZ <= MemAddingZ;
				StableOutputInner <= '1';
			elsif (CLKDBL = '0') then
				CLKDBL <= '1';
			elsif ((StableADDR and StableDOUB) = '1') then --Else, if the cells are stable, do the update.
				if (Adding_Round = '0') then --if adding bit, then do the adding (zero from 'not' equal to the ZSeroVector)
					MemAddingX <= ADDRCX;
					MemAddingY <= ADDRCY;
					MemAddingZ <= ADDRCZ;
				else
					MemNonceX <= ADDRCX;
					MemNonceY <= ADDRCY;
					MemNonceZ <= ADDRCZ;
				end if; 
				--Do the doubling unambiguously.
				MemDoublingX <= DOUBCX;
				MemDoublingY <= DOUBCY;
				MemDoublingZ <= DOUBCZ;
				if (Jindex(NGen-1) = '1') then
					J_Finished <= '1';
				end if;
				Jindex <= Jindex((NGen-2) downto 0) & "0";
				Jnext <= Jnext((NGen-2) downto 0) & "0";
				JComplete <= (JComplete or JK);
				CLKDBL <= '0';
			end if;
		else --Else, reset the signals and begin updates again.
			--Stability Checkers
			PreviousJPX <= JPX;
			PreviousJPY <= JPY;
			PreviousJPZ <= JPZ;
			PreviousKEY <= KEY;
			StableOutputInner <= '0';
			--Inititialise N (Doubling Feedback) and Q (Adder Feedback) and the index
			MemDoublingX <= JPX;
			MemDoublingY <= JPY;
			MemDoublingZ <= JPZ;
			MemAddingX <= UnitVector;
			MemAddingY <= UnitVector;
			MemAddingZ <= ZeroVector;
			MemNonceX <= UnitVector;
			MemNonceY <= UnitVector;
			MemNonceZ <= ZeroVector;
			Jindex <= UnitVector;
			JComplete <= ZeroVector;
			Jnext <= UnitVector((NGen-2) downto 0) & "0";
			CLKDBL <= '0';
			J_Finished <= '0';
		end if;	
	end if;
end process;

--N ? P
--Q ? 0
--for i from 0 to m do
--   if di = 1 then
--       Q ? point_add(Q, N)
--   N ? point_double(N)
--return Q

--The adder cell
ADDR : GENERIC_ECC_JACOBIAN_POINT_ADDITION_CLOCKED
    Generic Map (NGen => NGen,
					  MGen => MGen,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( AX => ADDRAX,
					AY => ADDRAY,
					AZ => ADDRAZ,
					BX => ADDRBX,
					BY => ADDRBY,
					BZ => ADDRBZ,
					CX => ADDRCX,
					CY => ADDRCY,
					CZ => ADDRCZ,
					Modulus => Modulus,
					CLK => CLK,
					StableOutput => StableADDR);

--The doubling cell
DOUB : GENERIC_ECC_JACOBIAN_POINT_DOUBLE_CLOCKED
    Generic Map (NGen => NGen,
					  MGen => MGen,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( AX => DOUBAX,
					AY => DOUBAY,
					AZ => DOUBAZ,
					CX => DOUBCX,
					CY => DOUBCY,
					CZ => DOUBCZ,
					Modulus => Modulus,
					ECC_A => ECC_A,
					CLK => CLK,
					StableOutput => StableDOUB);

end Behavioral;


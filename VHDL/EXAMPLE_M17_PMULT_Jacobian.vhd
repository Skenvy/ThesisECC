----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:35:28 03/30/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_M17_PMULT_Jacobian - Behavioral 
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

entity EXAMPLE_M17_PMULT_Jacobian is
    Port ( k : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           JPX : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           JPY : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  JPZ : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           JQX : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           JQY : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  JQZ : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  CLK : IN STD_LOGIC);
end EXAMPLE_M17_PMULT_Jacobian;

architecture Behavioral of EXAMPLE_M17_PMULT_Jacobian is

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

component EXAMPLE_M17_ECCPDJ2J is
    Port ( AX : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  CLK : IN STD_LOGIC);
end component;

component EXAMPLE_M17_ECCPAJ1J2J is
    Port ( AX : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           AY : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           AZ : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           BX : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           BY : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           BZ : in  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CX : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CY : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
           CZ : out  STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
			  CLK : IN STD_LOGIC);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--MemoryDataLine
signal MemDoublingX : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal MemDoublingY : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal MemDoublingZ : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal MemAddingX : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal MemAddingY : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal MemAddingZ : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
--Temporal Adder Inputs and Outputs for the port map
signal ADDRAX : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ADDRAY : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ADDRAZ : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ADDRBX : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ADDRBY : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ADDRBZ : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ADDRCX : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ADDRCY : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal ADDRCZ : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
--Temporal Doubling Inputs and Outputs for the port map
signal DOUBAX : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal DOUBAY : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal DOUBAZ : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal DOUBCX : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal DOUBCY : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
signal DOUBCZ : STD_LOGIC_VECTOR ((VecLen - 1) downto 0);
--Used to hold the result of the 'stable' output
signal InternalJQX : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
signal InternalJQY : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
signal InternalJQZ : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
--Used to control whether the stabalised outputs are displayed or not, turns to '1' when they are stable.
signal StableOutput : STD_LOGIC;
--Used to record the previous state of the input, to reflush and restart the procedure when new inputs are given
signal PreviousJPX : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
signal PreviousJPY : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
signal PreviousJPZ : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
signal PreviousK : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
--Hold the index and used to check that the entirety of K has been realised
signal Jindex : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
signal JComplete : STD_LOGIC_VECTOR((VecLen - 1) downto 0);
signal CLKDBL : STD_LOGIC; --Used to offset the input to output timing for inputs to the addr and doub cells, to place inputs on them in one clock cycle and then continuously check the output stability in every following clock cycles

begin

--Display the internnal outputs only when they are stable
JQX <= InternalJQX when StableOutput = '1' else (others => 'Z');
JQY <= InternalJQY when StableOutput = '1' else (others => 'Z');
JQZ <= InternalJQZ when StableOutput = '1' else (others => 'Z');

--Connecting the data bus lines of the ports.
ADDRAX <= MemAddingX;
ADDRAY <= MemAddingY;
ADDRAZ <= MemAddingZ;
ADDRBX <= MemDoublingX;
ADDRBY <= MemDoublingY;
ADDRBZ <= MemDoublingZ;
DOUBAX <= MemDoublingX;
DOUBAY <= MemDoublingY;
DOUBAZ <= MemDoublingZ;

process(CLK)
begin
	if	(rising_edge(CLK)) then
		if ((PreviousJPX = JPX) and (PreviousJPY = JPY) and (PreviousJPZ = JPZ) and (PreviousK = K)) then --If the Inputs are stable
			if (JComplete = K) then --If end condition met, put output
				InternalJQX <= MemAddingX;
				InternalJQY <= MemAddingY;
				InternalJQZ <= MemAddingZ;
				StableOutput <= '1';
			elsif (CLKDBL = '0') then
				CLKDBL <= '1';
			elsif ((ADDRCX /= ImpedeVector) and (ADDRCY /= ImpedeVector) and (ADDRCZ /= ImpedeVector) and (DOUBCX /= ImpedeVector) and (DOUBCY /= ImpedeVector) and (DOUBCZ /= ImpedeVector)) then --Else, if the inputs are stable, do the update.
				if ((Jindex and K) /= ZeroVector) then --if adding bit, then do the adding
					MemAddingX <= ADDRCX;
					MemAddingY <= ADDRCY;
					MemAddingZ <= ADDRCZ;
				end if; --Do the doubling unambiguously.
				MemDoublingX <= DOUBCX;
				MemDoublingY <= DOUBCY;
				MemDoublingZ <= DOUBCZ;
				Jindex <= STD_LOGIC_VECTOR(shift_left(unsigned(Jindex),1));
				JComplete <= STD_LOGIC_VECTOR(unsigned(JComplete) + unsigned(JIndex and K));
				CLKDBL <= '0';
			end if;
		else --Else, reset the signals and begin updates again.
			--Stability Checkers
			PreviousJPX <= JPX;
			PreviousJPY <= JPY;
			PreviousJPZ <= JPZ;
			PreviousK <= K;
			StableOutput <= '0';
			--Inititialise N (Doubling Feedback) and Q (Adder Feedback) and the index
			MemDoublingX <= JPX;
			MemDoublingY <= JPY;
			MemDoublingZ <= JPZ;
			MemAddingX <= UnitVector;
			MemAddingY <= UnitVector;
			MemAddingZ <= ZeroVector;
			Jindex <= UnitVector;
			JComplete <= ZeroVector;
			CLKDBL <= '0';
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
ADDR : EXAMPLE_M17_ECCPAJ1J2J port map (AX => ADDRAX,
													 AY => ADDRAY,
													 AZ => ADDRAZ,
													 BX => ADDRBX,
													 BY => ADDRBY,
													 BZ => ADDRBZ,
													 CX => ADDRCX,
													 CY => ADDRCY,
													 CZ => ADDRCZ,
													 CLK => CLK);

--The doubling cell
DOUB : EXAMPLE_M17_ECCPDJ2J port map (AX => DOUBAX,
												  AY => DOUBAY,
												  AZ => DOUBAZ,
												  CX => DOUBCX,
												  CY => DOUBCY,
												  CZ => DOUBCZ,
												  CLK => CLK);


end Behavioral;


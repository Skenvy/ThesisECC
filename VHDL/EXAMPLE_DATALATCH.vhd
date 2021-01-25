----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:02 03/31/2017 
-- Design Name: 
-- Module Name:    EXAMPLE_DATALATCH - Behavioral 
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

entity EXAMPLE_DATALATCH is
	Port (Element : in  STD_LOGIC_VECTOR (4 downto 0);
			Inverse : out  STD_LOGIC_VECTOR (4 downto 0);
			CLK : in  STD_LOGIC);
end EXAMPLE_DATALATCH;

architecture Behavioral of EXAMPLE_DATALATCH is

signal ControlLoop : STD_LOGIC_VECTOR(4 downto 0);
signal StableInverse : STD_LOGIC;
signal InternalInverse : STD_LOGIC_VECTOR(4 downto 0);
signal PreviousElement : STD_LOGIC_VECTOR(4 downto 0);

begin

Inverse <= InternalInverse when StableInverse = '1' else (others => 'Z');

process(CLK)
begin
	if	(rising_edge(CLK)) then
		if ((ControlLoop = "11000") and (Element = PreviousElement) ) then --If end condition met and inputs are stable, put output
			InternalInverse <= ControlLoop;
			StableInverse <= '1';
		elsif (Element = PreviousElement) then --Else, if the inputs are stable, do the update.
			ControlLoop <= STD_LOGIC_VECTOR(unsigned(ControlLoop) + 1);
		else --Else, reset the signals and begin updates again.
			PreviousElement <= Element;
			ControlLoop <= Element;
			StableInverse <= '0';
		end if;	
	end if;
end process;

end Behavioral;


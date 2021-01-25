----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:08:49 06/04/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED - Behavioral 
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
use work.ECC_STANDARD.ALL;

entity GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED is
    Generic (N : natural := VecLen; --VecLen  must match Parameter Size
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false;
				 ParameterSet : ECC_Parameters_5 := M17); --Parameter Size must match VecLen
    Port ( KEY : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           AQX : out STD_LOGIC_VECTOR ((N-1) downto 0);
           AQY : out STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED;

architecture Behavioral of GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED_PARAMETERISED is

COMPONENT GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED
Generic (N : natural := VecLen;
			M : Natural := MultLen;
			AddrDelay : Time;
			CompDelay : Time;
			Toomed : Boolean);
Port ( KEY : in  STD_LOGIC_VECTOR ((N-1) downto 0);
       APX : in STD_LOGIC_VECTOR ((N-1) downto 0);
       APY : in STD_LOGIC_VECTOR ((N-1) downto 0);
       AQX : out STD_LOGIC_VECTOR ((N-1) downto 0);
       AQY : out STD_LOGIC_VECTOR ((N-1) downto 0);
		 Modulus : In  STD_LOGIC_VECTOR ((N-1) downto 0);
		 ECC_A : In  STD_LOGIC_VECTOR ((N-1) downto 0);
		 CLK : IN STD_LOGIC;
		 StableOutput : out STD_LOGIC);
END COMPONENT;

begin

CELL : GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED
	Generic Map (N => N,
			M => M,
			AddrDelay => AddrDelay,
			CompDelay => CompDelay,
			Toomed => Toomed)
	Port Map ( KEY => KEY,
       APX => ParameterSet(3),
       APY => ParameterSet(4),
       AQX => AQX,
       AQY => AQY,
		 Modulus => ParameterSet(0),
		 ECC_A => ParameterSet(1),
		 CLK => CLK,
		 StableOutput => StableOutput);

end Behavioral;


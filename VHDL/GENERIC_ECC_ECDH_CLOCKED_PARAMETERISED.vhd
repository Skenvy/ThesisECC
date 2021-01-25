----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:26:37 06/04/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED - Behavioral 
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

entity GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED is
    Generic (N : natural := VecLen; --VecLen  must match Parameter Size
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false;
				 ParameterSet : ECC_Parameters_5 := M17); --Parameter Size must match VecLen
    Port ( KEY_PRIVATE : in STD_LOGIC_VECTOR ((N-1) downto 0);
			  KEY_PUBLIC : in STD_LOGIC_VECTOR (((2*N)-1) downto 0);
           SHARED_SECRET : out STD_LOGIC_VECTOR (((2*N)-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED;

architecture Behavioral of GENERIC_ECC_ECDH_CLOCKED_PARAMETERISED is

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

signal KEY_PUBLIC_X : STD_LOGIC_VECTOR ((N-1) downto 0);
signal KEY_PUBLIC_Y : STD_LOGIC_VECTOR ((N-1) downto 0);
signal SHARED_SECRET_X : STD_LOGIC_VECTOR ((N-1) downto 0);
signal SHARED_SECRET_Y : STD_LOGIC_VECTOR ((N-1) downto 0);

begin

KEY_PUBLIC_X <= KEY_PUBLIC(((2*N)-1) downto N);
KEY_PUBLIC_Y <= KEY_PUBLIC((N-1) downto 0);
SHARED_SECRET <= SHARED_SECRET_X & SHARED_SECRET_Y;

CELL : GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED
	Generic Map (N => N,
			M => M,
			AddrDelay => AddrDelay,
			CompDelay => CompDelay,
			Toomed => Toomed)
	Port Map ( KEY => KEY_PRIVATE,
       APX => KEY_PUBLIC_X,
       APY => KEY_PUBLIC_Y,
       AQX => SHARED_SECRET_X,
       AQY => SHARED_SECRET_Y,
		 Modulus => ParameterSet(0),
		 ECC_A => ParameterSet(1),
		 CLK => CLK,
		 StableOutput => StableOutput);

end Behavioral;


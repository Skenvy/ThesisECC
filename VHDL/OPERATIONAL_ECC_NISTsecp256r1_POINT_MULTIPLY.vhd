----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:16:47 06/02/2017 
-- Design Name: 
-- Module Name:    OPERATIONAL_ECC_NISTsecp256r1_POINT_MULTIPLY - Behavioral 
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

entity OPERATIONAL_ECC_NISTsecp256r1_POINT_MULTIPLY is
    Generic (N : natural := VecLen;
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( KEY : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           AQX : out STD_LOGIC_VECTOR ((N-1) downto 0);
           AQY : out STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end OPERATIONAL_ECC_NISTsecp256r1_POINT_MULTIPLY;

architecture Behavioral of OPERATIONAL_ECC_NISTsecp256r1_POINT_MULTIPLY is

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

constant Modulus : STD_LOGIC_VECTOR ((N-1) downto 0) := Prime_NISTsecp256r1;
constant ECC_A : STD_LOGIC_VECTOR ((N-1) downto 0) := A_NISTsecp256r1;
constant ECC_GX : STD_LOGIC_VECTOR ((N-1) downto 0) := GX_NISTsecp256r1;
constant ECC_GY : STD_LOGIC_VECTOR ((N-1) downto 0) := GY_NISTsecp256r1;

begin

CELL : GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED
	Generic Map (N => N,
			M => M,
			AddrDelay => AddrDelay,
			CompDelay => CompDelay,
			Toomed => Toomed)
	Port Map ( KEY => KEY,
       APX => ECC_GX,
       APY => ECC_GY,
       AQX => AQX,
       AQY => AQY,
		 Modulus => Modulus,
		 ECC_A => ECC_A,
		 CLK => CLK,
		 StableOutput => StableOutput);

end Behavioral;


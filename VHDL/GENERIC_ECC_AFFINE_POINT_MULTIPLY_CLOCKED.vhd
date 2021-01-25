----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:24:03 06/01/2017 
-- Design Name: 
-- Module Name:    GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED - Behavioral 
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

entity GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED is
	 Generic (N : natural := VecLen;
				 M : Natural := MultLen;
				 AddrDelay : Time := 30 ns;
				 CompDelay : Time := 30 ns;
				 Toomed : Boolean := false);
    Port ( KEY : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           APX : in STD_LOGIC_VECTOR ((N-1) downto 0);
           APY : in STD_LOGIC_VECTOR ((N-1) downto 0);
           AQX : out STD_LOGIC_VECTOR ((N-1) downto 0);
           AQY : out STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((N-1) downto 0);
			  ECC_A : In  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED;

architecture Behavioral of GENERIC_ECC_AFFINE_POINT_MULTIPLY_CLOCKED is

component GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED
	 Generic (NGen : natural;
				 MGen : Natural;
				 AddrDelay : Time;
				 CompDelay : Time;
				 Toomed : Boolean);
    Port ( KEY : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           JPX : in STD_LOGIC_VECTOR ((N-1) downto 0);
           JPY : in STD_LOGIC_VECTOR ((N-1) downto 0);
			  JPZ : in STD_LOGIC_VECTOR ((N-1) downto 0);
           JQX : out STD_LOGIC_VECTOR ((N-1) downto 0);
           JQY : out STD_LOGIC_VECTOR ((N-1) downto 0);
			  JQZ : out STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : In  STD_LOGIC_VECTOR ((N-1) downto 0);
			  ECC_A : In  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : IN STD_LOGIC;
			  StableOutput : out STD_LOGIC);
end component;

component GENERIC_FAP_MODINVR_CLOCKED
	 Generic (N : natural := VecLen;
				 M : natural := MultLen;
				 AddrDelay : Time := 30 ns);
    Port ( Element : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           Inverse : out  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC);
end component;

component GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic (N : Natural;
				 M : Natural;
				 AddrDelay : Time;
				 CompDelay : Time;
				 Toomed : Boolean);
    Port ( MultiplicandA : in  STD_LOGIC_VECTOR ((N-1) downto 0);
           MultiplicandB : in  STD_LOGIC_VECTOR ((N-1) downto 0);
			  Modulus : in STD_LOGIC_VECTOR ((N-1) downto 0);
           Product : out  STD_LOGIC_VECTOR ((N-1) downto 0);
			  CLK : in STD_LOGIC;
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

signal Stability_JPM : STD_LOGIC;
signal JQX : STD_LOGIC_VECTOR((N-1) downto 0);
signal JQY : STD_LOGIC_VECTOR((N-1) downto 0);
signal JQZ : STD_LOGIC_VECTOR((N-1) downto 0);
signal Inverse : STD_LOGIC_VECTOR((N-1) downto 0);
signal InverseSquared : STD_LOGIC_VECTOR((N-1) downto 0);
signal InverseCubed : STD_LOGIC_VECTOR((N-1) downto 0);
signal Stability_Inverse : STD_LOGIC;
signal Stability_Squared : STD_LOGIC;
signal Stability_Cubed : STD_LOGIC;
signal Stability_AQX : STD_LOGIC;
signal Stability_AQY : STD_LOGIC;

begin

JPM : GENERIC_ECC_JACOBIAN_POINT_MULTIPLY_CLOCKED
	 Generic Map (NGen => N,
					  MGen => M,
					  AddrDelay => AddrDelay,
					  CompDelay => CompDelay,
					  Toomed => Toomed)
    Port Map (KEY => KEY,
				  JPX => APX,
				  JPY => APY,
				  JPZ => UnitVector,
				  JQX => JQX,
				  JQY => JQY,
				  JQZ => JQZ,
				  Modulus => Modulus,
				  ECC_A => ECC_A,
				  CLK => CLK,
				  StableOutput => Stability_JPM);

MODINV : GENERIC_FAP_MODINVR_CLOCKED
	 Generic Map (N => N,
					  M => M,
					  AddrDelay => AddrDelay)
    Port Map (Element => JQZ,
				  Inverse => Inverse,
				  Modulus => Modulus,
				  CLK => CLK);

INVISZERO : GENERIC_FAP_RELATIONAL
	 Generic Map (N => N,
				 VType => 0) --0 for just equality, 1 for Greater Than test : Default 1
    Port Map ( A => Inverse,
           B => ZeroVector,
           E => Stability_Inverse,
           G => open);

MULT_INV2 : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => N,
					  M => M,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => Inverse,
					MultiplicandB => Inverse,
					Modulus => Modulus,
					Product => InverseSquared,
					CLK => CLK,
					StableOutput => Stability_Squared);

MULT_INV3 : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => N,
					  M => M,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => InverseSquared,
					MultiplicandB => Inverse,
					Modulus => Modulus,
					Product => InverseCubed,
					CLK => CLK,
					StableOutput => Stability_Cubed);

MULT_AX : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => N,
					  M => M,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => JQX,
					MultiplicandB => InverseSquared,
					Modulus => Modulus,
					Product => AQX,
					CLK => CLK,
					StableOutput => Stability_AQX);

MULT_AY : GENERIC_FAP_MODMULT_CLOCKEDCOMBS_TOOMCOOK
	 Generic Map (N => N,
					  M => M,
				 	  AddrDelay => AddrDelay,
				 	  CompDelay => CompDelay,
				 	  Toomed => Toomed)
    Port Map ( MultiplicandA => JQY,
					MultiplicandB => InverseCubed,
					Modulus => Modulus,
					Product => AQY,
					CLK => CLK,
					StableOutput => Stability_AQY);

StableOutput <= ((Stability_JPM and (not Stability_Inverse) and Stability_Squared) and (Stability_Cubed and Stability_AQX and Stability_AQY));

end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:49:29 03/22/2017 
-- Design Name: 
-- Module Name:    STRUC_FAP_MOD_ADDR_RCA_NISTsecp256r1 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity STRUC_FAP_MOD_ADDR_RCA_NISTsecp256r1 is
    Port ( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
           SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
           Summation : out  STD_LOGIC_VECTOR (255 downto 0));
end STRUC_FAP_MOD_ADDR_RCA_NISTsecp256r1;

architecture Behavioral of STRUC_FAP_MOD_ADDR_RCA_NISTsecp256r1 is

--------------------------------
-----CONSTANTS DECLARATIONS-----
--------------------------------

--NIST-secp256r1-Prime
constant Prime : STD_LOGIC_VECTOR (255 downto 0) := X"FFFF_FFFF_0000_0001_0000_0000_0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF";
--The 2's Compliment of the NIST-secp256r1-Prime
constant PrimeInverse : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_FFFF_FFFE_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_0000_0000_0000_0000_0000_0001";
--A 256 bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR (255 downto 0) := X"0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";

--------------------------------
-----COMPONENT DECLARATIONS-----
--------------------------------

--256 Bit Adder
component STRUC_FAP_LIN_ADDR_RCA_256
	port( SummandA : in  STD_LOGIC_VECTOR (255 downto 0);
         SummandB : in  STD_LOGIC_VECTOR (255 downto 0);
         Summation : out  STD_LOGIC_VECTOR (256 downto 0) --(Summation = A+B, Cout in Sum(256))
		);
end component;

--256 bit "Greater Than" Check (Included as component for future implementation as a structural unit, currently implemented behaviourally)
component STRUC_UTIL_IsGreater_NISTsecp256r1
	port( InVal : in  STD_LOGIC_VECTOR (256 downto 0);
         IsGreater : out  STD_LOGIC --1 iff A > B, else 0
		);
end component;

--256 bit "Equal To" Check (Included as component for future implementation as a structural unit, currently implemented behaviourally)
component STRUC_UTIL_IsEqual_NISTsecp256r1
	port( InVal : in  STD_LOGIC_VECTOR (256 downto 0);
         IsEqual : out  STD_LOGIC --1 iff A = B, else 0
		);
end component;

-----------------------------
-----SIGNAL DECLARATIONS-----
-----------------------------

--Carries the Sum of A and B
signal AandB : STD_LOGIC_VECTOR (256 downto 0);
--Carries the result of Adding the Inverse of the Prime to AandB
signal AandBModP : STD_LOGIC_VECTOR (256 downto 0);
--Carries the output of the 'Is Greater' Component
signal AandBGreaterPrime : STD_LOGIC;
--Carries the output of the 'Is Equal' Component
signal AandBEqualPrime : STD_LOGIC;

begin

-----------------------------------------------------------------------------------------------
-------------------------------------------PORT MAPS-------------------------------------------
-----------------------------------------------------------------------------------------------

--Determines whether the sum of A and B is equal to the Prime.
UTIL_IsEqual : STRUC_UTIL_IsEqual_NISTsecp256r1 port map (InVal(256 downto 0) => AandB(256 downto 0),
																			 IsEqual => AandBEqualPrime);

--Determines whether the sum of A and B is greater than the Prime.
UTIL_IsGreater : STRUC_UTIL_IsGreater_NISTsecp256r1 port map (InVal(256 downto 0) => AandB(256 downto 0),
																					 IsGreater => AandBGreaterPrime);

---------------------------
--256 Bit Adder Port Maps--
---------------------------

--Sums the inputs A and B, will be the output if AandB is neither equal to or greater than the Prime.
ADDR256_AandB : STRUC_FAP_LIN_ADDR_RCA_256 port map (SummandA(255 downto 0) => SummandA(255 downto 0), 
													SummandB(255 downto 0) => SummandB(255 downto 0), 
													Summation(256 downto 0) => AandB(256 downto 0));

--Sums the AandB with the inverse of the Prime. Will be the output iff AandB is greater than the Prime.
ADDR256_AandBModP : STRUC_FAP_LIN_ADDR_RCA_256 port map (SummandA(255 downto 0) => AandB(255 downto 0), 
														 SummandB(255 downto 0) => PrimeInverse, 
														 Summation(256 downto 0) => AandBModP(256 downto 0));

-----------------------------------------------------------------------------------------------
-----------------------------------------END PORT MAPS-----------------------------------------
-----------------------------------------------------------------------------------------------

SummationGenerate : for k in 0 to 255 generate
begin 
	Summation(k) <= ((AandBModP(k) and AandBGreaterPrime) or (AandB(k) and (not AandBGreaterPrime) and (not AandBEqualPrime)));
end generate SummationGenerate;

end Behavioral;


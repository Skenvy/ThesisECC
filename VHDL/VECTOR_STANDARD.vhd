--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

--A change file that declares basic vectors, up to a specific length
package VECTOR_STANDARD is

--Change this to define the standard length used
constant VecLen : natural := 192;
--A VecLen bit vector populated by only zeroes
constant ZeroVector : STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := (others => '0');
--A VecLen bit vector populated by only zeroes except the first bit
constant UnitVector : STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := (0 => '1', others => '0');
--A VecLen bit vector populated by only 'Z's, to drive a high impedence.
constant ImpedeVector : STD_LOGIC_VECTOR ((VecLen - 1) downto 0) := (others => 'Z');
--Used in determining the terminal length of multipliers.
constant MultLen : natural := 192;

end VECTOR_STANDARD;

package body VECTOR_STANDARD is
 
end VECTOR_STANDARD;

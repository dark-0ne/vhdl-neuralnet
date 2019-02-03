--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package utilities is
    type vector is array (natural range <>) of STD_LOGIC_VECTOR (15 downto 0); 
    function to_vec (slv: std_logic_vector) return vector;
     function to_slv (v: vector) return std_logic_vector;
end utilities;

package body utilities is

    function to_vec (slv: std_logic_vector) return vector is
    variable c : vector (0 to (slv'length/16)-1);
    begin
        for I in c'range loop
            c(I) := slv((I*16)+15 downto (I*16));
        end loop;
        return c;
    end function to_vec;
    
    function to_slv (v: vector) return std_logic_vector is
    variable slv : std_logic_vector ((v'length*16)-1 downto 0);
    begin
        for I in v'range loop
            slv((I*16)+15 downto (I*16)) := v(I);  
        end loop;
        return slv;
    end function to_slv;
end utilities; 
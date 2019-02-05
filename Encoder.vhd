----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:15:51 02/04/2019 
-- Design Name: 
-- Module Name:    Encoder - Structural 
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

entity Encoder is
	port (
		clk : in std_logic;
		neuron_vector : in std_logic_vector(9 downto 0);
		number_out : out std_logic_vector(3 downto 0)
	);
end Encoder;

architecture Structural of Encoder is

begin

	number_out <=   "1001" when neuron_vector(9) = '1' else
					"1000" when neuron_vector(8) = '1' else
					"0111" when neuron_vector(7) = '1' else
					"0110" when neuron_vector(6) = '1' else
					"0101" when neuron_vector(5) = '1' else
					"0100" when neuron_vector(4) = '1' else
					"0011" when neuron_vector(3) = '1' else
					"0010" when neuron_vector(2) = '1' else
					"0001" when neuron_vector(1) = '1' else
					"0000" when neuron_vector(0) = '1' else
					"1111";
					

end Structural;


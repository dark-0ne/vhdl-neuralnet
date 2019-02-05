----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:20:59 02/04/2019 
-- Design Name: 
-- Module Name:    comparator - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator is

	port (
		clk : in std_logic;
		neuron : in std_logic_vector(15 downto 0);
		bit_out : out std_logic
	);

end comparator;

architecture Structural of comparator is
	
	signal half : std_logic_vector(15 downto 0) := "0000100000000000";
begin
	
	bit_out  <= '1' when signed(neuron) >= signed(half) else '0';
	
	
end Structural;


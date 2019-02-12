----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:22:46 02/02/2019 
-- Design Name: 
-- Module Name:    sum_calculator - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- ----------------------------------------------------------------

entity sum_calculator is
	generic (
		ninputs : integer;
		iwidth  : integer;
		owidth  : integer
	);
	port (
		d      : in  std_logic_vector(ninputs*iwidth-1 downto 0);
		q      : out signed(owidth-1 downto 0)
	);
end entity;

-- ----------------------------------------------------------------

architecture Behavioral of sum_calculator is

	-- functions
	impure function din(i : integer) return signed is
	begin
		return signed(d((i+1)*iwidth-1 downto i*iwidth));
	end function;

	-- Constants

	constant NSTAGES : integer :=
		integer(ceil(log2(real(ninputs))));
	constant PWIDTH : integer := 2**NSTAGES;
	constant NSUMS : integer := PWIDTH-1;
	constant SWIDTH : integer := IWIDTH;

	-- Signals
	type sum_t is array (0 to NSUMS-1) of
		signed(SWIDTH-1 downto 0);
	signal sum    : sum_t;

begin
	process(d)
		variable prev_index : integer;
		variable curr_index : integer;
		variable num_sums   : integer;
	begin
			num_sums := PWIDTH/2;
			for j in 0 to num_sums-1 loop
				if (2*j+1 < NINPUTS) then
					sum(j) <=
						resize(din(2*j),   SWIDTH) +
						resize(din(2*j+1), SWIDTH);
				elsif (2*j < NINPUTS) then
					sum(j) <= resize(din(2*j), SWIDTH);
				end if;
			end loop;

			prev_index := 0;
			curr_index := num_sums;
			num_sums   := num_sums/2;
			for i in 1 to NSTAGES-1 loop
				for j in 0 to num_sums-1 loop
					sum(curr_index + j) <=
						sum(prev_index + 2*j) +
						sum(prev_index + 2*j + 1);
				end loop;

				prev_index := curr_index;
				curr_index := curr_index + num_sums;
				num_sums   := num_sums/2;
			end loop;
	end process;
	q <= sum(NSUMS-1)(OWIDTH-1 downto 0);

end architecture;

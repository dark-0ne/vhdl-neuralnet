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
		-- Number of inputs
		NINPUTS : integer;

		-- Input data width
		IWIDTH  : integer;

		-- Output data width
		-- * full-precision requires that
		--   OWIDTH = IWIDTH + ceil(log2(NINPUTS))
		OWIDTH  : integer
	);
	port (
		-- Reset and clock
		rstN   : in  std_logic;
		clk    : in  std_logic;

		-- Input data
		-- * NINPUTS x signed(IWIDTH-1 downto 0)
		d      : in  std_logic_vector(NINPUTS*IWIDTH-1 downto 0);

		-- Output data
		q      : out signed(OWIDTH-1 downto 0)
	);
end entity;

-- ----------------------------------------------------------------

architecture Behavioral of sum_calculator is

	-- ------------------------------------------------------------
	-- Local functions
	-- ------------------------------------------------------------
	--
	-- Input lookup and signed conversion
	impure function din(i : integer) return signed is
	begin
		return signed(d((i+1)*IWIDTH-1 downto i*IWIDTH));
	end function;

	-- ------------------------------------------------------------
	-- Constants
	-- ------------------------------------------------------------
	--
	-- Number of stages required to sum the inputs
	constant NSTAGES : integer :=
		integer(ceil(log2(real(NINPUTS))));

	-- Number of inputs padded to next power-of-2
	-- * the width of the first stage of sums
	constant PWIDTH : integer := 2**NSTAGES;

	-- The total number of sums in the pipeline
	constant NSUMS : integer := PWIDTH-1;

	-- The width of the last sum (used for all sums)
	constant SWIDTH : integer :=
		IWIDTH;

	-- ------------------------------------------------------------
	-- Signals
	-- ------------------------------------------------------------
	--
	-- Sum pipeline
	type sum_t is array (0 to NSUMS-1) of
		signed(SWIDTH-1 downto 0);
	signal sum    : sum_t;

begin

	-- ------------------------------------------------------------
	-- Pipelined adders
	-- ------------------------------------------------------------
	--
	process(clk,rstN)
		variable prev_index : integer;
		variable curr_index : integer;
		variable num_sums   : integer;
	begin
		if (rstN = '0') then
			sum <= (others => (others => '0'));
		elsif rising_edge(clk) then

			-- First stage; pairs of input sums
			-- * unused power-of-2 padding is left at the
			--   reset value of zero.
			num_sums := PWIDTH/2;
			for j in 0 to num_sums-1 loop
				if (2*j+1 < NINPUTS) then
					-- Resize and then sum (to avoid overflow)
					sum(j) <=
						resize(din(2*j),   SWIDTH) +
						resize(din(2*j+1), SWIDTH);
				elsif (2*j < NINPUTS) then
					sum(j) <= resize(din(2*j), SWIDTH);
				end if;
			end loop;

			-- Subsequent stages; sums of previous sums
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

		end if;
	end process;

	-- ------------------------------------------------------------
	-- Full-precision output sum
	-- ------------------------------------------------------------
	--
	q <= sum(NSUMS-1)(OWIDTH-1 downto 0);

end architecture;

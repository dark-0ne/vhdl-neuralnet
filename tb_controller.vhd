--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:04:22 02/09/2019
-- Design Name:   
-- Module Name:   D:/ISE/Projects/Final Project/fpga_nn/tb_controller.vhd
-- Project Name:  fpga_nn
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: controller
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_controller IS
END tb_controller;
 
ARCHITECTURE behavior OF tb_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controller
    PORT(
         din : IN  std_logic_vector(895 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         dout : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    type xins is array (0 to 13) of std_logic_vector(895 downto 0);


impure function InitXinsFromFile (FileName : in string) return xins is
    FILE romfile : text is in FileName;
    variable RomFileLine : line;
    variable rom : xins;
    begin
        for i in xins'range loop
            readline(romfile, RomFileLine);
            hread(RomFileLine, rom(i));
            end loop;
        return rom;
    end function;

   --Inputs
   signal din : std_logic_vector(895 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
	constant mem : xins := InitXinsFromFile("testData5.txt");

 	--Outputs
   signal dout : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controller PORT MAP (
          din => din,
          clk => clk,
          rst => rst,
          dout => dout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	variable line_v : line;
   file read_file : text;
   begin
      -- hold reset state for 100 ns.
      rst <= '1';
		wait for 100 ns;	
		
      wait for clk_period*10;

      -- insert stimulus here 
		rst <= '0';
		for i in 0 to 13 loop
			din <= mem(i);
			wait for clk_period;
		end loop;
      wait;
   end process;

END;

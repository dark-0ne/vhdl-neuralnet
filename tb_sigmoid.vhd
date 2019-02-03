--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:32:24 02/03/2019
-- Design Name:   
-- Module Name:   D:/ISE/Projects/Final Project/fpga_nn/tb_sigmoid.vhd
-- Project Name:  fpga_nn
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sigmoid
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_sigmoid IS
END tb_sigmoid;
 
ARCHITECTURE behavior OF tb_sigmoid IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sigmoid
    PORT(
         Y : IN  std_logic_vector(15 downto 0);
         O : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Y : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal O : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sigmoid PORT MAP (
          Y => Y,
          O => O
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset ate for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		y <= x"04cc";
      wait;
   end process;

END;

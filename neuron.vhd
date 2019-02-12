----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:32:15 02/02/2019 
-- Design Name: 
-- Module Name:    neuron - Mixed 
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
use IEEE.NUMERIC_STD.ALL;

library work;
use work.utilities.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Neuron is
    generic ( n : integer := 0 );
    Port ( slv_Xin, slv_Win : in STD_LOGIC_VECTOR ((n*16)+15 downto 0);
            slv_Bias : in STD_LOGIC_VECTOR(15 downto 0);
           O : out STD_LOGIC_VECTOR (15 downto 0));
end Neuron;

architecture Mixed of Neuron is
    component sigmoid
        port ( Y : in STD_LOGIC_VECTOR (15 downto 0);
               O : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    component sum_calculator
    generic (
            ninputs : integer;
            iwidth  : integer;
            owidth  : integer
        );
        port (
            d      : in  std_logic_vector(ninputs*iwidth-1 downto 0);
            q      : out signed(owidth-1 downto 0)
        );
    end component;
    signal sum : signed(15 downto 0) := x"0000";
    signal Y : STD_LOGIC_VECTOR (15 downto 0); 
    signal Xin, Win, Prod : vector (0 to n) := (others => x"0000"); 
    signal d : STD_LOGIC_VECTOR ((n*16)+15 downto 0); 
begin
    SIG : sigmoid port map (Y => Y, O => O);
    G1: if n>0 generate
        ADDER : sum_calculator
            generic map ( ninputs => n+1, iwidth => 16, owidth => 16)
            port map (d => d, q => sum);  
    end generate G1;  
      
    Xin <= to_vec(slv_Xin);
    Win <= to_vec(slv_Win);
    d <= to_slv(Prod);
    
    process (Xin, Win,sum)  
    begin 
        if (n>0) then
            L1: for I in 0 to n loop
                Prod(I) <= to_stdlogicvector(to_bitvector(std_logic_vector(signed(Xin(I)) * signed(Win(I)))))(27 downto 12);
            end loop L1;
        end if;  
    end process;
    
    process (slv_Xin,slv_Win,slv_Bias)
    begin
        if (n<1) then
            Y <= to_stdlogicvector(to_bitvector(std_logic_vector(signed(slv_Bias)+signed(Xin(0)) * signed(Win(0)))))(27 downto 12);
        else
            Y <= std_logic_vector(sum + signed(slv_Bias)); 
        end if;
    end process;

end Mixed;

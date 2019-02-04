----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:57:43 02/03/2019 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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

entity controller is
    Port ( din : in  STD_LOGIC_VECTOR (895 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (3 downto 0));
end controller;

architecture Behavioral of controller is
component Neuron is
    generic ( n : integer := 0 );
    Port ( slv_Xin, slv_Win : in STD_LOGIC_VECTOR ((n*16)+15 downto 0);
            slv_Bias : in STD_LOGIC_VECTOR(15 downto 0);
           clk : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (15 downto 0));
end component;
    
    --Types
    type ST is (get_input,first_layer,second_layer);
    type weights_f is array (799 downto 0) of STD_LOGIC_VECTOR(16383 downto 0);
    type biases_f is array (799 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
    type weights_s is array (9 downto 0) of STD_LOGIC_VECTOR(16383 downto 0);
    type biases_s is array (9 downto 0) of STD_LOGIC_VECTOR(15 downto 0);

    --Signals
    signal neuron_xin_first : STD_LOGIC_VECTOR(16383 downto 0) := (others => '0');
    signal neuron_win_first : STD_LOGIC_VECTOR(16383 downto 0) := (others => '0');
    signal neuron_bias_first : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal neuron_yout_first : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal neuron_xin_second : STD_LOGIC_VECTOR(16383 downto 0) := (others => '0');
    signal neuron_win_second : STD_LOGIC_VECTOR(16383 downto 0) := (others => '0');
    signal neuron_yout_second : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal network_yout : STD_LOGIC_VECTOR(159 downto 0) := (others => '0');
    signal weights_first : weights_f;
    signal biases_first : biases_f; 
    signal weights_second : weights_s;
    signal biases_second : biases_s;

    --Functions
    impure function InitFirstWeightsFromFile (WeightsFileName : in string) return weights_f is
    FILE romfile : text is in WeightsFileName;
    variable RomFileLine : line;
    variable rom : weights_f;
    begin
        for i in weights_f'range loop
            readline(romfile, RomFileLine);
            hread(RomFileLine, rom(i));
            end loop;
        return rom;
    end function;

    impure function InitFirstBiasesFromFile (BiasesFileName : in string) return biases_f is
    FILE romfile : text is in BiasesFileName;
    variable RomFileLine : line;
    variable rom : biases_f;
    begin
        for i in biases_f'range loop
            readline(romfile, RomFileLine);
            hread(RomFileLine, rom(i));
            end loop;
        return rom;
    end function;

    impure function InitSecondWeightsFromFile (WeightsFileName : in string) return weights_s is
    FILE romfile : text is in WeightsFileName;
    variable RomFileLine : line;
    variable rom : weights_s;
    begin
        for i in weights_s'range loop
            readline(romfile, RomFileLine);
            hread(RomFileLine, rom(i));
            end loop;
        return rom;
    end function;

    impure function InitSecondBiasesFromFile (BiasesFileName : in string) return biases_s is
    FILE romfile : text is in BiasesFileName;
    variable RomFileLine : line;
    variable rom : biases_s;
    begin
        for i in biases_s'range loop
            readline(romfile, RomFileLine);
            hread(RomFileLine, rom(i));
            end loop;
        return rom;
    end function;

begin
neuron1: Neuron 
    generic map(n => 1023)
    port map(slv_Xin => neuron_xin_first, slv_Win=>neuron_win_first, slv_Bias => neuron_bias_first, clk => clk, O => neuron_yout_first);

neuron2: Neuron 
    generic map(n => 1023)
    port map(slv_Xin => neuron_xin_second, slv_Win=>neuron_win_second, slv_Bias => neuron_bias_second, clk => clk, O => neuron_yout_second);

    process(clk,rst)
    variable state : ST := get_input;
    variable in_count : integer range 0 to 13 := 0;
    
    begin
        if(rst = '1') then 
            state := get_input;
            in_count := 0;
        elsif(clk'event and clk='1') then
            if(state = get_input) then
                    xin_first((in_count*896)+895 downto in_count*896) := din;
                    if(in_count = 13) then
                        in_count := 0;
                        state := first_layer;
                    else
                        in_count := in_count + 1;
                        end if;
                end if;
            end if;
        end process;

end Behavioral;


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
use std.textio.all;
use ieee.std_logic_textio.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

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
           O : out STD_LOGIC_VECTOR (15 downto 0));
end component;
component xinStorage is
    Port ( din : in  STD_LOGIC_VECTOR (895 downto 0);
				load: in std_logic;
				idx: in std_logic_vector(9 downto 0);
           clk : in  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (16383 downto 0));
end component;

    
    --Types
    type ST is (get_input,first_layer,second_layer,wait_for_reset);
    type weights_f is array (63 downto 0) of STD_LOGIC_VECTOR(16383 downto 0);
    type biases_f is array (63 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
	 type outs_f is array (63 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
    type weights_s is array (9 downto 0) of STD_LOGIC_VECTOR(1023 downto 0);
    type biases_s is array (9 downto 0) of STD_LOGIC_VECTOR(15 downto 0);

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

    --Signals
	 signal inStore_idx : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	 signal inStore_load : STD_LOGIC := '0';
    signal neuron_xin_first : STD_LOGIC_VECTOR(16383 downto 0);
	 signal neuron_win_first : STD_LOGIC_VECTOR(16383 downto 0);
    signal neuron_bias_first : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal neuron_yout_first : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	 signal neuron_outs_first : outs_f;
    signal neuron_xin_second : STD_LOGIC_VECTOR(1023 downto 0);
    signal neuron_win_second : STD_LOGIC_VECTOR(1023 downto 0);
    signal neuron_bias_second : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal neuron_yout_second : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    constant weights_first : weights_f := InitFirstWeightsFromFile("first_weights.txt");
    constant biases_first : biases_f := InitFirstBiasesFromFile("first_biases.txt"); 
    constant weights_second : weights_s := InitSecondWeightsFromFile("second_weights.txt");
    constant biases_second : biases_s := InitSecondBiasesFromFile("second_biases.txt");

begin
in_store: xinStorage
	port map(clk => clk, din => din, load => inStore_load, idx => inStore_idx,dout => neuron_xin_first );

neuron1: Neuron 
    generic map(n => 1023)
    port map(slv_Xin => neuron_xin_first, slv_Win=>neuron_win_first, slv_Bias => neuron_bias_first, O => neuron_yout_first);

neuron2: Neuron 
    generic map(n => 63)
    port map(slv_Xin => neuron_xin_second, slv_Win=>neuron_win_second, slv_Bias => neuron_bias_second, O => neuron_yout_second);
	 
process(clk) begin
	if (clk'event and clk = '1') then
		for i in 0 to 63 loop
			neuron_xin_second(1023 - i*16 downto 1008 - 16* i) <= neuron_outs_first(i);
		end loop;
	end if;
end process;

    process(clk,rst)
    variable state : ST := get_input;
    variable in_count : integer range 0 to 13 := 0;
    variable first_layer_count : integer range 0 to 63 := 0;
    variable second_layer_count : integer range 0 to 9 := 0;
	 variable max_val : signed(15 downto 0) := (others => '0');
	 variable max_number : integer range 0 to 9 := 0;
    
    begin
        if(rst = '1') then 
            state := get_input;
            in_count := 0;
        elsif(clk'event and clk='1') then
            if(state = get_input) then
                    inStore_load <= '1';
						  inStore_idx <= std_logic_vector(to_unsigned(in_count*56,10));
                    if(in_count = 13) then
                        in_count := 0;
                        state := first_layer;
								first_layer_count := 0;
                        neuron_win_first <= weights_first(0);
                        neuron_bias_first <= biases_first(0);
                    else
                        in_count := in_count + 1;
                    end if;
            elsif(state = first_layer) then
				    inStore_load <= '0';
					 neuron_outs_first(first_layer_count) <= neuron_yout_first;
                if(first_layer_count < 63) then
                    first_layer_count := first_layer_count + 1;
                    neuron_win_first <= weights_first(first_layer_count);
                    neuron_bias_first <= biases_first(first_layer_count);
                else
                    first_layer_count := 0;
						  second_layer_count := 0;
                    neuron_win_second <= weights_second(0);
                    neuron_bias_second <= biases_second(0);
                    state := second_layer;
                    end if;
            
            else
					if(signed(neuron_yout_second) > max_val) then
						max_val := signed(neuron_yout_second);
						max_number := second_layer_count;
					end if;
					
                if(second_layer_count < 9) then
                    second_layer_count := second_layer_count + 1;
                    neuron_win_second <= weights_second(second_layer_count);
                    neuron_bias_second <= biases_second(second_layer_count);
                else
                    second_layer_count := 0;
						  state := wait_for_reset;
                end if;
					dout <= std_logic_vector(to_unsigned(max_number,4));	  
            end if;
        end if;
        end process;

end Behavioral;


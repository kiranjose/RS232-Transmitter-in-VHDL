-- Quartus II VHDL Program 
-- UART Transmitter 
-- Baud: 9600 
-- Clock: 48MHz
-- Author Kiran Jose
-- Web: www.kiranjose.com

library ieee;
use ieee.std_logic_1164.all;

entity uart_tx is

	port 
	(
		clk		: in std_logic;
		rx			: in std_logic;
		tx			: buffer std_logic
	);

end entity;

architecture rtl of uart_tx is
	--signal data : std_logic_vector( 7 downto 0) := "01000001";
	signal data : std_logic_vector(7 downto 0) := x"41"; --ASCII value of alphabet 'A' in hex
begin
	process (clk)
		--variable to count the clock pulse
		variable count : integer range 0 to 4999 := 4999; --9600 baud generator variable (48MHz/9600)
		variable bit_number : integer range 0 to 20 :=0;  --start bit+8 data bits+stop bit+10 buffer bits
		begin

			if (rising_edge(clk)) then
				if (count = 4999) then
					if (bit_number = 0) then
						tx <= '0'; --start bit
					elsif(bit_number = 9) then	
						tx <= '1'; -- stop bit
					elsif((bit_number > 0) and (bit_number < 9))  then
						tx <= data(bit_number-1); --8 data bits
					elsif(bit_number > 9) then	
						tx <= '1'; --10 logic high bits as a buffer before the next transmission 
					end if;
					bit_number := bit_number+1;
					if(bit_number = 20) then --resetting the bit number
						bit_number:=0;
					end if;
					
				end if;
				count:= count+1;
				if (count = 5000) then --resetting the baud generator counter
					count :=0;
				end if;
			end if;
		
	end process;

end rtl;
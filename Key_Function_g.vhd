-- Written by Gaurav Aggarwal
-- Date: 20th Feb, 2021
-- Version: v.1.0



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Key_Function_g IS
    PORT ( encryption_round : IN STD_LOGIC_VECTOR(3 downto 0);
           key_in : IN STD_LOGIC_VECTOR (31 downto 0);
           key_out : OUT STD_LOGIC_VECTOR (31 downto 0));
END Key_Function_g;

ARCHITECTURE Key_FUnction_g_logic OF Key_Function_g IS

COMPONENT SBox_Table IS
		PORT (SBox_Table_in : IN std_logic_vector (7 downto 0);
		SBox_Table_out : OUT std_logic_vector (7 downto 0));
END COMPONENT;

SIGNAL sig3,sig2,sig1,sig0,temp : std_logic_vector(7 downto 0);

BEGIN
		SB3 : SBox_Table PORT MAP (SBox_Table_in=>key_in(23 downto 16),SBox_Table_out=>sig3);
		SB2 : SBox_Table PORT MAP (SBox_Table_in=>key_in(15 downto 8),SBox_Table_out=>sig2);
		SB1 : SBox_Table PORT MAP (SBox_Table_in=>key_in(7 downto 0),SBox_Table_out=>sig1);
		SB0 : SBox_Table PORT MAP (SBox_Table_in=>key_in(31 downto 24),SBox_Table_out=>sig0);

		WITH encryption_round SELECT
		                 temp <=		sig3 XOR "00000001"		WHEN "0001",
										sig3 XOR "00000010"		WHEN "0010",
										sig3 XOR "00000100"		WHEN "0011",
										sig3 XOR "00001000"		WHEN "0100",
										sig3 XOR "00010000"		WHEN "0101", 
										sig3 XOR "00100000"		WHEN "0110",
										sig3 XOR "01000000"		WHEN "0111",
										sig3 XOR "10000000"		WHEN "1000",
										sig3 XOR "00011011"		WHEN "1001",
										sig3 XOR "00110110"		WHEN "1010",
										sig3 XOR "00000000"		WHEN OTHERS;

		key_out(31 downto 24) <= temp;
		key_out(23 downto 16) <= sig2;
		key_out(15 downto 8) <= sig1;
		key_out(7 downto 0) <= sig0;

END Key_FUnction_g_logic;

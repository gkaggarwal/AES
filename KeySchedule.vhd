-- Written by Gaurav Aggarwal
-- Date: 20th Feb, 2021
-- Version: v.1.0



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



ENTITY KeySchedule IS
    PORT ( clk : IN std_logic;
		   encryption_round : IN std_logic_vector(3 downto 0);
		   encry_key_in : IN std_logic_vector(127 downto 0);
		   round_key : INOUT std_logic_vector(127 downto 0));
END KeySchedule;

ARCHITECTURE KeySchedule_logic OF KeySchedule IS

SIGNAL sig0 : std_logic_vector(31 downto 0);

COMPONENT Key_Function_g IS
    PORT ( encryption_round : IN STD_LOGIC_VECTOR(3 downto 0);
           key_in : IN STD_LOGIC_VECTOR (31 downto 0);
           key_out : OUT STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;

BEGIN
		KE1 : Key_Function_g PORT MAP (encryption_round=>encryption_round,key_in=>encry_key_in(31 downto 0),key_out=>sig0);
		
		PROCESS(clk)
				VARIABLE temp3,temp2,temp1,temp0 : std_logic_vector(31 downto 0);
		BEGIN
		       if clk'event AND clk='1' then
						
					temp0 := encry_key_in(31 downto 0) XOR sig0;
					temp1 := encry_key_in(63 downto 32) XOR temp0;
			        temp2 := encry_key_in(95 downto 64) XOR temp1;
					temp3 := encry_key_in(127 downto 96) XOR temp2;
						
			  end if;
			        	round_key(127 downto 96) <= temp3;
				        round_key(95 downto 64) <= temp2;
				        round_key(63 downto 32) <= temp1;
				        round_key(31 downto 0) <= temp0;
				
		END PROCESS;
END KeySchedule_logic;

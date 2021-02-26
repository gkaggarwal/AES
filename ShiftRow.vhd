-- Written by Gaurav Aggarwal
-- Date: 20th Feb, 2021
-- Version: v.1.0


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY ShiftRow IS
		PORT (shiftrow_in : IN std_logic_vector (127 downto 0);
			 shiftrow_out : OUT std_logic_vector(127 downto 0));
END ShiftRow;


ARCHITECTURE ShiftRow_logic OF ShiftRow IS
BEGIN
        shiftrow_out (127 downto 120) <= shiftrow_in (95 downto 88);
		shiftrow_out (119 downto 112) <= shiftrow_in (55 downto 48);
		shiftrow_out (111 downto 104) <= shiftrow_in (15 downto 8);
		shiftrow_out (103 downto 96)  <= shiftrow_in (103 downto 96);

		shiftrow_out (95 downto 88) <= shiftrow_in (63 downto 56);
		shiftrow_out (87 downto 80) <= shiftrow_in (23 downto 16);
		shiftrow_out (79 downto 72) <= shiftrow_in (111 downto 104);
		shiftrow_out (71 downto 64) <= shiftrow_in (71 downto 64);

		shiftrow_out (63 downto 56) <= shiftrow_in (31 downto 24);
		shiftrow_out (55 downto 48) <= shiftrow_in (119 downto 112);
		shiftrow_out (47 downto 40) <= shiftrow_in (79 downto 72);
		shiftrow_out (39 downto 32) <= shiftrow_in (39 downto 32);

		shiftrow_out (31 downto 24) <= shiftrow_in (127 downto 120);
		shiftrow_out (23 downto 16) <= shiftrow_in (87 downto 80);
		shiftrow_out (15 downto 8)  <= shiftrow_in (47 downto 40);
		shiftrow_out (7 downto 0)   <= shiftrow_in (7 downto 0);
		
END ShiftRow_logic;


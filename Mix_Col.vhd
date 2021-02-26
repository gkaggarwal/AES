-- Written by Gaurav Aggarwal
-- Date: 20th Feb, 2021
-- Version: v.1.0


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY Mix_Col IS
   PORT (Mix_Col_in: in STD_LOGIC_VECTOR(127 downto 0);
         Mix_Col_out: out STD_LOGIC_VECTOR(127 downto 0));
END Mix_Col;

ARCHITECTURE Mix_Col_logic OF Mix_Col IS
--------------------------------------------------------------------------------------
------------------------->  MixColumn Slice Component <-------------------------------
--------------------------------------------------------------------------------------
COMPONENT Mix_Col_Slice IS
    PORT(   slice3_in, slice2_in, slice1_in, slice0_in : IN std_logic_vector (7 downto 0);
			slice3_out, slice2_out, slice1_out, slice0_out : OUT std_logic_vector (7 downto 0));
END COMPONENT;

BEGIN

M3: Mix_Col_Slice PORT MAP(slice3_in=>Mix_Col_in(127 downto 120),slice2_in=>Mix_Col_in(119 downto 112),
                           slice1_in=>Mix_Col_in(111 downto 104),slice0_in=>Mix_Col_in(103 downto 96),
                           slice3_out=>Mix_Col_out(127 downto 120),slice2_out=>Mix_Col_out(119 downto 112),
                           slice1_out=>Mix_Col_out(111 downto 104),slice0_out=>Mix_Col_out(103 downto 96));
                           
M2: Mix_Col_Slice PORT MAP(slice3_in=>Mix_Col_in(95 downto 88),slice2_in=>Mix_Col_in(87 downto 80),
                           slice1_in=>Mix_Col_in(79 downto 72),slice0_in=>Mix_Col_in(71 downto 64),
                           slice3_out=>Mix_Col_out(95 downto 88),slice2_out=>Mix_Col_out(87 downto 80),
                           slice1_out=>Mix_Col_out(79 downto 72),slice0_out=>Mix_Col_out(71 downto 64));
 
M1: Mix_Col_Slice PORT MAP(slice3_in=>Mix_Col_in(63 downto 56),slice2_in=>Mix_Col_in(55 downto 48),
                           slice1_in=>Mix_Col_in(47 downto 40),slice0_in=>Mix_Col_in(39 downto 32),
                           slice3_out=>Mix_Col_out(63 downto 56),slice2_out=>Mix_Col_out(55 downto 48),
                           slice1_out=>Mix_Col_out(47 downto 40),slice0_out=>Mix_Col_out(39 downto 32));

M0: Mix_Col_Slice PORT MAP(slice3_in=>Mix_Col_in(31 downto 24),slice2_in=>Mix_Col_in(23 downto 16),
                           slice1_in=>Mix_Col_in(15 downto 8),slice0_in=>Mix_Col_in(7 downto 0),
                           slice3_out=>Mix_Col_out(31 downto 24),slice2_out=>Mix_Col_out(23 downto 16),
                           slice1_out=>Mix_Col_out(15 downto 8),slice0_out=>Mix_Col_out(7 downto 0));

END Mix_Col_logic;

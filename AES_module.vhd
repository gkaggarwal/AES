-- Written by Gaurav Aggarwal
-- Date: 22th Feb, 2021
-- Version: v.1.0

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY AES_module IS
		PORT (clk, rst : IN std_logic;
			  start : IN std_logic_vector(1 downto 0);
			  key_data_in : IN std_logic_vector(15 downto 0); 
			  done : OUT std_logic;
			  cipher_out : OUT std_logic_vector(15 downto 0));
END AES_module;


ARCHITECTURE AES_module_logic of AES_module is
         SIGNAL cipher_reg : std_logic_vector(127 downto 0);
--------->>>>> signal and component declaration for data_loading_controller instantiation ---->>>>>

		SIGNAL data_avail,data_ready : std_logic;
 		SIGNAL data_ld_rnd : std_logic_vector(3 downto 0);

COMPONENT data_loading_controller IS
		PORT (clk, rst, data_available : IN std_logic;
			plain_text_available : OUT std_logic;
			data_load_round : OUT std_logic_vector(3 downto 0));
END COMPONENT;
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for key_loading_controller instantiation--------->>>>>>
		
		SIGNAL ld_key : std_logic;
		SIGNAL enc_key : std_logic_vector(127 downto 0);

COMPONENT key_loading_controller IS
		PORT (clk, rst, load_key : IN std_logic;
			  data_load_round : IN std_logic_vector(3 downto 0);
			  data_in : IN std_logic_vector(15 downto 0);
			  encry_key : OUT std_logic_vector(127 downto 0));
END COMPONENT;
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for KeySchedule instantiation--------->>>>>>
         SIGNAL  rnd_key : std_logic_vector(127 downto 0); 
COMPONENT KeySchedule IS
    PORT ( clk : IN std_logic;
		   encryption_round : IN std_logic_vector(3 downto 0);
		   encry_key_in : IN std_logic_vector(127 downto 0);
		   round_key : INOUT std_logic_vector(127 downto 0));
END COMPONENT;
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for PlaintextLoading instantiation--------->>>>>>
		
		SIGNAL ld_plaintext : std_logic;
		SIGNAL plain_txt : std_logic_vector(127 downto 0);

COMPONENT PlaintextLoading IS
		PORT (clk, rst, load_plaintext : IN std_logic;
			  data_load_round : IN std_logic_vector (3 downto 0);
			  data_in : IN std_logic_vector (15 downto 0);
			  plain_text : OUT std_logic_vector (127 downto 0));
END COMPONENT;		
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for encry_round_controller instantiation--------->>>>>>

		
		SIGNAL encry_rnd : std_logic_vector(3 downto 0);

COMPONENT encry_round_controller IS
		PORT (clk, rst ,start: IN std_logic;
		cipher_text_ready : OUT std_logic;
		encry_round : OUT std_logic_vector(3 downto 0));
END COMPONENT;

-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for SBox instantiation--------->>>>>>

		
		
		SIGNAL sbx_out : std_logic_vector(127 downto 0);

COMPONENT SBox_AES IS
		PORT (SBox_in : IN std_logic_vector(127 downto 0);
			 SBox_out : OUT std_logic_vector(127 downto 0));
END COMPONENT;				
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for shiftrows instantiation--------->>>>>>


		SIGNAL shftrows_out : std_logic_vector(127 downto 0);		

COMPONENT ShiftRow IS
		PORT (shiftrow_in : IN std_logic_vector (127 downto 0);
			 shiftrow_out : OUT std_logic_vector(127 downto 0));
END COMPONENT;

-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------->>>>>>>>>> signal and component declaration for MixColumn instantiation--------->>>>>>

		
		SIGNAL mxcolumn_out ,mx_col: std_logic_vector(127 downto 0);

COMPONENT Mix_Col IS
   PORT (Mix_Col_in: in STD_LOGIC_VECTOR(127 downto 0);
         Mix_Col_out: out STD_LOGIC_VECTOR(127 downto 0));
END COMPONENT;
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<

------------>>>>>>>>>> signal and component declaration for RoundkeyAddition instantiation--------->>>>>>
		
		SIGNAL rnd_keyadd_out ,rnd_key_out,round_reg,rnd_key_in,key_reg: std_logic_vector(127 downto 0);
		
		COMPONENT RoundkeyAddition IS
		PORT (RoundkeyAddition_in, RoundKey : IN std_logic_vector (127 downto 0);
			 RoundkeyAddition_out : OUT std_logic_vector (127 downto 0));
		END COMPONENT;
		
-->>>>>>>>>>>>>>>>>>>>>>>>>---------------------------------------------------------<<<<<<<<<<<<<<<<<<	

BEGIN
           DLC0 : data_loading_controller PORT MAP (clk=>clk,rst=>rst,data_available=>data_avail,
                                    plain_text_available=>data_ready,data_load_round=>data_ld_rnd);


           KLC0 : key_loading_controller PORT MAP (clk=>clk,rst=>rst,load_key=>ld_key,data_load_round=>data_ld_rnd,
                                                   data_in=>key_data_in,encry_key=>enc_key);

                                                   
           PTL0 : PlaintextLoading PORT MAP (clk=>clk,rst=>rst,load_plaintext=>ld_plaintext,data_load_round=>data_ld_rnd,
                                              data_in=>key_data_in,plain_text=>plain_txt);
		
           
           ERC0 : encry_round_controller PORT MAP (clk=>clk,rst=>rst,start=>data_ready,cipher_text_ready=>done,
                                                    encry_round =>encry_rnd);

           
           KS0 : KeySchedule PORT MAP (clk=>clk,encryption_round =>encry_rnd,encry_key_in=>enc_key,round_key=>rnd_key);
  
  
           RKA0 : RoundkeyAddition PORT MAP (RoundkeyAddition_in=>round_reg,RoundKey=>key_reg,
                                             RoundkeyAddition_out=>rnd_keyadd_out);
                                             
           SB0 : SBox_AES PORT MAP (SBox_in=>rnd_keyadd_out, SBox_out=>sbx_out);
    
           
           SR0 : ShiftRow PORT MAP (shiftrow_in =>sbx_out,shiftrow_out=>shftrows_out);
      
           
           MC0 : Mix_Col PORT MAP (Mix_Col_in=>shftrows_out,Mix_Col_out=>mxcolumn_out);
        
           
           
        PROCESS(start)
		BEGIN
				if start="00" then
						ld_key <='0';
						ld_plaintext <='0';
						data_avail <='0';
				elsif start="01" then
						ld_key <='1';
						ld_plaintext <='0';
						data_avail <='1';
				elsif start="10" then
						ld_key <='0';
						ld_plaintext <='1';
						data_avail <='1';
				else
						ld_key <='0';
						ld_plaintext <='0';
						data_avail <='0';
				end if;
		END PROCESS;
		
		
		
		 
		PROCESS (clk,encry_rnd)
		BEGIN
		          if encry_rnd="1010" then
		                  mx_col <= shftrows_out;
		          else
		                  mx_col <= mxcolumn_out;
		          end if;
		 END PROCESS;
	
	    
		PROCESS (clk,encry_rnd)
		BEGIN
		          if encry_rnd="0001" then
		                  rnd_key_out <= plain_txt;
		          else
		                  rnd_key_out <= mx_col;
		          end if;
		 END PROCESS;
	
	    PROCESS(clk,rst)
		VARIABLE rnd_reg : std_logic_vector(127 downto 0);
		BEGIN
		      if rst='1' then
		          rnd_reg := (OTHERS=>'0');
		      elsif clk'event AND clk='1' then
		          rnd_reg := rnd_key_out;
		      end if;
		      round_reg <= rnd_reg;		      
		END PROCESS;
			
	    PROCESS(clk,rst)
		VARIABLE rnd_key_reg : std_logic_vector(127 downto 0);
		BEGIN
		      if rst='1' then
		          rnd_key_reg := (OTHERS=>'0');
		      elsif clk'event AND clk='1' then
		          rnd_key_reg := rnd_key_in;
		      end if;
		      key_reg <= rnd_key_reg;		      
		END PROCESS;
		
		PROCESS (clk,encry_rnd)
		BEGIN
		          if encry_rnd="0001" then
		                  rnd_key_in <= enc_key;
		          else
		                  rnd_key_in <= rnd_key;
		          end if;
		 END PROCESS;
		
		PROCESS(clk)
		BEGIN
		if clk'event AND clk='1' then
		          if encry_rnd="1010" then
		                  cipher_reg <= rnd_keyadd_out;
		          else
		                  cipher_reg <= cipher_reg;
		          end if;
		 end if;
		 END PROCESS;
		  PROCESS(clk,rst)
		 BEGIN
		      if rst='1' then
		              cipher_out <= (OTHERS => '0');	 
		      elsif clk'event AND clk='1' then
		              CASE encry_rnd IS 
		                  WHEN "1010" =>
		                                  cipher_out <= 	cipher_reg(15 downto 0);
		                  WHEN "0001" =>
		                                  cipher_out <= cipher_reg(31 downto 16);
		                  WHEN "0010" =>
		                                  cipher_out <= 	cipher_reg(47 downto 32);
		                  WHEN "0011" =>
		                                  cipher_out <= cipher_reg(63 downto 48);
		                  WHEN "0100" =>
		                                  cipher_out <= 	cipher_reg(79 downto 64);
		                  WHEN "0101" =>
		                                  cipher_out <= cipher_reg(95 downto 80);
		                  WHEN "0110" =>
		                                  cipher_out <= 	cipher_reg(111 downto 96);
		                  WHEN "0111" =>
		                                  cipher_out <= cipher_reg(127 downto 112);
		                  WHEN OTHERS=>
		                                  cipher_out <= (OTHERS => '0');
		                  END CASE;
		      end if;
		      END PROCESS;
END AES_module_logic;

VAR
	TON3_State: BOOL;
	TON2_State: BOOL;
	TON1_State: BOOL;
	TON0_State: BOOL;
	TON3: TON;
	TON2: TON;
	TON1: TON;
	TON0: TON;
END_VAR

//Керування двигуном позиціонування лазерної головки (в меню опції)
FreqGen_1(EN_Enable:= TRUE, F_Enable:= TRUE, EN_Sync:= TRUE, F_Sync:= TRUE, Frequency:= MD304);
TON0(IN:= MW34.11, PT:= T#1MS, Q=> TON0_State); //Задання напрямку 1
TON3(IN:= MW34.12, PT:= T#1MS, Q=> TON3_State); //Задання напрямку 2
TON1(IN:= TON0_State OR TON3_State, PT:= T#1MS, Q=> TON1_State); //Старт частоти
TON2(IN:= NOT(MW34.11) AND NOT(MW34.12), PT:= T#1MS, Q=> TON2_State); //Взведення ENA (стоп)
IF MW34.11 THEN 
	MW34.12:= FALSE; QX0_7:= FALSE; 
	IF TON0_State THEN QX0_6:= FALSE; END_IF
	IF TON1_State THEN MD304:= WORD_TO_DWORD(MW104)*10; END_IF
END_IF
IF MW34.12 THEN 
	MW34.11:= FALSE; QX0_7:= FALSE;
	IF TON3_State THEN QX0_6:= TRUE; END_IF
	IF TON1_State THEN MD304:= WORD_TO_DWORD(MW104)*10; END_IF
END_IF
IF NOT(MW34.11) AND NOT(MW34.12) THEN
	MD304:= 0;
	IF TON2_State THEN QX0_7:= TRUE; END_IF
END_IF

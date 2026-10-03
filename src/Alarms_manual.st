VAR
	TON13: TON;
	TON14: TON;
	TON15: TON;
	TON16: TON;
	TON19: TON;
	TON20: TON;
END_VAR

//Затримка аналізу аварій
TON19(IN:= MW0.7 OR MW0.9 OR MW0.10 OR MW0.11, PT:= WORD_TO_TIME(MW96), Q=> TON19_State);
//Аларми загальні
IF TON19_State THEN 
	IF IX0_0 THEN MW100:= 1; MW8.1:= TRUE; END_IF //Аларм по грибку
	IF MW18.12 AND MW0.7 AND IX0_8 THEN MW100:= 2; MW8.1:= TRUE; END_IF //Аларм по аварії лазера
	IF MW8.6 AND IW6 < MW80 THEN MW100:= 5; MW8.1:= TRUE; END_IF //Аларм по низькому тиску газу зварювання
	IF MW8.7 AND IW7 < MW82 THEN MW100:= 6; MW8.1:= TRUE; END_IF //Аларм по низькому тиску газу різання
	IF MW8.8 AND IW8 < MW84 THEN MW100:= 7; MW8.1:= TRUE; END_IF //Аларм по низьких витратах газу зварювання
	IF MW8.9 AND IW9 < MW86 THEN MW100:= 8; MW8.1:= TRUE; END_IF //Аларм по низьких витратах газу різання
END_IF
IF MW8.12 AND MW18.8 AND TON19_State AND MW0.9 AND IW12 < MW92 THEN MW100:= 9; MW8.1:= TRUE; END_IF //Аларм по низькому струму різання
IF MW8.13 AND MW18.8 AND TON19_State AND MW0.9 AND IW13 < MW94 THEN MW100:= 10; MW8.1:= TRUE; END_IF //Аларм по низькій напрузі різання
IF MW8.10 AND MW18.8 AND TON19_State AND (MW0.10 OR MW0.11) AND CAN_GET_WeldCurrent < MW88 THEN MW100:= 11; MW8.1:= TRUE; END_IF //Аларм низькому струму звар
IF MW8.11 AND MW18.8 AND TON19_State AND (MW0.10 OR MW0.11) AND CAN_GET_WeldVoltage < MW90 THEN MW100:= 12; MW8.1:= TRUE; END_IF //Аларм по низькій напрузі звар
//Готовність лазера
IF NOT(MW8.1) AND NOT(IX0_0) AND ((MW18.12 AND NOT(IX0_8)) OR NOT(MW18.12)) AND ((MW8.6 AND IW6 >= MW80) OR NOT(MW8.6)) AND ((MW8.7 AND IW7 >= MW82) OR NOT(MW8.7)) THEN 
	MW8.3:= TRUE; ELSE MW8.3:= FALSE; END_IF
//Готовність різання та зварювання + зварювання MIG
IF NOT(MW8.1) AND NOT(IX0_0) AND ((MW8.6 AND IW6 >= MW80) OR NOT(MW8.6)) AND ((MW8.7 AND IW7 >= MW82) OR NOT(MW8.7)) THEN 
	MW8.4:= TRUE; MW8.5:= TRUE; MW8.15:= TRUE; ELSE MW8.4:= FALSE; MW8.5:= FALSE; MW8.15:= FALSE; END_IF
//Скидання готовностей при виникненні помилки
IF MW8.1 THEN MW8.3:= FALSE; MW8.4:= FALSE; MW8.5:= FALSE; MW8.15:= FALSE; END_IF
//Затримка аварійного вимкнення
TON20(IN:= MW8.1, PT:= WORD_TO_TIME(MW98), Q=> TON20_Emergency_stop);
//Скидання аларму
IF MW8.0 THEN MW100:= 0; MW8.1:= FALSE; END_IF
//Видача готовності шафи керування на робот
IF MW8.3 OR MW8.4 OR MW8.5 OR MW8.15 THEN QX4_4:= TRUE; ELSE QX4_4:= FALSE; END_IF

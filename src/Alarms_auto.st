VAR
	TON13: TON;
	TON14: TON;
	TON15: TON;
	TON16: TON;
END_VAR

//Затримка аналізу аварій
TON13(IN:= MW34.10, PT:= WORD_TO_TIME(MW96), Q=> TON13_State);
//Затримка аналізу чергової дуги
TON14(IN:= TON1_A_State, PT:= WORD_TO_TIME(MW60), Q=> TON14_State);
//Затримка аналізу основної дуги
TON15(IN:= (MW34.2 AND NOT(MW34.1) AND QX5_5) OR (MW34.1 AND CAN_SET_ArcOn) OR (MW34.9 AND QX5_3), PT:= WORD_TO_TIME(MW64), Q=> TON15_State);
//Аларми
IF TON13_State THEN
	IF IX0_0 THEN MW100:= 1; MW8.1:= TRUE; END_IF //Аларм по грибку
	IF MW18.12 AND IX0_8 THEN MW100:= 2; MW8.1:= TRUE; END_IF //Аларм по аварії лазера
	IF MW18.13 AND MW34.4 AND NOT(IX0_4) THEN MW100:= 3; MW8.1:= TRUE; END_IF //Аларм по неготовності робота
	IF MW18.14 AND MW34.4 AND IX0_6 THEN MW100:= 4; MW8.1:= TRUE; END_IF //Аларм по аварії робота
	IF MW8.6 AND IW6 < MW80 THEN MW100:= 5; MW8.1:= TRUE; END_IF //Аларм по низькому тиску газу зварювання
	IF MW8.7 AND IW7 < MW82 THEN MW100:= 6; MW8.1:= TRUE; END_IF //Аларм по низькому тиску газу різання
	IF MW8.8 AND IW8 < MW84 THEN MW100:= 7; MW8.1:= TRUE; END_IF //Аларм по низьких витратах газу зварювання
	IF MW8.9 AND IW9 < MW86 THEN MW100:= 8; MW8.1:= TRUE; END_IF //Аларм по низьких витратах газу різання
END_IF
IF MW8.12 AND MW18.8 AND TON13_State AND QX5_5 AND IW12 < MW92 THEN MW100:= 9; MW8.1:= TRUE; END_IF //Аларм по низькому струму різання
IF MW8.13 AND MW18.8 AND TON13_State AND QX5_5 AND IW13 < MW94 THEN MW100:= 10; MW8.1:= TRUE; END_IF //Аларм по низькій напрузі різання
IF MW8.10 AND MW18.8 AND TON13_State AND (CAN_SET_ArcOn OR CAN_SET_PilotArc) AND CAN_GET_WeldCurrent < MW88 THEN MW100:= 11; MW8.1:= TRUE; END_IF //Аларм низькому струму звар
IF MW8.11 AND MW18.8 AND TON13_State AND (CAN_SET_ArcOn OR CAN_SET_PilotArc) AND CAN_GET_WeldVoltage < MW90 THEN MW100:= 12; MW8.1:= TRUE; END_IF //Аларм по низькій напрузі звар
//Контроль на обрив чергової дуги
IF TON14_State AND TON13_State AND MW18.10 AND (CAN_SET_ArcOn OR CAN_SET_PilotArc) AND NOT(MW18.7) THEN MW100:= 13; MW8.1:= TRUE; END_IF
//Контроль на обрив основної дуги
IF TON15_State AND TON13_State AND MW18.11 AND NOT(MW18.8) THEN MW100:= 14; MW8.1:= TRUE; END_IF
//Скидання готовності при виникненні помилки
IF MW8.1 THEN MW8.2:= FALSE; END_IF
//Готовність в автоматі
IF NOT(MW8.1) AND NOT(IX0_0) AND ((MW34.4 AND ((MW18.13 AND IX0_4) OR NOT(MW18.13)) AND ((MW18.14 AND NOT(IX0_6)) OR NOT(MW18.14))) OR NOT(MW34.4)) AND ((MW18.12 AND MW34.00 AND NOT(IX0_8)) OR NOT(MW18.12) OR NOT(MW34.00)) AND ((MW8.6 AND IW6 >= MW80) OR NOT(MW8.6)) AND ((MW8.7 AND IW7 >= MW82) OR NOT(MW8.7)) THEN
	MW8.2:= TRUE; ELSE MW8.2:= FALSE; END_IF
//Затримка аварійного вимкнення
TON16(IN:= MW8.1, PT:= WORD_TO_TIME(MW98), Q=> TON16_Emergency_stop);
//Скидання аларму
IF MW8.0 THEN MW100:= 0; MW8.1:= FALSE; END_IF
QX4_4:= MW8.2; //Видача готовності шафи керування на робот

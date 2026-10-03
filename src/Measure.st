//Дискретні сигнали
MW18.3:= IX0_0;
MW18.4:= IX0_8;
MW18.5:= IX0_4;
MW18.6:= IX0_6;
MW18.9:= IX0_5;
MW18.7:= CAN_GET_PilotArc;
IF QX5_5 AND (CAN_SET_ArcOn OR CAN_SET_PilotArc) THEN MW18.8:= IX0_2 AND CAN_GET_MainCurrent;
ELSIF QX5_3 AND (CAN_SET_ArcOn OR CAN_SET_PilotArc) THEN MW18.8:= IX0_3 AND CAN_GET_MainCurrent;
ELSIF CAN_SET_ArcOn OR CAN_SET_PilotArc THEN MW18.8:= CAN_GET_MainCurrent; 
ELSIF QX5_5 THEN MW18.8:= IX0_2;
ELSIF QX5_3 THEN MW18.8:= IX0_3;
ELSIF NOT(IX0_2) AND NOT(CAN_GET_MainCurrent) AND NOT(IX0_3) THEN MW18.8:= FALSE; END_IF
QX4_5:= MW18.8; //Видача Main current на робот

//Аналогові входи
IF IW12 >= 4800 THEN //Cutting current
	MW114:= IW12;
ELSE
	MW114:= 4000;
END_IF
IF IW13 >= 4500 THEN //Cutting voltage
	MW116:= IW13;
ELSE
	MW116:= 4000;
END_IF
IF IW6 >= 4100 THEN //BP1 pl. wel.
	MW118:= IW6;
ELSE
	MW118:= 4000;
END_IF
IF IW7 >= 4100 THEN //BP2 pl. cut.
	MW120:= IW7;
ELSE
	MW120:= 4000;
END_IF
IF IW8 >= 4100 THEN //FT2 pl. wel.
	MW122:= IW8;
ELSE
	MW122:= 4000;
END_IF
IF IW9 >= 4100 THEN //FT7 pl. cut.
	MW124:= IW9;
ELSE
	MW124:= 4000;
END_IF

//Вимірювання струму зварювання Cebora
IF CAN_GET_WeldCurrent <= 655 THEN
	MW110:= 0;
ELSE
	MW110:= CAN_GET_WeldCurrent;
END_IF

//Вимірювання напруги зварювання Cebora
IF CAN_GET_WeldVoltage <= 5000 THEN
	MW112:= 0;
ELSE
	MW112:= CAN_GET_WeldVoltage;
END_IF

//Вимірювання Cebora plasma gas
IF CAN_GET_PlasmaGasFlw <= 655 THEN
	MW126:= 0;
ELSE
	MW126:= CAN_GET_PlasmaGasFlw;
END_IF

//Вимірювання Cebora shield gas
IF CAN_GET_ShieldGasFlw <= 220 THEN
	MW128:= 0;
ELSE
	MW128:= CAN_GET_ShieldGasFlw;
END_IF

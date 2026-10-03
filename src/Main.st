VAR
	RTRIG1: R_TRIG;
END_VAR

QX4_7:= TRUE; //Подача сигналу "Керування від ЛПЗР" на Schneider-робота
IF MW0.5 THEN  Alarms_manual(); ELSE Alarms_auto(); END_IF //Аларми
Measure();
RTRIG1(CLK:= NOT(MW0.5));
IF IX0_0 OR RTRIG1.Q THEN Default(); END_IF //Скидання до дефолту
IF MW0.5 THEN  Manual(); LaserCut_focus(); ELSE Auto(); END_IF //Ручний + laser focus / Автоматичний

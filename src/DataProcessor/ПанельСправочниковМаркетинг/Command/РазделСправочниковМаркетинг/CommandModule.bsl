﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ВебКлиент Тогда
	ОкноОткрытияПанели = ПараметрыВыполненияКоманды.Окно;
	#Иначе
	ОкноОткрытияПанели = ПараметрыВыполненияКоманды.Источник;
	#КонецЕсли 
	
	ОткрытьФорму(
		"Обработка.ПанельСправочниковМаркетинг.Форма.ПанельСправочниковМаркетинг",
		,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ОкноОткрытияПанели
	);
	
КонецПроцедуры

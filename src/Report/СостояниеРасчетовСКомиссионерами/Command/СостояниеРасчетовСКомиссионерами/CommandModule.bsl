﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Отбор, ФиксированныеНастройки, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии");
	ПараметрыФормы.СформироватьПриОткрытии = Истина;
	
	ПараметрыФормы.Отбор = Новый Структура("ОтчетКомиссионера", ПараметрКоманды);
	ПараметрыФормы.КлючНазначенияИспользования = "ОтчетКомиссионера";
	ПараметрыФормы.КлючВарианта = "СостояниеРасчетовСКомиссионерами";
		
	ОткрытьФорму("Отчет.СостояниеРасчетовСКомиссионерами.Форма",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры

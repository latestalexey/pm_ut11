﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Отбор, ФиксированныеНастройки, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии");	
	ПараметрыФормы.СформироватьПриОткрытии = Истина;	
	ПараметрыФормы.Отбор = Новый Структура("ВариантГрафика", ПараметрКоманды);
		
	ОткрытьФорму("Отчет.ГрафикОплатНачисленийКредитовИДепозитов.Форма", 
					ПараметрыФормы, 
					ПараметрыВыполненияКоманды.Источник, 
					ПараметрыВыполненияКоманды.Уникальность, 
					ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

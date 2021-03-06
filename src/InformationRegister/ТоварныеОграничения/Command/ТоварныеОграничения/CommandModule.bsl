﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Номенклатура", ПараметрКоманды));
		ОткрытьФорму("РегистрСведений.ТоварныеОграничения.Форма.ТоварныеОграниченияНоменклатуры", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
		
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Склады") Тогда
		
		ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Склад", ПараметрКоманды));
		ОткрытьФорму("РегистрСведений.ТоварныеОграничения.Форма.ТоварныеОграниченияСклада", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
			
	КонецЕсли;
	
КонецПроцедуры

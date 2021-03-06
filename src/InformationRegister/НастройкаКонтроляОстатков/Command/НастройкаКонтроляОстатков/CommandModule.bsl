﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Номенклатура") Тогда
		
		ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Номенклатура", ПараметрКоманды));
		ОткрытьФорму("РегистрСведений.НастройкаКонтроляОстатков.Форма.НастройкаКонтроляОстатковНоменклатуры", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
		
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Склады") Тогда
		
		ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Склад", ПараметрКоманды));
		ОткрытьФорму("РегистрСведений.НастройкаКонтроляОстатков.Форма.НастройкаКонтроляОстатковСклада", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
			
	КонецЕсли;
	
КонецПроцедуры

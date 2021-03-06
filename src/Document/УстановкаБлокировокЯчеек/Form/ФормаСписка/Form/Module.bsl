﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОтчетПоЗаблокированнымЯчейкам(Команда)
	ПараметрыФормы = Новый Структура("КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии",
					"Основной",
					"Основной",
					Истина);

	ОткрытьФорму("Отчет.ЗаблокированныеЯчейки.Форма",
			ПараметрыФормы,
			ЭтаФорма);
КонецПроцедуры

﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВалютаУправленческогоУчета"));
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Константы.ВалютаУправленческогоУчета.Получить();
		Параметр.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры


#КонецЕсли
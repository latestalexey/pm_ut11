﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Возвращает имена блокруемых реквизитов для механизма блокирования реквизитов БСП
//	Возвращаемое значание:
//		Массив - имена блокируемых реквизитов
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	
	Результат.Добавить("Владелец");
 	Результат.Добавить("Помещение");

	Возврат Результат;

КонецФункции

#КонецЕсли
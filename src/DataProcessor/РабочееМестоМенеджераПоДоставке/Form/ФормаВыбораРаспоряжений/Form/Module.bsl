﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Распоряжения.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресРаспоряжений));
	АдресРаспоряжений = "";
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если АдресРаспоряжений <> "" Тогда 
		Структура = Новый Структура("АдресРаспоряжений", АдресРаспоряжений);
		ОповеститьОВыборе(Структура);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	ПоместитьРаспоряженияВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсе(Команда)
	Для Каждого Стр Из Распоряжения Цикл
		Стр.Выбран = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	Для Каждого Стр Из Распоряжения Цикл
		Стр.Выбран = Ложь;
	КонецЦикла;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПоместитьРаспоряженияВХранилище();
	//В исходной строке пункта маршрута должно остаться хотя бы одно распоряжение
	Если Распоряжения.НайтиСтроки(Новый Структура("Выбран",Ложь)).Количество() > 0
		  И Распоряжения.НайтиСтроки(Новый Структура("Выбран",Истина)).Количество() > 0 Тогда
		ТаблицаВыбранных = РеквизитФормыВЗначение("Распоряжения").Скопировать(Новый Структура("Выбран", Истина));
		АдресРаспоряжений = ПоместитьВоВременноеХранилище(ТаблицаВыбранных, УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

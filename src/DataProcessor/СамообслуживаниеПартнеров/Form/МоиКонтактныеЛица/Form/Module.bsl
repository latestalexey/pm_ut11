﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Партнер = ПартнерыИКонтрагентыВызовСервера.ПолучитьАвторизовавшегосяПартнера();
	
	Если Партнер = Неопределено ИЛИ Партнер.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	КонтактныеЛицаСписок.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДата()));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КонтактныеЛицаСписок.Отбор,
	                                                     "Владелец",
	                                                     Партнер,
	                                                     ВидСравненияКомпоновкиДанных.Равно,,Истина
	);
	
КонецПроцедуры


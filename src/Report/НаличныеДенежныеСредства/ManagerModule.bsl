﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки вариантов этого отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	// Настройка размещения, видимости по умолчанию, важности
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "НаличныеДенежныеСредства");
	ВариантыОтчетовУТПереопределяемый.УстановитьВажностьВариантаОтчета(ОписаниеВарианта, "Важный");
	
КонецПроцедуры

// Настройки зависимостей вариантов этого отчета от функциональных опций
//
Функция ФункциональныеОпцииВариантовОтчетов() Экспорт
	ФункциональныеОпцииВариантовОтчетов = ВариантыОтчетовУТПереопределяемый.ИнициализироватьФункциональныеОпцииВариантовОтчетов();
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьФункциональнуюОпциюВариантаОтчета(ФункциональныеОпцииВариантовОтчетов, 
		"НаличныеДенежныеСредства", "ИспользоватьНесколькоКасс");
	
	Возврат ФункциональныеОпцииВариантовОтчетов;
КонецФункции

 // Конец СтандартныеПодсистемы.ВариантыОтчетов
#КонецЕсли
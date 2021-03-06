﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки вариантов этого отчета.
// Подробнее - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	// Отключение контекстных вариантов
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ПоНоменклатуреКонтекст");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ПоОбластиХраненияКонтекст");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ПоСкладскойГруппеНоменклатурыКонтекст");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ПоЯчейкеКонтекст");
	ВариантыОтчетовУТПереопределяемый.ОтключитьВариантОтчета(Настройки, ОписаниеОтчета, "ДвиженияТоваровВЯчейкеКонтекст");
	
	// Настройка размещения, видимости по умолчанию, важности
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ДвиженияТоваровВЯчейке");
	ОписаниеВарианта.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецЕсли
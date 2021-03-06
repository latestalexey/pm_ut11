﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ТипПодключаемогоОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЕдиницаИзмеренияВеса");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	ДополнительныеСвойства.Вставить(
		"ЗарегистрироватьИзменения",
		НЕ ЭтоНовый()
		И (ПрефиксВесовогоТовара <> Ссылка.ПрефиксВесовогоТовара
		   ИЛИ ЕдиницаИзмеренияВеса <> Ссылка.ЕдиницаИзмеренияВеса
		)
	);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.ЗарегистрироватьИзменения Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
		|	ПодключаемоеОборудование.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.ПравилоОбмена = &ПравилоОбмена
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|");
		
		Запрос.УстановитьПараметр("ПравилоОбмена", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Метаданные.РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьРозничныйСкладПоУмолчанию(Склад);
	
КонецПроцедуры

#КонецЕсли

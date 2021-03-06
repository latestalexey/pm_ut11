﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Организация = Параметры.Организация;
	Партнер = Параметры.Партнер;
	Соглашение = Параметры.Соглашение;
	Дата = Параметры.Дата;
	АдресПлатежейВХранилище = Параметры.АдресПлатежейВХранилище;
	ПоРезультатамИнвентаризации = Параметры.ПоРезультатамИнвентаризации;
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТаблицаТоваровКоличествоУпаковокПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	СтрокаТаблицы.Выбран = (СтрокаТаблицы.КоличествоУпаковок <> 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровКоличествоУпаковокФактПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	СтрокаТаблицы.Выбран = Истина;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПоместитьТоварыВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
	ОповеститьОВыборе(АдресПлатежейВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Выбран = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ПоместитьТоварыВХранилище() 
	
	Товары = ТаблицаТоваров.Выгрузить(, "Выбран, Номенклатура, Характеристика, КоличествоУпаковок, Количество, КоличествоУпаковокФакт, КоличествоУпаковокУчет");
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаТаблицы Из Товары Цикл
		
		Если Не СтрокаТаблицы.Выбран Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаТаблицы);
		КонецЕсли;
		
		Если ПоРезультатамИнвентаризации Тогда
			СтрокаТаблицы.КоличествоУпаковок = СтрокаТаблицы.КоличествоУпаковокУчет - СтрокаТаблицы.КоличествоУпаковокФакт;
		КонецЕсли;
		СтрокаТаблицы.Количество = СтрокаТаблицы.КоличествоУпаковок;
		
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		Товары.Удалить(СтрокаТаблицы);
	КонецЦикла;

	ПоместитьВоВременноеХранилище(Товары, АдресПлатежейВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Количество КАК Количество
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|///////////////////////////////////////////////////////////////////////////////	
	|ВЫБРАТЬ
	|	ТоварыПереданные.Номенклатура КАК Номенклатура,
	|	ТоварыПереданные.Характеристика КАК Характеристика,
	|	ТоварыПереданные.КоличествоОстаток КАК КоличествоОстаток
	|
	|ПОМЕСТИТЬ ТоварыПереданные
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию.Остатки(&Граница,
	|		Организация = &Организация
	|		И Партнер = &Партнер
	|		И Соглашение = &Соглашение
	|	) КАК ТоварыПереданные
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыПереданные.Номенклатура КАК Номенклатура,
	|	ТоварыПереданные.Характеристика КАК Характеристика,
	|	ТоварыПереданные.КоличествоОстаток КАК КоличествоОстаток,
	|	ВЫБОР КОГДА ТоварыПереданные.КоличествоОстаток < 0 ТОГДА
	|		-1
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ КАК Знак
	|
	|ПОМЕСТИТЬ ТоварыПереданныеОстатки
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию.Остатки(,
	|		Организация = &Организация
	|		И Партнер = &Партнер
	|		И Соглашение = &Соглашение
	|	) КАК ТоварыПереданные
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		Ложь
	|	ИНАЧЕ
	|		Истина
	|	КОНЕЦ КАК Выбран,
	|	ТоварыПереданные.Номенклатура КАК Номенклатура,
	|	ТоварыПереданные.Характеристика КАК Характеристика,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток * ТоварыПереданныеОстатки.Знак, 0)
	|		< (ТоварыПереданные.КоличествоОстаток * ЕСТЬNULL(ТоварыПереданныеОстатки.Знак, 1))
	|	ТОГДА
	|		ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток, 0)
	|	ИНАЧЕ
	|		ТоварыПереданные.КоличествоОстаток
	|	КОНЕЦ КАК КоличествоУпаковокУчет,
	|
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ВЫБОР КОГДА ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток * ТоварыПереданныеОстатки.Знак, 0)
	|			< (ТоварыПереданные.КоличествоОстаток * ЕСТЬNULL(ТоварыПереданныеОстатки.Знак, 1))
	|		ТОГДА
	|			ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток, 0)
	|		ИНАЧЕ
	|			ТоварыПереданные.КоличествоОстаток
	|		КОНЕЦ
	|	ИНАЧЕ
	|		Товары.Количество
	|	КОНЕЦ КАК КоличествоУпаковок
	|ИЗ
	|	ТоварыПереданные КАК ТоварыПереданные
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТоварыПереданныеОстатки КАК ТоварыПереданныеОстатки
	|	ПО
	|		ТоварыПереданные.Номенклатура = ТоварыПереданныеОстатки.Номенклатура
	|		И ТоварыПереданные.Характеристика = ТоварыПереданныеОстатки.Характеристика
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Товары КАК Товары
	|	ПО
	|		ТоварыПереданные.Номенклатура = Товары.Номенклатура
	|		И ТоварыПереданные.Характеристика = Товары.Характеристика
	|
	|ГДЕ
	|	ТоварыПереданные.КоличествоОстаток <> 0
	|	И ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток, 0) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварыПереданные.Номенклатура,
	|	ТоварыПереданные.Характеристика
	|");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	
	ДатаЗаполнения = ?(ЗначениеЗаполнено(Дата), КонецДня(Дата), ТекущаяДата());
	Граница = Новый Граница(ДатаЗаполнения, ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	
	Товары = ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище);
	Товары.Свернуть("Номенклатура, Характеристика", "Количество");
	Запрос.УстановитьПараметр("Товары", Товары);
	
	ТаблицаТоваров.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Элементы.ТаблицаТоваровКоличествоУпаковок.Видимость = Не ПоРезультатамИнвентаризации;
	Элементы.ТаблицаТоваровКоличествоУпаковокФакт.Видимость = ПоРезультатамИнвентаризации;
		
КонецПроцедуры

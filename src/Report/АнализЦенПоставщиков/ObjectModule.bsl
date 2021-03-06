﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПараметрВалюта = ОбщегоНазначенияУТКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Валюта");
	
	Если ПараметрВалюта <> Неопределено И Не ПараметрВалюта.Использование Тогда
		ПараметрВалюта.Использование = Истина;
	КонецЕсли;
	
	ПараметрДокумент = ОбщегоНазначенияУТКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ФиксированныеНастройки, "Документ");
	ЗначениеПараметраДокумент = ПараметрДокумент.Значение;
	
	ТипДокумента = ТипЗнч(ЗначениеПараметраДокумент);
	
	Если ТипДокумента = Тип("СписокЗначений") Тогда
		Если ЗначениеПараметраДокумент.Количество() = 0 Тогда
			
			ПараметрДокумент          = ОбщегоНазначенияУТКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.Настройки, "Документ");
			ЗначениеПараметраДокумент = ПараметрДокумент.Значение;
			ТипДокумента              = ТипЗнч(ЗначениеПараметраДокумент);
			
			Если ТипДокумента = Тип("СписокЗначений") Тогда
				Если ЗначениеПараметраДокумент.Количество() = 0 Тогда
					Возврат;
				Иначе
					ТипДокумента = ТипЗнч(ЗначениеПараметраДокумент[0].Значение);
				КонецЕсли;
			КонецЕсли;
		Иначе
			ТипДокумента = ТипЗнч(ЗначениеПараметраДокумент[0].Значение);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипДокумента = Тип("СправочникСсылка.СделкиСКлиентами") Тогда
		
		ТекстЗапросаЗамена = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КоммерческоеПредложениеТовары.Ссылка.Сделка   КАК Ссылка,
			|	КоммерческоеПредложениеТовары.Ссылка          КАК Документ,
			|	КоммерческоеПредложениеТовары.Ссылка.Дата     КАК Дата,
			|	КоммерческоеПредложениеТовары.Ссылка.Валюта   КАК Валюта,
			|	КоммерческоеПредложениеТовары.НомерСтроки     КАК НомерСтроки,
			|	КоммерческоеПредложениеТовары.Номенклатура    КАК Номенклатура,
			|	КоммерческоеПредложениеТовары.Характеристика  КАК Характеристика,
			|	КоммерческоеПредложениеТовары.Упаковка        КАК Упаковка,
			|	КоммерческоеПредложениеТовары.Цена            КАК Цена,
			|	КоммерческоеПредложениеТовары.Цена - КоммерческоеПредложениеТовары.Цена *
			|	(КоммерческоеПредложениеТовары.ПроцентАвтоматическойСкидки +
			|	КоммерческоеПредложениеТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
			|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
			|ИЗ
			|	Документ.КоммерческоеПредложениеКлиенту.Товары КАК КоммерческоеПредложениеТовары
			|ГДЕ
			|	КоммерческоеПредложениеТовары.Ссылка.Сделка В(&Документ)
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	ЗаказКлиентаТовары.Ссылка.Сделка  КАК Ссылка,
			|	ЗаказКлиентаТовары.Ссылка         КАК Документ,
			|	ЗаказКлиентаТовары.Ссылка.Дата    КАК Дата,
			|	ЗаказКлиентаТовары.Ссылка.Валюта  КАК Валюта,
			|	ЗаказКлиентаТовары.НомерСтроки    КАК НомерСтроки,
			|	ЗаказКлиентаТовары.Номенклатура   КАК Номенклатура,
			|	ЗаказКлиентаТовары.Характеристика КАК Характеристика,
			|	ЗаказКлиентаТовары.Упаковка       КАК Упаковка,
			|	ЗаказКлиентаТовары.Цена           КАК Цена,
			|	ЗаказКлиентаТовары.Цена - ЗаказКлиентаТовары.Цена *
			|	(ЗаказКлиентаТовары.ПроцентАвтоматическойСкидки +
			|	ЗаказКлиентаТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
			|ИЗ
			|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
			|ГДЕ
			|	ЗаказКлиентаТовары.Ссылка.Сделка В(&Документ)
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ
			|	РеализацияТоваровУслугТовары.Ссылка.Сделка  КАК Ссылка,
			|	РеализацияТоваровУслугТовары.Ссылка         КАК Документ,
			|	РеализацияТоваровУслугТовары.Ссылка.Дата    КАК Дата,
			|	РеализацияТоваровУслугТовары.Ссылка.Валюта  КАК Валюта,
			|	РеализацияТоваровУслугТовары.НомерСтроки    КАК НомерСтроки,
			|	РеализацияТоваровУслугТовары.Номенклатура   КАК Номенклатура,
			|	РеализацияТоваровУслугТовары.Характеристика КАК Характеристика,
			|	РеализацияТоваровУслугТовары.Упаковка       КАК Упаковка,
			|	РеализацияТоваровУслугТовары.Цена           КАК Цена,
			|	РеализацияТоваровУслугТовары.Цена - РеализацияТоваровУслугТовары.Цена *
			|	(РеализацияТоваровУслугТовары.ПроцентАвтоматическойСкидки +
			|	РеализацияТоваровУслугТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
			|ИЗ
			|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
			|ГДЕ
			|	РеализацияТоваровУслугТовары.Ссылка.Сделка В(&Документ)
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика
			|;
			|";
			
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.КоммерческоеПредложениеКлиенту") Тогда
			
		ТекстЗапросаЗамена = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КоммерческоеПредложениеТовары.Ссылка          КАК Ссылка,
			|	КоммерческоеПредложениеТовары.Ссылка          КАК Документ,
			|	КоммерческоеПредложениеТовары.Ссылка.Дата     КАК Дата,
			|	КоммерческоеПредложениеТовары.Ссылка.Валюта   КАК Валюта,
			|	КоммерческоеПредложениеТовары.НомерСтроки     КАК НомерСтроки,
			|	КоммерческоеПредложениеТовары.Номенклатура    КАК Номенклатура,
			|	КоммерческоеПредложениеТовары.Характеристика  КАК Характеристика,
			|	КоммерческоеПредложениеТовары.Упаковка        КАК Упаковка,
			|	КоммерческоеПредложениеТовары.Цена            КАК Цена,
			|	КоммерческоеПредложениеТовары.Цена - КоммерческоеПредложениеТовары.Цена *
			|	(КоммерческоеПредложениеТовары.ПроцентАвтоматическойСкидки +
			|	КоммерческоеПредложениеТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
			|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
			|ИЗ
			|	Документ.КоммерческоеПредложениеКлиенту.Товары КАК КоммерческоеПредложениеТовары
			|ГДЕ
			|	КоммерческоеПредложениеТовары.Ссылка В(&Документ)
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика
			|;
			|";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		ТекстЗапросаЗамена = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ЗаказКлиентаТовары.Ссылка         КАК Ссылка,
			|	ЗаказКлиентаТовары.Ссылка         КАК Документ,
			|	ЗаказКлиентаТовары.Ссылка.Дата    КАК Дата,
			|	ЗаказКлиентаТовары.Ссылка.Валюта  КАК Валюта,
			|	ЗаказКлиентаТовары.НомерСтроки    КАК НомерСтроки,
			|	ЗаказКлиентаТовары.Номенклатура   КАК Номенклатура,
			|	ЗаказКлиентаТовары.Характеристика КАК Характеристика,
			|	ЗаказКлиентаТовары.Упаковка       КАК Упаковка,
			|	ЗаказКлиентаТовары.Цена           КАК Цена,
			|	ЗаказКлиентаТовары.Цена - ЗаказКлиентаТовары.Цена *
			|	(ЗаказКлиентаТовары.ПроцентАвтоматическойСкидки +
			|	ЗаказКлиентаТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
			|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
			|ИЗ
			|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
			|ГДЕ
			|	ЗаказКлиентаТовары.Ссылка В(&Документ)
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика
			|;
			|";
			
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
		ТекстЗапросаЗамена = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	РеализацияТоваровУслугТовары.Ссылка         КАК Ссылка,
			|	РеализацияТоваровУслугТовары.Ссылка         КАК Документ,
			|	РеализацияТоваровУслугТовары.Ссылка.Дата    КАК Дата,
			|	РеализацияТоваровУслугТовары.Ссылка.Валюта  КАК Валюта,
			|	РеализацияТоваровУслугТовары.НомерСтроки    КАК НомерСтроки,
			|	РеализацияТоваровУслугТовары.Номенклатура   КАК Номенклатура,
			|	РеализацияТоваровУслугТовары.Характеристика КАК Характеристика,
			|	РеализацияТоваровУслугТовары.Упаковка       КАК Упаковка,
			|	РеализацияТоваровУслугТовары.Цена           КАК Цена,
			|	РеализацияТоваровУслугТовары.Цена - РеализацияТоваровУслугТовары.Цена *
			|	(РеализацияТоваровУслугТовары.ПроцентАвтоматическойСкидки +
			|	РеализацияТоваровУслугТовары.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
			|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
			|ИЗ
			|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
			|ГДЕ
			|	РеализацияТоваровУслугТовары.Ссылка В(&Документ)
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика
			|;
			|";
			
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.АктВыполненныхРабот") Тогда
			
		ТекстЗапросаЗамена = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	АктВыполненныхРаботУслуги.Ссылка         КАК Ссылка,
			|	АктВыполненныхРаботУслуги.Ссылка         КАК Документ,
			|	АктВыполненныхРаботУслуги.Ссылка.Дата    КАК Дата,
			|	АктВыполненныхРаботУслуги.Ссылка.Валюта  КАК Валюта,
			|	АктВыполненныхРаботУслуги.НомерСтроки    КАК НомерСтроки,
			|	АктВыполненныхРаботУслуги.Номенклатура   КАК Номенклатура,
			|	АктВыполненныхРаботУслуги.Характеристика КАК Характеристика,
			|	ЗНАЧЕНИЕ (Справочник.УпаковкиНоменклатуры.ПустаяСсылка)  КАК Упаковка,
			|	АктВыполненныхРаботУслуги.Цена           КАК Цена,
			|	АктВыполненныхРаботУслуги.Цена - АктВыполненныхРаботУслуги.Цена *
			|	(АктВыполненныхРаботУслуги.ПроцентАвтоматическойСкидки +
			|	АктВыполненныхРаботУслуги.ПроцентРучнойСкидки) / 100 КАК ЦенаСоСкидкой
			|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
			|ИЗ
			|	Документ.АктВыполненныхРабот.Услуги КАК АктВыполненныхРаботУслуги
			|ГДЕ
			|	АктВыполненныхРаботУслуги.Ссылка В(&Документ)
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика
			|;
			|";
		
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ТекстЗапросаЗамена = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ЗаказПоставщикуТовары.Ссылка         КАК Ссылка,
			|	ЗаказПоставщикуТовары.Ссылка         КАК Документ,
			|	ЗаказПоставщикуТовары.Ссылка.Дата    КАК Дата,
			|	ЗаказПоставщикуТовары.Ссылка.Валюта  КАК Валюта,
			|	ЗаказПоставщикуТовары.НомерСтроки    КАК НомерСтроки,
			|	ЗаказПоставщикуТовары.Номенклатура   КАК Номенклатура,
			|	ЗаказПоставщикуТовары.Характеристика КАК Характеристика,
			|	ЗаказПоставщикуТовары.Упаковка       КАК Упаковка,
			|	ЗаказПоставщикуТовары.Цена           КАК Цена,
			|	ЗаказПоставщикуТовары.Цена - ЗаказПоставщикуТовары.Цена *
			|	ЗаказПоставщикуТовары.ПроцентРучнойСкидки / 100 КАК ЦенаСоСкидкой
			|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
			|ИЗ
			|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
			|ГДЕ
			|	ЗаказПоставщикуТовары.Ссылка В(&Документ)
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика
			|;
			|";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		
		ТекстЗапросаЗамена = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ПоступлениеТоваровУслугТовары.Ссылка         КАК Ссылка,
			|	ПоступлениеТоваровУслугТовары.Ссылка         КАК Документ,
			|	ПоступлениеТоваровУслугТовары.Ссылка.Дата    КАК Дата,
			|	ПоступлениеТоваровУслугТовары.Ссылка.Валюта  КАК Валюта,
			|	ПоступлениеТоваровУслугТовары.НомерСтроки    КАК НомерСтроки,
			|	ПоступлениеТоваровУслугТовары.Номенклатура   КАК Номенклатура,
			|	ПоступлениеТоваровУслугТовары.Характеристика КАК Характеристика,
			|	ПоступлениеТоваровУслугТовары.Упаковка       КАК Упаковка,
			|	ПоступлениеТоваровУслугТовары.Цена           КАК Цена,
			|	ПоступлениеТоваровУслугТовары.Цена - ПоступлениеТоваровУслугТовары.Цена *
			|	ПоступлениеТоваровУслугТовары.ПроцентРучнойСкидки / 100 КАК ЦенаСоСкидкой
			|ПОМЕСТИТЬ ПредварительныеДанныеДокументов
			|ИЗ
			|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
			|ГДЕ
			|	ПоступлениеТоваровУслугТовары.Ссылка В(&Документ)
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика
			|;
			|";
	КонецЕсли;
	
	ТекстЗапроса  = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
	ПозицияЗамены = Найти(ТекстЗапроса, "%1");
	ДлинаСтроки   = СтрДлина(ТекстЗапроса);
	ТекстЗапроса  = Прав(ТекстЗапроса, ДлинаСтроки - ПозицияЗамены - 1);
	ТекстЗапроса  = ТекстЗапросаЗамена + ТекстЗапроса;
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = ТекстЗапроса;
	
КонецПроцедуры

#КонецЕсли
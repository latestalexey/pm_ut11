﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидЦены = Параметры.ВидЦены;
	Цена = Параметры.Цена;
	Дата = Параметры.Дата;
	ДатаОтгрузки = Параметры.ДатаОтгрузки;
	Склад = Параметры.Склад;
	Номенклатура = Параметры.Номенклатура;
	Характеристика = Параметры.Характеристика;
	Валюта = Параметры.Валюта;
	ЦенаВключаетНДС = Параметры.ЦенаВключаетНДС;
	МаксПроцентРучнойСкидки = Параметры.МаксПроцентРучнойСкидки;
	СтараяУпаковка = Упаковка;
	
	Если МаксПроцентРучнойСкидки = 100 Тогда
		МаксПроцентРучнойСкидкиНеОграничена =  НСтр("ru = 'Не ограничена'");
		Элементы.МаксПроцентРучнойСкидкиНеОграничена.Видимость = Истина;
		Элементы.МаксПроцентРучнойСкидки.Видимость = Ложь;		
	КонецЕсли;	

	Элементы.ВидЦены.ТолькоПросмотр     = НЕ Параметры.РедактироватьВидЦены;
	Элементы.ВидЦены.ПропускатьПриВводе = НЕ Параметры.РедактироватьВидЦены;
	Элементы.Цена.ТолькоПросмотр        = НЕ Параметры.РедактироватьЦену;
	Элементы.Цена.ПропускатьПриВводе    = НЕ Параметры.РедактироватьЦену;
	
	НаименованиеТовара = "" + Параметры.Номенклатура + ?(ЗначениеЗаполнено(Параметры.Характеристика), " (" + Параметры.Характеристика + ")","");
	
	Если Параметры.СкрытьЦену Тогда
		
		Элементы.Цена.Видимость    = Ложь;
		Элементы.Валюта.Видимость  = Ложь;
		Элементы.ВидЦены.Видимость = Ложь;
		ЭтаФорма.АвтоЗаголовок     = Ложь;
		ЭтаФорма.Заголовок         = НСтр("ru = 'Ввод количества'");
		
	КонецЕсли;
	
	ИспользоватьРучныеСкидкиВПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	
	Если Не ИспользоватьРучныеСкидкиВПродажах ИЛИ Параметры.СкрыватьРучныеСкидки Тогда
		
		Элементы.ГруппаМаксимальныйПроцентРучнойСкидки.Видимость = Ложь;
		Элементы.ГруппаПроцентРучнойСкидки.Видимость = Ложь;	
		
	КонецЕсли;
		
	Если НЕ Параметры.ИспользоватьДатыОтгрузки Тогда
		Элементы.ДатаОтгрузки.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.ЭтоУслуга Тогда
		
		ДатаОтгрузки = '00010101';
		Склад = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
		Элементы.ДатаОтгрузки.Видимость = Ложь;
		
	КонецЕсли;
	
	Если НЕ Параметры.ИспользоватьСкладыВТабличнойЧасти Тогда
		Склад = Неопределено;
	КонецЕсли;
	
	ВидимостьСклада = (НЕ Параметры.ЭтоУслуга ИЛИ НЕ Параметры.ИспользоватьДатыОтгрузки) И Параметры.Склады.Количество() > 1 И Параметры.ИспользоватьСкладыВТабличнойЧасти;
	
	Элементы.Склад.Видимость = ВидимостьСклада;
	Элементы.Склад.СписокВыбора.ЗагрузитьЗначения(Параметры.Склады);
	
	Элементы.Упаковка.Видимость = ЗначениеЗаполнено(Номенклатура.НаборУпаковок);
	Элементы.ЕдиницаИзмерения.Видимость = Не ЗначениеЗаполнено(Номенклатура.НаборУпаковок);
				
	КоличествоУпаковок = 1;
	
	// Заполнить список выбора видов цен.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.Ссылка КАК ВидЦен
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	НЕ ВидыЦен.ПометкаУдаления
	|	И ВидыЦен.ИспользоватьПриПродаже
	|	И ВидыЦен.ЦенаВключаетНДС = &ЦенаВключаетНДС");
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ЦенаВключаетНДС);
	Элементы.ВидЦены.СписокВыбора.Очистить();
	Элементы.ВидЦены.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидЦен"));
	Элементы.ВидЦены.СписокВыбора.Добавить(Справочники.ВидыЦен.ПустаяСсылка(), НСтр("ru='<произвольная>'"));
	
	Элементы.Цена.Доступность = НЕ ЗначениеЗаполнено(ВидЦены);
	
	СтруктураОтбораУпаковок = Новый Структура;
	СтруктураОтбораУпаковок.Вставить("Номенклатура", Номенклатура);
	СтруктураОтбораУпаковок.Вставить("ДобавлятьПустуюУпаковку", Истина);
	
	СписокВыбораУпаковок = Справочники.УпаковкиНоменклатуры.ПолучитьДанныеВыбора(СтруктураОтбораУпаковок);
	
	Элементы.Упаковка.СписокВыбора.Очистить();
	
	УпаковкаХранения = Справочники.УпаковкиНоменклатуры.ПустаяСсылка();
	ДобавлятьПустую = Истина; 
	
	Для Каждого ЭлементСписка из СписокВыбораУпаковок Цикл
		Элементы.Упаковка.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		Если ЭлементСписка.Значение.Пустая() Тогда
			ДобавлятьПустую = Ложь;
		КонецЕсли;	
		Если ЭлементСписка.Пометка Тогда
			УпаковкаХранения = ЭлементСписка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если ДобавлятьПустую Тогда
		 ЕдиницаХранения = Строка(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура,"ЕдиницаИзмерения"));	
		 Элементы.Упаковка.СписокВыбора.Добавить(Справочники.УпаковкиНоменклатуры.ПустаяСсылка(), ЕдиницаХранения);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Параметры.Упаковка) Тогда
		Упаковка = Параметры.Упаковка;
	Иначе
		Упаковка = УпаковкаХранения;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаСервере
Процедура УпаковкаПриИзмененииНаСервере(СтараяУпаковка)
	
	Цена = Цена * ?(ЗначениеЗаполнено(Упаковка.Коэффициент), Упаковка.Коэффициент, 1) / ?(ЗначениеЗаполнено(СтараяУпаковка.Коэффициент), СтараяУпаковка.Коэффициент, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	УпаковкаПриИзмененииНаСервере(СтараяУпаковка);
	СтараяУпаковка = Упаковка;
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаОчистка(Элемент, СтандартнаяОбработка)
	
	УпаковкаПриИзмененииНаСервере(СтараяУпаковка);
	СтараяУпаковка = Упаковка;
	
КонецПроцедуры

&НаСервере
Процедура ВидЦеныПриИзмененииНаСервере()
	
	Элементы.Цена.Доступность = НЕ ЗначениеЗаполнено(ВидЦены);
	
	Если НЕ ЗначениеЗаполнено(ВидЦены) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫРАЗИТЬ(ЦеныНоменклатурыСрезПоследних.Цена * КурсыСрезПоследних.Курс / КурсыСрезПоследних.Кратность / КурсыСрезПоследнихВалютаЦены.Курс * КурсыСрезПоследнихВалютаЦены.Кратность * ЕСТЬNULL(ВЫРАЗИТЬ(&Упаковка КАК Справочник.УпаковкиНоменклатуры).Коэффициент, 1) / ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Упаковка.Коэффициент, 1) КАК ЧИСЛО(15, 2)) КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
	|			Номенклатура = &Номенклатура
	|				И Характеристика = &Характеристика
	|				И ВидЦены = &ВидЦены) КАК ЦеныНоменклатурыСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, ) КАК КурсыСрезПоследних
	|		ПО (КурсыСрезПоследних.Валюта = ЦеныНоменклатурыСрезПоследних.Валюта)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) КАК КурсыСрезПоследнихВалютаЦены
	|		ПО (ИСТИНА)");
	
	Запрос.УстановитьПараметр("ВидЦены",        ВидЦены);
	Запрос.УстановитьПараметр("Дата",           Дата);
	Запрос.УстановитьПараметр("Номенклатура",   Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Упаковка",       Упаковка);
	Запрос.УстановитьПараметр("Валюта",         Валюта);
	
	Цена = 0;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.Цена) Тогда
			Цена = Выборка.Цена;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	ВидЦеныПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаПриИзменении(Элемент)
	
	ВидЦены = Неопределено;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	ОчиститьСообщения();
	
	Если КоличествоУпаковок = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено количество'"),,"КоличествоУпаковок",,Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПодобранныеТовары = Новый Массив;
	
	ПараметрыТовара = ПодборТоваровКлиентСервер.ПараметрыТовара();
	
	ПараметрыТовара.Номенклатура        = Номенклатура;
	ПараметрыТовара.Характеристика      = Характеристика;
	ПараметрыТовара.Упаковка            = Упаковка;
	ПараметрыТовара.Цена                = Цена;
	ПараметрыТовара.ВидЦены             = ВидЦены;
	ПараметрыТовара.КоличествоУпаковок  = КоличествоУпаковок;
	ПараметрыТовара.Склад               = Склад;
	ПараметрыТовара.ДатаОтгрузки        = ДатаОтгрузки;
	ПараметрыТовара.ПроцентРучнойСкидки = ПроцентРучнойСкидки;
	
	ПодобранныеТовары.Добавить(ПараметрыТовара);
	
	Закрыть(ПодобранныеТовары);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры



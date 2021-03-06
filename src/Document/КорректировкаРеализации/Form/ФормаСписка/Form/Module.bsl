﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейПоМассивуРолей(Документы.КорректировкаРеализации.ИменаРолейСПравомДобавления())
	);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Менеджер = Настройки.Получить("Менеджер");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокКорректировкиРеализации.Отбор, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "ЭлектронныеДокументы"
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.СписокКорректировкиРеализации.Обновить();
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокКорректировкиРеализации.Отбор, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьНаОснованииРеализацииТоваровУслуг(Команда)
	
	ОткрытьФорму("Документ.КорректировкаРеализации.ФормаОбъекта",
		Новый Структура("Основание", ПредопределенноеЗначение("Документ.РеализацияТоваровУслуг.ПустаяСсылка"))
	);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииАктаВыполненныхРабот(Команда)
	
	ОткрытьФорму("Документ.КорректировкаРеализации.ФормаОбъекта",
		Новый Структура("Основание", ПредопределенноеЗначение("Документ.АктВыполненныхРабот.ПустаяСсылка"))
	);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииРеализацииУслугПрочихАктивов(Команда)
	
	ОткрытьФорму("Документ.КорректировкаРеализации.ФормаОбъекта",
		Новый Структура("Основание", ПредопределенноеЗначение("Документ.РеализацияУслугПрочихАктивов.ПустаяСсылка"))
	);
	
КонецПроцедуры


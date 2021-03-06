﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокРаспоряжений.Отбор, "Статус", Перечисления.СтатусыРаспоряженийНаПроведениеИнвентаризацийТоваров.ВРаботе, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокРаспоряжений.Отбор, "ДатаНачала", НачалоДня(ТекущаяДата()), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,, Истина);
 	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокРаспоряжений.Отбор, "ДатаОкончания", НачалоДня(ТекущаяДата()), ВидСравненияКомпоновкиДанных.БольшеИлиРавно,, Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокРаспоряжений.Отбор, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокРаспоряжений, "Склад", Склад, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокПересчетов, "Склад", Склад, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокПересчетов, "Помещение", Помещение, СтруктураБыстрогоОтбора);
	
	ИспользоватьРаспоряженияНаИнвентаризацию = ПолучитьФункциональнуюОпцию("ИспользоватьРаспоряженияНаИнвентаризацию");
	Если ИспользоватьРаспоряженияНаИнвентаризацию Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаСоздать", "Видимость", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаСкопировать", "Видимость", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокПересчетовКонтекстноеМенюСоздать", "Видимость", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокПересчетовКонтекстноеМенюСкопировать", "Видимость", Ложь);
	Иначе
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	УстановитьТекущуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.ПодключитьОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Склад = Настройки.Получить("Склад");
	Помещение = Настройки.Получить("Помещение");
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбора.Свойство("Склад") Тогда
			Склад = СтруктураБыстрогоОтбора.Склад;
			Настройки.Удалить("Склад");
		КонецЕсли;
		
		Если СтруктураБыстрогоОтбора.Свойство("Помещение") Тогда
			Помещение = СтруктураБыстрогоОтбора.Помещение;
			Настройки.Удалить("Помещение");
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокРаспоряжений.Отбор, "Склад", Склад, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Склад));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПересчетов.Отбор, "Склад", Склад, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Склад));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПересчетов.Отбор, "Помещение", Помещение, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Помещение));
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Склад));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	СкладПомещениеПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОтборПомещениеПриИзменении(Элемент)
	СкладПомещениеПриИзмененииСервер();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьПересчетТоваровПоРаспоряжению(Команда)
	ТекущиеДанные = Элементы.СписокРаспоряжений.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Помещение",Помещение);
		ЗначенияЗаполнения.Вставить("ДокументОснование",ТекущиеДанные.Ссылка);
		
		ОткрытьФорму("Документ.ПересчетТоваров.ФормаОбъекта",Новый Структура("ЗначенияЗаполнения",ЗначенияЗаполнения));
		
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СписокПересчетовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = ИспользоватьРаспоряженияНаИнвентаризацию;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// При изменении реквизитов

&НаСервере
Процедура СкладПомещениеПриИзмененииСервер()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокРаспоряжений.Отбор, "Склад", Склад, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Склад));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПересчетов.Отбор, "Помещение", Помещение, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Помещение));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокПересчетов.Отбор, "Склад", Склад, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Склад));
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Склад));
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Штрихкоды и торговое оборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПересчетТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.СписокПересчетов.ТекущаяСтрока = МассивСсылок[0];
		ОткрытьЗначение(МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура УстановитьТекущуюСтраницу()
	
	ИмяТекущейСтраницы = "";
	
	Если Параметры.Свойство("ИмяТекущейСтраницы", ИмяТекущейСтраницы) Тогда
		Если ЗначениеЗаполнено(ИмяТекущейСтраницы) Тогда
			ТекущийЭлемент = Элементы[ИмяТекущейСтраницы];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

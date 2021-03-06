﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.Ссылка КАК Склад
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	(Склады.ИспользоватьОрдернуюСхемуПриОтгрузке
	|		ИЛИ Склады.ИспользоватьОрдернуюСхемуПриПоступлении)
	|	И Склады.ЭтоГруппа = ЛОЖЬ
	|");
	Элементы.Склад.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Склад"));

	СкладПомещениеПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	СкладПомещениеПриИзмененииСервер();
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

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПомещениеПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	
	СкладПомещениеПриИзмененииСервер();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ ЖУРНАЛ ОРДЕРОВ

&НаКлиенте
Процедура ЖурналОрдеровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	Если ИспользоватьСкладскиеПомещения Тогда
		СоздатьОрдерНаПеремещениеКлиент();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьОрдерНаПеремещение(Команда)
	
	СоздатьОрдерНаПеремещениеКлиент();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// При изменении реквизитов

&НаСервере
Процедура СкладПомещениеПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(Склад) Тогда
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Склад));
		Элементы.ГруппаПомещение.ТекущаяСтраница = Элементы.СтраницаПомещение;
	Иначе
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Неопределено));
		Элементы.ГруппаПомещение.ТекущаяСтраница = Элементы.СтраницаПустая;
	КонецЕсли;
	
	Элементы.ЖурналОрдеровСтатус.Видимость = СкладыСервер.ИспользоватьСтатусыОрдеров(Склад);
	
	ИспользоватьСкладскиеПомещения = СкладыСервер.ИспользоватьСкладскиеПомещения(Склад);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЖурналОрдеров.Отбор, "Склад", Склад, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	ИспользоватьОтборПоПомещению = ЗначениеЗаполнено(Помещение);
	
	ГруппаЭлеметовОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(ЖурналОрдеров.Отбор.Элементы, "ОтборПоПомещению",
																					ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
																					
	Если Не ИспользоватьОтборПоПомещению Тогда
		ГруппаЭлеметовОтбора.Использование = Ложь;
	Иначе
		ГруппаЭлеметовОтбора.Использование = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаЭлеметовОтбора, "ПомещениеОтправитель", Помещение,
															ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаЭлеметовОтбора, "ПомещениеПолучатель", Помещение,
															ВидСравненияКомпоновкиДанных.Равно,,Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Штрихкоды и торговое оборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПриходныйОрдерНаТовары.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.РасходныйОрдерНаТовары.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаПеремещениеТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Элементы.ЖурналОрдеров.ТекущаяСтрока = Ссылка;
		
		ОткрытьЗначение(Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерНаПеремещениеКлиент()
	
	Основание = Новый Структура;
	Основание.Вставить("Склад", Склад);
	Основание.Вставить("ПомещениеОтправитель", Помещение);
	
	ОткрытьФорму("Документ.ОрдерНаперемещениеТоваров.Форма.ФормаДокумента",Новый Структура("Основание",Основание));
	
КонецПроцедуры


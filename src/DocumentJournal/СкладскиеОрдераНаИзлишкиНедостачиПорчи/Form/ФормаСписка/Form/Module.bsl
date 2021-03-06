﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ИспользоватьКачествоТоваров = ПолучитьФункциональнуюОпцию("ИспользоватьКачествоТоваров");
	
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
	
	Если ИмяСобытия = "Запись_ОрдерНаОтражениеРезультатовПересчетовТоваров" Тогда
		Элементы.СписокОснованияКОформлению.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Склад = Настройки.Получить("Склад");
	Помещение = Настройки.Получить("Помещение");
	СкладПомещениеПриИзмененииСервер();
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
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ СПИСОК ОРДЕРОВ

&НаКлиенте
Процедура СписокОрдеровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров"),,,БиблиотекаКартинок.Документ);
	СписокЗначений.Добавить(Тип("ДокументСсылка.ОрдерНаОтражениеНедостачТоваров"),,,БиблиотекаКартинок.Документ);
	
	Если ИспользоватьКачествоТоваров Тогда
		СписокЗначений.Добавить(Тип("ДокументСсылка.ОрдерНаОтражениеПорчиТоваров"),,,БиблиотекаКартинок.Документ);
	КонецЕсли;
	
	ВыбранноеЗначение = СписокЗначений.ВыбратьЭлемент(НСтр("ru = 'Выбор типа документа'"));
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		СоздатьОрдерКлиент(ВыбранноеЗначение.Значение)
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьОрдер(Команда)
	ТекущиеДанные = Элементы.СписокОснованияКОформлению.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ОткрытьФорму("Документ.ОрдерНаОтражениеРезультатовПересчетовТоваров.Форма.ФормаДокумента",
		             Новый Структура("Основание",
					                 Новый Структура("ДокументОснование, Склад, Помещение",
									 ТекущиеДанные.Ссылка, Склад, Помещение)));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерНаОтражениеИзлишков(Команда)
	
	СоздатьОрдерКлиент(Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерНаОтражениеНедостач(Команда)
	
	СоздатьОрдерКлиент(Тип("ДокументСсылка.ОрдерНаОтражениеНедостачТоваров"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерНаОтражениеПорчи(Команда)
	
	СоздатьОрдерКлиент(Тип("ДокументСсылка.ОрдерНаОтражениеПорчиТоваров"));
	
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
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокОрдеров.Отбор, "Склад",Склад, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокОрдеров.Отбор, "Помещение",Помещение, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	СписокОснованияКОформлению.Параметры.УстановитьЗначениеПараметра("Склад", Склад); 
	СписокОснованияКОформлению.Параметры.УстановитьЗначениеПараметра("Помещение", Помещение); 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Штрихкоды и торговое оборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаОтражениеИзлишковТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаОтражениеНедостачТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаОтражениеПорчиТоваров.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОрдерНаОтражениеРезультатовПересчетовТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаОрдера;
		
		ОткрытьЗначение(Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОрдерКлиент(Тип)
	Основание = Новый Структура;
	Основание.Вставить("Склад", Склад);
	Основание.Вставить("Помещение", Помещение);
	
	Если Тип = Тип("ДокументСсылка.ОрдерНаОтражениеИзлишковТоваров") Тогда
		ОткрытьФорму("Документ.ОрдерНаОтражениеИзлишковТоваров.ФормаОбъекта",Новый Структура("Основание",Основание));
	ИначеЕсли Тип = Тип("ДокументСсылка.ОрдерНаОтражениеНедостачТоваров") Тогда
		ОткрытьФорму("Документ.ОрдерНаОтражениеНедостачТоваров.ФормаОбъекта",Новый Структура("Основание",Основание));
	ИначеЕсли Тип = Тип("ДокументСсылка.ОрдерНаОтражениеПорчиТоваров") Тогда
		ОткрытьФорму("Документ.ОрдерНаОтражениеПорчиТоваров.ФормаОбъекта",Новый Структура("Основание",Основание));
	КонецЕсли;
	
КонецПроцедуры

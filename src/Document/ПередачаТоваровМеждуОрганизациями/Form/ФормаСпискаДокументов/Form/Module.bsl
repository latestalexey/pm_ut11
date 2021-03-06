﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	УстановитьПараметрыДинамическихСписков();
	
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
	
	Если ИмяСобытия = "Запись_ПередачаТоваровМеждуОрганизациями" Тогда
		Элементы.ТоварыОрганизацийКПередаче.Обновить();
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаКОформлению Тогда
		Элементы.ТоварыОрганизацийКПередаче.Обновить();
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьПередачуТоваров(Команда)
	
	Строка = Элементы.ТоварыОрганизацийКПередаче.ТекущиеДанные;
	Если Строка <> Неопределено Тогда
		
		СтруктураОснование = Новый Структура("
			|Организация,
			|ОрганизацияПолучатель,
			|Склад,
			|ТипЗапасов,
			|ПередачаПодДеятельность,
			|НачалоПериода,
			|КонецПериода,
			|ЗаполнятьПоСхеме",
			Строка.Отправитель,
			Строка.Получатель,
			Строка.Склад,
			Строка.ТипЗапасов,
			Строка.ПередачаПодДеятельность,
			Период.ДатаНачала,
			Период.ДатаОкончания,
			Истина // ЗаполнениеПоСхеме
		);
		СтруктураПараметры = Новый Структура;
		СтруктураПараметры.Вставить("Основание", СтруктураОснование);
		ОткрытьФорму("Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПередачуНаКомиссию(Команда)
	
	ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию");

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.ПередачаТоваровМеждуОрганизациями.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Штрихкоды и торговое оборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПередачаТоваровМеждуОрганизациями.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ОткрытьЗначение(МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	ДатаОстатков = ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, Дата(2399, 1, 1));
	Граница = Новый Граница(КонецДня(ДатаОстатков), ВидГраницы.Включая);
	ТоварыОрганизацийКПередаче.Параметры.УстановитьЗначениеПараметра("Граница", Граница);
	
КонецПроцедуры

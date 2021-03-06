﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Дата = Параметры.Дата;
	Организация = Параметры.Организация;
	БанковскийСчет = Параметры.БанковскийСчет;
	ПодборВходящихПлатежей = Параметры.ПодборВходящихПлатежей;
	АдресПлатежейВХранилище = Параметры.АдресПлатежейВХранилище;
	ВыпискаПоРасчетномуСчету = Параметры.ВыпискаПоРасчетномуСчету;
	
	ЗаполнитьТаблицуПлатежей(Неопределено);
	УправлениеЭлементамиФормы();
	ЗаполнитьСпискиХозяйственныхОпераций();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	МассивСобытий = Новый Массив;
	МассивСобытий.Добавить("Запись_ОтчетБанкаПоОперациямЭквайринга");
	МассивСобытий.Добавить("Запись_ПоступлениеБезналичныхДенежныхСредств");
	МассивСобытий.Добавить("Запись_СписаниеБезналичныхДенежныхСредств");
	
	Если МассивСобытий.Найти(ИмяСобытия) <> Неопределено Тогда
		ЗаполнитьТаблицуПлатежей(Источник);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПеренестиВДокумент()

	ПоместитьПлатежиВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
	Структура = Новый Структура("ПодборВходящихПлатежей, АдресПлатежейВХранилище", ПодборВходящихПлатежей, АдресПлатежейВХранилище);
	ОповеститьОВыборе(Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПлатежи()

	Для Каждого СтрокаТаблицы Из ТаблицаПлатежей Цикл
		СтрокаТаблицы.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьПлатежи()

	Для Каждого СтрокаТаблицы Из ТаблицаПлатежей Цикл
		СтрокаТаблицы.Выбран = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеПлатежи(Команда)
	
	МассивСтрок = Элементы.ТаблицаПлатежей.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаПлатежей.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеПлатежи(Команда)
	
	МассивСтрок = Элементы.ТаблицаПлатежей.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаПлатежей.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеОплатыОтКлиента(Команда)
	
	СоздатьПоступлениеБезналичныхДенежныхСредств(0);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтПоставщика()

	СоздатьПоступлениеБезналичныхДенежныхСредств(1);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочееПоступлениеДенежныхСредств()

	СоздатьПоступлениеБезналичныхДенежныхСредств(2);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочиеДоходы(Команда)
	
	СоздатьПоступлениеБезналичныхДенежныхСредств(3);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочиеРасходы(Команда)

	СоздатьСписаниеБезналичныхДенежныхСредств(4);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОтчетБанкаПоОперациямЭквайринга(Команда)
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("Организация", Организация));
	ОткрытьФорму("Документ.ОтчетБанкаПоОперациямЭквайринга.ФормаОбъекта", СтруктураПараметры, Элементы.ТаблицаПлатежей);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуПлатежей(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПлатеж(Команда)
	
	СтрокаТаблицы = Элементы.ТаблицаПлатежей.ТекущиеДанные;
	Если СтрокаТаблицы <> Неопределено Тогда
		ОткрытьЗначение(СтрокаТаблицы.ПлатежныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Создание документов

&НаКлиенте
Процедура СоздатьПоступлениеБезналичныхДенежныхСредств(ХозяйственнаяОперацияИндекс)

	ХозяйственнаяОперация = СписокХозяйственныхОпераций[ХозяйственнаяОперацияИндекс].Значение;

	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация", Организация);
	ДанныеЗаполнения.Вставить("БанковскийСчет", БанковскийСчет);
	ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	СтруктураПараметры = Новый Структура("Основание", ДанныеЗаполнения);
	ОткрытьФорму("Документ.ПоступлениеБезналичныхДенежныхСредств.ФормаОбъекта", СтруктураПараметры, Элементы.ТаблицаПлатежей);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеБезналичныхДенежныхСредств(ХозяйственнаяОперацияИндекс)

	ХозяйственнаяОперация = СписокХозяйственныхОпераций[ХозяйственнаяОперацияИндекс].Значение;

	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация", Организация);
	ДанныеЗаполнения.Вставить("БанковскийСчет", БанковскийСчет);
	ДанныеЗаполнения.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	СтруктураПараметры = Новый Структура("Основание", ДанныеЗаполнения);
	ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаОбъекта", СтруктураПараметры, Элементы.ТаблицаПлатежей);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ЗаполнитьСпискиХозяйственныхОпераций()
	
	СписокХозяйственныхОпераций.Очистить();
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика);
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств);
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПрочиеДоходы);
	
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПрочиеРасходы);
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьПлатежиВХранилище() 
	
	Таблица = ТаблицаПлатежей.Выгрузить(, "Выбран, ПлатежныйДокумент, Сумма");
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если Не СтрокаТаблицы.Выбран Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		Таблица.Удалить(СтрокаТаблицы);
	КонецЦикла;

	ПоместитьВоВременноеХранилище(Таблица, АдресПлатежейВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПоВходящимПлатежам()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДенежныеСредства.Документ В (&МассивПлатежныхДокументов) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК Выбран,
	|	ДенежныеСредства.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ДенежныеСредства.Документ КАК ПлатежныйДокумент,
	|	ДенежныеСредства.Документ.ТипПлатежногоДокумента КАК ТипПлатежногоДокумента,
	|
	|	ВЫБОР КОГДА ДенежныеСредства.Документ ССЫЛКА Документ.ПоступлениеБезналичныхДенежныхСредств ТОГДА
	|		ДенежныеСредства.Документ.НомерВходящегоДокумента
	|	ИНАЧЕ
	|		ДенежныеСредства.Документ.Номер
	|	КОНЕЦ КАК Номер,
	|
	|	ВЫБОР КОГДА ДенежныеСредства.Документ ССЫЛКА Документ.ПоступлениеБезналичныхДенежныхСредств ТОГДА
	|		ДенежныеСредства.Документ.ДатаВходящегоДокумента
	|	ИНАЧЕ
	|		ДенежныеСредства.Документ.Дата
	|	КОНЕЦ КАК Дата,
	|
	|	ДенежныеСредства.Документ.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДенежныеСредства.Документ.Контрагент КАК Контрагент,
	|	ДенежныеСредства.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКПоступлениюБезналичные.Остатки(,
	|		Организация = &Организация
	|		И БанковскийСчет = &БанковскийСчет
	|		И ТипДенежныхСредств <> ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствКПоступлению.КонвертацияВалюты)
	|	) КАК ДенежныеСредства
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ВыпискаПоРасчетномуСчету.ВходящиеПлатежи КАК ВходящиеПлатежи
	|	ПО
	|		ДенежныеСредства.Документ = ВходящиеПлатежи.ПлатежныйДокумент
	|		И ВходящиеПлатежи.Ссылка <> &ВыпискаПоРасчетномуСчету
	|		И ВходящиеПлатежи.Ссылка.Проведен
	|
	|ГДЕ
	|	ДенежныеСредства.СуммаОстаток > 0
	|	И ЕСТЬNULL(ДенежныеСредства.Документ.ДатаВходящегоДокумента, ДенежныеСредства.Документ.Дата) <= &Дата
	|	И ВходящиеПлатежи.ПлатежныйДокумент ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Истина КАК Выбран,
	|	ДенежныеСредства.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ДенежныеСредства.Документ КАК ПлатежныйДокумент,
	|	ДенежныеСредства.Документ.ТипПлатежногоДокумента КАК ТипПлатежногоДокумента,
	|
	|	ВЫБОР КОГДА ДенежныеСредства.Документ ССЫЛКА Документ.ПоступлениеБезналичныхДенежныхСредств ТОГДА
	|		ДенежныеСредства.Документ.НомерВходящегоДокумента
	|	ИНАЧЕ
	|		ДенежныеСредства.Документ.Номер
	|	КОНЕЦ КАК Номер,
	|
	|	ВЫБОР КОГДА ДенежныеСредства.Документ ССЫЛКА Документ.ПоступлениеБезналичныхДенежныхСредств ТОГДА
	|		ДенежныеСредства.Документ.ДатаВходящегоДокумента
	|	ИНАЧЕ
	|		ДенежныеСредства.Документ.Дата
	|	КОНЕЦ КАК Дата,
	|
	|	ДенежныеСредства.Документ.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДенежныеСредства.Документ.Контрагент КАК Контрагент,
	|	ДенежныеСредства.СуммаПриход КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКПоступлениюБезналичные.Обороты(,, Авто,
	|		Организация = &Организация
	|		И БанковскийСчет = &БанковскийСчет
	|		И Документ В (&МассивПлатежныхДокументов)
	|		И ТипДенежныхСредств <> ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствКПоступлению.КонвертацияВалюты)
	|	) КАК ДенежныеСредства
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.Ссылка В (&МассивПлатежныхДокументов) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК Выбран,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствКПоступлению.ПоступлениеОтБанкаПоЭквайрингу) КАК ТипДенежныхСредств,
	|	ДанныеДокумента.Ссылка КАК ПлатежныйДокумент,
	|	Неопределено КАК ТипПлатежногоДокумента,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Дата,
	|	Неопределено КАК ХозяйственнаяОперация,
	|	Неопределено КАК Контрагент,
	|	ДанныеДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ВыпискаПоРасчетномуСчету.ВходящиеПлатежи КАК Выписка
	|	ПО
	|		ДанныеДокумента.Ссылка = Выписка.ПлатежныйДокумент
	|		И Выписка.Ссылка <> &ВыпискаПоРасчетномуСчету
	|		И Выписка.Ссылка.Проведен
	|
	|ГДЕ
	|	Не ДанныеДокумента.ПометкаУдаления
	|	И ДанныеДокумента.Организация = &Организация
	|	И ДанныеДокумента.ДоговорЭквайринга.БанковскийСчет = &БанковскийСчет
	|	И ДанныеДокумента.СуммаДокумента = 0
	|	И Выписка.ПлатежныйДокумент ЕСТЬ NULL
	|	И ДанныеДокумента.Дата <= &Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Номер
	|");
	Запрос.УстановитьПараметр("Дата", КонецДня(Дата)); 
	Запрос.УстановитьПараметр("Организация", Организация); 
	Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчет); 
	Запрос.УстановитьПараметр("ВыпискаПоРасчетномуСчету", ВыпискаПоРасчетномуСчету);
	
	МассивПлатежныхДокументов = Платежи.Выгрузить(,).ВыгрузитьКолонку("ПлатежныйДокумент");
	Запрос.УстановитьПараметр("МассивПлатежныхДокументов", МассивПлатежныхДокументов); 
	
	ТаблицаПлатежей.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПоИсходящимПлатежам()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДенежныеСредства.Документ В (&МассивПлатежныхДокументов) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК Выбран,
	|	ДенежныеСредства.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ДенежныеСредства.Документ КАК ПлатежныйДокумент,
	|	ДенежныеСредства.Документ.ТипПлатежногоДокумента КАК ТипПлатежногоДокумента,
	|	ДенежныеСредства.Документ.Номер КАК Номер,
	|	ДенежныеСредства.Документ.Дата КАК Дата,
	|	ДенежныеСредства.Документ.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДенежныеСредства.Документ.Контрагент КАК Контрагент,
	|	(-ДенежныеСредства.СуммаОстаток) КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКСписаниюБезналичные.Остатки(,
	|		Организация = &Организация
	|		И БанковскийСчет = &БанковскийСчет
	|	) КАК ДенежныеСредства
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ВыпискаПоРасчетномуСчету.ИсходящиеПлатежи КАК ИсходящиеПлатежи
	|	ПО
	|		ДенежныеСредства.Документ = ИсходящиеПлатежи.ПлатежныйДокумент
	|		И ИсходящиеПлатежи.Ссылка <> &ВыпискаПоРасчетномуСчету
	|		И ИсходящиеПлатежи.Ссылка.Проведен
	|ГДЕ
	|	ДенежныеСредства.СуммаОстаток < 0
	|	И ДенежныеСредства.Документ.Дата <= &Дата
	|	И ИсходящиеПлатежи.ПлатежныйДокумент ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Истина КАК Выбран,
	|	ДенежныеСредства.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ДенежныеСредства.Документ КАК ПлатежныйДокумент,
	|	ДенежныеСредства.Документ.ТипПлатежногоДокумента КАК ТипПлатежногоДокумента,
	|	ДенежныеСредства.Документ.Номер КАК Номер,
	|	ДенежныеСредства.Документ.Дата КАК Дата,
	|	ДенежныеСредства.Документ.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ДенежныеСредства.Документ.Контрагент КАК Контрагент,
	|	ДенежныеСредства.СуммаРасход КАК Сумма
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКСписаниюБезналичные.Обороты(,, Авто,
	|		Организация = &Организация
	|		И БанковскийСчет = &БанковскийСчет
	|		И Документ В (&МассивПлатежныхДокументов)
	|	) КАК ДенежныеСредства
	|ГДЕ
	|	ДенежныеСредства.Организация = &Организация
	|	И ДенежныеСредства.БанковскийСчет = &БанковскийСчет
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Номер
	|");
	Запрос.УстановитьПараметр("Дата", КонецДня(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("БанковскийСчет", БанковскийСчет);
	Запрос.УстановитьПараметр("ВыпискаПоРасчетномуСчету", ВыпискаПоРасчетномуСчету);
	
	МассивПлатежныхДокументов = Платежи.Выгрузить(,).ВыгрузитьКолонку("ПлатежныйДокумент");
	Запрос.УстановитьПараметр("МассивПлатежныхДокументов", МассивПлатежныхДокументов); 
	
	ТаблицаПлатежей.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПлатежей(ПлатежныйДокумент)
	
	Если Платежи.Количество() = 0 Тогда
		Платежи.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПлатежныйДокумент) Тогда
		НоваяСтрока = Платежи.Добавить();
		НоваяСтрока.ПлатежныйДокумент = ПлатежныйДокумент;
	КонецЕсли;
	
	Если ПодборВходящихПлатежей Тогда
		ЗаполнитьТаблицуПоВходящимПлатежам();
	Иначе
		ЗаполнитьТаблицуПоИсходящимПлатежам();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если ПодборВходящихПлатежей Тогда
		Заголовок = "Подбор входящих платежей";
		Элементы.ГруппаСоздатьСписание.Видимость = Ложь;
	Иначе
		Заголовок = "Подбор исходящих платежей";
		Элементы.ГруппаСоздатьПоступление.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	
КонецПроцедуры

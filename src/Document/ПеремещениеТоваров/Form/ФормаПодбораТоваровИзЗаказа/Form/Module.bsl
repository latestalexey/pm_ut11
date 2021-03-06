﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.Накладная);
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если Модифицированность Тогда

		Ответ = Вопрос(НСтр("ru = 'Данные были изменены. Перенести изменения в документ?'"), РежимДиалогаВопрос.ДаНетОтмена);

		Если Ответ = КодВозвратаДиалога.Да Тогда

			Отказ = Истина;
			// Снятие модифицированности, т.к. перед закрытием признак проверяется.
			Модифицированность = Ложь;

			ПеренестиСтрокиВДокумент();

		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда

			Отказ = Истина;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ТОВАРЫ

&НаКлиенте
Процедура ТаблицаТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаТовары.ТекущиеДанные <> Неопределено Тогда
		Если Поле.Имя = "ТаблицаТоварыЗаказНаПеремещение" Тогда
			ОткрытьЗначение(Элементы.ТаблицаТовары.ТекущиеДанные.ЗаказНаПеремещение);
		ИначеЕсли Поле.Имя = "ТаблицаТоварыСделка" Тогда
			ОткрытьЗначение(Элементы.ТаблицаТовары.ТекущиеДанные.Сделка);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНД

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)

	ПеренестиСтрокиВДокумент();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтроки(Команда)

	ОтметитьСтроки(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки(Команда)

	ОтметитьСтроки(Ложь);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
//Прочее

&НаСервере
Функция ПоместитьТоварыВХранилище()

	АдресВХранилище = ПоместитьВоВременноеХранилище(Новый Структура("Товары",
			ТаблицаТовары.Выгрузить(Новый Структура("СтрокаВыбрана", Истина))));

	Возврат АдресВХранилище;

КонецФункции

&НаКлиенте
Процедура ПеренестиСтрокиВДокумент()

	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;

	АдресВХранилище = ПоместитьТоварыВХранилище();

	Закрыть();

	ОповеститьОВыборе(Новый Структура("ВыполняемаяОперация, АдресВХранилище",
						"ПодборТоваровИзЗаказа", АдресВХранилище));

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	ДанныеОтбора = Новый Структура();
	ДанныеОтбора.Вставить("Организация",      Параметры.Организация);
	ДанныеОтбора.Вставить("Подразделение",    Параметры.Подразделение);
	ДанныеОтбора.Вставить("СкладОтправитель", Параметры.СкладОтправитель);
	ДанныеОтбора.Вставить("СкладПолучатель",  Параметры.СкладПолучатель);
	ДанныеОтбора.Вставить("Ссылка",           Параметры.Накладная);
	ДанныеОтбора.Вставить("Дата",             Параметры.Дата);
	
	Если Не ЗначениеЗаполнено(Параметры.Заказ) Или ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеПоНесколькимЗаказам") Тогда
		МассивЗаказов = Неопределено;
	Иначе
		МассивЗаказов = Новый Массив();
		МассивЗаказов.Добавить(Параметры.Заказ);
	КонецЕсли;
	
	Документы.ПеремещениеТоваров.ЗаполнитьПоОстаткамЗаказов(
		ДанныеОтбора,
		ТаблицаТовары,
		МассивЗаказов
	);
	
	ЗаказыСервер.УстановитьПризнакиПрисутствияСтрокиВДокументе(ТаблицаТовары, "ЗаказНаПеремещение", Параметры.МассивКодовСтрок);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьСтроки(Значение)

	Для Каждого СтрокаТЧ Из ТаблицаТовары.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не Значение)) Цикл

		СтрокаТЧ.СтрокаВыбрана = Значение;

	КонецЦикла;

КонецПроцедуры





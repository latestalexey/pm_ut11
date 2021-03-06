﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ТипРасчетовРасчетыСКлиентом = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
	СписаниеДебиторскойЗадолженности = Перечисления.ХозяйственныеОперации.СписаниеДебиторскойЗадолженности;
	СписаниеКредиторскойЗадолженности = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности;
	ТипСсылкаКонтрагенты = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ТипСсылкаОрганизации = Новый ОписаниеТипов("СправочникСсылка.Организации");
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ПодборПоРасчетамСПартнерами" Тогда
		
		Если РезультатВыбора.ХозяйственнаяОперация = СписаниеДебиторскойЗадолженности Тогда
			ПолучитьДебиторскуюЗадолженностиИзХранилища(РезультатВыбора.АдресПлатежейВХранилище);
		Иначе
			ПолучитьКредиторскуюЗадолженностиИзХранилища(РезультатВыбора.АдресПлатежейВХранилище);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияУТ.ПолучитьКартинкуКомментария(Объект.Комментарий);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	
	Если Объект.СуммаДокумента <> 0
	 И (Объект.ДебиторскаяЗадолженность.Итог("Сумма") > 0
		ИЛИ Объект.КредиторскаяЗадолженность.Итог("Сумма") > 0) Тогда
	
		ТекстВопроса = НСтр("ru = 'Суммы дебиторской и кредиторской задолженности будут скорректированы, продолжить?'");
		КодОтвета = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если КодОтвета = КодВозвратаДиалога.Да Тогда
			РассчитатьСуммыВзаимозачета(Объект.СуммаДокумента);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	Если ФинансыКлиент.НеобходимПересчетВВалюту(Объект, ТекущаяВалюта, Объект.Валюта)
	 И ФинансыКлиент.РазрешенПересчетВВалюту(Объект.Валюта) Тогда
		
		ПересчетСуммДокументаВВалюту();
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ТекущаяВалюта, Объект.Валюта);
		ТекущаяВалюта = Объект.Валюта;
		
	Иначе
		
		Объект.Валюта = ТекущаяВалюта;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияКомментария(Элемент.ТекстРедактирования, Объект.Комментарий, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыМеждуОрганизациямиДебиторПриИзменении(Элемент)
	УстановитьТипДебитора();
КонецПроцедуры

&НаКлиенте
Процедура РасчетыМеждуОрганизациямиКредиторПриИзменении(Элемент)
	УстановитьТипКредитора();
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентДебиторПриИзменении(Элемент)
	ЕстьСтроки = Объект.ДебиторскаяЗадолженность.Количество()>0;
	ОчиститьТЧ = НужноОчищатьТЧ(ЕстьСтроки);
	ЗаполнитьПартнераДебитора(ЕстьСтроки, ОчиститьТЧ);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентКредиторПриИзменении(Элемент)
	ЕстьСтроки = Объект.КредиторскаяЗадолженность.Количество()>0;
	ОчиститьТЧ = НужноОчищатьТЧ(ЕстьСтроки);
	ЗаполнитьПартнераКредитора(ЕстьСтроки, ОчиститьТЧ);
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииСервер()
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ ДЕБИТОРСКАЯ ЗАДОЛЖЕННОСТЬ

&НаКлиенте
Процедура ДебиторскаяЗадолженностьПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТаблицы = Элементы.ДебиторскаяЗадолженность.ТекущиеДанные;
	
	Если НоваяСтрока и Не Копирование Тогда
		
		Если Не ЗначениеЗаполнено(ПартнерДебитор) Тогда
			ЗаполнитьПартнераДебитора();
		КонецЕсли;
		
		СтрокаТаблицы.Партнер = ПартнерДебитор;
		
		СуммаОстаток = Объект.СуммаДокумента - Объект.ДебиторскаяЗадолженность.Итог("Сумма");
		Элемент.ТекущиеДанные.Сумма = СуммаОстаток;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ДебиторскаяЗадолженностьТипРасчетовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ДебиторскаяЗадолженность.ТекущиеДанные;
	СтрокаТаблицы.Заказ = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ДебиторскаяЗадолженностьЗаказНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.ДебиторскаяЗадолженность.ТекущиеДанные;
	ФинансыКлиент.ДокументРасчетовНачалоВыбора(
		Объект.Организация,
		СтрокаТаблицы.Партнер,
		Объект.КонтрагентДебитор,
		Неопределено, // Соглашение
		(СтрокаТаблицы.ТипРасчетов = ТипРасчетовРасчетыСКлиентом),  //ЭтоРасчетыСКлиентами
		Ложь, // ВыборОснованияПлатежа
		Элемент,
		СтандартнаяОбработка
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ДебиторскаяЗадолженностьЗаказОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элементы.ДебиторскаяЗадолженность.ТекущиеДанные;	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДебиторскаяЗадолженностьСуммаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ДебиторскаяЗадолженность.ТекущиеДанные;
	Если Объект.Валюта = СтрокаТаблицы.ВалютаВзаиморасчетов Тогда
		СтрокаТаблицы.СуммаВзаиморасчетов = СтрокаТаблицы.Сумма;
	Иначе
		СтрокаТаблицы.СуммаВзаиморасчетов = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДебиторскаяЗадолженностьВалютаВзаиморасчетовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ДебиторскаяЗадолженность.ТекущиеДанные;
	СтрокаТаблицы.СуммаВзаиморасчетов = 0;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ КРЕДИТОРСКАЯ ЗАДОЛЖЕННОСТЬ

&НаКлиенте
Процедура КредиторскаяЗадолженностьПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	СтрокаТаблицы = Элементы.КредиторскаяЗадолженность.ТекущиеДанные;
	
	Если НоваяСтрока и Не Копирование Тогда
		
		Если Не ЗначениеЗаполнено(ПартнерКредитор) Тогда
			ЗаполнитьПартнераКредитора();
		КонецЕсли;
		
		СтрокаТаблицы.Партнер = ПартнерКредитор;
		
		СуммаОстаток = Объект.СуммаДокумента - Объект.КредиторскаяЗадолженность.Итог("Сумма");
		СтрокаТаблицы.Сумма = СуммаОстаток;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура КредиторскаяЗадолженностьТипРасчетовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.КредиторскаяЗадолженность.ТекущиеДанные;
	СтрокаТаблицы.Заказ = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура КредиторскаяЗадолженностьЗаказНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.КредиторскаяЗадолженность.ТекущиеДанные;
	ФинансыКлиент.ДокументРасчетовНачалоВыбора(
		Объект.Организация,
		СтрокаТаблицы.Партнер,
		Объект.КонтрагентКредитор,
		Неопределено, // Соглашение,
		(СтрокаТаблицы.ТипРасчетов = ТипРасчетовРасчетыСКлиентом), // ЭтоРасчетыСКлиентами
		Ложь, // ВыборОснованияПлатежа
		Элемент,
		СтандартнаяОбработка
	);
	
КонецПроцедуры

&НаКлиенте
Процедура КредиторскаяЗадолженностьЗаказОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элементы.КредиторскаяЗадолженность.ТекущиеДанные;	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыбранноеЗначение);
		Модифицированность = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КредиторскаяЗадолженностьСуммаПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.КредиторскаяЗадолженность.ТекущиеДанные;
	Если Объект.Валюта = СтрокаТаблицы.ВалютаВзаиморасчетов Тогда
		СтрокаТаблицы.СуммаВзаиморасчетов = СтрокаТаблицы.Сумма;
	Иначе
		СтрокаТаблицы.СуммаВзаиморасчетов = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КредиторскаяЗадолженностьВалютаВзаиморасчетовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.КредиторскаяЗадолженность.ТекущиеДанные;
	СтрокаТаблицы.СуммаВзаиморасчетов = 0;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Функция используется в автотесте процесса продаж.
//
&НаКлиенте
Процедура АвтоТест_РассчитатьВзаимозачет(Команда) Экспорт
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Валюта");
	СтруктураРеквизитов.Вставить("КонтрагентДебитор", "Дебитор");
	СтруктураРеквизитов.Вставить("КонтрагентКредитор", "Кредитор");
	
	Если (Объект.ДебиторскаяЗадолженность.Количество() = 0 ИЛИ Объект.КредиторскаяЗадолженность.Количество() = 0)
	 И ОбщегоНазначенияУТКлиент.ВозможноЗаполнениеТабличнойЧасти(ЭтаФорма, Неопределено, СтруктураРеквизитов) Тогда
		
		Если Объект.ДебиторскаяЗадолженность.Количество() = 0 Тогда
			ЗаполнитьПоОстаткамДебиторскуюЗадолженностьСервер();
		КонецЕсли;
		
		Если Объект.КредиторскаяЗадолженность.Количество() = 0 Тогда
			ЗаполнитьПоОстаткамКредиторскуюЗадолженностьСервер();
		КонецЕсли;
		
	КонецЕсли;
	
	РассчитатьСуммыВзаимозачета(Объект.СуммаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткамДебиторскуюЗадолженность(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Валюта");
	СтруктураРеквизитов.Вставить("КонтрагентДебитор", "Дебитор");
	
	Если ОбщегоНазначенияУТКлиент.ВозможноЗаполнениеТабличнойЧасти(ЭтаФорма, Неопределено, СтруктураРеквизитов) Тогда

		АдресПлатежейВХранилище = ПоместитьРасшифровкуПлатежаВХранилище(Объект.ДебиторскаяЗадолженность);
		ПараметрыПодбора = Новый Структура("
			|АдресПлатежейВХранилище, 
			|Организация, 
			|Контрагент,
			|Валюта,
			|СуммаДокумента,
			|ДатаДокумента,
			|ХозяйственнаяОперация
			|",
			АдресПлатежейВХранилище,
			Объект.Организация, 
			Объект.КонтрагентДебитор,
			Объект.Валюта,
			Объект.СуммаДокумента,
			Объект.Дата,
			СписаниеДебиторскойЗадолженности
		);
		ОткрытьФорму(
			"ОбщаяФорма.ПодборПоРасчетамСПартнерами",
			ПараметрыПодбора, 
			ЭтаФорма
		);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоОстаткамКредиторскуюЗадолженность(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Валюта");
	СтруктураРеквизитов.Вставить("КонтрагентКредитор", "Кредитор");
	
	Если ОбщегоНазначенияУТКлиент.ВозможноЗаполнениеТабличнойЧасти(ЭтаФорма, Неопределено, СтруктураРеквизитов) Тогда

		АдресПлатежейВХранилище = ПоместитьРасшифровкуПлатежаВХранилище(Объект.КредиторскаяЗадолженность);
		ПараметрыПодбора = Новый Структура("
			|АдресПлатежейВХранилище, 
			|Организация, 
			|Контрагент,
			|Валюта,
			|СуммаДокумента,
			|ДатаДокумента,
			|ХозяйственнаяОперация
			|",
			АдресПлатежейВХранилище,
			Объект.Организация, 
			Объект.КонтрагентКредитор,
			Объект.Валюта,
			Объект.СуммаДокумента,
			Объект.Дата,
			СписаниеКредиторскойЗадолженности
		);
		ОткрытьФорму(
			"ОбщаяФорма.ПодборПоРасчетамСПартнерами",
			ПараметрыПодбора, 
			ЭтаФорма
		);
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Заполнение

&НаСервере
Процедура ЗаполнитьПоОстаткамДебиторскуюЗадолженностьСервер()
	
	ВзаиморасчетыСервер.ЗаполнитьЗадолженностьПоОстаткам(
		Объект.Организация, 
		Объект.КонтрагентДебитор,
		Перечисления.ТипыЗадолженности.Дебиторская, 
		Объект.Дата,
		Объект.Валюта,
		Объект.ДебиторскаяЗадолженность
	);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОстаткамКредиторскуюЗадолженностьСервер()
	
	ВзаиморасчетыСервер.ЗаполнитьЗадолженностьПоОстаткам(
		Объект.Организация, 
		Объект.КонтрагентКредитор,
		Перечисления.ТипыЗадолженности.Кредиторская, 
		Объект.Дата,
		Объект.Валюта,
		Объект.КредиторскаяЗадолженность
	);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПартнераВТабличнойЧасти(ОбъектТабличнаяЧасть, ПартнерСсылка, РасчетыМеждуОрганизациями)
	Для Каждого СтрокаТаблицы из ОбъектТабличнаяЧасть Цикл
		Если РасчетыМеждуОрганизациями Тогда
			СтрокаТаблицы.Партнер = Неопределено;
		ИначеЕсли Не ЗначениеЗаполнено(СтрокаТаблицы.Партнер) Тогда
			СтрокаТаблицы.Партнер = ПартнерСсылка;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПартнераДебитора(ЗаполнятьТЧ = Ложь, ОчиститьТЧ = Ложь)

	Если ЗначениеЗаполнено(Объект.КонтрагентДебитор) Тогда
		ПартнерДебитор = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(Объект.КонтрагентДебитор);
	КонецЕсли;
	
	Если ЗаполнятьТЧ Тогда
		Если ОчиститьТЧ Тогда
			Объект.ДебиторскаяЗадолженность.Очистить();
			Объект.КредиторскаяЗадолженность.Очистить();
			Объект.СуммаДокумента = 0;
		Иначе
			ЗаполнитьПартнераВТабличнойЧасти(Объект.ДебиторскаяЗадолженность, ПартнерДебитор, Объект.РасчетыМеждуОрганизациямиДебитор);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПартнераКредитора(ЗаполнятьТЧ = Ложь, ОчиститьТЧ = Ложь)
	
	Если ЗначениеЗаполнено(Объект.КонтрагентКредитор) Тогда
		ПартнерКредитор = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(Объект.КонтрагентКредитор);
	КонецЕсли;
	
	Если ЗаполнятьТЧ Тогда
		Если ОчиститьТЧ Тогда
			Объект.ДебиторскаяЗадолженность.Очистить();
			Объект.КредиторскаяЗадолженность.Очистить();
			Объект.СуммаДокумента = 0;
		Иначе
			ЗаполнитьПартнераВТабличнойЧасти(Объект.КредиторскаяЗадолженность,ПартнерКредитор,Объект.РасчетыМеждуОрганизациямиКредитор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ТекущаяВалюта = Объект.Валюта;
	УстановитьЗаголовокСуммы();
	УстановитьТипДебитора();
	УстановитьТипКредитора();
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияУТ.ПолучитьКартинкуКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьРасшифровкуПлатежаВХранилище(Знач РасшифровкаПлатежа)
	
	АдресПлатежейВХранилище = ДенежныеСредстваСервер.ПоместитьРасшифровкуПлатежаВХранилище(
		РасшифровкаПлатежа,
		УникальныйИдентификатор
	);	
	Возврат АдресПлатежейВХранилище;
	
КонецФункции

&НаСервере
Процедура ПолучитьДебиторскуюЗадолженностиИзХранилища(АдресПлатежейВХранилище)

	Объект.ДебиторскаяЗадолженность.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьКредиторскуюЗадолженностиИзХранилища(АдресПлатежейВХранилище)

	Объект.КредиторскаяЗадолженность.Загрузить(ПолучитьИзВременногоХранилища(АдресПлатежейВХранилище));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокСуммы()
	
	Элементы.ДебиторскаяЗадолженностьСумма.Заголовок = "Сумма (" + Строка(Объект.Валюта) + ")";
	Элементы.КредиторскаяЗадолженностьСумма.Заголовок = "Сумма (" + Строка(Объект.Валюта) + ")";
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипДебитора()
	Элементы.КонтрагентДебитор.ОграничениеТипа = ?(Объект.РасчетыМеждуОрганизациямиДебитор,ТипСсылкаОрганизации,ТипСсылкаКонтрагенты);
	Элементы.ДебиторскаяЗадолженностьПартнер.Видимость = Не Объект.РасчетыМеждуОрганизациямиДебитор;
КонецПроцедуры

&НаСервере
Процедура УстановитьТипКредитора()
	Элементы.КонтрагентКредитор.ОграничениеТипа = ?(Объект.РасчетыМеждуОрганизациямиКредитор,ТипСсылкаОрганизации,ТипСсылкаКонтрагенты);
	Элементы.КредиторскаяЗадолженностьПартнер.Видимость = Не Объект.РасчетыМеждуОрганизациямиКредитор;
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммыВзаимозачетаСервер()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	*
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ИсходнаяТаблицаДокумента КАК ИсходнаяТаблицаДокумента
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	*,
	|	ТаблицаДокумента.Заказ.Дата КАК Дата,
	|	ТаблицаДокумента.Заказ.Номер КАК Номер
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Номер
	|");
	
	МассивТабличныйЧастей = Новый Массив;
	МассивТабличныйЧастей.Добавить("ДебиторскаяЗадолженность");
	МассивТабличныйЧастей.Добавить("КредиторскаяЗадолженность");
	
	Для Каждого ТабличнаяЧасть Из МассивТабличныйЧастей Цикл
		
		СуммаДокумента = Объект.СуммаДокумента;
		
		ТаблицаДокумента = Объект[ТабличнаяЧасть].Выгрузить(,);
		Запрос.УстановитьПараметр("ИсходнаяТаблицаДокумента", ТаблицаДокумента);
		
		Объект[ТабличнаяЧасть].Очистить();
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Сумма = Мин(Выборка.Сумма, СуммаДокумента);
			Если Сумма > 0 Тогда
			
				СтрокаТаблицы = Объект[ТабличнаяЧасть].Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
				СтрокаТаблицы.Сумма = Сумма;
				СуммаДокумента = СуммаДокумента - СтрокаТаблицы.Сумма;
				
				Если СтрокаТаблицы.ВалютаВзаиморасчетов = Объект.Валюта Тогда
					СтрокаТаблицы.СуммаВзаиморасчетов = СтрокаТаблицы.Сумма;
				Иначе
					СтрокаТаблицы.СуммаВзаиморасчетов = 0;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммыВзаимозачета(Знач СуммаДокумента = 0)
	
	Дебиторская = Объект.ДебиторскаяЗадолженность.Итог("Сумма");
	Кредиторская = Объект.КредиторскаяЗадолженность.Итог("Сумма");
	Если СуммаДокумента <> 0 Тогда
		СуммаВзаимозачета = Мин(Дебиторская, Кредиторская, СуммаДокумента);
	Иначе
		СуммаВзаимозачета = Мин(Дебиторская, Кредиторская);
	КонецЕсли;
	
	РассчитыватьСуммуВзаимозачета = Истина;
	Если СуммаВзаимозачета = 0 Тогда
		РассчитыватьСуммуВзаимозачета = Ложь;
	
	ИначеЕсли СуммаВзаимозачета < СуммаДокумента Тогда
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Взаимозачет возможен на сумму %1 %2, продолжить?'"),
			СуммаВзаимозачета,
			Объект.Валюта
		);
		КодОтвета = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		РассчитыватьСуммуВзаимозачета = (КодОтвета = КодВозвратаДиалога.Да);
			
	КонецЕсли;
	
	Если РассчитыватьСуммуВзаимозачета Тогда
		Объект.СуммаДокумента = СуммаВзаимозачета;
		РассчитатьСуммыВзаимозачетаСервер();
		
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Рассчитан взаимозачет на сумму %1'"), СуммаВзаимозачета);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Рассчитан взаимозачет'"),, Текст, БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НужноОчищатьТЧ(ЕстьСтроки)
	
	ОчищатьТабличныеЧасти = Ложь;
	Если ЕстьСтроки Тогда
		
		ТекстВопроса = НСтр("ru='Суммы взаимозачета могут стать неактуальным.
			|Очистить списки задолженностей?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		ОчищатьТабличныеЧасти = (Ответ = КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
	Возврат ОчищатьТабличныеЧасти;
	
КонецФункции

&НаСервере
Процедура ПересчетСуммДокументаВВалюту()
	
	ДенежныеСредстваСервер.ПересчетСуммДокументаВВалюту(
		Объект,
		ТекущаяВалюта,
		Объект.Валюта
	);
	УстановитьЗаголовокСуммы();
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

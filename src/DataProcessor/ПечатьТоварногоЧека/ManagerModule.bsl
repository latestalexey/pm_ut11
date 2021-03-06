﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТоварныйЧек") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ТоварныйЧек", "Товарный чек", СформироватьПечатнуюФормуТоварныйЧек(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуТоварныйЧек(СтруктураТипов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТоварныйЧек";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыТоварныйЧек(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументТоварныйЧек(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументТоварныйЧек(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.ПолучитьМакет("Обработка.ПечатьТоварногоЧека.ПФ_MXL_ТоварныйЧек");
	
	ПервыйДокумент = Истина;
	
	Выборка = ДанныеДляПечати.РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной.
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(Выборка, ДанныеДляПечати.ЗаголовокДокумента);
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, Выборка.Ссылка);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ПредставлениеПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Выборка.Организация, Выборка.Дата), "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны");
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ПредставлениеПоставщика;
		ОбластьМакета.Параметры.Поставщик = Выборка.Организация;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ЕстьСкидки = Ложь;
		ЕстьНДС = Ложь;
		ВыборкаСтрокТовары = Выборка.Товары.Выбрать();
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			Если ВыборкаСтрокТовары.Скидка <> 0 Тогда
				ЕстьСкидки = Истина;
			КонецЕсли;
			Если ВыборкаСтрокТовары.СуммаНДС <> 0 Тогда
				ЕстьНДС = Истина;
			КонецЕсли;
		КонецЦикла;
		
		ЗаголовокСкидки = ЗаголовокСкидки(Выборка.Товары.Выбрать(), ЕстьСкидки);
		
		ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
		Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
			ВыводитьКоды = Истина;
			Колонка = "Артикул";
		ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
			ВыводитьКоды = Истина;
			Колонка = "Код";
		Иначе
			ВыводитьКоды = Ложь;
		КонецЕсли;
		
		ОбластьНомера   = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
		ОбластьКодов    = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
		ОбластьДанных   = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
		ОбластьСкидок   = Макет.ПолучитьОбласть("ШапкаТаблицы|Скидка");
		ОбластьСуммыНДС = Макет.ПолучитьОбласть("ШапкаТаблицы|СуммаНДС");
		ОбластьСуммы    = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");
		
		ТабличныйДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ОбластьКодов.Параметры.ИмяКолонкиКодов = Колонка;
			ТабличныйДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьДанных);
		Если ЕстьСкидки Тогда
			ОбластьСкидок.Параметры.Скидка = ЗаголовокСкидки.Скидка;
			ОбластьСкидок.Параметры.СуммаБезСкидки = ЗаголовокСкидки.СуммаСкидки;
			ТабличныйДокумент.Присоединить(ОбластьСкидок);
		КонецЕсли;
		Если ЕстьНДС Тогда
			ТабличныйДокумент.Присоединить(ОбластьСуммыНДС);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьСуммы);
		
		ОбластьКолонкаТовар = Макет.Область("Товар");
		Если Не ВыводитьКоды Тогда
			ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки
			                                  + Макет.Область("КолонкаКодов").ШиринаКолонки;
		КонецЕсли;
		Если Не ЕстьСкидки Тогда
			ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки
			                                  + Макет.Область("СуммаБезСкидки").ШиринаКолонки
			                                  + Макет.Область("СуммаСкидки").ШиринаКолонки;
		КонецЕсли;
		
		ОбластьНомера   = Макет.ПолучитьОбласть("Строка|НомерСтроки");
		ОбластьКодов    = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
		ОбластьДанных   = Макет.ПолучитьОбласть("Строка|Данные");
		ОбластьСкидок   = Макет.ПолучитьОбласть("Строка|Скидка");
		ОбластьСуммыНДС = Макет.ПолучитьОбласть("Строка|СуммаНДС");
		ОбластьСуммы    = Макет.ПолучитьОбласть("Строка|Сумма");
		
		Сумма          = 0;
		ВсегоСкидок    = 0;
		ВсегоБезСкидок = 0;
		
		ВыборкаСтрокТовары = Выборка.Товары.Выбрать();
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			
			ОбластьНомера.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабличныйДокумент.Вывести(ОбластьНомера);
			
			Если ВыводитьКоды Тогда
				Если Колонка = "Артикул" Тогда
					ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Артикул;
				Иначе
					ОбластьКодов.Параметры.Артикул = ВыборкаСтрокТовары.Код;
				КонецЕсли;
				ТабличныйДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			
			ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьДанных.Параметры.Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ВыборкаСтрокТовары.ПолноеНаименованиеНоменклатуры,
				ВыборкаСтрокТовары.ПолноеНаименованиеХарактеристики
			);
			
			ТабличныйДокумент.Присоединить(ОбластьДанных);
			
			Если ЕстьСкидки Тогда
				ОбластьСкидок.Параметры.Скидка         = ?(ЗаголовокСкидки.ТолькоНаценка,-ВыборкаСтрокТовары.Скидка, ВыборкаСтрокТовары.Скидка);
				ОбластьСкидок.Параметры.СуммаБезСкидки = ВыборкаСтрокТовары.Сумма + ВыборкаСтрокТовары.Скидка;
				ТабличныйДокумент.Присоединить(ОбластьСкидок);
			КонецЕсли;
			
			Если ЕстьНДС Тогда
				ОбластьСуммыНДС.Параметры.СуммаНДС = ВыборкаСтрокТовары.СуммаНДС;
				ТабличныйДокумент.Присоединить(ОбластьСуммыНДС);
			КонецЕсли;
			
			Если Не Выборка.ЦенаВключаетНДС Тогда
				СуммаСНДС = ВыборкаСтрокТовары.Сумма + ВыборкаСтрокТовары.СуммаНДС;
			Иначе
				СуммаСНДС = ВыборкаСтрокТовары.Сумма;
			КонецЕсли;
			
			ОбластьСуммы.Параметры.Сумма = СуммаСНДС;
			ТабличныйДокумент.Присоединить(ОбластьСуммы);
			
			ВсегоСкидок    = ВсегоСкидок    + ВыборкаСтрокТовары.Скидка;
			ВсегоБезСкидок = ВсегоБезСкидок + ВыборкаСтрокТовары.Сумма + ВыборкаСтрокТовары.Скидка;
			
		КонецЦикла;
		
		Товары = Выборка.Товары.Выгрузить();
		
		// Вывести Итого.
		ОбластьНомера   = Макет.ПолучитьОбласть("Итого|НомерСтроки");
		ОбластьКодов    = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
		ОбластьДанных   = Макет.ПолучитьОбласть("Итого|Данные");
		ОбластьСкидок   = Макет.ПолучитьОбласть("Итого|Скидка");
		ОбластьСуммы    = Макет.ПолучитьОбласть("Итого|Сумма");
		ОбластьСуммыНДС = Макет.ПолучитьОбласть("Итого|СуммаНДС");
		
		ТабличныйДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьДанных);
		Если ЕстьСкидки Тогда
			ОбластьСкидок.Параметры.ВсегоСкидок    = ?(ЗаголовокСкидки.ТолькоНаценка,-ВсегоСкидок, ВсегоСкидок);
			ОбластьСкидок.Параметры.ВсегоБезСкидок = ВсегоБезСкидок;
			ТабличныйДокумент.Присоединить(ОбластьСкидок);
		КонецЕсли;
		
		СуммаНДС = Товары.Итог("СуммаНДС");
		Сумма    = Товары.Итог("Сумма");
		
		Если ЕстьНДС Тогда
			ОбластьСуммыНДС.Параметры.СуммаНДС = СуммаНДС;
			ТабличныйДокумент.Присоединить(ОбластьСуммыНДС);
		КонецЕсли;
		
		Если Не Выборка.ЦенаВключаетНДС Тогда
			СуммаДокумента = Сумма + СуммаНДС;
		Иначе
			СуммаДокумента = Сумма;
		КонецЕсли;
		
		ОбластьСуммы.Параметры.Сумма = СуммаДокумента;
		ТабличныйДокумент.Присоединить(ОбластьСуммы);
		
		// Вывести Сумму прописью.
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего наименований " + ВыборкаСтрокТовары.Количество()
		                                       + ", на сумму " + ФормированиеПечатныхФорм.ФорматСумм(Выборка.СуммаДокумента);
		ОбластьМакета.Параметры.СуммаПрописью  = РаботаСКурсамиВалют.СформироватьСуммуПрописью(Выборка.СуммаДокумента, Выборка.Валюта);
		ТабличныйДокумент.Вывести(ОбластьМакета);
	
		// Вывести подписи.
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		ОбластьМакета.Параметры.ОтветственныйПредставление = ФизическиеЛица.ФамилияИнициалыФизЛица(Выборка.Ответственный);

		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТабличныйДокументТоварныйЧек()

// Функция возвращает структуру с заголовками Скидка или Наценка для таблицы печатной формы,
// а также с флагами ЕстьСкидки и ТолькоНаценка
//
Функция ЗаголовокСкидки(Знач Товары, ИспользоватьСкидки) Экспорт
	
	ЕстьНаценки = Ложь;
	ЕстьСкидки  = Ложь;
	
	СтруктураШапки = Новый Структура("Скидка, СуммаСкидки, ТолькоНаценка");
	
	Если ИспользоватьСкидки Тогда
		
		Пока Товары.Следующий() Цикл
			Если Товары.Скидка>0 Тогда
				ЕстьСкидки = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Товары.Сбросить();
		
		Пока Товары.Следующий() Цикл
			Если Товары.Скидка<0 Тогда
				ЕстьНаценки = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьНаценки И ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", "Скидка (Наценка)");
			СтруктураШапки.Вставить("СуммаСкидки", "Сумма " + Символы.ПС + "без скидки (наценки)");
		ИначеЕсли ЕстьНаценки И НЕ ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", "Наценка");
			СтруктураШапки.Вставить("СуммаСкидки", "Сумма" + Символы.ПС + "без наценки");
		ИначеЕсли ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", "Скидка");
			СтруктураШапки.Вставить("СуммаСкидки", "Сумма" + Символы.ПС + "без скидки");
		КонецЕсли;
		СтруктураШапки.Вставить("ТолькоНаценка", ЕстьНаценки);
	КонецЕсли;
	
	Возврат СтруктураШапки;
	
КонецФункции // НужноВыводитьСкидки()
#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		
		Возврат;
		
	КонецЕсли;

	// 1. Получение информации о наборе.
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Если Не СтруктураВременныеТаблицы.Свойство("СтруктураКонтроляОстатков") Тогда

		ДанныеДляБлокировки = ПроведениеСервер.ПолучитьДанныеДляБлокировки(ЭтотОбъект);
		СтруктураВременныеТаблицы.Вставить("СтруктураКонтроляОстатков", ДанныеДляБлокировки.СтруктураКонтроляОстатков);

		УстановитьБлокировкуГрафика           = СтруктураВременныеТаблицы.СтруктураКонтроляОстатков.НеобходимКонтрольГрафика;
		УстановитьБлокировкуСвободныхОстатков = СтруктураВременныеТаблицы.СтруктураКонтроляОстатков.НеобходимКонтрольОстатков;

	Иначе

		УстановитьБлокировкуГрафика           = Ложь;
		УстановитьБлокировкуСвободныхОстатков = Ложь;

	КонецЕсли;

	// Если в наборе нет складов с контролем.
	Если Не СтруктураВременныеТаблицы.СтруктураКонтроляОстатков.НеобходимКонтрольОстатков Тогда
		
		ДополнительныеСвойства.РассчитыватьИзменения = Ложь;
		Возврат;
		
	КонецЕсли;

	// 2. Блокировка необходимых ресурсов.
	БлокировкаДанных = Неопределено;

	// Блокировка регистра график движения товаров.
	Если УстановитьБлокировкуГрафика Тогда

		// Разделяемая блокировка, т.к. нужно выполнить только контроль остатков.
		Блокировка = Новый БлокировкаДанных;

		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ГрафикДвиженияТоваров");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;

		// Если количество в наборе равно количеству в массиве - блокировка набором.
		Если ДанныеДляБлокировки.МассивСтрокБлокировкиГрафика.Количество() = Количество() Тогда
			ЭлементБлокировки.ИсточникДанных = Выгрузить( , "Номенклатура, Характеристика, Склад");
		Иначе 
			ЭлементБлокировки.ИсточникДанных = Выгрузить(ДанныеДляБлокировки.МассивСтрокБлокировкиГрафика, "Номенклатура, Характеристика, Склад");
		КонецЕсли;

		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура",   "Номенклатура");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Характеристика", "Характеристика");
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Склад",          "Склад");

	КонецЕсли;

	// Блокировка регистра свободные остатки в случае, когда нужно блокировать не все строки.
	Если УстановитьБлокировкуСвободныхОстатков Тогда
		
		Если СтруктураВременныеТаблицы.СтруктураКонтроляОстатков.ЕстьБезКонтроля Тогда

			Если Блокировка = Неопределено Тогда
				
				Блокировка = Новый БлокировкаДанных;
				
			КонецЕсли;

			ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.СвободныеОстатки");
			ЭлементБлокировки.Режим          = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.ИсточникДанных = Выгрузить(ДанныеДляБлокировки.МассивСтрокБлокировкиОстатков, "Номенклатура, Характеристика, Склад");
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура",   "Номенклатура");
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Характеристика", "Характеристика");
			ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Склад",          "Склад");

		Иначе
			// Блокировка всего набора.
			БлокироватьДляИзменения = Истина;

		КонецЕсли;
		
	КонецЕсли;

	Если Не Блокировка = Неопределено Тогда
		
		Блокировка.Заблокировать();
		
	КонецЕсли;

	// 3. Формирование таблиц.
	// Текущее состояние набора помещается во временную таблицу "ДвиженияПередЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.ЭтоНовый);
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДата()));
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Номенклатура        КАК Номенклатура,
	|	Таблица.Характеристика      КАК Характеристика,
	|	Таблица.Склад               КАК Склад,
	|	ЕСТЬNULL(НастройкаХарактеристика.ВариантКонтроля,
	|		ЕСТЬNULL(НастройкаНоменклатура.ВариантКонтроля, НастройкаСклад.ВариантКонтроля)) КАК ВариантКонтроля,
	|	ВЫБОР
	|		КОГДА Таблица.СрокПоставки = 0 ТОГДА
	|			-9999999999
	|		ИНАЧЕ
	|			-Таблица.СрокПоставки
	|	КОНЕЦ                       КАК СрокПоставки,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|			-Таблица.ВНаличии
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ                       КАК ВНаличииПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			-Таблица.ВРезерве
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ                       КАК ВРезервеПередЗаписью
	|
	|ПОМЕСТИТЬ СвободныеОстаткиПередЗаписью
	|
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОстатков КАК НастройкаХарактеристика
	|		ПО Таблица.Склад             = НастройкаХарактеристика.Склад
	|			И Таблица.Номенклатура   = НастройкаХарактеристика.Номенклатура
	|			И Таблица.Характеристика = НастройкаХарактеристика.Характеристика
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОстатков КАК НастройкаНоменклатура
	|		ПО Таблица.Склад                  = НастройкаНоменклатура.Склад
	|			И Таблица.Номенклатура        = НастройкаНоменклатура.Номенклатура
	|			И (НастройкаНоменклатура.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|			И (НастройкаХарактеристика.Склад ЕСТЬ NULL )
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОстатков КАК НастройкаСклад
	|		ПО Таблица.Склад                 = НастройкаСклад.Склад
	|			И (НастройкаСклад.Номенклатура   = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|			И (НастройкаСклад.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|			И (НастройкаХарактеристика.Склад ЕСТЬ NULL )
	|			И (НастройкаНоменклатура.Склад ЕСТЬ NULL )
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И ЕСТЬNULL(НастройкаХарактеристика.ВариантКонтроля, ЕСТЬNULL(НастройкаНоменклатура.ВариантКонтроля, НастройкаСклад.ВариантКонтроля)) <> ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.НеКонтролировать)
	|	И (НЕ &ЭтоНовый)
	|";
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Или Не ПроведениеСервер.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		
		Возврат;
		
	КонецЕсли;

	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДата()));
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Номенклатура КАК Номенклатура,
	|	ТаблицаИзменений.Характеристика КАК Характеристика,
	|	ТаблицаИзменений.Склад КАК Склад,
	|	ТаблицаИзменений.ВариантКонтроля КАК ВариантКонтроля,
	|	ВЫБОР
	|		КОГДА МАКСИМУМ(ТаблицаИзменений.ГраницаКонтроляСрокПоставки) <> ДАТАВРЕМЯ(1, 1, 1)
	|				И МАКСИМУМ(ТаблицаИзменений.ГраницаКонтроляСрокПоставки) < МАКСИМУМ(ТаблицаИзменений.ГраницаКонтроля)
	|			ТОГДА МАКСИМУМ(ТаблицаИзменений.ГраницаКонтроляСрокПоставки)
	|		ИНАЧЕ МАКСИМУМ(ТаблицаИзменений.ГраницаКонтроля)
	|	КОНЕЦ КАК ГраницаКонтроля,
	|	СУММА(ТаблицаИзменений.ВНаличииУвеличениеРасхода) КАК ВНаличииУвеличениеРасхода,
	|	СУММА(ТаблицаИзменений.ВРезервеУвеличениеПрихода) КАК ВРезервеУвеличениеПрихода
	|ПОМЕСТИТЬ ДвиженияСвободныеОстаткиИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Номенклатура КАК Номенклатура,
	|		Таблица.Характеристика КАК Характеристика,
	|		Таблица.Склад КАК Склад,
	|		Таблица.ВариантКонтроля КАК ВариантКонтроля,
	|		Таблица.СрокПоставки КАК СрокПоставки,
	|		ДАТАВРЕМЯ(1, 1, 1) КАК ГраницаКонтроляСрокПоставки,
	|		ДАТАВРЕМЯ(1, 1, 1) КАК ГраницаКонтроля,
	|		Таблица.ВНаличииПередЗаписью КАК ВНаличииУвеличениеРасхода,
	|		Таблица.ВРезервеПередЗаписью КАК ВРезервеУвеличениеПрихода,
	|		0 КАК ВНаличииРасход
	|	ИЗ
	|		СвободныеОстаткиПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Номенклатура,
	|		Таблица.Характеристика,
	|		Таблица.Склад,
	|		ЕСТЬNULL(НастройкаХарактеристика.ВариантКонтроля, ЕСТЬNULL(НастройкаНоменклатура.ВариантКонтроля, НастройкаСклад.ВариантКонтроля)),
	|		Таблица.СрокПоставки,
	|		ВЫБОР
	|			КОГДА ЕСТЬNULL(НастройкаХарактеристика.ВариантКонтроля, ЕСТЬNULL(НастройкаНоменклатура.ВариантКонтроля, НастройкаСклад.ВариантКонтроля)) = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.ОстаткиСУчетомГрафика)
	|				ТОГДА ВЫБОР
	|						КОГДА Таблица.СрокПоставки > 0
	|							ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, Таблица.СрокПоставки - 1)
	|						ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|					КОНЕЦ
	|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ЕСТЬNULL(НастройкаХарактеристика.ВариантКонтроля, ЕСТЬNULL(НастройкаНоменклатура.ВариантКонтроля, НастройкаСклад.ВариантКонтроля)) = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.ОстаткиСУчетомГрафика)
	|				ТОГДА ВЫБОР
	|						КОГДА НЕ НастройкаХарактеристика.ВариантКонтроля ЕСТЬ NULL 
	|							ТОГДА ВЫБОР
	|									КОГДА НастройкаХарактеристика.ГраницаГрафикаДоступности >= &ТекущаяДата
	|										ТОГДА НастройкаХарактеристика.ГраницаГрафикаДоступности
	|									КОГДА НастройкаХарактеристика.СрокПоставки > 0
	|										ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, НастройкаХарактеристика.СрокПоставки - 1)
	|									ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|								КОНЕЦ
	|						КОГДА НЕ НастройкаНоменклатура.ВариантКонтроля ЕСТЬ NULL 
	|							ТОГДА ВЫБОР
	|									КОГДА НастройкаНоменклатура.ГраницаГрафикаДоступности >= &ТекущаяДата
	|										ТОГДА НастройкаНоменклатура.ГраницаГрафикаДоступности
	|									КОГДА НастройкаНоменклатура.СрокПоставки > 0
	|										ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, НастройкаНоменклатура.СрокПоставки - 1)
	|									ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|								КОНЕЦ
	|						ИНАЧЕ ВЫБОР
	|								КОГДА НастройкаСклад.ГраницаГрафикаДоступности >= &ТекущаяДата
	|									ТОГДА НастройкаСклад.ГраницаГрафикаДоступности
	|								КОГДА НастройкаСклад.СрокПоставки > 0
	|									ТОГДА ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, НастройкаСклад.СрокПоставки - 1)
	|								ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|							КОНЕЦ
	|					КОНЕЦ
	|			ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА Таблица.ВНаличии
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА Таблица.ВРезерве
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|				ТОГДА Таблица.ВНаличии
	|			ИНАЧЕ 0
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.СвободныеОстатки КАК Таблица
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОстатков КАК НастройкаХарактеристика
	|			ПО Таблица.Склад = НастройкаХарактеристика.Склад
	|				И Таблица.Номенклатура = НастройкаХарактеристика.Номенклатура
	|				И Таблица.Характеристика = НастройкаХарактеристика.Характеристика
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОстатков КАК НастройкаНоменклатура
	|			ПО Таблица.Склад = НастройкаНоменклатура.Склад
	|				И Таблица.Номенклатура = НастройкаНоменклатура.Номенклатура
	|				И (НастройкаНоменклатура.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|				И (НастройкаХарактеристика.Склад ЕСТЬ NULL )
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОстатков КАК НастройкаСклад
	|			ПО Таблица.Склад = НастройкаСклад.Склад
	|				И (НастройкаСклад.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|				И (НастройкаСклад.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|				И (НастройкаХарактеристика.Склад ЕСТЬ NULL )
	|				И (НастройкаНоменклатура.Склад ЕСТЬ NULL )
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор
	|		И ЕСТЬNULL(НастройкаХарактеристика.ВариантКонтроля, ЕСТЬNULL(НастройкаНоменклатура.ВариантКонтроля, НастройкаСклад.ВариантКонтроля)) <> ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.НеКонтролировать)) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Склад,
	|	ТаблицаИзменений.ВариантКонтроля
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ВЫБОР
	|				КОГДА ТаблицаИзменений.ВариантКонтроля = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.Остатки)
	|					ТОГДА ТаблицаИзменений.ВНаличииУвеличениеРасхода
	|				КОГДА ТаблицаИзменений.ВариантКонтроля = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.ОстаткиСУчетомРезерва)
	|					ТОГДА ТаблицаИзменений.ВНаличииУвеличениеРасхода + ТаблицаИзменений.ВРезервеУвеличениеПрихода
	|				КОГДА ТаблицаИзменений.ВариантКонтроля = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.ОстаткиСУчетомГрафика)
	|					ТОГДА ТаблицаИзменений.ВНаличииУвеличениеРасхода
	|				ИНАЧЕ 0
	|			КОНЕЦ) > 0
	|		ИЛИ ТаблицаИзменений.ВариантКонтроля = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.ОстаткиСУчетомГрафика)
	|			И СУММА(ТаблицаИзменений.ВНаличииРасход) > 0
	|			И СУММА(ТаблицаИзменений.СрокПоставки) > 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ СвободныеОстаткиПередЗаписью
	|";
	Результат = Запрос.ВыполнитьПакет();

	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	Выборка = Результат[0].Выбрать();
	Выборка.Следующий();
	СтруктураВременныеТаблицы.Вставить("ДвиженияСвободныеОстаткиИзменение", Выборка.Количество > 0);

КонецПроцедуры

#КонецЕсли
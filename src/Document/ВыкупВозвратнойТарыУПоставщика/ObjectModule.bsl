﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет условия продаж в заказе поставщику
//
// Параметры:
//	УсловияЗакупок - Структура - Структура для заполнения
//
Процедура ЗаполнитьУсловияЗакупок(Знач УсловияЗакупок) Экспорт
	
	Если УсловияЗакупок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияЗакупок.Валюта;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Организация) И УсловияЗакупок.Организация <> Организация Тогда
		Организация = УсловияЗакупок.Организация;
		БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Склад) Тогда
		Склад = УсловияЗакупок.Склад;
		СтруктураОтветственного = ЗакупкиСервер.ПолучитьОтветственногоПоСкладу(Склад, Менеджер);
		Если СтруктураОтветственного <> Неопределено Тогда
			Принял = СтруктураОтветственного.Ответственный;
			ПринялДолжность = СтруктураОтветственного.ОтветственныйДолжность;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияЗакупок.Контрагент) И УсловияЗакупок.Контрагент <> Контрагент Тогда
		Контрагент = УсловияЗакупок.Контрагент;
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
	КонецЕсли;
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
	Договор = ЗакупкиСервер.ПолучитьДоговорПоУмолчанию(
		Договор,
		Партнер,
		Контрагент,
		Организация,
		,
		Валюта,
		Соглашение
	);
	
	ЗакупкиВызовСервера.ЗаполнитьБанковскиеСчетаПоДоговору(Договор, БанковскийСчетОрганизации, БанковскийСчетКонтрагента);
	
	Если ЗначениеЗаполнено(УсловияЗакупок.ГруппаФинансовогоУчета) Тогда
		ГруппаФинансовогоУчета = УсловияЗакупок.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ЦенаВключаетНДС      = УсловияЗакупок.ЦенаВключаетНДС;
	НалогообложениеНДС   = УсловияЗакупок.НалогообложениеНДС;
	
КонецПроцедуры

// Заполняет условия закупок по торговому соглашению с поставщиком
//
// Параметры:
//	ПересчитатьЦены - Булево - Истина, если необходимо пересчитать цены в табличной части документа
//
Процедура ЗаполнитьУсловияЗакупокПоУмолчанию(ПересчитатьЦены = Истина) Экспорт
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(
			Партнер,
			Новый Структура("ВыбранноеСоглашение", Соглашение)
		);
		
		ЦеныЗаполнены = Ложь;
		
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			
			Если Соглашение <> УсловияЗакупокПоУмолчанию.Соглашение
				И ЗначениеЗаполнено(УсловияЗакупокПоУмолчанию.Соглашение) Тогда
			
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
				ЗаполнитьУсловияЗакупок(УсловияЗакупокПоУмолчанию);
				
				Если ПересчитатьЦены И ЗначениеЗаполнено(Соглашение) Тогда
					СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
					ЦеныЗаполнены = ЗакупкиСервер.ЗаполнитьЦены(
						Товары,
						, // Массив строк
						Новый Структура( // Параметры заполнения
							"ПоляЗаполнения, Дата, Валюта, Соглашение",
							"Цена, СтавкаНДС, УсловиеЦеныПоставщика",
							Дата,
							Валюта,
							Соглашение
						),
						Новый Структура( // Структура действий с измененныими строками
							"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС, ПересчитатьСуммуРучнойСкидки, ПересчитатьСуммуСУчетомРучнойСкидки",
							"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы, "КоличествоУпаковок", Новый Структура("Очищать", Ложь)
						)
					);
					
				КонецЕсли;
			
				БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация, , БанковскийСчетОрганизации);
				
			Иначе
				Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
			КонецЕсли;
			
		Иначе
			ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
			Соглашение = Неопределено;
		КонецЕсли;
		
		БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в заказе поставщику
//
// Параметры:
//	ПересчитатьЦены - Булево - Истина, если необходимо пересчитать цены в табличной части документа
//
Процедура ЗаполнитьУсловияЗакупокПоCоглашению(ПересчитатьЦены = Истина) Экспорт
	
	УсловияЗакупок = ЗакупкиСервер.ПолучитьУсловияЗакупок(Соглашение, Истина, Истина);
	ЗаполнитьУсловияЗакупок(УсловияЗакупок);
	
	Если ПересчитатьЦены Тогда
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
		ЗакупкиСервер.ЗаполнитьЦены(
			Товары,
			, // Массив строк
			Новый Структура( // Параметры заполнения
				"ПоляЗаполнения, Дата, Валюта, Соглашение",
				"Цена, СтавкаНДС, УсловиеЦеныПоставщика",
				Дата,
				Валюта,
				Соглашение
			),
			Новый Структура( // Структура действий с измененныими строками
				"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
				"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы, "КоличествоУпаковок", Новый Структура("Очищать", Ложь)
			)
		);
	КонецЕсли;
	
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация, , БанковскийСчетОрганизации);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Соглашение) Или Не ОбщегоНазначения.ПолучитьЗначениеРеквизита(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	Если НЕ ПредъявленСчетФактура Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерСчетаФактуры");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаСчетаФактуры");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаСчетаФактуры");
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ Тогда
		Отказ = ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты);
	КонецЕсли;
	
	ЗакупкиСервер.ПроверитьКорректностьЗаполненияДокументаЗакупки(ЭтотОбъект,Отказ);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Перем СкладПоступления;
	Перем РеквизитыШапки;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);

	ЗаполнитьПоЗначениямАвтозаполнения(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ЗаполнитьПоПринятойТаре") Тогда
			ЗаполнитьДокументНаОснованииПринятойТары(ДанныеЗаполнения);
		Иначе
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ЗаполнитьДокументНаОснованииПоступленияТоваровУслуг(ДанныеЗаполнения);
	КонецЕсли;

	ИнициализироватьДокумент();

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ЗакупкиСервер.ОчиститьНомерДатуСчетаФактуры(ЭтотОбъект);
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
		ЗакупкиСервер.СвязатьНоменклатуруСНоменклатуройПоставщика(Товары, Отказ);
	КонецЕсли;
	
	Документы.СчетФактураПолученный.ПроверитьРеквизитыСчетФактуры(Ссылка, ПометкаУдаления, Организация);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ВыкупВозвратнойТарыУПоставщика.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	МногооборотнаяТараСервер.ОтразитьПринятуюВозвратнуюТару(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ДатаПлатежа     = Дата(1,1,1);
	Согласован      = Ложь;
	ВидЗапасов      = Неопределено;
	ПредъявленСчетФактура = Ложь;
	ДатаСчетаФактуры = Дата(1,1,1);
	НомерСчетаФактуры = "";
	ВалютаСчетаФактуры = Справочники.Валюты.ПустаяСсылка();
	ДатаВходящегоДокумента = Дата(1,1,1);
	НомерВходящегоДокумента = "";
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Документы.СчетФактураПолученный.АктуализироватьСчетФактуру(ЭтотОбъект.Ссылка, ЭтотОбъект.Проведен);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Инициализация и заполнение

Процедура ЗаполнитьДокументНаОснованииПринятойТары(Знач РеквизитыЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаполнения.РеквизитыШапки);
	
	Если Не ЗначениеЗаполнено(Соглашение) Тогда
		ЗаполнитьУсловияЗакупокПоУмолчанию(Ложь);
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(РеквизитыЗаполнения.АдресТарыВоВременномХранилище) Тогда
		
		ПринятаяТара = ПолучитьИзВременногоХранилища(РеквизитыЗаполнения.АдресТарыВоВременномХранилище);
		Товары.Загрузить(ПринятаяТара);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", НалогообложениеНДС);
		
		Для каждого ТекущаяСтрока Из Товары Цикл
			
			ТекущаяСтрока.СуммаСНДС = ТекущаяСтрока.Сумма;
			ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.Количество;
			
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
			Ценообразование.ПересчитатьСуммыВСтрокеПоСуммеСНДС(ТекущаяСтрока, ЦенаВключаетНДС, Ложь, Ложь, Истина);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПоступленияТоваровУслуг(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслуг.Ссылка                       КАК ДокументОснование,
		|	ПоступлениеТоваровУслуг.Валюта                       КАК Валюта,
		|	ПоступлениеТоваровУслуг.Партнер                      КАК Партнер,
		|	ПоступлениеТоваровУслуг.Соглашение                   КАК Соглашение,
		|	ПоступлениеТоваровУслуг.Организация                  КАК Организация,
		|	ПоступлениеТоваровУслуг.Контрагент                   КАК Контрагент,
		|	ПоступлениеТоваровУслуг.ЦенаВключаетНДС              КАК ЦенаВключаетНДС,
		|	ПоступлениеТоваровУслуг.НалогообложениеНДС           КАК НалогообложениеНДС,
		|	НЕ ПоступлениеТоваровУслуг.Проведен                  КАК ЕстьОшибкиПроведен,
		|	НЕ ПоступлениеТоваровУслуг.ВернутьМногооборотнуюТару КАК ЕстьОшибкиВернутьМногооборотнуюТару
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		|ГДЕ
		|	ПоступлениеТоваровУслуг.Ссылка = &ДокументОснование
		|;
		|ВЫБРАТЬ
		|	ПринятаяВозвратнаяТараОстатки.Номенклатура        КАК Номенклатура,
		|	ПринятаяВозвратнаяТараОстатки.Характеристика      КАК Характеристика,
		|	ПринятаяВозвратнаяТараОстатки.ДокументПоступления КАК ДокументПоступления,
		|	ПринятаяВозвратнаяТараОстатки.СуммаОстаток        КАК Сумма,
		|	ПринятаяВозвратнаяТараОстатки.КоличествоОстаток   КАК Количество,
		|	ПринятаяВозвратнаяТараОстатки.КоличествоОстаток   КАК КоличествоУпаковок
		|ИЗ
		|	РегистрНакопления.ПринятаяВозвратнаяТара.Остатки(, ДокументПоступления = &ДокументОснование) КАК ПринятаяВозвратнаяТараОстатки
		|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	УстановитьПривилегированныйРежим(Истина);
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	ВыборкаШапка = ПакетЗапросов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОснованииВыкупаТары(
		ДокументОснование,
		ВыборкаШапка.ЕстьОшибкиПроведен,
		ВыборкаШапка.ЕстьОшибкиВернутьМногооборотнуюТару
	);
		
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	Товары.Загрузить(ПакетЗапросов[1].Выгрузить());
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", НалогообложениеНДС);
	
	Для каждого ТекущаяСтрока Из Товары Цикл
		
		ТекущаяСтрока.СуммаСНДС = ТекущаяСтрока.Сумма;
		ТекущаяСтрока.КоличествоУпаковок = ТекущаяСтрока.Количество;
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
		Ценообразование.ПересчитатьСуммыВСтрокеПоСуммеСНДС(ТекущаяСтрока, ЦенаВключаетНДС, Ложь, Ложь, Истина);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗаполнитьУсловияЗакупокПоУмолчанию();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоЗначениямАвтозаполнения(ДанныеЗаполнения = Неопределено)
	
	ЕстьДанныеЗаполнения = (НЕ ДанныеЗаполнения = Неопределено);
	ДанныеЗаполненияСтруктура = (ТипЗнч(ДанныеЗаполнения) = Тип("Структура"));
	
	Если Не ЕстьДанныеЗаполнения Или ДанныеЗаполненияСтруктура Тогда
		// Заполним основные свойства
		СвойстваАвтозаполнения = Новый Структура("Организация");
		
		Если ДанныеЗаполненияСтруктура Тогда
			ОбщегоНазначенияУТКлиентСервер.ДополнитьСтруктуру(СвойстваАвтозаполнения, ДанныеЗаполнения, Истина);
			
		КонецЕсли;
		
		ОбщегоНазначенияУТ.ЗаполнитьЗначенияСвойствАвтозаполнения(Ссылка, СвойстваАвтозаполнения);
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СвойстваАвтозаполнения);
		
		// Заполним банковский счет в зависимости от организации
		СвойстваАвтозаполнения = Новый Структура("Организация, БанковскийСчетОрганизации", Организация);
		
		Если ДанныеЗаполненияСтруктура Тогда
			ОбщегоНазначенияУТКлиентСервер.ДополнитьСтруктуру(СвойстваАвтозаполнения, ДанныеЗаполнения, Истина);
			
		КонецЕсли;
		
		ОбщегоНазначенияУТ.ЗаполнитьЗначенияСвойствАвтозаполнения(Ссылка, СвойстваАвтозаполнения);
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СвойстваАвтозаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент()
	
	Менеджер                  = Пользователи.ТекущийПользователь();
	Валюта                    = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
	Организация               = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение             = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер, Подразделение);
	БанковскийСчетОрганизации = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация, , БанковскийСчетОрганизации);
	БанковскийСчетКонтрагента = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент, , БанковскийСчетКонтрагента);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ПринятаяВозвратнаяТара);
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры
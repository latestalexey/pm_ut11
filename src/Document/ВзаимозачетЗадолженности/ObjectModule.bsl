﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ДебиторскаяЗадолженность.Количество() > 0 Тогда
		ДебиторскаяЗадолженность.Очистить();
	КонецЕсли;
	
	Если КредиторскаяЗадолженность.Количество() > 0 Тогда
		КредиторскаяЗадолженность.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	// Проверим соответствие сумм документа и табличной части.
	Если ДебиторскаяЗадолженность.Итог("Сумма") <> КредиторскаяЗадолженность.Итог("Сумма") Тогда
		ТекстСообщения = НСтр("ru = 'Сумма по строкам в табличной части ""Задолженность дебитора"" должна равняться сумме по строкам в табличной части ""Задолженность перед кредитором""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			, // Поле
			,
			Отказ
		);
	КонецЕсли;
	
	Если РасчетыМеждуОрганизациямиДебитор Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДебиторскаяЗадолженность.Партнер");
	КонецЕсли;
	Если РасчетыМеждуОрганизациямиКредитор Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КредиторскаяЗадолженность.Партнер");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	МетаданныеРеквизитов = Метаданные().Реквизиты;
	ПроверитьКонтрагента(КонтрагентДебитор,МетаданныеРеквизитов.КонтрагентДебитор,Отказ);
	ПроверитьКонтрагента(КонтрагентКредитор,МетаданныеРеквизитов.КонтрагентКредитор,Отказ);
	ОтветственныеЛицаСервер.ПроверитьЗаполнениеОтветственныхЛицДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	// Заполнение суммы взаиморасчетов в табличных частях.
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВТабличнойЧасти(
			Валюта,
			Дата,
			ДебиторскаяЗадолженность
		);
		ВзаиморасчетыСервер.ЗаполнитьСуммуВзаиморасчетовВТабличнойЧасти(
			Валюта,
			Дата,
			КредиторскаяЗадолженность
		);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ДебиторскаяЗадолженность);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(КредиторскаяЗадолженность);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ВзаимозачетЗадолженности.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по расчетам с поставщиками и клиентами.
	ВзаиморасчетыСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСКлиентамиПоследовательность(ДополнительныеСвойства, ПринадлежностьПоследовательностям, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщикамиПоследовательность(ДополнительныеСвойства, ПринадлежностьПоследовательностям, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Инициализация и заполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта = ДоходыИРасходыСервер.ПолучитьВалютуРегламентированногоУчета(Валюта);
	ОтветственныеЛицаСервер.ЗаполнитьОтветственныхЛицДокумента(ЭтотОбъект);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда

		Массив.Добавить(Движения.РасчетыСКлиентами);

	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ПроверитьКонтрагента(Контрагент, МетаданныеРеквизита, Отказ)
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Контрагент) И (Организация=Контрагент) Тогда
		Текст = НСтр("ru='Организация и %Контрагент% должны различаться.'");
		Текст = СтрЗаменить(Текст,"%Контрагент%",МетаданныеРеквизита.Синоним);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,ЭтотОбъект,МетаданныеРеквизита.Имя,,Отказ);
	КонецЕсли;
КонецПроцедуры

#КонецЕсли
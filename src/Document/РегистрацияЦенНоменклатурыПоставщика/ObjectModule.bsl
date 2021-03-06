﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура ЗаполнитьНаборыЗначенийДоступа заполняет наборы значений доступа
// по объекту в таблице с полями:
//  - НомерНабора     Число                                     (необязательно, если набор один),
//  - ВидДоступа      ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//  - ЗначениеДоступа Неопределено, СправочникСсылка или др.    (обязательно),
//  - Чтение          Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Добавление      Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Изменение       Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора),
//  - Удаление        Булево (необязательно, если набор для всех прав; устанавливается для одной строки набора).
//
//  Вызывается из процедуры УправлениеДоступом.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	Строка = Таблица.Добавить();
	Строка.ВидДоступа      = ПланыВидовХарактеристик.ВидыДоступа.ГруппыПартнеров;
	Строка.ЗначениеДоступа = Партнер;
	
КонецПроцедуры

// Заполняет торговое соглашение с поставщиком
//
Процедура ЗаполнитьСоглашениеПоУмолчанию() Экспорт

	Если ЗначениеЗаполнено(Соглашение) Тогда
		Соглашение = Справочники.СоглашенияСПоставщиками.ПустаяСсылка();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		УсловияЗакупокПоУмолчанию = ЗакупкиСервер.ПолучитьУсловияЗакупокПоУмолчанию(
			Партнер,
			Новый Структура("ТолькоДляЗакупки,ТолькоДействующее", Ложь, Ложь)
		);
		Если УсловияЗакупокПоУмолчанию <> Неопределено Тогда
			Соглашение = УсловияЗакупокПоУмолчанию.Соглашение;
		Иначе
			Соглашение = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ИИЦИАЛИЗАЦИИ И ЗАПОЛНЕНИЯ РЕГИСТРАЦИИ ЦЕН ПОСТАВЩИКА

Процедура ЗаполнитьДокументНаОснованииПартнера(Основание)
	
	Партнер = Основание;
	ЗаполнитьСоглашениеПоУмолчанию();
	
КонецПроцедуры

// Заполняет регистрацию цен номенклатуры поставщика на основании соглашения с партнером
//
// Параметры
//  Основание - Ссылка на партнера.
//
Процедура ЗаполнитьДокументНаОснованииСоглашенияСПоставщиком(Основание)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	СоглашениеСПоставщиком.Партнер КАК Партнер,
		|	СоглашениеСПоставщиком.Ссылка  КАК Соглашение
		|ИЗ
		|	Справочник.СоглашенияСПоставщиками КАК СоглашениеСПоставщиком
		|ГДЕ
		|	СоглашениеСПоставщиком.Ссылка = &Ссылка
		|");
		
	Запрос.УстановитьПараметр("Ссылка", Основание);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

// Заполняет регистрацию цен в соответствии с отбором
//
// Параметры:
// ДанныеЗаполнения - Структура - Структура со значениями отбора
//
Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Соглашение") Тогда
		
		Соглашение = ДанныеЗаполнения.Соглашение;
		ЗаполнитьДокументНаОснованииСоглашенияСПоставщиком(Соглашение);
		
	ИначеЕсли ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		ЗаполнитьДокументНаОснованииПартнера(ДанныеЗаполнения.Партнер);
		
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует установку цен номенклатуры партнеров.
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗакупкиСервер.СвязатьНоменклатуруСНоменклатуройПоставщика(Товары, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);

	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.Партнеры") Тогда
		ЗаполнитьДокументНаОснованииПартнера(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.СоглашенияСПоставщиками") Тогда
		ЗаполнитьДокументНаОснованииСоглашенияСПоставщиком(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Документы.РегистрацияЦенНоменклатурыПоставщика.ЗаполнитьРегистрациюЦенПоДокументуЗакупки(ДанныеЗаполнения, ЭтотОбъект);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Документы.РегистрацияЦенНоменклатурыПоставщика.ЗаполнитьРегистрациюЦенПоДокументуЗакупки(ДанныеЗаполнения, ЭтотОбъект);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	// АСТЭК
	//НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	Ценообразование.ПроверитьКорректностьЗаполненияДокументаУстановкиЦенНоменклатурыПоставщика(ЭтотОбъект,Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	Документы.РегистрацияЦенНоменклатурыПоставщика.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Ценообразование.ОтразитьЦеныНоменклатурыПоставщика(ДополнительныеСвойства, Движения, Отказ);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

КонецПроцедуры


#КонецЕсли
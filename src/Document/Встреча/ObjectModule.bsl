﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Процедура формирует строки списка участников
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Взаимодействия.ЗаполнитьКонтактыДляВстречи(Контакты, Участники);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ДатаНачала = ТекущаяДатаСеанса();
	ДатаНачала = НачалоЧаса(ДатаНачала) + ?(Минута(ДатаНачала) < 30, 1800, 3600);
	ДатаОкончания = ДатаНачала + 1800;
	Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.СформироватьСписокУчастников(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаНачала       = ТекущаяДатаСеанса();
	ДатаОкончания    = Неопределено;
	РассмотретьПосле = Неопределено;
	Рассмотрено      = Ложь;
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если ДатаОкончания < ДатаНачала Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Дата окончания не может быть меньше даты начала.'"),
			ЭтотОбъект,
			"ДатаОкончания",
			,
			Отказ);

	КонецЕсли;

КонецПроцедуры

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

	// Логика ограничения следующая: объект доступен если доступен  "Автор" или "Ответственный".
	// Логика "ИЛИ" реализуется через различные номера наборов.

	// Ограничение по "УчетныеЗаписиЭлектроннойПочты".
	НомерНабора = 1;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = НомерНабора;
	СтрокаТаб.ВидДоступа      = ПланыВидовХарактеристик.ВидыДоступа.Пользователи;
	СтрокаТаб.ЗначениеДоступа = Автор;

	// Ограничение по "Ответственный".
	НомерНабора = НомерНабора + 1;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = НомерНабора;
	СтрокаТаб.ВидДоступа      = ПланыВидовХарактеристик.ВидыДоступа.Пользователи;
	СтрокаТаб.ЗначениеДоступа = Ответственный;

	МассивКонтактныхЛиц = Новый Массив;
	Для Каждого СтрокаТаблицы Из Участники Цикл

		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Контакт) Тогда
			Продолжить;
		КонецЕсли;

		Если ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка.Партнеры") Тогда

			НомерНабора = НомерНабора + 1;

			СтрокаТаб = Таблица.Добавить();
			СтрокаТаб.НомерНабора     = НомерНабора;
			СтрокаТаб.ВидДоступа      = ПланыВидовХарактеристик.ВидыДоступа.ГруппыПартнеров;
			СтрокаТаб.ЗначениеДоступа = СтрокаТаблицы.Контакт;

		ИначеЕсли ТипЗнч(СтрокаТаблицы.Контакт) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда

			МассивКонтактныхЛиц.Добавить(СтрокаТаблицы.Контакт);

		КонецЕсли;

	КонецЦикла;

	Если МассивКонтактныхЛиц.Количество() > 0 Тогда

		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КонтактныеЛицаПартнеров.Владелец КАК Партнер
		|ИЗ
		|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
		|ГДЕ
		|	КонтактныеЛицаПартнеров.Ссылка В(&МассивКонтактныхЛиц)
		|");
		Запрос.УстановитьПараметр("МассивКонтактныхЛиц", МассивКонтактныхЛиц);
		Выборка = Запрос.Выполнить().Выбрать();

		Пока Выборка.Следующий() Цикл

			НомерНабора = НомерНабора + 1;

			СтрокаТаб = Таблица.Добавить();
			СтрокаТаб.НомерНабора     = НомерНабора;
			СтрокаТаб.ВидДоступа      = ПланыВидовХарактеристик.ВидыДоступа.ГруппыПартнеров;
			СтрокаТаб.ЗначениеДоступа = Выборка.Партнер;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ





#КонецЕсли
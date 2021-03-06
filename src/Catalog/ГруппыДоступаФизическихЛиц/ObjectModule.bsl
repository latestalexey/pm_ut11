﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Обработка реквизита для РЛС.
	Если Не ЭтоНовый() Тогда

		ГруппаДоступа = Ссылка;

	ИначеЕсли ЗначениеЗаполнено(ПолучитьСсылкуНового()) Тогда

		ГруппаДоступа = ПолучитьСсылкуНового();

	Иначе

		ГруппаДоступа = Справочники.ГруппыДоступаФизическихЛиц.ПолучитьСсылку();
		УстановитьСсылкуНового(ГруппаДоступа);

	КонецЕсли;

КонецПроцедуры

#КонецЕсли
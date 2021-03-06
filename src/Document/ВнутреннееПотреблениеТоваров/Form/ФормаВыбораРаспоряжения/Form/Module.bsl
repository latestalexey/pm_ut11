﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Отбор.Свойство("Организация") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Организация", Параметры.Отбор.Организация);
	КонецЕсли;

	Если Параметры.Отбор.Свойство("Подразделение") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Подразделение", Параметры.Отбор.Подразделение);
	КонецЕсли;

	Если Параметры.Отбор.Свойство("Склад") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Склад", Параметры.Отбор.Склад);
	КонецЕсли;

	Если Параметры.Отбор.Свойство("Сделка") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Сделка", Параметры.Отбор.Сделка);
	КонецЕсли;

	Если Параметры.Отбор.Свойство("ХозяйственнаяОперация") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ХозяйственнаяОперация", Параметры.Отбор.ХозяйственнаяОперация);
	КонецЕсли;

	Список.Параметры.УстановитьЗначениеПараметра("Регистратор", Параметры.Регистратор);

КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Закрыть(Элементы.Список.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если РаботаСДиалогамиКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.Список) Тогда
		Закрыть(Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

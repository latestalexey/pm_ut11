﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ФормаЗагрузитьКлассификатор.Видимость = Не ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗагрузитьКлассификатор(Команда)
	ПараметрыФормы = Новый Структура("ОткрытиеИзСписка");
	ОткрытьФормуМодально("Справочник.КлассификаторБанковРФ.Форма.ЗагрузкаКлассификатора", ПараметрыФормы);
КонецПроцедуры


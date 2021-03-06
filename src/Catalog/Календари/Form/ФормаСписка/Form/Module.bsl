﻿///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		СоздатьКалендарьПоШаблону(РезультатВыбора);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
			Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	СоздатьКалендарь();

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Группа Тогда
		Возврат;
	КонецЕсли;
	
	Текст = НСтр("ru = 'Есть возможность создать календарь по шаблону, на основе данных производственного календаря.
						|Создать по шаблону?'");
	Результат = Вопрос(Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Если Результат = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		СоздатьКалендарь();
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура СоздатьКалендарь()
	
	// Настройка неоднозначна, нужно уточнить ее у пользователя в форме мастера
	ОткрытьФорму("Справочник.Календари.Форма.НастройкаНовогоКалендаря", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКалендарьПоШаблону(ДанныеШаблона)
	
	ОткрытьФорму("Справочник.Календари.ФормаОбъекта", ДанныеШаблона, ЭтаФорма);
	
КонецПроцедуры


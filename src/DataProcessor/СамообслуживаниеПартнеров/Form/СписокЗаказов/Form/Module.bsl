﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Партнер = ПартнерыИКонтрагентыВызовСервера.ПолучитьАвторизовавшегосяПартнера();
		
	Если Партнер = Неопределено ИЛИ Партнер.Пустая() Тогда
		 Отказ = Истина;
		 Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДата()));
	Список.Параметры.УстановитьЗначениеПараметра("Партнер",Партнер);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НеПоказыватьЗакрытыеПриИзменении(Элемент)
	
	Если НеПоказыватьЗакрытые Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Состояние", "Закрыт", ВидСравненияКомпоновкиДанных.НеРавно,,Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Состояние");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Печать(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	Для Каждого Ссылка Из Элементы.Список.ВыделенныеСтроки Цикл
		МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.ЗаказКлиента",
		"ЗаказКлиента",
		МассивСсылок,
		Неопределено,
		Неопределено
	);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеВыполнения(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 0 Тогда
		
		МассивОтбора = Новый Массив;
		
		Для Каждого ТекЭлемент Из  Элементы.Список.ВыделенныеСтроки Цикл
			
			Если ТипЗнч(ТекЭлемент) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				МассивОтбора.Добавить(ТекЭлемент);
			КонецЕсли;
			
		КонецЦикла;
		
		Если МассивОтбора.Количество() > 0 Тогда
			
			ОткрытьФорму("Отчет.СостояниеВыполненияЗаказовКлиентовСамообслуживание.Форма",
			Новый Структура("Отбор,СформироватьПриОткрытии", Новый Структура("Заказ", МассивОтбора), Истина));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныеДокументы(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОткрытьФорму("ОбщаяФорма.СтруктураПодчиненности",Новый Структура("ОбъектОтбора", ТекущиеДанные.Ссылка),ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры



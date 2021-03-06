﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ВыборВЗаказ;
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ГруппаСкладов") И Параметры.Свойство("Номенклатура") Тогда
		
		Если НЕ Параметры.Свойство("ВыборВЗаказ", ВыборВЗаказ) Тогда
			ВыборВЗаказ = Ложь;
		КонецЕсли;
		
		// Получение массива складов, входящих в иерархию параметра "ГруппаСкладов"
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Склады.Ссылка КАК Ссылка,
		|	Склады.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Ссылка В ИЕРАРХИИ(&ГруппаСкладов)
		|	И Склады.ЭтоГруппа = ЛОЖЬ
		|	И ВЫБОР
		|			КОГДА &ВыборВЗаказ = ИСТИНА
		|				ТОГДА Склады.ВыборГруппы <> ЗНАЧЕНИЕ(Перечисление.ВыборГруппыСкладов.Запретить)
		|			ИНАЧЕ Склады.ВыборГруппы = ЗНАЧЕНИЕ(Перечисление.ВыборГруппыСкладов.РазрешитьВЗаказахИНакладных)
		|		КОНЕЦ");
		Запрос.УстановитьПараметр("ВыборВЗаказ", ВыборВЗаказ);
		Запрос.УстановитьПараметр("ГруппаСкладов", Параметры.ГруппаСкладов);
		ТаблицаСкладов = Запрос.Выполнить().Выгрузить();
		МассивСкладов = ТаблицаСкладов.ВыгрузитьКолонку("Ссылка");
		
		// Получение структуры остатков по номеклатуре/характеристике, заданной в параметрах, и массиву складов
		СтруктураОстатков = ПодборТоваровСервер.ОстаткиНоменклатуры(Параметры.Номенклатура, Параметры.Характеристика, МассивСкладов);
		
		// Заполнение таблицы значений
		СкладыДанные = РеквизитФормыВЗначение("Склады");
		Для Каждого СтруктураТекущихОстатков Из СтруктураОстатков.ТекущиеОстатки Цикл
			
			// Текущие остатки
			НоваяСтрока = СкладыДанные.Строки.Добавить();
			НоваяСтрока.Склад = СтруктураТекущихОстатков.Склад;
			НоваяСтрока.Описание = СтруктураТекущихОстатков.Склад;
			НоваяСтрока.Доступно = СтруктураТекущихОстатков.Свободно;
			НоваяСтрока.Период = ТекущаяДата();
			НоваяСтрока.ПериодОписание = НСтр("ru = 'Сейчас'");
			НоваяСтрока.ПометкаУдаления = ТаблицаСкладов.Найти(НоваяСтрока.Склад, "Ссылка").ПометкаУдаления;
			
			// Планируемые остатки
			Если ВыборВЗаказ Тогда
				
				Для Каждого СтруктураПланируемыхОстатков Из СтруктураОстатков.ПланируемыеОстатки Цикл
					Если СтруктураПланируемыхОстатков.Склад <> СтруктураТекущихОстатков.Склад Тогда
						Продолжить;
					КонецЕсли;
					НоваяСтрокаПлана = НоваяСтрока.Строки.Добавить();
					НоваяСтрокаПлана.Склад = СтруктураПланируемыхОстатков.Склад;
					НоваяСтрокаПлана.Описание = "";
					НоваяСтрокаПлана.Доступно = СтруктураПланируемыхОстатков.Доступно;
					НоваяСтрокаПлана.Период = СтруктураПланируемыхОстатков.Период;
					НоваяСтрокаПлана.ПериодОписание = Формат(СтруктураПланируемыхОстатков.Период, "ДФ=dd.MM.yyyy");
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		ЗначениеВРеквизитФормы(СкладыДанные, "Склады");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Перем ТекущийЭлемент;
	
	Если НЕ Параметры.Свойство("ГруппаСкладов")
		ИЛИ НЕ Параметры.Свойство("Номенклатура") Тогда
		
		Предупреждение(НСтр("ru='Форма предназначена только для открытия из табличной части ""Товары""'"));
		Отказ = Истина;
		
	ИначеЕсли Параметры.Свойство("ТекущийЭлемент", ТекущийЭлемент) Тогда
		
		Для Каждого Строка Из Склады.ПолучитьЭлементы() Цикл
			Если Строка.Склад = ТекущийЭлемент Тогда
				Элементы.Склады.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СкладыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПриВыбореЗначения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	ПриВыбореЗначения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиенте
Процедура ПриВыбореЗначения()
	
	ТекущаяСтрока = Элементы.Склады.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		Если ТекущаяСтрока.ПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru='Выбранный элемент помечен на удаление
			|Продолжить?'");
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		Закрыть(Новый Структура("Склад, ДатаОтгрузки", ТекущаяСтрока.Склад, ТекущаяСтрока.Период));
	КонецЕсли;
	
КонецПроцедуры 


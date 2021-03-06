﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Параметры.Свойство("Владелец") Тогда
			Объект.Владелец = Параметры.Владелец;
		КонецЕсли;
		
		Если Параметры.Свойство("Номенклатура") Тогда
			Объект.Номенклатура = Параметры.Номенклатура;
		КонецЕсли;
		
		Если Параметры.Свойство("Характеристика") Тогда
			Объект.Характеристика = Параметры.Характеристика;
		КонецЕсли;
		
		Если Параметры.Свойство("Упаковка") Тогда
			Объект.Упаковка = Параметры.Упаковка;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		
		ДубльНоменклатурыПоставщика = НайтиДубльНоменклатурыПоставщика(Объект.Ссылка, Объект.Владелец, Объект.Номенклатура, Объект.Характеристика, Объект.Упаковка);
		
		Если ДубльНоменклатурыПоставщика <> Неопределено Тогда
			
			ТекстВопроса = НСтр("ru='Найдена номенклатура ""%ДубльНоменклатурыПоставщика%"", для которой уже задано аналогичное соответствие номенклатуре.'");
			ТекстВопроса = ТекстВопроса + Символы.ПС + НСтр("ru='Продолжить запись текущего элемента?'");
			ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ДубльНоменклатурыПоставщика%", ДубльНоменклатурыПоставщика);
			
			ОтветНаВопрос = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
			Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Объект.Характеристика);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Объект.Номенклатура);
	СтруктураСтроки.Вставить("Характеристика", Объект.Характеристика);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ХарактеристикиИспользуются);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, КэшированныеЗначения);

	ЗаполнитьЗначенияСвойств(Объект, СтруктураСтроки);
	
	ХарактеристикиИспользуются = СтруктураСтроки.ХарактеристикиИспользуются;
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

Функция НайтиДубльНоменклатурыПоставщика(Ссылка, Партнер, Номенклатура, Характеристика, Упаковка)
	
	Запрос = Новый Запрос("
		|ВЫБРАТь ПЕРВЫЕ 1
		|	НоменклатураПоставщиков.Ссылка КАК НоменклатураПоставщика
		|ИЗ
		|	Справочник.НоменклатураПоставщиков КАК НоменклатураПоставщиков
		|ГДЕ
		|	НоменклатураПоставщиков.Владелец = &Партнер
		|	И НоменклатураПоставщиков.Номенклатура = &Номенклатура
		|	И НоменклатураПоставщиков.Характеристика = &Характеристика
		|	И (НоменклатураПоставщиков.Упаковка = &Упаковка)
		|	И НЕ НоменклатураПоставщиков.ЭтоГруппа
		|	И НЕ НоменклатураПоставщиков.ПометкаУдаления
		|	И НоменклатураПоставщиков.Ссылка <> &Ссылка
		|");
	
	Запрос.УстановитьПараметр("Партнер",        Партнер);
	Запрос.УстановитьПараметр("Номенклатура",   Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Упаковка",       Упаковка);
	Запрос.УстановитьПараметр("Ссылка",         Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.НоменклатураПоставщика;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Объект.Номенклатура);
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	
КонецПроцедуры
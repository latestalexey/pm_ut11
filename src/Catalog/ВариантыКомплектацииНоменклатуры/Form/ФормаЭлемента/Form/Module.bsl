﻿&НаКлиенте
Перем КэшированныеЗначения;


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Объект.Ссылка.Пустая() Тогда
		ОбновитьПризнакИспользованияХарактеристики();
	КонецЕсли;

	УстановитьДоступностьХарактеристики();

	// Подсистема запрета редактирования ключевых реквизитов объектов.
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ОбновитьПризнакИспользованияХарактеристики();

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Товары,
		Новый Структура(
			"ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются")
		)
	);
	
	// Подсистема запрета редактирования ключевых реквизитов объектов.
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НаименованиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Представление = СокрЛП(Объект.Владелец);
	Если ЗначениеЗаполнено(Объект.Характеристика) Тогда

		Представление = Представление + " " + СокрЛП(Объект.Характеристика);

	КонецЕсли;
	Список = Новый СписокЗначений;
	Список.Добавить(Представление);

	РезультатВыбора = ВыбратьИзСписка(Список, Элемент);
	Если РезультатВыбора <> Неопределено Тогда

		Модифицированность = Истина;

		Объект.Наименование = РезультатВыбора.Значение;

	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ ТОВАРЫ

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",    ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные; 
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока,СтруктураДействий,КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоУпаковокПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные; 
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока,СтруктураДействий,КэшированныеЗначения);

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНД

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Результат = ОткрытьФормуМодально("Справочник.ВариантыКомплектацииНоменклатуры.Форма.РазблокированиеРеквизитов");
		Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда

			ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);

		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)

	ЗаполнитьПоКомплектующим();

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
//Прочее

&НаКлиенте
Процедура ЗаполнитьПоКомплектующим()

	Если Объект.Товары.Количество() > 0 Тогда

		Ответ = Вопрос(НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'"),
						РежимДиалогаВопрос.ДаНет,,
						КодВозвратаДиалога.Да,);

		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли; 

		Объект.Товары.Очистить();

	КонецЕсли;

	ПараметрыОтбора = Новый Структура("Отбор", Новый Структура("Владелец", Объект.Владелец));
	ЭлементКомплектующих = ОткрытьФормуМодально("Справочник.ВариантыКомплектацииНоменклатуры.Форма.ФормаВыбора",
			ПараметрыОтбора, ЭтаФорма);

	Если Не ЗначениеЗаполнено(ЭлементКомплектующих) Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьТабличнуюЧастьПоКомплектующей(ЭлементКомплектующих);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьПоКомплектующей(ЭлементКомплектующих)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Товары.Номенклатура       КАК Номенклатура,
	|	Товары.Характеристика     КАК Характеристика,
	|	Товары.Упаковка           КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.ДоляСтоимости      КАК ДоляСтоимости,
	|	Товары.Количество         КАК Количество
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|");
	Запрос.УстановитьПараметр("Ссылка", ЭлементКомплектующих);
	
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Товары,
		Новый Структура(
			"ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются")
		)
	);

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьХарактеристики()

	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;

КонецПроцедуры

&НаСервере
Процедура ОбновитьПризнакИспользованияХарактеристики()
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(Объект.Владелец);
	Иначе
		ХарактеристикиИспользуются = Ложь;
	КонецЕсли;
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.Товары,
		Новый Структура(
			"ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются")
		)
	);
	
КонецПроцедуры


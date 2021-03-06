﻿/////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданиНаСервере();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриЧтенииСозданиНаСервере();	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад, Помещение", Объект.Владелец, Объект.Ссылка));
	
	Если Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки
		 И Не ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
   		 ОповещатьОбОтключенныхУпаковках = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	НеобходимоОбновлятьИнтерфейс = Ложь;
	
	Для Каждого СтрСтруктуры из КешРеквизитов Цикл
		Если Объект[СтрСтруктуры.Ключ] <> СтрСтруктуры.Значение Тогда
			НеобходимоОбновлятьИнтерфейс = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс();
		
		КешРеквизитовСтуктура = Новый Структура;
		КешРеквизитовСтуктура.Вставить("ИспользованиеРабочихУчастков",Объект.ИспользованиеРабочихУчастков);
		КешРеквизитовСтуктура.Вставить("НастройкаАдресногоХранения",Объект.НастройкаАдресногоХранения);
		
		КешРеквизитов = Новый ФиксированнаяСтруктура(КешРеквизитовСтуктура);
	КонецЕсли;
	
	Если ОповещатьОбОтключенныхУпаковках Тогда
		ТекстСообщения = НСтр("ru='В настройках учета отключено использование упаковок номенклатуры. Оприходовать товар на склад
		|с хранением остатков в разрезе ячеек без указания упаковок невозможно.'");
		Предупреждение(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НастройкаАдресногоХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗаполнитьДанныеВыбораНастройкиАдресногоХранения(ДанныеВыбора);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАдресногоХраненияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАдресногоХраненияПриИзменении(Элемент)
	
	НастройкаАдресногоХраненияПриИзмененииСервер();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	Если Не Объект.Ссылка.Пустая() Тогда
		Результат = ОткрытьФормуМодально("Справочник.СкладскиеПомещения.Форма.РазблокированиеРеквизитов");
		Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда

			ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НастройкиПодпитки(Команда)
	ПараметрыФормы = Новый Структура("Ключ",КлючЗаписиНастроекПодпитки());
	ОткрытьФорму("РегистрСведений.НастройкиАдресныхСкладов.ФормаЗаписи", ПараметрыФормы, ЭтаФорма,,);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ЗаполнитьДанныеВыбораНастройкиАдресногоХранения(ДанныеВыбора)
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(Перечисления.НастройкиАдресногоХранения.НеИспользовать);
	ДанныеВыбора.Добавить(Перечисления.НастройкиАдресногоХранения.ЯчейкиСправочно);	
	ДанныеВыбора.Добавить(Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки);
КонецПроцедуры

&НаСервере
Функция КлючЗаписиНастроекПодпитки()
	СтруктураИзмерений = Новый Структура;
	СтруктураИзмерений.Вставить("Склад", Объект.Владелец);
	СтруктураИзмерений.Вставить("Помещение", Объект.Ссылка);
	
	Возврат РегистрыСведений.НастройкиАдресныхСкладов.СоздатьКлючЗаписи(СтруктураИзмерений);
КонецФункции

&НаСервере
Процедура ПриЧтенииСозданиНаСервере()
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад, Помещение", Объект.Владелец, Объект.Ссылка));
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		КешРеквизитовСтуктура = Новый Структура;
		КешРеквизитовСтуктура.Вставить("НастройкаАдресногоХранения",Объект.НастройкаАдресногоХранения);
	Иначе
		КешРеквизитовСтуктура = Новый Структура;
		КешРеквизитовСтуктура.Вставить("НастройкаАдресногоХранения",Неопределено);
	КонецЕсли;
	
	КешРеквизитов = Новый ФиксированнаяСтруктура(КешРеквизитовСтуктура);
	УстановитьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура НастройкаАдресногоХраненияПриИзмененииСервер()
	
	Если Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.НеИспользовать Тогда
		Объект.ИспользованиеРабочихУчастков = Перечисления.ИспользованиеСкладскихРабочихУчастков.НеИспользовать
	КонецЕсли;
	
	УстановитьДоступность();

КонецПроцедуры

Процедура УстановитьДоступность()
	
	Элементы.ИспользованиеРабочихУчастков.Доступность = Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиОстатки
														Или Объект.НастройкаАдресногоХранения = Перечисления.НастройкиАдресногоХранения.ЯчейкиСправочно;
	
КонецПроцедуры

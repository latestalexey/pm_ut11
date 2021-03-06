﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Не ЭтоГруппа Тогда
		
		Если ВариантКонтроля <> Перечисления.ВариантыКонтроля.ОстаткиСУчетомГрафика Тогда

			Если СрокПоставки <> 0 Тогда
				СрокПоставки = 0;
			КонецЕсли;

			Если ГраницаГрафикаДоступности <> '00010101' Тогда
				ГраницаГрафикаДоступности = '00010101';
			КонецЕсли;

		КонецЕсли;
		
		ЗаполнитьВыборГруппыТекущегоСклада();
		ОбновитьФлагИспользованияСерий();
		ОбновитьФлагКонтроляОперативныхОстатков();
		
		СкладыКлиентСервер.СогласоватьЗначенияПризнаков(ЭтотОбъект);
		
	КонецЕсли;
	
	Если Не ЭтоНовый()
		И Не ЭтоГруппа Тогда
		
		Если ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
			Справочники.КлючиАналитикиУчетаНоменклатуры.УстановитьПометкуУдаления(Новый Структура("Склад", Ссылка), ПометкаУдаления);
		КонецЕсли;

	КонецЕсли;

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		УстановитьПривилегированныйРежим(Истина);
 		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Склады.Ссылка
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Ссылка <> &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Если Не Запрос.Выполнить().Пустой() Тогда
			Константы.ИспользоватьНесколькоСкладов.Установить(Истина);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		
		ЗаполнитьВыборГруппыПодчиненныхСкладов(Отказ);
		
	Иначе
		
		РегистрыСведений.НастройкаКонтроляОстатков.УстановитьНастройкуКонтроляОстатковСклада(Ссылка, ВариантКонтроля, СрокПоставки, ГраницаГрафикаДоступности);
		РегистрыСведений.НастройкиАдресныхСкладов.УстановитьНастройкиПоУмолчанию(Ссылка,
																				Справочники.СкладскиеПомещения.ПустаяСсылка(),
																				ИспользоватьАдресноеХранение,
																				ИспользоватьАдресноеХранениеСправочно,
																				ИспользованиеРабочихУчастков = Перечисления.ИспользованиеСкладскихРабочихУчастков.Использовать);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если Не ЭтоГруппа Тогда
		
		Если (ТипСклада <> Перечисления.ТипыСкладов.РозничныйМагазин
			Или ЗначениеЗаполнено(РозничныйВидЦены) ) Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("РозничныйВидЦены");
		КонецЕсли;
		
		МассивНепроверяемыхРеквизитов.Добавить("ВыборГруппы");
		
		Если (ТипСклада <> Перечисления.ТипыСкладов.РозничныйМагазин )
			ИЛИ (НЕ КонтролироватьАссортимент)
			ИЛИ (НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент")) Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("ФорматМагазина");
			
		КонецЕсли;
		
	Иначе
		
		ПроверитьКорректностьВыбораГруппыРодителя(Отказ);
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

Процедура ЗаполнитьВыборГруппыПодчиненныхСкладов(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Склады.Ссылка
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Родитель = &Ссылка
		|	И НЕ Склады.ЭтоГруппа
		|	И Склады.ВыборГруппы <> &ВыборГруппыСкладов";
		
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВыборГруппыСкладов", ВыборГруппы);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось заблокировать %Элемент%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Элемент%",        Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			
		КонецПопытки;
			
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		
		Попытка
			
			Объект.Записать();
			
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось записать %Элемент%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Элемент%",        Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
			
		КонецПопытки
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВыборГруппыТекущегоСклада()
	
	Если Не ЗначениеЗаполнено(Родитель) Или
		(Не ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки")) Тогда
		
		ВыборГруппы = Перечисления.ВыборГруппыСкладов.Запретить;
		
	Иначе
		
		ВыборГруппы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ВыборГруппы");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьКорректностьВыбораГруппыРодителя(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Склады.Ссылка
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Ссылка = &Родитель
		|	И Склады.ВыборГруппы = ЗНАЧЕНИЕ(Перечисление.ВыборГруппыСкладов.РазрешитьВЗаказахИНакладных)
		|	И &ВыборГруппыСкладов =  ЗНАЧЕНИЕ(Перечисление.ВыборГруппыСкладов.РазрешитьВЗаказах)";
		
	Запрос.УстановитьПараметр("Родитель", Родитель);
	Запрос.УстановитьПараметр("ВыборГруппыСкладов", ВыборГруппы);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
			ТекстОшибки = НСтр("ru='Запрещено указывать значение ""Разрешить в заказах"", если в вышестоящей группе складов указано значение ""Разрешить в заказах и накладных""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ВыборГруппы",
			,
			Отказ);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьФлагИспользованияСерий()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПропуститьОбновлениеФлагаИспользованияСерий") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ИспользоватьСерииНоменклатуры = Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ИспользоватьСерииНоменклатуры
	|ИЗ
	|	Справочник.Склады КАК Склады
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО Склады.Ссылка = ПолитикиУчетаСерий.Склад
	|ГДЕ
	|	Склады.Ссылка = &Склад";
	Запрос.УстановитьПараметр("Склад", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ИспользоватьСерииНоменклатуры = Выборка.ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

Процедура ОбновитьФлагКонтроляОперативныхОстатков()
	Если ДополнительныеСвойства.Свойство("ПропуститьОбновлениеФлагаКонтроляОперативныхОстатков") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
	|	КОНЕЦ КАК КонтролироватьОперативныеОстатки
	|ИЗ
	|	Справочник.Склады КАК Склады
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|		ПО Склады.Ссылка = ПолитикиУчетаСерий.Склад
	|ГДЕ
	|	Склады.Ссылка = &Склад";
	Запрос.УстановитьПараметр("Склад", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если Выборка.КонтролироватьОперативныеОстатки Тогда
		КонтролироватьОперативныеОстатки = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ЭтоГруппа Тогда
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
			ВидЦены = Ценообразование.ВидЦеныПрайсЛист();
			УчетныйВидЦены = ВидЦены;
			ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет таблицу реквизитов, зависимых от хозяйственной операции
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - хозяйственная операция соглашения
//	МассивВсехРеквизитов - Массив - реквизиты, которые не зависят от хозяйственной операции
//	МассивРеквизитовОперации - Массив - реквизиты, которые зависят от хозяйственной операции
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СпособРасчетаВознаграждения");
	МассивВсехРеквизитов.Добавить("ПроцентВознаграждения");
	МассивВсехРеквизитов.Добавить("УдержатьВознаграждение");
	МассивВсехРеквизитов.Добавить("ПроцентРучнойСкидки");
	МассивВсехРеквизитов.Добавить("ПроцентРучнойНаценки");
	МассивВсехРеквизитов.Добавить("НалогообложениеНДС");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию Тогда
		МассивРеквизитовОперации.Добавить("НалогообложениеНДС");
		МассивРеквизитовОперации.Добавить("СпособРасчетаВознаграждения");
		МассивРеквизитовОперации.Добавить("ПроцентВознаграждения");
		МассивРеквизитовОперации.Добавить("УдержатьВознаграждение");
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту Тогда
		МассивРеквизитовОперации.Добавить("ПроцентРучнойСкидки");
		МассивРеквизитовОперации.Добавить("ПроцентРучнойНаценки");
		
	Иначе
		МассивРеквизитовОперации.Добавить("НалогообложениеНДС");
		МассивРеквизитовОперации.Добавить("ПроцентРучнойСкидки");
		МассивРеквизитовОперации.Добавить("ПроцентРучнойНаценки");
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает статус соглашений с поставщиками
//
// Параметры:
//	Соглашения - Массив - массив ссылок на соглашения с поставщиками
//	Статус     - ПеречислениеСсылка.СтатусыСоглашенийСПоставщиками - статус, который будет установлен у соглашений.
//
Функция УстановитьСтатус(Знач Соглашения, Знач Статус) Экспорт
	
	МассивСсылок = Новый Массив();
	КоличествоОбработанных = 0;
	
	Для Каждого Соглашение Из Соглашения Цикл
	
		Если ТипЗнч(Соглашение) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСсылок.Добавить(Соглашение);
		
	КонецЦикла;
	
	Если МассивСсылок = 0 Тогда
		Возврат КоличествоОбработанных;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоглашениеСПоставщиком.Ссылка КАК Ссылка,
	|	СоглашениеСПоставщиком.ПометкаУдаления КАК ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА СоглашениеСПоставщиком.Статус = &Статус
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатусСовпадает
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК СоглашениеСПоставщиком
	|ГДЕ
	|	СоглашениеСПоставщиком.Ссылка В(&МассивСсылок)");
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("Статус", Статус);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПометкаУдаления Тогда
			
			ТекстОшибки = НСтр("ru='Соглашение %Соглашение% помечено на удаление. Невозможно изменить статус'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			Продолжить;
			
		КонецЕслИ;
		
		Если Выборка.СтатусСовпадает Тогда
			
			ТекстОшибки = НСтр("ru='Соглашению %Соглашение% уже присвоен статус ""%Статус%""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", Статус);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			Продолжить;
			
		КонецЕслИ;
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось заблокировать %Соглашение%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
		КонецПопытки;
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Статус = Статус;
		
		Если Статус = Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано Тогда
			Если Объект.Согласован Тогда
				Объект.Согласован = Ложь;
			КонецЕсли;
		КонецЕсли;
			
		Если Не Объект.ПроверитьЗаполнение() Тогда
			Продолжить;
		КонецЕсли;
			
		Попытка
			
			Объект.Записать();
			КоличествоОбработанных = КоличествоОбработанных + 1;
			
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось записать %Соглашение%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
		КонецПопытки
		
	КонецЦикла;
	
	Возврат КоличествоОбработанных;

КонецФункции

// Ищет/создает документ регистрации для соглашения.
//
// Параметры:
//	Соглашение - СправочникСсылка.СоглашенияСПоставщиками - ссылка на соглашение
//
// Возвращаемое значение:
//	ДокументСсылка.СоглашениеСПоставщиком
//
Функция ПолучитьСоздатьДокументРегистрации(Соглашение) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Ссылка КАК Документ
	|ИЗ
	|	Документ.СоглашениеСПоставщиком КАК Таблица
	|ГДЕ
	|	Таблица.Соглашение = &Соглашение");
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда

		Результат = Выборка.Документ;

	Иначе
		
		СоглашениеСПоставщиком = Документы.СоглашениеСПоставщиком.СоздатьДокумент();
		СоглашениеСПоставщиком.Дата       = ТекущаяДата();
		СоглашениеСПоставщиком.Соглашение = Соглашение;
		СоглашениеСПоставщиком.Записать();

		Результат = СоглашениеСПоставщиком.Ссылка;

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возрвщает признак использования как агрегирующей сущности в товарах к поступлению
//
// Параметры:
//	Соглашение - СправочникСсылка.СоглашенияСПоставщиками - ссылка на соглашение
//
// Возвращаемое значение:
//	Булево, используется соглашение при приемке.
//
Функция СоглашениеИспользуетсяПриПриемке(ВариантПриемкиТоваров) Экспорт

	Результат = Ложь;
	Если ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным
		Или  ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных Тогда 

		Результат = Истина;

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возвращает массив имен ролей с правом "Добавление" для данного документа
//
// Возвращаемое значение:
//	Массив - Массив с именами ролей
//
Функция ИменаРолейСПравомДобавления() Экспорт
	
	МассивРолей = Новый Массив;
	МассивРолей.Добавить("ПолныеПрава");
	МассивРолей.Добавить("ДобавлениеИзменениеСоглашенийСПоставщиками");
	
	Возврат МассивРолей;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Партнер       = Справочники.Партнеры.ПустаяСсылка();
	ДатаДокумента = ТекущаяДата();
	СтрокаПоиска  = "";
	ДоступноДляЗакупки = Ложь;
	
	Если Параметры.Отбор.Свойство("Партнер") Тогда
		Партнер = Параметры.Отбор.Партнер;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Возврат;
	КонецЕсли;
		
	Если Параметры.Отбор.Свойство("Дата") Тогда
		ДатаДокумента = Параметры.Отбор.Дата;
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступноДляЗакупки") Тогда
		ДоступноДляЗакупки = Параметры.ДоступноДляЗакупки;
	КонецЕсли;

	Параметры.Свойство("СтрокаПоиска",СтрокаПоиска);
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 51
		|	СправочникСоглашениеСПоставщиком.Ссылка       КАК Ссылка,
		|	СправочникСоглашениеСПоставщиком.Наименование КАК Наименование,
		|	СправочникСоглашениеСПоставщиком.Номер        КАК Номер,
		|	СправочникСоглашениеСПоставщиком.Дата         КАК Дата,
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.ПометкаУдаления
		|		ТОГДА
		|			0
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|		ТОГДА
		|			0
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.НеСогласовано)
		|		ТОГДА
		|			1
		|	КОНЕЦ КАК ИндексКартинки,
		|
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|			И ((СправочникСоглашениеСПоставщиком.ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1) И
		|			СправочникСоглашениеСПоставщиком.ДатаНачалаДействия > &ДатаДокумента))
		|		ТОГДА
		|			ИСТИНА
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ КАК СрокДействияНеНаступил,
		|
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|			И ((СправочникСоглашениеСПоставщиком.ДатаОкончанияДействия <> ДАТАВРЕМЯ(1,1,1) И
		|			СправочникСоглашениеСПоставщиком.ДатаОкончанияДействия < &ДатаДокумента))
		|		ТОГДА
		|			ИСТИНА
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ КАК СрокДействияИстек
		|
		|ИЗ
		|	Справочник.СоглашенияСПоставщиками КАК СправочникСоглашениеСПоставщиком
		|ГДЕ
		|	СправочникСоглашениеСПоставщиком.Партнер = &Партнер
		|	И СправочникСоглашениеСПоставщиком.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Закрыто)
		|	И (СправочникСоглашениеСПоставщиком.Наименование ПОДОБНО &СтрокаПоиска
		|	ИЛИ СправочникСоглашениеСПоставщиком.Номер ПОДОБНО &СтрокаПоиска)
		|	И (СправочникСоглашениеСПоставщиком.ДоступноДляЗакупки
		|	ИЛИ СправочникСоглашениеСПоставщиком.ДоступноДляЗакупки = &ДоступноДляЗакупки)
		|	И (&ДоступноДляЗакупки = ИСТИНА И СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|	ИЛИ &ДоступноДляЗакупки = ЛОЖЬ)
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачалаДействия ВОЗР,
		|	ДатаОкончанияДействия ВОЗР
		|");
		
	Запрос.УстановитьПараметр("Партнер",            Партнер);
	Запрос.УстановитьПараметр("ДоступноДляЗакупки", ДоступноДляЗакупки);
	Запрос.УстановитьПараметр("ДатаДокумента",      НачалоДня(ДатаДокумента));
	Запрос.УстановитьПараметр("СтрокаПоиска",       СтрокаПоиска + "%");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ДанныеВыбора = Новый СписокЗначений();
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Дата) И
				ЗначениеЗаполнено(Выборка.Номер) Тогда
				
				Представление = НСтр("ru='%Наименование% (%Номер% от %Дата%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Номер%",        Выборка.Номер);
				Представление = СтрЗаменить(Представление,"%Дата%",         Формат(Выборка.Дата, "ДФ=dd.MM.yyyy"));
				
			ИначеЕсли ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Дата) Тогда
				
				Представление = НСтр("ru='%Наименование% (от %Дата%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Дата%",         Формат(Выборка.Дата, "ДФ=dd.MM.yyyy"));
				
			ИначеЕсли ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Номер) Тогда
				
				Представление = НСтр("ru='%Наименование% (%Номер%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Номер%",        Выборка.Номер);
				
			Иначе
				
				Представление = НСтр("ru='%Наименование%'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				
			КонецЕсли;
			
			Структура = Новый Структура();
			Структура.Вставить("Значение", Выборка.Ссылка);
			
			Если Выборка.СрокДействияНеНаступил Тогда
				Структура.Вставить("Предупреждение", НСтр("ru='У соглашения не наступил срок действия.'"));
			ИначеЕсли Выборка.СрокДействияИстек Тогда
				Структура.Вставить("Предупреждение", НСтр("ru='У соглашения истек срок действия.'"));
			КонецЕсли;
			
			Если Выборка.ИндексКартинки = 0 Тогда
				Картинка = БиблиотекаКартинок.СоглашениеСПоставщиком;
			Иначе
				Картинка = БиблиотекаКартинок.СоглашениеСПоставщикомНеСогласовано;
			КонецЕсли;
				
			ДанныеВыбора.Добавить(
				Структура,
				Представление,
				,
				Картинка
			);
			
		КонецЦикла;
			
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПолученияДанныхВыбора()

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СоздатьСоглашениеПоУмолчанию(Знач Параметры) Экспорт
	
	Соглашение = Справочники.СоглашенияСПоставщиками.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(Соглашение, Параметры);
	Соглашение.Дата = ТекущаяДата();
	Соглашение.Статус = Перечисления.СтатусыСоглашенийСПоставщиками.Действует;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.Наименование) Тогда
		Соглашение.Наименование = НСтр("ru='Условия закупок с '") + Соглашение.Партнер;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.ВариантПриемкиТоваров) ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		Соглашение.ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.ПорядокОплаты) Тогда
		Соглашение.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях;
	КонецЕсли;
	
	Соглашение.Записать();
	
	Возврат Соглашение.Ссылка
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#КонецЕсли
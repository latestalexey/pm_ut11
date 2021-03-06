﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронныеДокументыКлиентПереопределяемый: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Переопределяет сообщение о нехватке прав доступа
//
// Параметры:
//  ТекстСообщения - строка сообщения
//
Процедура ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения) Экспорт
	
	// При необходимости можно переопределить или дополнить текст сообщения
	
КонецПроцедуры

// Производит заполнение реквизитов формы переданными значениями 
//
// Параметры:
//  Источник - Управляемая форма
//  ЗначениеЗаполнения - ссылка на хранилище
//
Процедура ОткрытьФормуВыбораПользователей(ЭтаФорма, ТекущийПользователь) Экспорт
	
	Параметры = Новый Структура("Ключ", ТекущийПользователь);
	Параметры.Вставить("РежимВыбора",             Истина);
	Параметры.Вставить("ТекущаяСтрока",           ТекущийПользователь);
	Параметры.Вставить("ВыборГруппПользователей", Ложь);
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", Параметры, ЭтаФорма);
	
КонецПроцедуры

// Проверяет на модифицированность объект в случае обычного приложения.
//
// Параметры:
//  Объект - объекта, модифицированность которого надо проверить;
//  Форма - форма объекта, модифицированность которого надо проверить.
//  Результат - Булево - результат проверки модифицированности формы объекта.
//
Процедура ОбъектМодифицирован(Объект, Форма, Результат) Экспорт
	
КонецПроцедуры

// Выполняет интерактивное проведение документов перед формированием ЭД.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры
//  ДокументыМассив - Массив           - ссылки на документы, которые требуется провести перед печатью.
//                                       После выполнения функции из массива исключаются непроведенные документы.
//  ФормаИсточник   - УправляемаяФорма - форма, из которой было вызвана команда.
//
// Возвращаемое значение:
//  Булево - есть документы для печати в параметре ДокументыМассив.
//
Функция ПроверитьДокументыПроведены(ДокументыМассив, ФормаИсточник = Неопределено) Экспорт
	
	ОчиститьСообщения();
	ДокументыТребующиеПроведение = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ДокументыМассив);
	КоличествоНепроведенныхДокументов = ДокументыТребующиеПроведение.Количество();
	
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронную версию документа, его необходимо предварительно провести. Выполнить проведение документа и продолжить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронные версии документов, их необходимо предварительно провести. Выполнить проведение документов и продолжить?'");
		КонецЕсли;
		
		КодОтвета = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если КодОтвета <> КодВозвратаДиалога.Да Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(ДокументыТребующиеПроведение);
		
		// сообщаем о документах, которые не провелись
		ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2 Формирование ЭД невозможно.'");
		НепроведенныеДокументы = Новый Массив;
		Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(ИнформацияОДокументе.Ссылка), 
					ИнформацияОДокументе.ОписаниеОшибки), ИнформацияОДокументе.Ссылка);
			НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);		
		КонецЦикла;
		
		КоличествоНепроведенныхДокументов = НепроведенныеДокументы.Количество();
		
		// Оповещаем открытые формы о том, что были проведены документы
		ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.СократитьМассив(ДокументыТребующиеПроведение, НепроведенныеДокументы);
		ТипыПроведенныхДокументов = Новый Соответствие;
		Для Каждого ПроведенныйДокумент Из ПроведенныеДокументы Цикл
			ТипыПроведенныхДокументов.Вставить(ТипЗнч(ПроведенныйДокумент));
		КонецЦикла;
		Для Каждого Тип Из ТипыПроведенныхДокументов Цикл
			ОповеститьОбИзменении(Тип.Ключ);
		КонецЦикла;
		
		// Если команда была вызвана из формы, то зачитываем в форму актуальную (проведенную) копию из базы.
		Если ТипЗнч(ФормаИсточник) = Тип("УправляемаяФорма") Тогда
			Попытка
				ФормаИсточник.Прочитать();
			Исключение
				// Если метода Прочитать нет, значит печать выполнена не из формы объекта.
			КонецПопытки;
		КонецЕсли;
		
		// Обновляем исходный массив документов
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.СократитьМассив(ДокументыМассив, НепроведенныеДокументы);
		
	КонецЕсли;
	
	ЕстьДокументыГотовыеДляФормированияЭД = ДокументыМассив.Количество() > 0;
	
	Отказ = Ложь;
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		// Спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов
		
		ТекстДиалога = НСтр("ru = 'Не удалось провести один или несколько документов.'");
		КнопкиДиалога = Новый СписокЗначений;
		
		Если ЕстьДокументыГотовыеДляФормированияЭД Тогда
			ТекстДиалога = ТекстДиалога + " " + НСтр("ru = 'Продолжить?'");
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
		Иначе
			КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
		КонецЕсли;
		
		Ответ = Вопрос(ТекстДиалога, КнопкиДиалога);
		Если Ответ <> КодВозвратаДиалога.Пропустить Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

// Проверяет на использование в прикладном решении библиотеки интернет поддержки пользователей.
//
// Параметры:
//  Использование - булево - признак использования библиотеки МПП..
//
Процедура ПроверитьИспользованиеИнтернетПоддержкаПользователей(Использование) Экспорт
	
КонецПроцедуры

// Вспомогательная процедура для запуска метода из библиотеки интернет поддержки пользователей.
//
Процедура СтартоватьМеханизмРаботыСОператоромЭДО(СертификатАбонента, Организация, ВариантБизнесПроцесса, ИдентификаторОрганизации = "") Экспорт
	
КонецПроцедуры

// Проверяет выполняются ли необходимые автоматические условия для подписи документа.
// 
// Параметры:
//  ЭлектронныйДокумент - ссылка на присоединенный файл.
//
Функция ЭлектронныйДокументГотовКПодписи(ЭлектронныйДокумент) Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет адрес хранилища с таблицей значений - каталога товаров
//
// Параметры:
//  АдресВоВременномХранилище - адрес хранения католога товаров;
//  ИдентификаторФормы - уникальный  идентификатор формы, вызвавшей функцию.
//
Процедура ПоместитьКаталогТоваровВоВременноеХранилище(АдресВоВременномХранилище, ИдентификаторФормы) Экспорт
	
	ЭлектронныеДокументыСлужебныйВызовСервера.ПоместитьКаталогТоваровВоВременноеХранилище(
													АдресВоВременномХранилище,
													ИдентификаторФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сопоставление номенклатуры

// В зависимости от прикладного решения определяет момент открытия формы сопоставления номенклатуры
//
//  Параметры:
//  СопоставлятьНоменклатуру - <Булево> - Истина - открывать форму сопоставления до заполнения документа, Ложь - в обратном порядке
//  Истина для УПП, БП
//  Ложь для УТ
//
Процедура СопоставлятьНоменклатуруПередЗаполнениемДокумента(СопоставлятьНоменклатуру) Экспорт
	
	СопоставлятьНоменклатуру = Ложь;
	
КонецПроцедуры

// Находит элемент номенклатуры поставщика и открывает форму просмотра
//
// Параметры:
//  Идентификатор - уникальный идентификатор объекта
//
Процедура ОткрытьЭлементНоменклатурыПоставщика(Идентификатор) Экспорт
	
	
	ДополнительныеРеквизиты = Новый Структура;
	ДополнительныеРеквизиты.Вставить("Идентификатор", Идентификатор);
	
	НоменклатураПоставщика = ЭлектронныеДокументыСлужебныйВызовСервера.НайтиСсылкуНаОбъект("НоменклатураПоставщиков",
																						   ,
																						   ДополнительныеРеквизиты);
		
	Если ЗначениеЗаполнено(НоменклатураПоставщика) Тогда
		ОткрытьЗначение(НоменклатураПоставщика);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Методы клиент - банка

// Разбирает переданный текстовый файл выписки.
//
// Параметры
//  ФайлСсылка - Строка, ссылка на временное хранилище
//  СоглашениеЭД - СправочникСсылка.СоглашениеОбИспользованииЭД - соглашение, по которому производится обмен.
//  НомерСчета - Строка, содержит номер счета выписки
//
Процедура РазобратьФайлВыписки(ФайлСсылка, СоглашениеЭД, НомерСчета) Экспорт
	
	
КонецПроцедуры


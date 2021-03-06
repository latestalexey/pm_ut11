﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Точка входа для выполнения итерации обмена данными – загрузки и выгрузки данных для узла плана обмена
//
// Параметры:
//  Отказ                  - Булево - флаг отказа; поднимается в случае возникновения ошибки при выполнении обмена
//  УзелИнформационнойБазы – ПланОбменаСсылка – узел плана обмена, для которого выполняется итерация обмена данными
//  ВыполнятьЗагрузку      – Булево (необязательный) – флаг необходимости выполнять загрузку данных. Значение по умолчанию - Истина
//  ВыполнятьВыгрузку      – Булево (необязательный) – флаг необходимости выполнять выгрузку данных. Значение по умолчанию – Истина
//  ВидТранспортаСообщенийОбмена (необязательный) - ПеречислениеСсылка.ВидыТранспортаСообщенийОбмена – вид транспорта, 
//								который будет использоваться в процессе обмена данными. 
//								Значение по умолчанию – значение из РС.НастройкиТранспортаОбмена.Ресурс.ВидТранспортаСообщенийОбменаПоУмолчанию;
//								если в РС значение не задано, то значение по умолчанию - Перечисления.ВидыТранспортаСообщенийОбмена.FILE
// 
Процедура ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ,
														УзелИнформационнойБазы,
														ВыполнятьЗагрузку = Истина,
														ВыполнятьВыгрузку = Истина,
														ВидТранспортаСообщенийОбмена = Неопределено,
														ДлительнаяОперация = Ложь,
														ИдентификаторОперации = "",
														ИдентификаторФайла = "",
														ДлительнаяОперацияРазрешена = Ложь,
														Знач Пароль = ""
	) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Отказ,
														УзелИнформационнойБазы,
														ВыполнятьЗагрузку,
														ВыполнятьВыгрузку,
														ВидТранспортаСообщенийОбмена,
														ДлительнаяОперация,
														ИдентификаторОперации,
														ИдентификаторФайла,
														ДлительнаяОперацияРазрешена,
														Пароль
	);
	
КонецПроцедуры

// Выполняет процесс обмена данными отдельно для каждой строки настройки обмена
// Процесс обмена данными состоит из двух стадий:
// - инициализация обмена - подготовка подсистемы обмена данными к процессу обмена
// - обмен данными        - процесс зачитывания файла сообщения с последующей загрузкой этих данных в ИБ 
//                          или выгрузки изменений в файл сообщения
// Стадия инициализации выполняется один раз за сеанс и сохраняется в кэше сеанса на сервере 
// до перезапуска сеанса или сброса повторно-используемых значений подсистемы обмена данными.
// Сброс повторно-используемых значений происходит при изменении данных, влияющих на процесс обмена данными
// (настройки транспорта, настройка выполнения обмена, настройка отборов на узлах планов обмена)
//
// Обмен может быть выполнен полностью для всех строк сценария,
// а может быть выполнен для отдельной строки ТЧ сценария обмена
//
// Параметры:
//  Отказ                     - Булево - флаг отказа; поднимается в случае возникновения ошибки при выполнении сценария
//  НастройкаВыполненияОбмена - СправочникСсылка.СценарииОбменовДанными - элемент справочника,
//                              по значениям реквизитов которого будет выполнен обмен данными
//  НомерСтроки               - Число - Номер строки по которой будет выполнен обмен данными.
//                              Если не указан, то обмен данными будет выполнен для всех строк
// 
Процедура ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, НастройкаВыполненияОбмена, НомерСтроки = Неопределено) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, НастройкаВыполненияОбмена, НомерСтроки);
	
КонецПроцедуры

//

// Выполняет проверку актуальности КЭШа механизма регистрации объектов.
// Если кэш неактуальный, то выполняется инициализация КЭШа актуальными значениями.
//
// Параметры:
//  Нет.
// 
Процедура ПроверитьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		АктуальнаяДата = ПолучитьФункциональнуюОпцию("АктуальнаяДатаОбновленияПовторноИспользуемыхЗначенийМРО");
		
		Если ПараметрыСеанса.ДатаОбновленияПовторноИспользуемыхЗначенийМРО <> АктуальнаяДата Тогда
			
			ОбновитьКэшМеханизмаРегистрацииОбъектов();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обновляет/устанавливает повторно-используемые значения и параметры сеанса для подсистемы обмена данными
//
// Устанавливаемые параметры сеанса:
//   ОбменДаннымиВключен         - Булево - флаг, который показывает следует или нет использовать обмен данными в конфигурации.
//                                Определяется косвенным образом по факту наличия обмена данными хотя бы с одним планом обмена.
//                                Наличие обмена с каким либо планом обмена определяется по наличию у этого плана обмена узлов
//                                кроме предопределенного.
//   ИспользуемыеПланыОбмена    - ФиксированныйМассив - массив с именами планов обмена для которых используется обмен.
//   ПравилаРегистрацииОбъектов - ХранилищеЗначения - в бинарном виде содержит таблицу значений с правилами регистрации объектов.
//   ПравилаВыборочнойРегистрацииОбъектов - 
//   ДатаОбновленияПовторноИспользуемыхЗначенийМРО - Дата (Дата и время) - содержит дату последнего актуального
//                                                                         кэша для подсистемы обмена данными
//
// Параметры:
//  Нет.
// 
Процедура ОбновитьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Обновляем повторно используемые значения
	ОбновитьПовторноИспользуемыеЗначения();
	
	// получаем планы обмена конфигурации, которые используются при обмене
	ИспользуемыеПланыОбмена = ОбменДаннымиСервер.ПолучитьИспользуемыеПланыОбмена();
	
	// флаг включения механизма обмена данными
	ОбменДаннымиВключен = (ИспользуемыеПланыОбмена.Количество() <> 0);
	
	// устанавливаем параметр сеанса ОбменДаннымиВключен
	ПараметрыСеанса.ОбменДаннымиВключен = ОбменДаннымиВключен;
	
	// устанавливаем параметр сеанса ИспользуемыеПланыОбмена
	ПараметрыСеанса.ИспользуемыеПланыОбмена = Новый ФиксированныйМассив(ИспользуемыеПланыОбмена);
	
	// получаем таблицу правил регистрации из ИБ
	ПравилаРегистрацииОбъектов = ОбменДаннымиСервер.ПолучитьПравилаРегистрацииОбъектов();
	
	// устанавливаем параметр сеанса ПравилаРегистрацииОбъектов
	ПараметрыСеанса.ПравилаРегистрацииОбъектов = Новый ХранилищеЗначения(ПравилаРегистрацииОбъектов);
	
	// устанавливаем параметр сеанса ПравилаВыборочнойРегистрацииОбъектов
	ПравилаВыборочнойРегистрацииОбъектов = ОбменДаннымиСервер.ПолучитьПравилаВыборочнойРегистрацииОбъектов();
	
	ПараметрыСеанса.ПравилаВыборочнойРегистрацииОбъектов = Новый ХранилищеЗначения(ПравилаВыборочнойРегистрацииОбъектов);
	
	// КЛЮЧ ДЛЯ ПРОВЕРКИ АКТУАЛЬНОСТИ КЭША
	
	// устанавливаем актуальную дату обновления кеша МРО
	АктуальнаяДата = ПолучитьФункциональнуюОпцию("АктуальнаяДатаОбновленияПовторноИспользуемыхЗначенийМРО");
	
	ПараметрыСеанса.ДатаОбновленияПовторноИспользуемыхЗначенийМРО = АктуальнаяДата;
	
КонецПроцедуры

// Устанавливает значение константы ДатаОбновленияПовторноИспользуемыхЗначенийМРО
// В качестве устанавливаемого значения используется текущая дата компьютера (сервера)
// В момент изменения значения этой константы повторно-используемые значения 
// для подсистемы обмена данными становятся неактуальными и требуют повторной инициализации.
//
// Параметры:
//  Нет.
// 
Процедура СброситьКэшМеханизмаРегистрацииОбъектов() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		// записываем дату и время компьютера сервера - ТекущаяДата()
		// метод ТекущаяДатаСеанса() использовать нельзя.
		// Текущая дата сервера в данном случае используется в качестве ключа уникальности кэша механизма регистрации объектов.
		Константы.ДатаОбновленияПовторноИспользуемыхЗначенийМРО.Установить(ТекущаяДата());
		
	КонецЕсли;
	
КонецПроцедуры

//

// Получает строку информации о правилах конвертации/регистрации из файла правил.
//
// Параметры:
//  АдресВременногоХранилища – адрес временного хранилища, в котором находятся данные файла правил;
//  СтрокаИнформацииОПравилах – в этот параметр процедура возвращает строку информации о правилах;
// 
Процедура ЗагрузитьИнформациюОПравилах(Отказ, АдресВременногоХранилища, СтрокаИнформацииОПравилах) Экспорт
	
	РегистрыСведений.ПравилаДляОбменаДанными.ЗагрузитьИнформациюОПравилах(Отказ, АдресВременногоХранилища, СтрокаИнформацииОПравилах);
	
КонецПроцедуры

// Выполняет загрузку данных сообщения обмена, расположенного в локальной файловой системе сервера.
//
Процедура ВыполнитьЗагрузкуДляУзлаИнформационнойБазыЧерезФайл(Отказ, Знач УзелИнформационнойБазы, Знач ПолноеИмяФайлаСообщенияОбмена) Экспорт
	
	Попытка
		ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЧерезФайлИлиСтроку(УзелИнформационнойБазы, ПолноеИмяФайлаСообщенияОбмена, Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	Исключение
		Отказ = Истина;
	КонецПопытки;
	
КонецПроцедуры

// Фиксирует успешное выполнение обмена данными в системе.
//
Процедура ЗафиксироватьВыполнениеВыгрузкиДанныхВРежимеДлительнойОперации(Знач УзелИнформационнойБазы, Знач ДатаНачала) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДействиеПриОбмене = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	
	СтруктураНастроекОбмена = Новый Структура;
	СтруктураНастроекОбмена.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
	СтруктураНастроекОбмена.Вставить("РезультатВыполненияОбмена", Перечисления.РезультатыВыполненияОбмена.Выполнено);
	СтруктураНастроекОбмена.Вставить("ДействиеПриОбмене", ДействиеПриОбмене);
	СтруктураНастроекОбмена.Вставить("КоличествоОбъектовОбработано", 0);
	СтруктураНастроекОбмена.Вставить("КлючСообщенияЖурналаРегистрации", ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене));
	СтруктураНастроекОбмена.Вставить("ДатаНачала", ДатаНачала);
	СтруктураНастроекОбмена.Вставить("ДатаОкончания", ТекущаяДатаСеанса());
	СтруктураНастроекОбмена.Вставить("ЭтоОбменВРИБ", ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(УзелИнформационнойБазы));
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена);
	
КонецПроцедуры

// Фиксирует аварийное завершение обмена данными.
//
Процедура ЗафиксироватьЗавершениеОбменаСОшибкой(Знач УзелИнформационнойБазы,
												Знач ДействиеПриОбмене,
												Знач ДатаНачала,
												Знач СтрокаСообщенияОбОшибке
	) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбменаСОшибкой(УзелИнформационнойБазы,
											ДействиеПриОбмене,
											ДатаНачала,
											СтрокаСообщенияОбОшибке
	);
КонецПроцедуры

// Выполняет получение файла сообщения обмена из базы-корреспондента через веб-сервис.
// Выполняет загрузку полученного файла сообщения обмена в эту базу.
//
Процедура ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
															Отказ,
															Знач УзелИнформационнойБазы,
															Знач ИдентификаторФайла,
															Знач ДатаНачалаОперации,
															Знач Пароль = ""
	) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЗавершениеДлительнойОперации(
															Отказ,
															УзелИнформационнойБазы,
															ИдентификаторФайла,
															ДатаНачалаОперации,
															Пароль
	);
КонецПроцедуры

// Выполняет попытку установки внешнего соединения по переданным параметрам подключения.
// Если установить внешнее соединение не удалось, то поднимается флаг Отказ.
//
Процедура ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ, СтруктураНастроек, ОшибкаПодключенияКомпоненты = Ложь) Экспорт
	
	СтрокаСообщенияОбОшибке = "";
	
	// выполняем попытку установки внешнего соединения
	ВнешнееСоединение = ОбменДаннымиСервер.УстановитьВнешнееСоединение(СтруктураНастроек, СтрокаСообщенияОбОшибке, ОшибкаПодключенияКомпоненты);
	
	Если ВнешнееСоединение = Неопределено Тогда
		
		// Выводим сообщение об ошибке
		Сообщение = НСтр("ru = 'Ошибка при установке подключения ко второй информационной базе: %1'");
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение, СтрокаСообщенияОбОшибке);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение,,,, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает признак того, что набора записей регистра не содержит данных.
//
Функция НаборЗаписейРегистраПустой(СтруктураЗаписи, ИмяРегистра) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	
	// создаем набор записей регистра
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	
	// устанавливаем отбор по измерениям регистра
	Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		
		// если задано значение в структуре, то отбор устанавливаем
		Если СтруктураЗаписи.Свойство(Измерение.Имя) Тогда
			
			НаборЗаписей.Отбор[Измерение.Имя].Установить(СтруктураЗаписи[Измерение.Имя]);
			
		КонецЕсли;
		
	КонецЦикла;
	
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Количество() = 0;
	
КонецФункции

// Возвращает ключ сообщения журнала регистрации по строке действия
//
Функция ПолучитьКлючСообщенияЖурналаРегистрацииПоСтрокеДействия(УзелИнформационнойБазы, ДействиеПриОбменеСтрокой) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, Перечисления.ДействияПриОбмене[ДействиеПриОбменеСтрокой]);
	
КонецФункции

// Возвращает структуру с данными отбора для журнала регистрации
//
Функция ПолучитьСтруктуруДанныхОтбораЖурналаРегистрации(УзелИнформационнойБазы, Знач ДействиеПриОбмене) Экспорт
	
	Если ТипЗнч(ДействиеПриОбмене) = Тип("Строка") Тогда
		
		ДействиеПриОбмене = Перечисления.ДействияПриОбмене[ДействиеПриОбмене];
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СостоянияОбменовДанными = РегистрыСведений.СостоянияОбменовДанными.СостоянияОбменовДанными(УзелИнформационнойБазы, ДействиеПриОбмене);
	
	Отбор = Новый Структура;
	Отбор.Вставить("СобытиеЖурналаРегистрации", ОбменДаннымиСервер.ПолучитьКлючСообщенияЖурналаРегистрации(УзелИнформационнойБазы, ДействиеПриОбмене));
	Отбор.Вставить("ДатаНачала",                СостоянияОбменовДанными.ДатаНачала);
	Отбор.Вставить("ДатаОкончания",             СостоянияОбменовДанными.ДатаОкончания);
	
	Возврат Отбор;
КонецФункции

// Получает код предопределенного узла плана обмена
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена как оно задано в конфигураторе
// 
// Возвращаемое значение:
//  Строка - код предопределенного узла плана обмена
//
Функция ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
КонецФункции

// Возвращает массив всех ссылочных типов, определенных в конфигурации
//
Функция ВсеСсылочныеТипыКонфигурации() Экспорт
	
	Возврат ОбменДаннымиПовтИсп.ВсеСсылочныеТипыКонфигурации();
	
КонецФункции

// Получает состояние длительной операции (фонового задания), выполняемой в базе-корреспонденте.
//
Функция СостояниеДлительнойОперации(Знач ИдентификаторОперации,
									Знач URLВебСервиса,
									Знач ИмяПользователя,
									Знач Пароль,
									СтрокаСообщенияОбОшибке = ""
	) Экспорт
	
	ПараметрыПодключения = ОбменДаннымиСервер.СтруктураПараметровWS();
	ПараметрыПодключения.WSURLВебСервиса   = URLВебСервиса;
	ПараметрыПодключения.WSИмяПользователя = ИмяПользователя;
	ПараметрыПодключения.WSПароль          = Пароль;
	
	WSПрокси = ОбменДаннымиСервер.ПолучитьWSПрокси(ПараметрыПодключения, СтрокаСообщенияОбОшибке);
	
	Если WSПрокси = Неопределено Тогда
		ВызватьИсключение СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	Возврат WSПрокси.GetContinuousOperationStatus(ИдентификаторОперации, СтрокаСообщенияОбОшибке);
КонецФункции

// Получает сообщение обмена из базы-корреспондента через веб-сервис.
// Сохраняет полученное сообщение обмена во временный каталог.
//
Функция ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервис(
											Отказ,
											УзелИнформационнойБазы,
											ИдентификаторФайла,
											ДлительнаяОперация,
											ИдентификаторОперации,
											Пароль = ""
	) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервис(
											Отказ,
											УзелИнформационнойБазы,
											ИдентификаторФайла,
											ДлительнаяОперация,
											ИдентификаторОперации,
											Пароль
	);
КонецФункции

// Получает сообщение обмена из базы-корреспондента через веб-сервис.
// Сохраняет полученное сообщение обмена во временный каталог.
// Используется в том случае, если получение сообщения обмена выполнялось в контексте фонового задания в базе-корреспонденте.
//
Функция ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервисЗавершениеДлительнойОперации(
							Отказ,
							УзелИнформационнойБазы,
							ИдентификаторФайла,
							Знач Пароль = ""
	) Экспорт
	
	Возврат ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталогИзИнформационнойБазыКорреспондентаЧерезВебСервисЗавершениеДлительнойОперации(
							Отказ,
							УзелИнформационнойБазы,
							ИдентификаторФайла,
							Пароль
	);
КонецФункции

// Возвращает признак изменения конфигурации для подчиненного узла распределенной ИБ.
//
Функция ТребуетсяУстановкаОбновления() Экспорт
	
	ОбменДаннымиСервер.ПроверитьВозможностьВыполненияОбменов();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиСервер.ТребуетсяУстановкаОбновления();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обмен данными под полными правами

// Устанавливает параметры сеанса подсистемы обмена данными
//
// Параметры:
//  ИмяПараметра - Строка - имя параметра сеанса, значение которого необходимо установить
//  УстановленныеПараметры - массив - в данный параметр помещается информация об установленных параметрах сеанса
// 
Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
	
	// процедура обновления повторно-используемых значений и параметров сеанса
	ОбновитьКэшМеханизмаРегистрацииОбъектов();
	
	// зарегистрируем имена параметров, которые установлены при 
	// выполнении ОбменДаннымиВызовСервера.ОбновитьКэшМеханизмаРегистрацииОбъектов
	УстановленныеПараметры.Добавить("ОбменДаннымиВключен");
	УстановленныеПараметры.Добавить("ИспользуемыеПланыОбмена");
	УстановленныеПараметры.Добавить("ПравилаВыборочнойРегистрацииОбъектов");
	УстановленныеПараметры.Добавить("ПравилаРегистрацииОбъектов");
	УстановленныеПараметры.Добавить("ДатаОбновленияПовторноИспользуемыхЗначенийМРО");
	
КонецПроцедуры

Процедура ВыполнитьОбработчикВПривилегированномРежиме(Значение, Знач СтрокаОбработчика) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ВызватьИсключение НСтр("ru = 'Метод не поддерживается в режиме управляемого приложения.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выполнить(СтрокаОбработчика);
	
КонецПроцедуры

// Находит регламентное задание по GUID
//
// Параметры:
//  УникальныйНомерЗадания - Строка - строка с GUID регламентного задания
// 
// Возвращаемое значение:
//  Неопределено               - если поиск регламентного задания по GUID не дал результатов
//  ТекущееРегламентноеЗадание - РегламентноеЗадание - найденное по GUID регламентное задание
//
Функция НайтиРегламентноеЗаданиеПоПараметру(УникальныйНомерЗадания) Экспорт
	
	// возвращаемое значение функции
	РегламентноеЗадание = Неопределено;
	
	Если ПустаяСтрока(УникальныйНомерЗадания) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(УникальныйНомерЗадания));
		
	Исключение
		
		РегламентноеЗадание = Неопределено;
		
	КонецПопытки;
	
	Возврат РегламентноеЗадание;
	
КонецФункции

// Возвращает структуру со значениями свойств объекта, полученных запросом из ИБ.
// Ключ структуры – имя свойства; Значение – значение свойства объекта.
//
// Параметры:
//  Ссылка – ссылка на объект ИБ, значения свойств которого требуется получить
// 
//  Возвращаемое значение:
//  Тип: Структура. Структура со значениями свойств объекта.
//
Функция ПолучитьЗначенияСвойствДляСсылки(Ссылка, СвойстваОбъекта, Знач СвойстваОбъектаСтрокой, Знач ОбъектМетаданныхИмя) Экспорт
	
	ЗначенияСвойств = ОбменДаннымиСобытия.СкопироватьСтруктуру(СвойстваОбъекта);
	
	Если ЗначенияСвойств.Количество() = 0 Тогда
		
		Возврат ЗначенияСвойств; // возвращаем пустую структуру
		
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	[СвойстваОбъектаСтрокой]
	|ИЗ
	|	[ОбъектМетаданныхИмя] КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка = &Ссылка
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[СвойстваОбъектаСтрокой]", СвойстваОбъектаСтрокой);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОбъектМетаданныхИмя]",    ОбъектМетаданныхИмя);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		Выборка = Запрос.Выполнить().Выбрать();
		
	Исключение
		
		// фиксируем ошибку в ЖР
		СтрокаСообщения = НСтр("ru = 'Ошибка при получении свойств ссылки. Ошибка выполнения запроса: [ОписаниеОшибки]'");
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "[ОписаниеОшибки]", ОписаниеОшибки());
		ОбменДаннымиСобытия.ЗаписьЖурналаРегистрацииПРО(СтрокаСообщения, Ссылка.Метаданные());
		
		// устанавливаем все свойства в значение "Неопределено"
		Для Каждого Элемент Из ЗначенияСвойств Цикл
			
			ЗначенияСвойств[Элемент.Ключ] = Неопределено;
			
		КонецЦикла;
		
		Возврат ЗначенияСвойств;
	КонецПопытки;
	
	Если Выборка.Следующий() Тогда
		
		Для Каждого Элемент Из ЗначенияСвойств Цикл
			
			ЗначенияСвойств[Элемент.Ключ] = Выборка[Элемент.Ключ];
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ЗначенияСвойств;
	
КонецФункции

// Возвращает массив узлов плана обмена по заданным параметрам запроса и тексту запроса к таблице плана обмена
//
//
Функция МассивУзловПоЗначениямСвойств(ЗначенияСвойств, Знач ТекстЗапроса, Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// возвращаемое значение функции
	МассивУзловРезультат = Новый Массив;
	
	// подготавливаем запрос для получения узлов планов обмена
	Запрос = Новый Запрос;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОбязательныеУсловия]",
				"И    ПланОбменаОсновнаяТаблица.Ссылка <> &" + ИмяПланаОбмена + "ЭтотУзел
				|И НЕ ПланОбменаОсновнаяТаблица.ПометкаУдаления
				|[УсловиеОтбораПоРеквизитуФлагу]
				|");
	//
	Если ПустаяСтрока(ИмяРеквизитаФлага) Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[УсловиеОтбораПоРеквизитуФлагу]", "");
		
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[УсловиеОтбораПоРеквизитуФлагу]",
			"И  (ПланОбменаОсновнаяТаблица.[ИмяРеквизитаФлага] = ЗНАЧЕНИЕ(Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию)
			|ИЛИ ПланОбменаОсновнаяТаблица.[ИмяРеквизитаФлага] = ЗНАЧЕНИЕ(Перечисление.РежимыВыгрузкиОбъектовОбмена.ПустаяСсылка))");
		//
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяРеквизитаФлага]", ИмяРеквизитаФлага);
		
	КонецЕсли;
	
	// текст запроса
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр(ИмяПланаОбмена + "ЭтотУзел", ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПланаОбмена(ИмяПланаОбмена));
	
	// задаем значения параметров запроса из свойств объекта
	Для Каждого Элемент Из ЗначенияСвойств Цикл
		
		Запрос.УстановитьПараметр("СвойствоОбъекта_" + Элемент.Ключ, Элемент.Значение);
		
	КонецЦикла;
	
	Попытка
		
		МассивУзловРезультат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
	Исключение
		
		// фиксируем ошибку в ЖР
		
		СтрокаСообщения = НСтр("ru = 'Ошибка при получении списка узлов получателей. Ошибка выполнения запроса: [ОписаниеОшибки]'");
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "[ОписаниеОшибки]", ОписаниеОшибки());
		
		ОбменДаннымиСобытия.ЗаписьЖурналаРегистрацииПРО(СтрокаСообщения);
		
		Возврат Новый Массив // возвращаем пустой массив
		
	КонецПопытки;
	
	// возвращаем результирующий массив узлов
	Возврат МассивУзловРезультат;
	
КонецФункции

// Возвращает значение параметра сеанса ПравилаРегистрацииОбъектов, полученное в привилегированном режиме.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Тип: ХранилищеЗначения. Значение параметра сеанса ПравилаРегистрацииОбъектов.
//
Функция ПараметрыСеансаПравилаРегистрацииОбъектов() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ПравилаРегистрацииОбъектов;
	
КонецФункции

// Функция возвращает список всех узлов заданного плана обмена кроме предопределенного узла
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, как оно задано в конфигураторе, список узлов для которого необходимо получить
//
//  Возвращаемое значение:
//   Массив – список всех узлов заданного плана обмена.
//
Функция ВсеУзлыПланаОбмена(Знач ИмяПланаОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ОбменДаннымиПовтИсп.ПолучитьМассивУзловПланаОбмена(ИмяПланаОбмена);
	
КонецФункции

// Возвращает признак того, что для получателя зарегистрированы изменения данных
//
Функция ИзмененияЗарегистрированы(Знач Получатель) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1 1
	|ИЗ
	|	[Таблица].Изменения КАК ТаблицаИзменений
	|ГДЕ
	|	ТаблицаИзменений.Узел = &Узел";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Узел", Получатель);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СоставПланаОбмена = Метаданные.ПланыОбмена[ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Получатель)].Состав;
	
	Для Каждого ЭлементСостава Из СоставПланаОбмена Цикл
		
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "[Таблица]", ЭлементСостава.Метаданные.ПолноеИмя());
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

// Признак наличия настроенного обмена данными – определяется по наличию узлов в планах обмена.
//
// Параметры:
//  Нет.
// 
//  Возвращаемое значение:
//  Тип: Булево. Истина – в системе есть настроенный обмен данными; Ложь – обмена нет.
//
Функция ОбменДаннымиВключен() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ОбменДаннымиВключен;
	
КонецФункции

// Получает массив узлов плана обмена, для которых установлен признак «Выгружать всегда»
//
// Параметры:
//  ИмяПланаОбмена    – Строка – имя плана обмена, как объекта метаданных, по которому определяются узлы
//  ИмяРеквизитаФлага – Строка – имя реквизита плана обмена, по которому устанавливается фильтр на выборку узлов 
// 
//  Возвращаемое значение:
//  Тип: Массив. Массив узлов плана обмена, для которых установлен признак «Выгружать всегда»
//
Функция ПолучитьМассивУзловДляРегистрацииВыгружатьВсегда(Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ШапкаПланаОбмена.Ссылка КАК Узел
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК ШапкаПланаОбмена
	|ГДЕ
	|	  ШапкаПланаОбмена.Ссылка <> &ЭтотУзел
	|	И ШапкаПланаОбмена.[ИмяРеквизитаФлага] = ЗНАЧЕНИЕ(Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВсегда)
	|	И Не ШапкаПланаОбмена.ПометкаУдаления
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]",    ИмяПланаОбмена);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяРеквизитаФлага]", ИмяРеквизитаФлага);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЭтотУзел", ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПланаОбмена(ИмяПланаОбмена));
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Узел");
	
КонецФункции

// Получает массив узлов плана обмена, для которых установлен признак «Выгружать при необходимости»
//
// Параметры:
//  Ссылка – ссылка на объект ИБ, для которого необходимо получить массив узлов, в которые объект ранее выгружался
//  ИмяПланаОбмена    – Строка – имя плана обмена, как объекта метаданных, по которому определяются узлы
//  ИмяРеквизитаФлага – Строка – имя реквизита плана обмена, по которому устанавливается фильтр на выборку узлов 
// 
//  Возвращаемое значение:
//  Тип: Массив. Массив узлов плана обмена, для которых установлен признак «Выгружать при необходимости»
//
Функция ПолучитьМассивУзловДляРегистрацииВыгружатьПриНеобходимости(Ссылка, Знач ИмяПланаОбмена, Знач ИмяРеквизитаФлага) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ШапкаПланаОбмена.Ссылка КАК Узел
	|ИЗ
	|	ПланОбмена.[ИмяПланаОбмена] КАК ШапкаПланаОбмена
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.СоответствияОбъектовИнформационныхБаз КАК СоответствияОбъектовИнформационныхБаз
	|ПО
	|	ШапкаПланаОбмена.Ссылка = СоответствияОбъектовИнформационныхБаз.УзелИнформационнойБазы
	|	И СоответствияОбъектовИнформационныхБаз.УникальныйИдентификаторИсточника = &Объект
	|ГДЕ
	|	     ШапкаПланаОбмена.Ссылка <> &ЭтотУзел
	|	И    ШапкаПланаОбмена.[ИмяРеквизитаФлага] = ЗНАЧЕНИЕ(Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости)
	|	И НЕ ШапкаПланаОбмена.ПометкаУдаления
	|	И    СоответствияОбъектовИнформационныхБаз.УникальныйИдентификаторИсточника = &Объект
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяПланаОбмена]",    ИмяПланаОбмена);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ИмяРеквизитаФлага]", ИмяРеквизитаФлага);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ЭтотУзел", ОбменДаннымиПовтИсп.ПолучитьЭтотУзелПланаОбмена(ИмяПланаОбмена));
	Запрос.УстановитьПараметр("Объект",   Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Узел");
	
КонецФункции


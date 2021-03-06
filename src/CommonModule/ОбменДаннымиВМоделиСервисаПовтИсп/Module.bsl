﻿////////////////////////////////////////////////////////////////////////////////
// ОбменДаннымиВМоделиСервисаПовтИсп: механизм обмена данными.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает ссылку на объект WSПрокси сервиса обмена версии 1.0.6.5.
//
// Возвращаемое значение:
// WSПрокси.
//
Функция ПолучитьWSПроксиСервисаОбмена() Экспорт
	
	НастройкиТранспорта = РегистрыСведений.НастройкиТранспортаОбмена.НастройкиТранспортаWS(
		РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса()
	);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("WSURLВебСервиса",   НастройкиТранспорта.WSURLВебСервиса);
	СтруктураНастроек.Вставить("WSИмяПользователя", НастройкиТранспорта.WSИмяПользователя);
	СтруктураНастроек.Вставить("WSПароль",          НастройкиТранспорта.WSПароль);
	СтруктураНастроек.Вставить("WSИмяСервиса",      "ManageApplicationExchange_1_0_6_5");
	СтруктураНастроек.Вставить("WSURLПространстваИменСервиса", "http://www.1c.ru/SaaS/1.0/WS/ManageApplicationExchange_1_0_6_5");
	СтруктураНастроек.Вставить("WSТаймаут", 20);
	
	Результат = ОбменДаннымиСервер.ПолучитьWSПроксиПоПараметрамПодключения(СтруктураНастроек);
	
	Если Результат = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка получения web-сервиса обмена данными управляющего приложения.'");
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Возвращает ссылку на объект WSПрокси корреспондента, идентифицируемого узлом плана обмена.
//
// Параметры:
// УзелИнформационнойБазы - ПланОбменаСсылка.
// СтрокаСообщенияОбОшибке - Строка - Текст сообщения об ошибке.
//
// Возвращаемое значение:
// WSПрокси.
//
Функция ПолучитьWSПроксиКорреспондента(УзелИнформационнойБазы, СтрокаСообщенияОбОшибке = "") Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.НастройкиТранспортаWS(УзелИнформационнойБазы);
	СтруктураНастроек.Вставить("WSИмяСервиса", "RemoteAdministrationOfExchange");
	СтруктураНастроек.Вставить("WSURLПространстваИменСервиса", "http://www.1c.ru/SaaS/1.0/WS/RemoteAdministrationOfExchange");
	СтруктураНастроек.Вставить("WSТаймаут", 20);
	
	Возврат ОбменДаннымиСервер.ПолучитьWSПроксиПоПараметрамПодключения(СтруктураНастроек, СтрокаСообщенияОбОшибке);
	
КонецФункции

// Возвращает ссылку на объект WSПрокси версии 2.0.1.6 корреспондента, идентифицируемого узлом плана обмена.
//
// Параметры:
// УзелИнформационнойБазы - ПланОбменаСсылка.
// СтрокаСообщенияОбОшибке - Строка - Текст сообщения об ошибке.
//
// Возвращаемое значение:
// WSПрокси.
//
Функция ПолучитьWSПроксиКорреспондента_2_0_1_6(УзелИнформационнойБазы, СтрокаСообщенияОбОшибке = "") Экспорт
	
	СтруктураНастроек = РегистрыСведений.НастройкиТранспортаОбменаОбластиДанных.НастройкиТранспортаWS(УзелИнформационнойБазы);
	СтруктураНастроек.Вставить("WSИмяСервиса", "RemoteAdministrationOfExchange_2_0_1_6");
	СтруктураНастроек.Вставить("WSURLПространстваИменСервиса", "http://www.1c.ru/SaaS/1.0/WS/RemoteAdministrationOfExchange_2_0_1_6");
	СтруктураНастроек.Вставить("WSТаймаут", 20);
	
	Возврат ОбменДаннымиСервер.ПолучитьWSПроксиПоПараметрамПодключения(СтруктураНастроек, СтрокаСообщенияОбОшибке);
КонецФункции

Функция СинхронизацияДанныхПоддерживается() Экспорт
	
	Возврат ПланыОбменаСинхронизацииДанных().Количество() > 0;
	
КонецФункции

Функция ПланыОбменаСинхронизацииДанных() Экспорт
	
	// План обмена для организации синхронизации данных в модели сервиса должен:
	// - быть подключенным к подсистеме обмена данными БСП
	// - быть разделенным
	// - быть планом обмена Не РИБ
	// - использоваться для обмена в модели сервиса (ПланОбменаИспользуетсяВМоделиСервиса = Истина)
	
	Результат = Новый Массив;
	
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		
		Если Не ПланОбмена.РаспределеннаяИнформационнаяБаза
			И ОбменДаннымиПовтИсп.ПланОбменаИспользуетсяВМоделиСервиса(ПланОбмена.Имя)
			И ОбменДаннымиСервер.ЭтоРазделенныйПланОбменаБСП(ПланОбмена.Имя) Тогда
			
			Результат.Добавить(ПланОбмена.Имя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция ЭтоПланОбменаСинхронизацииДанных(Знач ИмяПланаОбмена) Экспорт
	
	Возврат ПланыОбменаСинхронизацииДанных().Найти(ИмяПланаОбмена) <> Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обмен сообщениями

// Возвращает URI пространство имен XDTO-пакета АдминистрированиеОбменаДаннымиУправление.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетАдминистрированиеОбменаДаннымиУправление() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ExchangeAdministration/Manage";
	
КонецФункции

// Возвращает URI пространство имен XDTO-пакета АдминистрированиеОбменаДаннымиКонтроль.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетАдминистрированиеОбменаДаннымиКонтроль() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ExchangeAdministration/Control";
	
КонецФункции

// Возвращает URI пространство имен XDTO-пакета ОбменДаннымиУправление.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетОбменДаннымиУправление() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/Exchange/Manage";
	
КонецФункции

// Возвращает URI пространство имен XDTO-пакета ОбменДаннымиКонтроль.
//
// Возвращаемое значение:
// Строка.
//
Функция ПакетОбменДаннымиКонтроль() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/Exchange/Control";
	
КонецФункции

//

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПодключитьКорреспондента() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "ConnectCorrespondent");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеУстановитьНастройкиТранспорта() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "SetTransportParams");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетАдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеКорреспондентУспешноПодключен() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "CorrespondentConnectionCompleted");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетАдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаПодключенияКорреспондента() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "CorrespondentConnectionFailed");
	
КонецФункции

//

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПолучитьНастройкиСинхронизацииДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "GetSyncSettings");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетАдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеНастройкиСинхронизацииДанныхПолучены() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "GettingSyncSettingsCompleted");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетАдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаПолученияНастроекСинхронизацииДанных() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "GettingSyncSettingsFailed");
	
КонецФункции

//

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеУдалитьНастройкуСинхронизации() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "DeleteSync");
	
КонецФункции

//

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеВключитьСинхронизацию() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "EnableSync");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОтключитьСинхронизацию() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "DisableSync");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетАдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеВключениеСинхронизацииУспешноЗавершено() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "EnableSyncCompleted");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетАдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеСинхронизацияУспешноОтключена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "DisableSyncCompleted");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетАдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаВключенияСинхронизации() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "EnableSyncFailed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетАдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаОтключенияСинхронизации() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "DisableSyncFailed");
	
КонецФункции

//

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеНастроитьОбменШаг1() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиУправление(), "SetupExchangeStep1");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеНастроитьОбменШаг2() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиУправление(), "SetupExchangeStep2");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеЗагрузитьСообщениеОбмена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиУправление(), "DownloadMessage");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПолучитьДанныеКорреспондента() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиУправление(), "GetData");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПолучитьОбщиеДанныеУзловКорреспондента() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиУправление(), "GetCommonNodsData");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПолучитьПараметрыУчетаКорреспондента() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиУправление(), "GetCorrespondentParams");
	
КонецФункции

//

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеНастройкаОбменаШаг1УспешноЗавершена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "SetupExchangeStep1Completed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеНастройкаОбменаШаг2УспешноЗавершена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "SetupExchangeStep2Completed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаНастройкиОбменаШаг1() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "SetupExchangeStep1Failed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаНастройкиОбменаШаг2() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "SetupExchangeStep2Failed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеЗагрузкаСообщенияОбменаУспешноЗавершена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "DownloadMessageCompleted");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаЗагрузкиСообщенияОбмена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "DownloadMessageFailed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПолучениеДанныхКорреспондентаУспешноЗавершено() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "GettingDataCompleted");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПолучениеОбщихДанныхУзловКорреспондентаУспешноЗавершено() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "GettingCommonNodsDataCompleted");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаПолученияДанныхКорреспондента() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "GettingDataFailed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаПолученияОбщихДанныхУзловКорреспондента() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "GettingCommonNodsDataFailed");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПолучениеПараметровУчетаКорреспондентаУспешноЗавершено() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "GettingCorrespondentParamsCompleted");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета ПакетОбменДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеОшибкаПолученияПараметровУчетаКорреспондента() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетОбменДаннымиКонтроль(), "GettingCorrespondentParamsFailed");
	
КонецФункции

//

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПротолкнутьСинхронизацию() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "PushSync");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеПротолкнутьСинхронизациюДвухПриложений() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "PushTwoApplicationSync");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиУправление по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеВыполнитьСинхронизацию() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиУправление(), "ExecuteSync");
	
КонецФункции

// Возвращает тип объекта XDTO-пакета АдминистрированиеОбменаДаннымиКонтроль по его имени.
//
// Возвращаемое значение:
// ТипОбъектаXDTO.
//
Функция СообщениеСинхронизацияЗавершена() Экспорт
	
	Возврат ФабрикаXDTO.Тип(ПакетАдминистрированиеОбменаДаннымиКонтроль(), "SyncCompleted");
	
КонецФункции

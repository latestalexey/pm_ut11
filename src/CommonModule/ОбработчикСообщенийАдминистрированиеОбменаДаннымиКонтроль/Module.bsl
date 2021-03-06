﻿////////////////////////////////////////////////////////////////////////////////
// Обработка сообщений администрирования обмена данными
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений
//
// Параметры:
//  <КаналСообщений> (обязательный). Тип:Строка. Идентификатор канала сообщений, из которого получено сообщение.
//  <ТелоСообщения> (обязательный). Тип: Произвольный. Тело сообщения, полученное из канала, которое подлежит обработке.
//  <Отправитель> (обязательный). Тип: ПланОбменаСсылка.ОбменСообщениями. Конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(Знач КаналСообщений, Знач ТелоСообщения, Знач Отправитель) Экспорт
	
	ТипСообщения = СообщенияВМоделиСервиса.ТипСообщенияПоИмениКанала(КаналСообщений);
	
	Сообщение = СообщенияВМоделиСервиса.ПрочитатьСообщениеИзНетипизированногоТела(ТелоСообщения);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, Сообщение.Body.Zone);
	
	Словарь = ОбменДаннымиВМоделиСервисаПовтИсп;
	
	СообщенияВМоделиСервиса.ЗаписатьСобытиеНачалоОбработки(Сообщение);
	
	Если ТипСообщения = Словарь.СообщениеНастройкиСинхронизацииДанныхПолучены() Тогда
		
		ОбменДаннымиВМоделиСервиса.СохранитьДанныеСессии(Сообщение, ПредставлениеОперацииПолученияНастроек());
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаПолученияНастроекСинхронизацииДанных() Тогда
		
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеОперацииПолученияНастроек());
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеВключениеСинхронизацииУспешноЗавершено() Тогда
		
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеВключениеСинхронизации());
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаВключенияСинхронизации() Тогда
		
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеВключениеСинхронизации());
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеСинхронизацияУспешноОтключена() Тогда
		
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеОтключениеСинхронизации());
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаОтключенияСинхронизации() Тогда
		
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеОтключениеСинхронизации());
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеСинхронизацияЗавершена() Тогда
		
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеВыполнениеСинхронизации());
		
	Иначе
		
		СообщенияВМоделиСервиса.ОшибкаНеизвестноеИмяКанала(КаналСообщений);
		
	КонецЕсли;
	
	СообщенияВМоделиСервиса.ЗаписатьСобытиеОкончаниеОбработки(Сообщение);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПредставлениеОперацииПолученияНастроек()
	
	Возврат НСтр("ru = 'Получение настроек синхронизации данных из Менеджера сервиса.'");
	
КонецФункции

Функция ПредставлениеВключениеСинхронизации()
	
	Возврат НСтр("ru = 'Включение синхронизации данных в Менеджере сервиса.'");
	
КонецФункции

Функция ПредставлениеОтключениеСинхронизации()
	
	Возврат НСтр("ru = 'Отключение синхронизации данных в Менеджере сервиса.'");
	
КонецФункции

Функция ПредставлениеВыполнениеСинхронизации()
	
	Возврат НСтр("ru = 'Выполнение синхронизации данных по запросу пользователя.'");
	
КонецФункции

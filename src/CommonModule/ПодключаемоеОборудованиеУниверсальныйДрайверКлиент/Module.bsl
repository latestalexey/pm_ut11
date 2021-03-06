﻿
///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция осуществляет подключение устройства.
//
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	ВыходныеПараметры = Новый Массив();
	ПараметрыПодключения.Вставить("ИДУстройства", Неопределено);

	Для Каждого Параметр Из Параметры Цикл
		Если Лев(Параметр.Ключ, 2) = "P_" Тогда
			ЗначениеПараметра = Параметр.Значение;
			ИмяПараметра = Сред(Параметр.Ключ, 3);
			ОбъектДрайвера.УстановитьПараметр(ИмяПараметра, ЗначениеПараметра) 
		КонецЕсли;
	КонецЦикла;
                                               
	Если Результат Тогда
		Ответ = ОбъектДрайвера.Подключить(ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		Иначе
			ПараметрыПодключения.Вставить("КодОригинальнойТранзакции", Неопределено);
			ПараметрыПодключения.Вставить("ТипТранзакции", "");
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ОбъектДрайвера.Отключить(ПараметрыПодключения.ИДУстройства);

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт
	
	Результат = Истина;
	
	ВыходныеПараметры = Новый Массив();
	
	// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ ВСЕХ ТИПОВ ДРАЙВЕРОВ
	
	// Тестирование устройства
	Если Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" ИЛИ Команда = "GetVersion" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Получение описание драйвера
	ИначеЕсли Команда = "ПолучитьОписаниеДрайвера" ИЛИ Команда = "GetDescription" Тогда
		Результат = ПолучитьОписаниеДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ФИСКАЛЬНЫМИ РЕГИСТРАТОРАМИ
	
	// Открыть смену
	ИначеЕсли Команда = "OpenDay" ИЛИ Команда = "ОткрытьСмену" Тогда
		Результат = ОткрытьСмену(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Печать отчета без гашения
	ИначеЕсли Команда = "PrintXReport" ИЛИ Команда = "НапечататьОтчетБезГашения" Тогда
		Результат = НапечататьОтчетБезГашения(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Печать отчета с гашением
	ИначеЕсли Команда = "PrintZReport" ИЛИ Команда = "НапечататьОтчетСГашением" Тогда
		Результат = НапечататьОтчетСГашением(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Печать чека
	ИначеЕсли Команда = "PrintReceipt" ИЛИ Команда = "ПечатьЧека" Тогда
		Результат = ПечатьЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры,	ВыходныеПараметры);

	// Печать слип чека
	ИначеЕсли Команда = "PrintText" ИЛИ Команда = "ПечатьТекста"  Тогда
		СтрокаТекста   = ВходныеПараметры[0];
		Результат = ПечатьТекста(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                         СтрокаТекста, ВыходныеПараметры);
	
	// Печать чека внесения/выемки
	ИначеЕсли Команда = "Encash" ИЛИ Команда = "Инкассация" Тогда
		ТипИнкассации = ВходныеПараметры[0];
		Сумма         = ВходныеПараметры[1];
		Результат = Инкассация(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипИнкассации, Сумма, ВыходныеПараметры);
		
	ИначеЕсли Команда = "PrintBarCode" ИЛИ Команда = "ПечатьШтрихкода" Тогда
		ТипШтрихКода = ВходныеПараметры[0];
		ШтрихКод     = ВходныеПараметры[1];
		Результат = ПечатьШтрихкода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипШтрихКода, ШтрихКод, ВыходныеПараметры);
		
	// Открытие денежного ящика
	ИначеЕсли Команда = "OpenCashDrawer" ИЛИ Команда = "ОткрытьДенежныйЯщик" Тогда
		Результат = ОткрытьДенежныйЯщик(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ТЕРМИНАЛАМИ СБОРА ДАННЫМИ
	
	// Выгрузка таблицы в терминал сбора данных
	ИначеЕсли Команда =  "UploadDirectory" ИЛИ Команда = "ВыгрузитьТаблицу" Тогда
		ТаблицаВыгрузки = ВходныеПараметры[1];
		Результат = ВыгрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                             ТаблицаВыгрузки, ВыходныеПараметры);
	// Загрузка таблицы из терминала сбора данных
	ИначеЕсли Команда = "DownloadDocument" ИЛИ Команда = "ЗагрузитьТаблицу" Тогда
		Результат = ЗагрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Очищает загруженную ранее таблицу в терминале сбора данных
	ИначеЕсли Команда = "ClearTable" ИЛИ Команда = "ОчиститьТаблицу" Тогда
		Результат = ОчиститьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ДИСПЛЕЯМИ ПОКУПАТЕЛЯ
	
	// Вывод строк на дисплей
	ИначеЕсли Команда = "DisplayText" ИЛИ Команда = "ВывестиСтрокуНаДисплейПокупателя" Тогда
		СтрокаТекста = ВходныеПараметры[0];
		Результат = ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры);
		
	// Очистка дисплея
	ИначеЕсли Команда = "ClearText" ИЛИ Команда = "ОчиститьДисплейПокупателя" Тогда
		Результат = ОчиститьДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Получить параметры вывода
	ИначеЕсли Команда = "GetOutputOptions" ИЛИ Команда = "ПолучитьПараметрыВывода" Тогда
		Результат = ПолучитьПараметрыВывода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ЭЛЕКТРОННЫМИ ВЕСАМИ
	
	// Получить вес 
	ИначеЕсли Команда = "GetWeight" ИЛИ Команда = "ПолучитьВес" Тогда
		Результат = ПолучитьВес(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Установить вес тары 
	ИначеЕсли Команда = "Calibrate" ИЛИ Команда = "Тарировать" Тогда
		ВесТары = ?(ТипЗнч(ВходныеПараметры) = Тип("Массив") И ВходныеПараметры.Количество() > 0, ВходныеПараметры[0], Неопределено);
		Результат = Тарировать(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВесТары, ВыходныеПараметры);
		
	// Указанная команда не поддерживается данным драйвером
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ФИСКАЛЬНЫМИ РЕГИСТРАТОРАМИ

// Функция осуществляет открытие смены
//
Функция ОткрытьСмену(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	// Заполнение выходных параметров
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(ТекущаяДата());
	Возврат Результат;
	
КонецФункции

// Осуществляет печать фискального чека
//
Функция ПечатьЧека(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры)
	       
	Возврат МенеджерОборудованияКлиентСерверПереопределяемый.ПечатьЧека(ПодключаемоеОборудованиеУниверсальныйДрайверКлиент,
		ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры);
		
КонецФункции

// Осуществляет печать текста
//
Функция ПечатьТекста(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                       СтрокаТекста, ВыходныеПараметры)

	Результат  = Истина;

	// Открываем чек
	Результат = ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, Ложь, Ложь, ВыходныеПараметры);

	// Печатаем строки чека
	Если Результат Тогда
		Для НомерСтроки = 1 По СтрЧислоСтрок(СтрокаТекста) Цикл
			ВыделеннаяСтрока = СтрПолучитьСтроку(СтрокаТекста, НомерСтроки);
			Если НЕ НапечататьНефискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыделеннаяСтрока, ВыходныеПараметры) Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Закрываем чек
	Если Результат Тогда
		ТаблицаОплат = Новый Массив();
		Результат = ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет открытие нового чека
//
Функция ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ЧекВозврата, ФискальныйЧек, ВыходныеПараметры) Экспорт
	
	Результат  = Истина;
	НомерСмены = 0;
	НомерЧека  = 0;

	Попытка
		Ответ = ОбъектДрайвера.ОткрытьЧек(ПараметрыПодключения.ИДУстройства, ФискальныйЧек, ЧекВозврата,  Истина, НомерЧека, НомерСмены);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Иначе
			// Заполнение выходных параметров
			ВыходныеПараметры.Добавить(НомерСмены);
			ВыходныеПараметры.Добавить(НомерЧека);
			ВыходныеПараметры.Добавить(0); // Номер документа
			ВыходныеПараметры.Добавить(ТекущаяДата());
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ОткрытьЧек>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет закрытие ранее открытого чека
//
Функция ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры) Экспорт

	Результат = Истина;
	
	СуммаНаличнойОплаты     = 0;
	СуммаБезналичнойОплаты1 = 0;
	СуммаБезналичнойОплаты2 = 0;
	СуммаБезналичнойОплаты3 = 0;
	
	Для ИндексОплаты = 0 По ТаблицаОплат.Количество() - 1 Цикл
		Если ТаблицаОплат[ИндексОплаты][0].Значение = 0 Тогда
			СуммаНаличнойОплаты = СуммаНаличнойОплаты + ТаблицаОплат[ИндексОплаты][1].Значение;
		ИначеЕсли ТаблицаОплат[ИндексОплаты][0].Значение = 1 Тогда
			СуммаБезналичнойОплаты1 = СуммаБезналичнойОплаты1 + ТаблицаОплат[ИндексОплаты][1].Значение;
		ИначеЕсли ТаблицаОплат[ИндексОплаты][0].Значение = 2 Тогда
			СуммаБезналичнойОплаты2 = СуммаБезналичнойОплаты2 + ТаблицаОплат[ИндексОплаты][1].Значение;
		Иначе
			СуммаБезналичнойОплаты3 = СуммаБезналичнойОплаты3 + ТаблицаОплат[ИндексОплаты][1].Значение;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Ответ = ОбъектДрайвера.ЗакрытьЧек(ПараметрыПодключения.ИДУстройства,
	                                      СуммаНаличнойОплаты, СуммаБезналичнойОплаты1, СуммаБезналичнойОплаты2, СуммаБезналичнойОплаты3);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
			
			ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		КонецЕсли
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ЗакрытьЧек>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;

КонецФункции

// Функция осуществляет отмену ранее открытого чека.
//
Функция ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	
	Попытка
		ОбъектДрайвера.ОтменитьЧек(ПараметрыПодключения.ИДУстройства);
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ОтменитьЧек>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;   
	
КонецФункции

// Функция осуществляет снятие отчёта без гашения 
//
Функция НапечататьОтчетБезГашения(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.НапечататьОтчетБезГашения(ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Иначе
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(ТекущаяДата());
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.НапечататьОтчетБезГашения>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет снятие отчёта с гашением 
//
Функция НапечататьОтчетСГашением(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.НапечататьОтчетСГашением(ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Иначе
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(ТекущаяДата());
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.НапечататьОтчетСГашением>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет печать фискальной строки 
//
Функция НапечататьФискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                   Наименование, Количество, Цена, ПроцентСкидки, Сумма,
                                   НомерСекции, СтавкаНДС, ВыходныеПараметры) Экспорт
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.НапечататьФискСтроку(ПараметрыПодключения.ИДУстройства, Наименование, Количество, Цена,
	                                                Сумма, НомерСекции, СтавкаНДС);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
			ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.НапечататьФискСтроку>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет печать нефискальной строки 
//
Функция НапечататьНефискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.НапечататьНефискСтроку(ПараметрыПодключения.ИДУстройства, СтрокаТекста);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
			ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.НапечататьНефискСтроку>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет внесение или выемку суммы 
//
Функция Инкассация(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипИнкассации, Сумма, ВыходныеПараметры)
	
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.НапечататьЧекВнесенияВыемки(ПараметрыПодключения.ИДУстройства,
	                           ?(ТипИнкассации = 1, Сумма, -Сумма));
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		Иначе
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(0);
			ВыходныеПараметры.Добавить(ТекущаяДата());
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.НапечататьЧекВнесенияВыемки>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет печать штрихкода 
//
Функция ПечатьШтрихкода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипШтрихКода, ШтрихКод, ВыходныеПараметры)
	
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.НапечататьШтрихКод(ПараметрыПодключения.ИДУстройства, ТипШтрихКода, ШтрихКод);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.НапечататьШтрихКод>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет открытие денежного ящика
//
Функция ОткрытьДенежныйЯщик(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.ОткрытьДенежныйЯщик(ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ОткрытьДенежныйЯщик>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;

КонецФункции

// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ТЕРМИНАЛАМИ СБОРА ДАННЫМИ

// Функция осуществляет выгрузку данных в терминал сбора данных.
//
Функция ВыгрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаВыгрузки, ВыходныеПараметры)

	Результат = Истина;

	Если ТаблицаВыгрузки.Количество() = 0 Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Нет данных для выгрузки.'"));
		Возврат Ложь;
	КонецЕсли;
	
	РазмерПакета     = 100;
	ТекущийПакет     = 1;
	ЗаписьВПакете    = 0;
	ЗаписейВыгружено = 0;
	ЗаписейВсего     = ТаблицаВыгрузки.Количество();
	СтатусПакета     = "first";
	
	ТекущийПроцент = 0;
	Состояние(НСтр("ru='Инициализация выгрузки...'"), Окр(ТекущийПроцент));
	ПроцентИнкремент = 100 / (ЗаписейВсего / РазмерПакета);
	
	МассивТоваров = Новый Массив;

	Для Каждого Позиция Из ТаблицаВыгрузки  Цикл
		
		Если ЗаписьВПакете = 0 Тогда
		    МассивТоваров.Очистить();
		КонецЕсли;
		
		СтрокаМассиваТСД = Новый СписокЗначений; 
		СтрокаМассиваТСД.Добавить(Позиция[0].Значение);
		СтрокаМассиваТСД.Добавить(Позиция[1].Значение);
		СтрокаМассиваТСД.Добавить(Позиция[2].Значение);
		СтрокаМассиваТСД.Добавить(Позиция[3].Значение);
		СтрокаМассиваТСД.Добавить(Позиция[4].Значение);
		СтрокаМассиваТСД.Добавить(Позиция[5].Значение);
		СтрокаМассиваТСД.Добавить(Позиция[6].Значение);
		СтрокаМассиваТСД.Добавить(Позиция[7].Значение);
		МассивТоваров.Добавить(СтрокаМассиваТСД);
		
		ЗаписейВыгружено  = ЗаписейВыгружено + 1;
		ЗаписьВПакете = ЗаписьВПакете + 1;
		
		Если (ЗаписьВПакете = РазмерПакета) ИЛИ (ЗаписейВыгружено = ЗаписейВсего) Тогда  
			
			ДанныеДляВыгрузки = МенеджерОборудованияСервер.СформироватьТаблицуТоваров(МассивТоваров);
			
			Если (ЗаписейВыгружено = ЗаписейВсего) Тогда
				СтатусПакета = "last";
			ИначеЕсли (ТекущийПакет > 1) Тогда
				СтатусПакета = "regular";
			КонецЕсли;
			
			Ответ = ОбъектДрайвера.ВыгрузитьТаблицу(ПараметрыПодключения.ИДУстройства, ДанныеДляВыгрузки, СтатусПакета);
			Если НЕ Ответ Тогда
				Результат = Ложь;
				ВыходныеПараметры.Очистить();
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить("");
				ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
				Возврат Результат;
			КонецЕсли;
			
			ЗаписьВПакете = 0;
			ТекущийПакет = ТекущийПакет + 1;
			
			ТекущийПроцент = ТекущийПроцент + ПроцентИнкремент;
			Состояние(НСтр("ru='Выгрузка данных...'"), Окр(ТекущийПроцент));
			 
		 КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

// Функция осуществляет загрузку таблицы из терминала сбора данных.
//
Функция ЗагрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	ДанныеЗагрузки = "";
	Состояние(НСтр("ru='Загрузка данных...'"));
	
	Попытка
		
		Ответ = ОбъектДрайвера.ЗагрузитьТаблицу(ПараметрыПодключения.ИДУстройства, ДанныеЗагрузки);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		КонецЕсли;      
		
		Если НЕ ПустаяСтрока(ДанныеЗагрузки) Тогда
			МассивДанных = МенеджерОборудованияСервер.ПолучитьТаблицуТоваров(ДанныеЗагрузки);
		КонецЕсли;
	
		Если ПустаяСтрока(ДанныеЗагрузки) Или (МассивДанных.Количество() = 0) Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(НСтр("ru='Нет данных для загрузки.'"));
		Иначе
			ВыходныеПараметры.Добавить(МассивДанных);
		КонецЕсли;   
		
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ЗагрузитьТаблицу>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Очищает загруженную ранее таблицу товаров в ТСД
//
Функция ОчиститьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	Состояние(НСтр("ru='Выполнение операции...'"));	
	
	Попытка
		Ответ = ОбъектДрайвера.ОчиститьТаблицу(ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ОчиститьТаблицу>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;

КонецФункции

// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ДИСПЛЕЯМИ ПОКУПАТЕЛЯ

// Функция осуществляет вывод списка строк на дисплей покупателя.
//
Функция ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры)
	
	Результат = Истина;
	
	МассивСтрок = Новый Массив();
	МассивСтрок.Добавить(СтрПолучитьСтроку(СтрокаТекста, 1));
	МассивСтрок.Добавить(СтрПолучитьСтроку(СтрокаТекста, 2));
	
	Попытка
		Ответ = ОбъектДрайвера.ВывестиСтрокуНаДисплейПокупателя(ПараметрыПодключения.ИДУстройства, МассивСтрок);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ВывестиСтрокуНаДисплейПокупателя>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет очистку дисплея покупателя.
//
Функция ОчиститьДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.ОчиститьДисплейПокупателя(ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ОчиститьДисплейПокупателя>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает параметры вывода на дисплей покупателя)
//
Функция ПолучитьПараметрыВывода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	СтолбцовНаДисплее = 20; 
	СтрокНаДисплее    = 2;
	
	Попытка
		Ответ = ОбъектДрайвера.ПолучитьПараметрыВывода(ПараметрыПодключения.ИДУстройства, СтолбцовНаДисплее, СтрокНаДисплее);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		Иначе
			ВыходныеПараметры.Очистить();  
			ВыходныеПараметры.Добавить(СтолбцовНаДисплее);
			ВыходныеПараметры.Добавить(СтрокНаДисплее);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ПолучитьПараметрыВывода>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ЭЛЕКТРОННЫМИ ВЕСАМИ

// Функция осуществляет получение веса груза, расположенного на весах
//
Функция ПолучитьВес(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	Вес = 0;
	
	Попытка
		Ответ = ОбъектДрайвера.ПолучитьВес(ПараметрыПодключения.ИДУстройства, Вес);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		Иначе
			ВыходныеПараметры.Очистить();  
			ВыходныеПараметры.Добавить(Вес);
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ПолучитьВес>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет установку веса тары на весах
//
Функция Тарировать(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВесТары = 0, ВыходныеПараметры)
	
	Результат = Истина;
	
	Попытка
		Ответ = ОбъектДрайвера.УстановитьВесТары(ПараметрыПодключения.ИДУстройства, ВесТары);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		Иначе
			ВыходныеПараметры.Очистить();  
		КонецЕсли;
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.Тарировать>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ ВСЕХ ТИПОВ ДРАЙВЕРОВ

// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат            = Истина;
	РезультатТеста       = "";
	АктивированДемоРежим = "";
	
	Для Каждого Параметр Из Параметры Цикл
		Если Лев(Параметр.Ключ, 2) = "P_" Тогда
			ЗначениеПараметра = Параметр.Значение;
			ИмяПараметра = Сред(Параметр.Ключ, 3);
			Ответ = ОбъектДрайвера.УстановитьПараметр(ИмяПараметра, ЗначениеПараметра) 
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Ответ = ОбъектДрайвера.ТестУстройства(РезультатТеста, АктивированДемоРежим);
	
		Если Ответ Тогда
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(0);
		Иначе
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
		КонецЕсли;
		ВыходныеПараметры.Добавить(РезультатТеста);
		ВыходныеПараметры.Добавить(АктивированДемоРежим);
	
	Исключение
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Ошибка вызова метода <ОбъектДрайвера.ТестУстройства>: '") + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
	КонецПопытки;

	Возврат Результат;

КонецФункции

// Функция возвращает описание установленного драйвера
//
Функция ПолучитьОписаниеДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	
	ВыходныеПараметры.Очистить();
	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));
	
	ВыходныеПараметры.Добавить(НСтр("ru='Не определено'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определено'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определено'"));
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	
	НаименованиеДрайвера      = "";
	ОписаниеДрайвера          = "";
	ТипОборудования           = "";
	ИнтеграционнаяБиблиотека  = "";
	ОсновнойДрайверУстановлен = "";
	РевизияИнтерфейса         = "";
	URLCкачивания             = "";
	ПараметрыДрайвера         = "";
	ДополнительныеДействия    = "";
	
	Попытка
		// Получаем версию драйвера
		ВерсияДрайвера = ОбъектДрайвера.ПолучитьНомерВерсии();
		ВыходныеПараметры[1] = ВерсияДрайвера;

		// Получаем описание драйвера
		ОбъектДрайвера.ПолучитьОписание(НаименованиеДрайвера, 
										ОписаниеДрайвера, 
										ТипОборудования, 
										РевизияИнтерфейса, 
										ИнтеграционнаяБиблиотека, 
										ОсновнойДрайверУстановлен, 
										URLCкачивания);
		ВыходныеПараметры[2] = НаименованиеДрайвера;
		ВыходныеПараметры[3] = ОписаниеДрайвера;
		ВыходныеПараметры[4] = ТипОборудования;
		ВыходныеПараметры[5] = РевизияИнтерфейса;
		ВыходныеПараметры[6] = ИнтеграционнаяБиблиотека;
		ВыходныеПараметры[7] = ОсновнойДрайверУстановлен;
		ВыходныеПараметры[8] = URLCкачивания;
		
		// Получаем описание драйвера
		ОбъектДрайвера.ПолучитьПараметры(ПараметрыДрайвера);
		ВыходныеПараметры[9] = ПараметрыДрайвера;
		
		// Получаем дополнительные действия
		//ОбъектДрайвера.ПолучитьДополнительныеДействия(ДополнительныеДействия);
		//ВыходныеПараметры[10] = ДополнительныеДействия;
	Исключение
		Сообщить(НСтр("ru='Ошибка получения описания драйвера'"));
	КонецПопытки;
	
	Возврат Результат;

КонецФункции


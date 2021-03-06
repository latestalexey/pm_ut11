﻿//+++АК
Перем НеИзменятьСделки Экспорт;
//---АК

&НаСервере
Процедура ОбновитьСодержание()

	СтрокаСодержания = "";
	
	// Заказчики 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АК_ЗаказНаДоставкуМаршрут.Партнер,
		|	АК_ЗаказНаДоставкуМаршрут.ПунктНазначения,
		|	АК_ЗаказНаДоставкуМаршрут.КлючСтрокиМаршрута,
		|	АК_ЗаказНаДоставкуМаршрут.ДатаВремя
		|ПОМЕСТИТЬ Маршрут
		|ИЗ
		|	&Маршрут КАК АК_ЗаказНаДоставкуМаршрут
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(АК_ЗаказНаДоставкуЗаказы.Заказ КАК Документ.ЗаказКлиента) КАК Заказ,
		|	АК_ЗаказНаДоставкуЗаказы.КлючСтрокиМаршрута
		|ПОМЕСТИТЬ Заказы
		|ИЗ
		|	&Заказы КАК АК_ЗаказНаДоставкуЗаказы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Маршрут.ДатаВремя КАК ДатаВремя,
		|	Маршрут.Партнер КАК Партнер,
		|	Маршрут.ПунктНазначения КАК ПунктНазначения,
		|	ЕСТЬNULL(Заказы.Заказ, ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)) КАК Заказ
		|ИЗ
		|	Маршрут КАК Маршрут
		|		ПОЛНОЕ СОЕДИНЕНИЕ Заказы КАК Заказы
		|		ПО Маршрут.Партнер = Заказы.Заказ.Партнер
		|			И Маршрут.КлючСтрокиМаршрута = Заказы.КлючСтрокиМаршрута
		|ИТОГИ
		|	МИНИМУМ(ДатаВремя)
		|ПО
		|	ОБЩИЕ,
		|	Партнер,
		|	Заказ,
		|	ПунктНазначения";
	
	Запрос.УстановитьПараметр("Маршрут", Маршрут);
	Запрос.УстановитьПараметр("Заказы", Заказы);
	
	Результат = Запрос.Выполнить();
	ВыборкаОбщая = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаОбщая.Следующий() Цикл
		
		// Заполним дату
		Если Не ЗначениеЗаполнено(ДатаВремя) Тогда
			
			ДатаВремя = ВыборкаОбщая.ДатаВремя;
			
		КонецЕсли; 
		
		// Укажем заказчика
		ВыборкаПоЗаказчикам = ВыборкаОбщая.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаПоЗаказчикам.Следующий() Цикл
			
			// начнем с новой строки
			Если СтрокаСодержания <> "" Тогда
				СтрокаСодержания = СтрокаСодержания + Символы.ПС;
			КонецЕсли; 
			
			СтрокаСодержания = СтрокаСодержания + Строка(ВыборкаПоЗаказчикам.Партнер) + " - ";
			
			// адреса
			ВыборкаПоАдресам = ВыборкаПоЗаказчикам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ПунктНазначения");
			Пока ВыборкаПоАдресам.Следующий() Цикл
				СтрокаСодержания = СтрокаСодержания + ВыборкаПоАдресам.ПунктНазначения + ", ";
			КонецЦикла; 
			
			// заказы
			ВыборкаПоЗаказам = ВыборкаПоЗаказчикам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Заказ");
			Пока ВыборкаПоЗаказам.Следующий() Цикл
				
				Если ЗначениеЗаполнено(ВыборкаПоЗаказам.Заказ) Тогда
					СтрокаСодержания = СтрокаСодержания + "№ " + ВыборкаПоЗаказам.Заказ.Номер  + " от " + Формат(ВыборкаПоЗаказам.Заказ.Дата, "ДФ=dd.MM.yy") + ", ";
				КонецЕсли;
				
			КонецЦикла; 
		
		КонецЦикла; 
	
	КонецЦикла;
	
	Информация = Лев(СтрокаСодержания, СтрДлина(СтрокаСодержания) - 2);

КонецПроцедуры // ОбновитьСодержание()

&НаСервере
Процедура ПолучитьСвязанныеЗаказы(Заказы, ЭтоЗаказыПоставщику, СвязанныеЗаказы = Неопределено)
	
	СвязанныеЗаказы = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаказПоставщикуТовары.Ссылка КАК Заказ
		|ИЗ
		|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
		|ГДЕ
		|	ВЫБОР
		|			КОГДА &ЭтоЗаказыПоставщику
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ЗаказПоставщикуТовары.АК_ЗаказКлиента В (&Заказы)
		|		КОНЕЦ
		|	И ЗаказПоставщикуТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаказПоставщикуТовары.АК_ЗаказКлиента
		|ИЗ
		|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
		|ГДЕ
		|	ВЫБОР
		|			КОГДА &ЭтоЗаказыПоставщику
		|				ТОГДА ЗаказПоставщикуТовары.Ссылка В (&Заказы)
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ
		|	И ЗаказПоставщикуТовары.Номенклатура = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)";
		
	Запрос.УстановитьПараметр("Заказы", Заказы);
	Запрос.УстановитьПараметр("ЭтоЗаказыПоставщику", ЭтоЗаказыПоставщику);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СвязанныеЗаказы.Добавить(Выборка.Заказ);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНовыйКлючСтрокиМаршрута(Объект) Экспорт
	
	МаксимальныйКлюч = 1;
	
	Для Каждого Строка Из Объект.Маршрут Цикл
		
		Если Строка.КлючСтрокиМаршрута >= МаксимальныйКлюч Тогда
			МаксимальныйКлюч = Строка.КлючСтрокиМаршрута + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МаксимальныйКлюч;
	
КонецФункции

&НаСервере
Процедура ДобавитьПартнераВМаршрут(Объект, Партнер, Операция, ДатаВремя, КлючСтрокиМаршрута)
	
	Если Ложь Тогда
		Объект = Документы.АК_ЗаказНаДоставку.СоздатьДокумент();
	КонецЕсли;
	
	// пункт назначения
	ОсновнойАдрес = "";
	АК_ОбщегоНазначения.ПолучитьОсновнойАдресПартнера(Партнер, ОсновнойАдрес);
	
	НайденнаяСтрока = Объект.Маршрут.Найти(Партнер, "Партнер");
	Если НайденнаяСтрока = Неопределено Тогда
		
		НоваяСтрока = Объект.Маршрут.Добавить();
		НоваяСтрока.Партнер = Партнер;
		НоваяСтрока.Адрес = ОсновнойАдрес;
		НоваяСтрока.ДатаВремя = ДатаВремя;
		НоваяСтрока.Операция = Операция;
		НоваяСтрока.КонтактноеЛицо = Партнер.ОсновнойМенеджер;
		КлючСтрокиМаршрута = ПолучитьНовыйКлючСтрокиМаршрута(Объект);
		НоваяСтрока.КлючСтрокиМаршрута = КлючСтрокиМаршрута;
		
	Иначе
		
		КлючСтрокиМаршрута = НайденнаяСтрока.КлючСтрокиМаршрута;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЗаказ(Объект, Заказ, КлючСтрокиМаршрута, ЗаказДобавлен)
	
	ЗаказДобавлен = Ложь;
	
	Если Объект.Заказы.Найти(Заказ, "Заказ") = Неопределено Тогда
		НоваяСтрока = Объект.Заказы.Добавить();
		НоваяСтрока.Заказ = Заказ;
		НоваяСтрока.КлючСтрокиМаршрута = КлючСтрокиМаршрута;
		ЗаказДобавлен = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНоменклатуруПоЗаказу(Объект, Заказ, ЭтоСвязанныйЗаказ)
	
	Для Каждого СтрокаЗаказа Из Заказ.Товары Цикл
	
		Если СтрокаЗаказа.Номенклатура.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
			
			СтрокаНоменклатуры = Объект.Товары.Найти(СтрокаЗаказа.Номенклатура, "Номенклатура");
			Если СтрокаНоменклатуры = Неопределено Тогда
				СтрокаНоменклатуры = Объект.Товары.Добавить();
				СтрокаНоменклатуры.Номенклатура = СтрокаЗаказа.Номенклатура;
				СтрокаНоменклатуры.Количество = ?(ЭтоСвязанныйЗаказ, 0, СтрокаЗаказа.Количество);
			Иначе
				СтрокаНоменклатуры.Количество = СтрокаНоменклатуры.Количество + ?(ЭтоСвязанныйЗаказ, 0, СтрокаЗаказа.Количество);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДанныеПоЗаказу(Объект, Заказ, ЭтоСвязанныйЗаказ = Ложь)
	
	КлючСтрокиМаршрута = 0;
	Если ТипЗнч(Заказ) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		ДобавитьПартнераВМаршрут(Объект, Заказ.Партнер, Перечисления.АК_ВидыОперацийДоставки.Разгрузка, Заказ.ЖелаемаяДатаОтгрузки, КлючСтрокиМаршрута);
		
	ИначеЕсли ТипЗнч(Заказ) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ДобавитьПартнераВМаршрут(Объект, Заказ.Партнер, Перечисления.АК_ВидыОперацийДоставки.Погрузка, Заказ.ЖелаемаяДатаПоступления, КлючСтрокиМаршрута);
		
	КонецЕсли;
	
	ЗаказДобавлен = Ложь;
	Если ЗначениеЗаполнено(КлючСтрокиМаршрута) Тогда
		ДобавитьЗаказ(Объект, Заказ, КлючСтрокиМаршрута, ЗаказДобавлен);
	КонецЕсли;
	
	Если ЗаказДобавлен Тогда
		ДобавитьНоменклатуруПоЗаказу(Объект, Заказ, ЭтоСвязанныйЗаказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура заполняет табличные части по выбранным заказам клиентов
// 
Процедура ОбработатьДобавлениеЗаказовСервер(Объект, Заказы, ЭтоЗаказыПоставщику) Экспорт
	
	// Получим связанные заказы
	СвязанныеЗаказы = Новый СписокЗначений();
	ПолучитьСвязанныеЗаказы(Заказы, ЭтоЗаказыПоставщику, СвязанныеЗаказы);
	
	Если ЭтоЗаказыПоставщику Тогда // сначала добавляются данные по заказам поставщиков
										// в конце добавляются данные по заказам клиентов
		
		Для Каждого Заказ Из Заказы Цикл
			ДобавитьДанныеПоЗаказу(Объект, Заказ.Значение);
		КонецЦикла;
		
		Для Каждого Заказ Из СвязанныеЗаказы Цикл
			ДобавитьДанныеПоЗаказу(Объект, Заказ.Значение, Истина);
		КонецЦикла;
		
	Иначе
	
		Для Каждого Заказ Из СвязанныеЗаказы Цикл
			ДобавитьДанныеПоЗаказу(Объект, Заказ.Значение, Истина);
		КонецЦикла;
		
		Для Каждого Заказ Из Заказы Цикл
			ДобавитьДанныеПоЗаказу(Объект, Заказ.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗапросПоЗаказамСервер(СписокЗаказов, ТипЗаказов)
	
	// тодо переделать

	Запрос = Новый Запрос;
    Запрос.Текст =  
		"ВЫБРАТЬ
		|	Заказ.Партнер КАК Партнер,
		|	ВЫБОР
		|		КОГДА &ЗаказПоставщику = ""ЗаказПоставщику""
		|			ТОГДА ""Погрузка""
		|		ИНАЧЕ ""Разгрузка""
		|	КОНЕЦ КАК ВидОперации,
		|	Заказ.Ссылка КАК Заказ,
		|	NULL КАК ПунктНазначения,
		|	КонтактныеЛицаПартнеров.Ссылка КАК КонтактноеЛицо,
		|	КонтактныеЛицаПартнеровКонтактнаяИнформация.НомерТелефона КАК НомерТелефона,
		|	ВЫБОР
		|		КОГДА &ЗаказПоставщику = ""ЗаказПоставщику""
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК ПриоритетОперации
		|ИЗ
		|	Документ.ЗаказКлиента КАК Заказ
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
		|			ПО КонтактныеЛицаПартнеров.Ссылка = КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка
		|		ПО Заказ.Партнер = КонтактныеЛицаПартнеров.Владелец
		|ГДЕ
		|	Заказ.Ссылка В(&СписокЗаказов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриоритетОперации,
		|	Партнер
		|ИТОГИ
		|	МАКСИМУМ(ПунктНазначения),
		|	МАКСИМУМ(КонтактноеЛицо),
		|	МАКСИМУМ(НомерТелефона)
		|ПО
		|	ВидОперации,
		|	Партнер";
		
	Если ТипЗаказов = "ЗаказПоставщику" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ЗаказКлиента", "ЗаказПоставщику");
	КонецЕсли;

    Запрос.УстановитьПараметр("СписокЗаказов", СписокЗаказов);
	Запрос.УстановитьПараметр("ТипЗаказов", ТипЗаказов);

	Возврат Запрос;
	
КонецФункции 

&НаСервере
Процедура ЗаполнитьЗаказыСервер(Объект, СписокЗаказов, ТипЗаказов, ЗаполнятьНоменклатуру = Истина) Экспорт
	// тодо обновить
	Запрос = ПолучитьЗапросПоЗаказамСервер(СписокЗаказов, ТипЗаказов);
	
	ВыборкаПартнер = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Партнер");
	
	Пока ВыборкаПартнер.Следующий() Цикл
		
			
		ВыборкаВидОперации = ВыборкаПартнер.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ВидОперации");
		
				
		Пока ВыборкаВидОперации.Следующий() Цикл
		
			Выборка = ВыборкаВидОперации.Выбрать();
			
			Если Выборка.Количество() > 0 Тогда
				НовСтрмаршрут = Объект.Маршрут.Добавить();
				НовСтрмаршрут.ВидОперации = ВыборкаВидОперации.ВидОперации; 			
								
			КонецЕсли;
			
			Счета = "";
			
			Пока Выборка.Следующий() Цикл
				Если Найти(Счета, Строка(Выборка.Заказ.Номер)) = 0 Тогда
					Счета = Счета + Строка(Выборка.Заказ.Номер) + ", ";				
					НовСтрЗаказы = Объект.Заказы.Добавить();
					НовСтрЗаказы.Заказ = Выборка.Заказ;
				КонецЕсли;
				
			КонецЦикла;
			
			Если Прав(Счета, 2) = ", " Тогда
				Счета = Лев(Счета, СтрДлина(Счета) - 2);
			КонецЕсли;

			 НовСтрмаршрут.Партнер = ВыборкаВидОперации.Партнер;
			 НовСтрМаршрут.Адрес = ВыборкаВидОперации.ПунктНазначения;
			 НОвСтрМаршрут.КонтактноеЛицо = ВыборкаВидОперации.КонтактноеЛицо; 			 
			 НовСтрМаршрут.МобильныйТелефон = ВыборкаВидОперации.НомерТелефона;
			 новСтрМаршрут.НомерСчета = Счета;
			 
		 КонецЦикла;
		 
	КонецЦикла;
				
	//Если ЗаполнятьНоменклатуру Тогда		
	//	ЗаполнитьТЧТоварыСервер(Объект);
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтразитьДвижениеТоваров(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДвижениеТоваров;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Набор = Движения.ДвижениеТоваров;
	Набор.Записывать = Истина;
	Набор.Загрузить(Таблица);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	//
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	//
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	//
	ОбновитьСодержание();
	
КонецПроцедуры

//
//
&НаСервере
Процедура ОтразитьЗаказыНаДоставку(ДополнительныеСвойства, Движения, Отказ)
	
	//+++АК
		
	ТаблицаЗаказыКлиентовРазмещение = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЗаказыКлиентовРазмещение;
	
	Если НЕ Отказ И НЕ ТаблицаЗаказыКлиентовРазмещение.Количество() = 0 Тогда
		ДвиженияЗаказыКлиентов = Движения.АК_ЗаказыКлиентовРазмещение;
		ДвиженияЗаказыКлиентов.Записывать = Истина;
		ДвиженияЗаказыКлиентов.Загрузить(ТаблицаЗаказыКлиентовРазмещение);	
	КонецЕсли;
	
	//---АК
	
КонецПроцедуры	

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.АК_ЗаказНаДоставку.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ОтразитьЗаказыНаДоставку(ДополнительныеСвойства, Движения, Отказ);
	
	//
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры // ОбработкаПроведения()

//+++АК
НеИзменятьСделки = Ложь;
//---АК

﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отчет.РабочаяДата = ТекущаяДата();
	Отчет.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	Отчет.ПериодПросроченныхПлатежей.Вариант = ВариантСтандартногоПериода.Последние7Дней;
	Отчет.ПериодБудущихПлатежей.Вариант = ВариантСтандартногоПериода.Следующие7Дней;
	Отчет.ВыводитьЗаказы = Параметры.ВыводитьЗаказы;
	
	ЗаполнитьСписокХозяйственныхОпераций();
	
	СтатьяПоступлениеОплатыОтКлиента = Справочники.СтатьиДвиженияДенежныхСредств.ПоступлениеОплатыОтКлиента;
	СтатьяОплатаПоставщику = Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику;
	
	ЭтаФорма.Заголовок = "Платежный календарь на " + Формат(Отчет.РабочаяДата, "ДЛФ=Д"); 
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	АдресХранилищаСКД = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	МассивСобытий = Новый Массив;
	МассивСобытий.Добавить("Запись_ЗаявкаНаРасходованиеДенежныхСредств");
	МассивСобытий.Добавить("Запись_ПланируемоеПоступлениеДенежныхСредств");
	МассивСобытий.Добавить("Запись_РаспоряжениеНаПеремещениеДенежныхСредств");
	
	Если МассивСобытий.Найти(ИмяСобытия) <> Неопределено Тогда
		СкомпоноватьРезультат();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Параметры.ПериодБудущихПлатежей) Тогда
		Настройки.Вставить("Отчет.ПериодБудущихПлатежей", Параметры.ПериодБудущихПлатежей);
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ПериодПросроченныхПлатежей) Тогда
		Настройки.Вставить("Отчет.ПериодПросроченныхПлатежей", Параметры.ПериодПросроченныхПлатежей);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПросроченныхПлатежейПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодБудущихПлатежейПриИзменении(Элемент)
	
	УстановитьСостояниеОтчетНеСформирован();
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Перем СтруктураКоманды;

	СтандартнаяОбработка = Ложь;
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(
		ДанныеРасшифровки, 
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресХранилищаСКД)
	);
	
	ВыполненноеДействие = Неопределено;
	ПараметрВыполненногоДействия = Неопределено;
	
	ДоступныеДействия = Новый Массив;
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	
	ОбработкаРасшифровки.ВыбратьДействие(
		Расшифровка, 
		ВыполненноеДействие, 
		ПараметрВыполненногоДействия, 
		ДоступныеДействия,
		//ДополнительноеМеню
	);
	
	Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
		
		Если ТипЗнч(ПараметрВыполненногоДействия) = Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств") Тогда
			
			ДоступныеДействия = Новый Массив;
			ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
			
			ОбработкаРасшифровки.ВыбратьДействие(
				Расшифровка, 
				ВыполненноеДействие, 
				ПараметрВыполненногоДействия, 
				ДоступныеДействия,
				//ДополнительноеМеню
			);
			Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать Тогда
				ОписаниеОбработкиРасшифровки = Новый ОписаниеОбработкиРасшифровкиКомпоновкиДанных(
					ДанныеРасшифровки,
					Расшифровка,
					ПараметрВыполненногоДействия
				);
				
				ПараметрыФормы = Новый Структура("ВыводитьЗаказы,
												 |ПериодПросроченныхПлатежей,
												 |ПериодБудущихПлатежей,
												 |СформироватьПриОткрытии,
												 |КлючНазначенияИспользования,
												 |Расшифровка");
												 
				ПараметрыФормы.ВыводитьЗаказы = Истина;
				ПараметрыФормы.ПериодПросроченныхПлатежей = Отчет.ПериодПросроченныхПлатежей;
				ПараметрыФормы.ПериодБудущихПлатежей = Отчет.ПериодБудущихПлатежей;
				ПараметрыФормы.СформироватьПриОткрытии = Истина;
				ПараметрыФормы.КлючНазначенияИспользования = "Расшифровка";
				ПараметрыФормы.Расшифровка = ОписаниеОбработкиРасшифровки;
				ОткрытьФорму("Отчет.ПлатежныйКалендарь.Форма", ПараметрыФормы);
			КонецЕсли;
			
		ИначеЕсли ПараметрВыполненногоДействия = Неопределено Тогда
			ОткрытьОтчетОстаткиИДвиженияДенежныхСредств();
		Иначе
			ОткрытьЗначение(ПараметрВыполненногоДействия);
		КонецЕсли;
		
	Иначе
		ОткрытьОтчетОстаткиИДвиженияДенежныхСредств();
	КонецЕсли;

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ДобавитьПоступление(Команда)
	
	СтруктураОснование = Новый Структура("Организация, Валюта",
		Отчет.Организация,
		Отчет.Валюта
	);
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", СтруктураОснование);
	ОткрытьФорму("Документ.ПланируемоеПоступлениеДенежныхСредств.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПеремещение(Команда)
	
	ВыбранноеЗначение = ВыбратьИзМеню(СписокХозяйственныхОпераций, Элементы.ДобавитьПеремещение);
	Если ВыбранноеЗначение <> Неопределено Тогда
		
		СтруктураОтбор = Новый Структура("ХозяйственнаяОперация, Валюта", ВыбранноеЗначение.Значение, Отчет.Валюта);
		Если ЗначениеЗаполнено(Отчет.Организация) Тогда
			СтруктураОтбор.Вставить("Организация", Отчет.Организация);
		КонецЕсли;
		СтруктураПараметры = Новый Структура("Основание", СтруктураОтбор);
		ОткрытьФорму("Документ.РаспоряжениеНаПеремещениеДенежныхСредств.ФормаОбъекта", СтруктураПараметры, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетОстаткиИДвиженияДенежныхСредств()
	
	ПараметрыФормы = Новый Структура("Отбор, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии");
	ПараметрыФормы.СформироватьПриОткрытии = Истина;
	ПараметрыФормы.КлючНазначенияИспользования = "РасшифровкаПлатежногоКалендаря";
	ПараметрыФормы.КлючВарианта = "ОстаткиДенежныхСредств";
	ПараметрыФормы.Отбор = Новый Структура("Валюта", Отчет.Валюта);
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		ПараметрыФормы.Отбор.Вставить("Организация", Отчет.Организация);
	КонецЕсли;
	
	ОткрытьФорму("Отчет.ОстаткиИДвиженияДенежныхСредств.Форма", ПараметрыФормы);
			
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ЗаполнитьСписокХозяйственныхОпераций()
	
	СписокХозяйственныхОпераций.Очистить();
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка, "Поступление из банка");
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк, "Сдача в банк");
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу, "Выдача в другую кассу");
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет, "Перечисление на другой счет");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеОтчетНеСформирован()
	
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.Результат.ОтображениеСостояния.Текст = НСтр("ru = 'Отчет не сформирован. Нажмите ""Сформировать"" для получения отчета.'");
	Элементы.Результат.ОтображениеСостояния.Видимость = Истина;
	
КонецПроцедуры

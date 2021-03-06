﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


///////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//                                                                               
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	ТекстПоступления = "
	|ВЫБРАТЬ // Поступление на расчетный счет (Дт 51, 52 :: Кт 57.03)
	|	ЕСТЬNULL(Выписка.Дата, Операция.Дата) КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.Сумма КАК Сумма,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Операция.ДоговорЭквайринга.БанковскийСчет.ВалютаДенежныхСредств КАК ВалютаДт,
	|	Операция.ДоговорЭквайринга.БанковскийСчет.Подразделение КАК ПодразделениеДт,
	|	ВЫБОР КОГДА Операция.ДоговорЭквайринга.БанковскийСчет.ВалютаДенежныхСредств = Константы.ВалютаРегламентированногоУчета ТОГДА
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетныеСчета)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ВалютныеСчета)
	|	КОНЕЦ КАК СчетДт,
	|	Операция.ДоговорЭквайринга.БанковскийСчет КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	Строки.Сумма КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	Операция.Валюта КАК ВалютаКт,
	|	Операция.ДоговорЭквайринга.БанковскийСчет.Подразделение КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПродажиПоПлатежнымКартам) КАК СчетКт,
	|	Операция.ДоговорЭквайринга.Контрагент КАК СубконтоКт1,
	|	Операция.ДоговорЭквайринга СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	Строки.Сумма КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетБанкаПоОперациямЭквайринга.Покупки КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ (
	|		ВЫБРАТЬ ПЕРВЫЕ 1
	|			Платежи.Ссылка.Дата КАК Дата
	|       ИЗ
	|			Документ.ВыпискаПоРасчетномуСчету.ВходящиеПлатежи КАК Платежи
	|		ГДЕ
	|			Платежи.ПлатежныйДокумент = &Ссылка
	|		) КАК Выписка
	|	ПО
	|		Истина
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Константы КАК Константы
	|	ПО
	|		Истина
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|";
	
	ТекстВозвраты = "
	|ВЫБРАТЬ // Получение оплаты от клиента (Дт 57.03 :: Кт 51, 52)
	|	ЕСТЬNULL(Выписка.Дата, Операция.Дата) КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.Сумма КАК Сумма,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Операция.Валюта КАК ВалютаДт,
	|	Операция.ДоговорЭквайринга.БанковскийСчет.Подразделение КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПродажиПоПлатежнымКартам) КАК СчетДт,
	|	Операция.ДоговорЭквайринга.Контрагент КАК СубконтоДт1,
	|	Операция.ДоговорЭквайринга СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	Строки.Сумма КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	Операция.ДоговорЭквайринга.БанковскийСчет.ВалютаДенежныхСредств КАК ВалютаКт,
	|	Операция.ДоговорЭквайринга.БанковскийСчет.Подразделение КАК ПодразделениеКт,
	|	ВЫБОР КОГДА Операция.ДоговорЭквайринга.БанковскийСчет.ВалютаДенежныхСредств = Константы.ВалютаРегламентированногоУчета ТОГДА
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетныеСчета)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ВалютныеСчета)
	|	КОНЕЦ КАК СчетКт,
	|	Операция.ДоговорЭквайринга.БанковскийСчет КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	Строки.Сумма КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК Операция
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтчетБанкаПоОперациямЭквайринга.Возвраты КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ (
	|		ВЫБРАТЬ ПЕРВЫЕ 1
	|			Платежи.Ссылка.Дата КАК Дата
	|       ИЗ
	|			Документ.ВыпискаПоРасчетномуСчету.ИсходящиеПлатежи КАК Платежи
	|		ГДЕ
	|			Платежи.ПлатежныйДокумент = &Ссылка
	|		) КАК Выписка
	|	ПО
	|		Истина
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Константы КАК Константы
	|	ПО
	|		Истина
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|";
	
	ТекстКомиссия = "
	|ВЫБРАТЬ // Поступление услуг (Дт 44 :: Кт 51, 52)
	|	ЕСТЬNULL(Выписка.Дата, Операция.Дата) КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Операция.СуммаКомиссии КАК Сумма,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаДт,
	|	Операция.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	Операция.СуммаКомиссии КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	Операция.ДоговорЭквайринга.БанковскийСчет.ВалютаДенежныхСредств КАК ВалютаКт,
	|	Операция.ДоговорЭквайринга.БанковскийСчет.Подразделение КАК ПодразделениеКт,
	|	ВЫБОР КОГДА Операция.ДоговорЭквайринга.БанковскийСчет.ВалютаДенежныхСредств = Константы.ВалютаРегламентированногоУчета ТОГДА
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.РасчетныеСчета)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ВалютныеСчета)
	|	КОНЕЦ КАК СчетКт,
	|	Операция.ДоговорЭквайринга.БанковскийСчет КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	Операция.СуммаКомиссии КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК Операция
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ (
	|		ВЫБРАТЬ ПЕРВЫЕ 1
	|			Платежи.Ссылка.Дата КАК Дата
	|       ИЗ
	|			Документ.ВыпискаПоРасчетномуСчету.ВходящиеПлатежи КАК Платежи
	|		ГДЕ
	|			Платежи.ПлатежныйДокумент = &Ссылка
	|		) КАК Выписка
	|	ПО
	|		Истина
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Константы КАК Константы
	|	ПО
	|		Истина
	|ГДЕ
	|	Операция.Ссылка = &Ссылка
	|	И Операция.СуммаКомиссии <> 0
	|";
	
	Возврат
	ТекстПоступления
	+ "ОБЪЕДИНИТЬ ВСЕ" + ТекстВозвраты
	+ "ОБЪЕДИНИТЬ ВСЕ" + ТекстКомиссия;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
		Реквизиты.Валюта, 
		, // ВалютаВзаиморасчетов
		Реквизиты.Период
	);
	ТекстЗапроса = ТекстЗапросаТаблицаРасчетыПоЭквайрингу()
		+ ТекстЗапросаТаблицаДенежныеСредстваКПоступлениюБезналичные()
		+ ТекстЗапросаТаблицаДенежныеСредстваКСписаниюБезналичные()
		+ ТекстЗапросаТаблицаПрочиеРасходы()
		+ ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл()
		;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Валюта", Реквизиты.Валюта);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр", Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл", Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ИспользоватьУчетПрочихДоходовРасходов", ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов")); 
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицыДляДвижений = СтруктураДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыПоЭквайрингу",                     МассивРезультатов[0].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваКПоступлениюБезналичные", МассивРезультатов[1].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваКСписаниюБезналичные",    МассивРезультатов[2].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаПрочиеРасходы",                           МассивРезультатов[3].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаСуммыДокументовВВалютеРегл",              МассивРезультатов[4].Выгрузить());
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаРасчетыПоЭквайрингу()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Платежи.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.ПоступлениеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|
	|	&Организация КАК Организация,
	|	&Валюта КАК Валюта,
	|	Платежи.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	Платежи.ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|	Платежи.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	Платежи.ДатаПлатежа КАК ДатаПлатежа,
	|	Платежи.Сумма КАК Сумма
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Покупки КАК Платежи
	|	
	|ГДЕ
	|	Платежи.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Платежи.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.СписаниеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|
	|	&Организация КАК Организация,
	|	&Валюта КАК Валюта,
	|	Платежи.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	Платежи.ВидПлатежнойКарты КАК ВидПлатежнойКарты,
	|	Платежи.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	Платежи.ДатаПлатежа КАК ДатаПлатежа,
	|	Платежи.Сумма КАК Сумма
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Возвраты КАК Платежи
	|	
	|ГДЕ
	|	Платежи.Ссылка = &Ссылка
	|	
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДенежныеСредстваКПоступлениюБезналичные()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствКПоступлению.ПоступлениеОтБанкаПоЭквайрингу) КАК ТипДенежныхСредств,
	|
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ДоговорЭквайринга.БанковскийСчет КАК БанковскийСчет,
	|	ДанныеДокумента.Ссылка КАК Документ,
	|	
	|	Неопределено КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПоступлениеОплатыОтКлиента) КАК СтатьяДвиженияДенежныхСредств,
	|	Неопределено КАК АналитикаУчетаПоПартнерам,
	|	Неопределено КАК Заказ,
	|	
	|	ДанныеДокумента.СуммаДокумента КАК Сумма
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаДокумента > 0
	|	
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДенежныеСредстваКСписаниюБезналичные()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствКСписанию.СписаниеБанкомПоЭквайрингу) КАК ТипДенежныхСредств,
	|
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ДоговорЭквайринга.БанковскийСчет КАК БанковскийСчет,
	|	ДанныеДокумента.Ссылка КАК Документ,
	|	
	|	Неопределено КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПоступлениеОплатыОтКлиента) КАК СтатьяДвиженияДенежныхСредств,
	|	Неопределено КАК АналитикаУчетаПоПартнерам,
	|	Неопределено КАК Заказ,
	|	
	|	- ДанныеДокумента.СуммаДокумента КАК Сумма
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаДокумента < 0
	|
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеРасходы()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочиеРасходы) КАК ХозяйственнаяОперация,
	|	
	|	// Рассчитаем сумму в валюте управленческого учета.
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15,2)) КАК Сумма
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаКомиссии <> 0
	|	И &ИспользоватьУчетПрочихДоходовРасходов
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаДокумента.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	ТаблицаДокумента.Сумма КАК СуммаБезНДС,
	|	0 КАК СуммаНДС,
	|	ТаблицаДокумента.Сумма * &КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	0 КАК СуммаНДСРегл,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Покупки КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И &Валюта <> &ВалютаРегламентированногоУчета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2 КАК Порядок,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаДокумента.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	ТаблицаДокумента.Сумма КАК СуммаБезНДС,
	|	0 КАК СуммаНДС,
	|	ТаблицаДокумента.Сумма * &КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	0 КАК СуммаНДСРегл,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Возвраты КАК ТаблицаДокумента
	|
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И &Валюта <> &ВалютаРегламентированногоУчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	НомерСтроки
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции // ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл()


#КонецЕсли
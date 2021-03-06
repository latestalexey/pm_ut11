﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Экспортные функции для интерактивной работы со скидками.

// Процедура сбрасывает флаг СкидкиРассчитаны и делает недоступными колонки табличной части.
//
Процедура СброситьФлагСкидкиРассчитаны(Форма) Экспорт
	
	Форма.Объект.СкидкиРассчитаны = Ложь;
	
КонецПроцедуры

Функция ПредложитьПользователюРассчитатьСкидки() Экспорт
	
	ТекстВопроса = НСтр("ru='Автоматические скидки (наценки) не рассчитаны. Рассчитать автоматические скидки (наценки)?'");
	Возврат Вопрос(ТекстВопроса,РежимДиалогаВопрос.ОКОтмена);
	
КонецФункции

// Проверяет заполненность реквизитов, необходимых для назначения скидок
//
// Параметры:
// Документ                    - ДокументОбъект, для которого выполняются проверки
// ИмяТабличнойЧасти           - Строка - имя табличной части, в которой необходимо осуществить проверку
// ПредставлениеТабличнойЧасти - Строка - представление табличной части для информирования пользователя
//
// Возвращаемое значение:
// Булево
// Ложь, если необходимые данные не заполнены
//
Функция ВозможноНазначениеРучнойСкидкиНаценки(Документ, ИмяТабличнойЧасти, ПредставлениеТабличнойЧасти) Экспорт

	Если Документ[ИмяТабличнойЧасти].Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='В документе не заполнена таблица %ПредставлениеТабличнойЧасти%. Ручная скидка (наценка) не может быть назначена'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ПредставлениеТабличнойЧасти%", ПредставлениеТабличнойЧасти);
		Предупреждение(ТекстПредупреждения);
		Возврат Ложь;
		
	КонецЕсли;

	Возврат Истина;

КонецФункции

// Проверяет заполненность реквизитов, необходимых для отмены скидок
//
// Параметры:
// Документ                    - ДокументОбъект, для которого выполняются проверки
// ИмяТабличнойЧасти           - Строка - имя табличной части, в которой необходимо осуществить проверку
// ПредставлениеТабличнойЧасти - Строка - представление табличной части для информирования пользователя
//
// Возвращаемое значение:
// Булево
// Ложь, если необходимые данные не заполнены
//
Функция ВозможнаОтменаРучныхСкидокНаценок(Документ, ИмяТабличнойЧасти, ПредставлениеТабличнойЧасти) Экспорт

	Если Документ[ИмяТабличнойЧасти].Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='В документе не заполнена таблица %ПредставлениеТабличнойЧасти%. Ручные скидки (наценки) не могут быть отменены'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ПредставлениеТабличнойЧасти%", ПредставлениеТабличнойЧасти);
		Предупреждение(ТекстПредупреждения);
		Возврат Ложь;
		
	ИначеЕсли Документ[ИмяТабличнойЧасти].Итог("СуммаРучнойСкидки") = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='В документе не заполнена сумма ручной скидки в таблице %ПредставлениеТабличнойЧасти%. Ручные скидки (наценки) не могут быть отменены'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ПредставлениеТабличнойЧасти%", ПредставлениеТабличнойЧасти);
		Предупреждение(ТекстПредупреждения);
		Возврат Ложь;
		
	КонецЕсли;

	Возврат Истина;

КонецФункции

//Показывает оповещение пользователя об окончании назначения ручных скидок (наценок)
//
Процедура ОповеститьОбОкончанииНазначенияРучныхСкидокНаценок(СуммаСкидкиНаценки = 0, Валюта = Неопределено) Экспорт

	Если СуммаСкидкиНаценки > 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Назначена ручная скидка %СуммаСкидкиНаценки% %Валюта%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СуммаСкидкиНаценки%", СуммаСкидкиНаценки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Валюта%", Валюта);
		
	ИначеЕсли СуммаСкидкиНаценки < 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Назначена ручная наценка %СуммаСкидкиНаценки% %Валюта%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СуммаСкидкиНаценки%", СуммаСкидкиНаценки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Валюта%", Валюта);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Ручные скидки (наценки) отменены'");
		
	КонецЕсли;
		
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Скидки (наценки)'"),
		,
		ТекстСообщения,
		БиблиотекаКартинок.Информация32
	);

КонецПроцедуры // ОповеститьОбОкончанииНазначенияРучныхСкидокНаценок()

////////////////////////////////////////////////////////////////////////////////
// Примененные скидки.

// Процедура открывает форму расшифровки скидок рассчитанных по текущей строке табличной части
//
// Параметры
//  ТекущиеДанные  - СтрокаТабличнойЧасти - строка для которой необходимо открыть расшифровку скидок
//  Объект  - ДанныеФормы - Объект, для которого нужно открыть форму расшифровки скидок
//  Форма  - Форма - Форма объекта
//
Процедура ОткрытьФормуПримененныеСкидки(ТекущиеДанные, Объект, Форма) Экспорт
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.АктВыполненныхРабот") Тогда
		ИмяКоличества = "Количество";
	Иначе
		ИмяКоличества = "КоличествоУпаковок";
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено Тогда
	
		СтруктураТекущиеДанные = Новый Структура;
		СтруктураТекущиеДанные.Вставить("КлючСвязи",         ТекущиеДанные.КлючСвязи);
		СтруктураТекущиеДанные.Вставить("Номенклатура",      ТекущиеДанные.Номенклатура);
		СтруктураТекущиеДанные.Вставить("Характеристика",    ТекущиеДанные.Характеристика);
		СтруктураТекущиеДанные.Вставить("СуммаРучнойСкидки", ТекущиеДанные.СуммаРучнойСкидки);
		СтруктураТекущиеДанные.Вставить("СуммаБезСкидки",    ТекущиеДанные.Цена * ТекущиеДанные[ИмяКоличества]);
		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("Объект", Объект);
		СтруктураПараметров.Вставить("Заголовок", НСтр("ru = 'Примененные скидки (наценки) для строки'"));
		СтруктураПараметров.Вставить("ТекущиеДанные", СтруктураТекущиеДанные);
		СтруктураПараметров.Вставить("АдресПримененныхСкидокВоВременномХранилище",          Форма.АдресПримененныхСкидокВоВременномХранилище);
		СтруктураПараметров.Вставить("ОтображатьИнформациюОСкидкахПоСтроке",                Истина);
		СтруктураПараметров.Вставить("ОтображатьИнформациюОРасчетеСкидокПоСтроке",          Истина);
		СтруктураПараметров.Вставить("ОтображатьИнформациюОРасчетеСкидокПоДокументуВЦелом", Ложь);
		
		ОткрытьФорму("ОбщаяФорма.ПримененныеСкидкиНаценки", СтруктураПараметров, Форма, Форма.УникальныйИдентификатор);
	
	КонецЕсли;
	
КонецПроцедуры // ОткрытьФормуПримененныеСкидки()

Функция ОткрытьФормуНазначенияРучныхСкидок(АдресВоВременномХранилище, Валюта, ИспользоватьОграниченияРучныхСкидок = Истина) Экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВоВременномХранилище",           АдресВоВременномХранилище);
	ПараметрыФормы.Вставить("Валюта",                              Валюта);
	ПараметрыФормы.Вставить("ИспользоватьОграниченияРучныхСкидок", ИспользоватьОграниченияРучныхСкидок);
	Возврат ОткрытьФормуМодально("ОбщаяФорма.НазначениеРучнойСкидкиНаценки", ПараметрыФормы);

КонецФункции

Функция ОткрытьФормуНазначенияУправляемыхСкидокНаценок(АдресВоВременномХранилище) Экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
	Возврат ОткрытьФормуМодально("ОбщаяФорма.НазначениеАвтоматическихУправляемыхСкидокНаценок", ПараметрыФормы);

КонецФункции

Функция РассчитатьСуммыВыделенныхСтрок(КоллекцияСтрок, ВыделенныеСтроки, РассчитыватьАвтоСкидки = Ложь) Экспорт
	
	СуммаВсего = 0;
	СуммаАвтоСкидки = 0;
	СуммаРучнойСкидки = 0;
	
	Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
		
		СтрокаКоллекции = КоллекцияСтрок.НайтиПоИдентификатору(ТекСтрока);
		
		Если СтрокаКоллекции = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СуммаВсего = СуммаВсего + СтрокаКоллекции.Сумма;
		СуммаРучнойСкидки = СуммаРучнойСкидки + СтрокаКоллекции.СуммаРучнойСкидки;
		Если РассчитыватьАвтоСкидки Тогда
			СуммаАвтоСкидки = СуммаАвтоСкидки + СтрокаКоллекции.СуммаАвтоматическойСкидки;
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураСумм = Новый Структура();
	СтруктураСумм.Вставить("СуммаВсего", СуммаВсего + СуммаРучнойСкидки + СуммаАвтоСкидки);
	СтруктураСумм.Вставить("СуммаРучнойСкидки", СуммаРучнойСкидки);
	Если РассчитыватьАвтоСкидки Тогда
		СтруктураСумм.Вставить("СуммаАвтоСкидки", СуммаАвтоСкидки);
	КонецЕсли;
	
	Возврат СтруктураСумм;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сообщения.

Процедура ОткрытьФормуСообщений(СтруктураСообщений, Форма) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.СообщенияСкидокНаценок", СтруктураСообщений, Форма, Форма.УникальныйИдентификатор);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

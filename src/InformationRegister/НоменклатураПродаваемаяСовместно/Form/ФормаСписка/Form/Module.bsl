﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ВариантДобавленияОтбор = Настройки.Получить("ВариантДобавленияОтбор");
	ВариантАнализаОтбор = Настройки.Получить("ВариантАнализаОтбор");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ВариантАнализа", ВариантАнализаОтбор, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ВариантАнализаОтбор));
	Если ВариантДобавленияОтбор = "" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДобавленоАвтоматически", Неопределено, ВидСравненияКомпоновкиДанных.Равно,, Ложь);
	ИначеЕсли ВариантДобавленияОтбор = "ДобавленоАвтоматически" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДобавленоАвтоматически", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ИначеЕсли ВариантДобавленияОтбор = "ДобавленоВРучную" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДобавленоАвтоматически", Ложь, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Настроить(Команда)
	
	ОткрытьФорму("РегистрСведений.НоменклатураПродаваемаяСовместно.Форма.НастройкаПоискаАссоциаций", Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоискАссоциаций(Команда)
	
	ОбновитьДанныеОНоменклатуреПродаваемойСовместно();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВариантДобавленияПриИзменении(Элемент)
	
	Если ВариантДобавленияОтбор = "" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДобавленоАвтоматически", Неопределено, ВидСравненияКомпоновкиДанных.Равно,, Ложь);
	ИначеЕсли ВариантДобавленияОтбор = "ДобавленоАвтоматически" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДобавленоАвтоматически", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ИначеЕсли ВариантДобавленияОтбор = "ДобавленоВРучную" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ДобавленоАвтоматически", Ложь, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантАнализаОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ВариантАнализа", ВариантАнализаОтбор, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ВариантАнализаОтбор));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ОбновитьДанныеОНоменклатуреПродаваемойСовместно()
	
	НоменклатураПродаваемаяСовместно.ОбновитьДанныеОНоменклатуреПродаваемойСовместно();
	Элементы.Список.Обновить();
	
КонецПроцедуры

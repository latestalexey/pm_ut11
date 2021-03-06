﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Параметры.ВидНоменклатуры) Тогда
		ВидНоменклатуры = Параметры.ВидНоменклатуры;
	ИначеЕсли ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
		РеквизитыСерии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.ТекущаяСтрока,
			Новый Структура("ВидНоменклатуры","ВидНоменклатуры"));
			
		ВидНоменклатуры = РеквизитыСерии.ВидНоменклатуры;
	ИначеЕсли ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
		РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Номенклатура,
			Новый Структура("ВидНоменклатуры","ВидНоменклатуры"));
			
		ВидНоменклатуры = РеквизитыНоменклатуры.ВидНоменклатуры;
	КонецЕсли;
	
	
	Элементы.ВидНоменклатуры.ТолькоПросмотр = ЗначениеЗаполнено(ВидНоменклатуры);
	
	НастроитьПоШаблону();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.ПодключитьОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			
			Номер = МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр).Штрихкод;
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Номер", Номер, ВидСравненияКомпоновкиДанных.Содержит,,ЗначениеЗаполнено(Номер));
			
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Номер", Номер, ВидСравненияКомпоновкиДанных.Содержит,,ЗначениеЗаполнено(Номер));
КонецПроцедуры

&НаКлиенте
Процедура ГоденДоПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ГоденДо", ГоденДо, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(ГоденДо));
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	НастроитьПоШаблону();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ СПИСОК

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Не Копирование Тогда
		Отказ = Истина;
		
		Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
			ТекстПредупреждения = НСтр("ru = 'Перед добавлением серии необходимо указать вид номенклатуры.'");
			
			Предупреждение(ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВидНоменклатуры",ВидНоменклатуры);
		ЗначенияЗаполнения.Вставить("Номер",Номер);
		ЗначенияЗаполнения.Вставить("ГоденДо",ГоденДо);
		
		ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта", 
			Новый Структура("ЗначенияЗаполнения",ЗначенияЗаполнения), Элементы.Список);
				
	КонецЕсли;	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура НастроитьПоШаблону()
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ВидНоменклатуры", ВидНоменклатуры, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
	Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		ПараметрыШаблона = Новый ФиксированнаяСтруктура(
					ЗначениеНастроекПовтИсп.ПараметрыСерийНоменклатуры(ВидНоменклатуры));
		
		Элементы.ГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		Элементы.Номер.Видимость   = ПараметрыШаблона.ИспользоватьНомерСерии;
		
		Если ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
			Элементы.ГоденДо.Формат               = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
			Элементы.ГоденДо.ФорматРедактирования = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
			
			Элементы.СписокГоденДо.Формат = ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности;
		КонецЕсли;
		
		Элементы.СписокГоденДо.Видимость = ПараметрыШаблона.ИспользоватьСрокГодностиСерии;
		Элементы.СписокНомер.Видимость   = ПараметрыШаблона.ИспользоватьНомерСерии;
	КонецЕсли;
КонецПроцедуры


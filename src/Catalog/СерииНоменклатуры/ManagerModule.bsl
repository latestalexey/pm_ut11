﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Расчитывает максимальный номер серии который уже используется для вида номенклатуры
// или уже указан в ТаблицеЗначений "ТаблицаСерий"
//
// Параметры
//	ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - вид номенклатуры, для которого ищется номер серии    
//  ТаблицаСерий  - ТаблицаЗначений - таблица значений содержащая номера серий использованных на форме
//
// Возвращаемое значение:
//   ЗначениеКодаЧислом - Число - номер серии 
//
Функция ВычислитьМаксимальныйНомерСерии(ВидНоменклатуры,ТаблицаСерий)  Экспорт 
	 
	 Запрос = Новый Запрос;
	 Запрос.Текст =	
	 "ВЫБРАТЬ
	 |	ТаблицаСерий.Номер
	 |ПОМЕСТИТЬ ТаблицаСерий
	 |ИЗ
	 |	&ТаблицаСерий КАК ТаблицаСерий
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ ПЕРВЫЕ 1
	 |	ТаблицаСерий.Номер КАК Номер
	 |ИЗ
	 |	ТаблицаСерий КАК ТаблицаСерий,
	 |	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	 |ГДЕ
	 |	ТаблицаСерий.Номер ПОДОБНО ""[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]""
	 |
	 |ОБЪЕДИНИТЬ ВСЕ
	 |
	 |ВЫБРАТЬ
	 |	СерииНоменклатуры.Номер
	 |ИЗ
	 |	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	 |ГДЕ
	 |	СерииНоменклатуры.ВидНоменклатуры = &ВидНоменклатуры
	 |	И СерииНоменклатуры.ПометкаУдаления = ЛОЖЬ
	 |	И СерииНоменклатуры.Номер ПОДОБНО ""[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]""
	 |
	 |УПОРЯДОЧИТЬ ПО
	 |	Номер УБЫВ";
	 
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
 	Запрос.УстановитьПараметр("ТаблицаСерий",ТаблицаСерий);	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
		
	ОписаниеТипаЧисла = Новый ОписаниеТипов("Число");
	ЗначениеКодаЧислом = ОписаниеТипаЧисла.ПривестиЗначение(Выборка.Номер);
	
	Возврат ЗначениеКодаЧислом;
	
КонецФункции

// Извлекает из штрихкода информацию о номере и сроке годности. 
// Работает только для штрихкодов, сгенерированных обработкой печати штрихкодов и номеров
// серий, сгенерированных формой регистрации серий
//
// Параметры:
//		Штрихкод - Строка - штрихкод, из которого нужно извлечь информацию
//		ЕстьПолеНомер - Булево - признак, что для серии, чей штрихкод передан, используется номер
//		ЕстьПолеГоденДо - Булево - признак, что для серии, чей штрихкод передан, используется номер
// Возвращаемое значение
//		Структура
//			Номер - Строка - номер, извлеченный из штрихкода, если номера у серии нет - пустая строка
//			ГоденДо - Дата - дата срока годности, если срока годности у серии нет - пустая дата
Функция ИнформацияИзШтрихкода(Знач Штрихкод, ЕстьПолеНомер, ЕстьПолеГоденДо) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Номер", "");
	Результат.Вставить("ГоденДо", '00010101');
	
	Штрихкод = СокрЛП(Штрихкод);
	
	Если ЕстьПолеНомер Тогда
		
		Результат.Номер = Штрихкод;
		
		Если ЕстьПолеГоденДо Тогда
			//Проверка, что это сгененированный в программе штрихкод - из других
			//выделять срокгодности не умеем
			СрокГодностиИзШтрихкодаДата = '00010101';
			
			Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Результат.Номер)
				И СтрДлина(Результат.Номер) = 16 Тогда
				
				СрокГодностиИзШтрихкода = Прав(Результат.Номер, 8);
				СрокГодностиИзШтрихкода = "20" + Сред(СрокГодностиИзШтрихкода,5,2) + Сред(СрокГодностиИзШтрихкода,3,2) + Лев(СрокГодностиИзШтрихкода,2) + Прав(СрокГодностиИзШтрихкода, 2) + "0000";
				
				Попытка
					СрокГодностиИзШтрихкодаДата = Дата(СрокГодностиИзШтрихкода);
				Исключение
					СрокГодностиИзШтрихкодаДата = '00010101';
				КонецПопытки;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СрокГодностиИзШтрихкодаДата) Тогда
				Результат.ГоденДо = СрокГодностиИзШтрихкодаДата;
				Результат.Номер = Лев(Результат.Номер,8);
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СрокГодностиИзШтрихкодаДата = '00010101';
		
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Штрихкод)
			И СтрДлина(Штрихкод) = 8 Тогда
			
			СрокГодностиИзШтрихкода =  "20" + Сред(Штрихкод,5,2) + Сред(Штрихкод,3,2) + Лев(Штрихкод,2) + Прав(Штрихкод, 2) + "0000";
			
			Попытка
				СрокГодностиИзШтрихкодаДата = Дата(СрокГодностиИзШтрихкода);
			Исключение
				СрокГодностиИзШтрихкодаДата = '00010101';
			КонецПопытки;             
			
		КонецЕсли;
		
		Результат.ГоденДо = СрокГодностиИзШтрихкодаДата;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Параметры.Свойство("ВидНоменклатуры") Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СерииНоменклатуры.Ссылка КАК Серия,
		|	СерииНоменклатуры.Наименование,
		|	СерииНоменклатуры.ГоденДо КАК ГоденДо,
		|	СерииНоменклатуры.Номер КАК Номер
		|ИЗ
		|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
		|ГДЕ
		|	СерииНоменклатуры.ВидНоменклатуры = &ВидНоменклатуры
		|	И ВЫБОР
		|			КОГДА СерииНоменклатуры.ВидНоменклатуры.ИспользоватьНомерСерии
		|				ТОГДА &НомерНеУказан
		|						ИЛИ СерииНоменклатуры.Номер ПОДОБНО &Номер
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|	И ВЫБОР
		|			КОГДА СерииНоменклатуры.ВидНоменклатуры.ИспользоватьСрокГодностиСерии
		|				ТОГДА &ГоденДоНеУказан
		|						ИЛИ СерииНоменклатуры.ГоденДо = &ГоденДо
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номер,
		|	ГоденДо";
		
		Запрос.УстановитьПараметр("ВидНоменклатуры", Параметры.ВидНоменклатуры);
		Запрос.УстановитьПараметр("ГоденДоНеУказан", Не ЗначениеЗаполнено(Параметры.ГоденДо));
		Запрос.УстановитьПараметр("ГоденДо",Параметры.ГоденДо);
		Запрос.УстановитьПараметр("НомерНеУказан", Не ЗначениеЗаполнено(Параметры.Номер));
		Запрос.УстановитьПараметр("Номер", "%"+СокрЛП(Параметры.Номер)+"%");
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Пока Выборка.Следующий() Цикл
			Значение = Новый Структура("Серия,Номер,ГоденДо");
			ЗаполнитьЗначенияСвойств(Значение,Выборка);
			
			ДанныеВыбора.Добавить(Значение,Выборка.Наименование);
			
		КонецЦикла;
	ИначеЕсли Параметры.Свойство("Номенклатура") Тогда 	
		СтрокаПоиска = Параметры.СтрокаПоиска;
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	СпрСерии.Ссылка КАК Серия,
		|	СпрСерии.Наименование КАК СерияПредставление
		|ИЗ
		|	Справочник.Номенклатура КАК СпрНоменклатура
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Справочник.СерииНоменклатуры КАК СпрСерии
		|ПО
		|	СпрСерии.ВидНоменклатуры = СпрНоменклатура.ВидНоменклатуры 
		|ГДЕ
		|	СпрНоменклатура.Ссылка = &Номенклатура
		|	" + ?(СтрокаПоиска = Неопределено, "", "И СпрСерии.Наименование ПОДОБНО &СтрокаПоиска") + "
		|УПОРЯДОЧИТЬ ПО
		|	СерияПредставление
		|");
		
		Запрос.УстановитьПараметр("Номенклатура", Параметры.Номенклатура);
		
		Если СтрокаПоиска <> Неопределено Тогда
			Запрос.УстановитьПараметр("СтрокаПоиска", СтрокаПоиска + "%");
		КонецЕсли;
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ДанныеВыбора.Добавить(Выборка.Серия, Выборка.СерияПредставление);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
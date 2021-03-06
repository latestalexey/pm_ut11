﻿
////////////////////////////////////////////////////////////////////////////////////////////

//
//
Процедура ВывестиВExcel(ТабличныйДокумент, Организация, Имя = "temp")
	
	//
	ИмяФайла =  КаталогВременныхФайлов() + Строка(Имя) + ".xls";
	
	//
	ТабличныйДокумент.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.XLS);
	
	//
	Попытка
		COMОбъект = Новый COMОбъект("Excel.Application");
	Исключение
		ВызватьИсключение "Excel не установлен";
	КонецПопытки;
	
	//
	Workbook = COMОбъект.Workbooks.Open(ИмяФайла);
	
	//ЛЕВЫЙ КОЛОНТИТУЛ
	ИмяФайлаКартинкиКолонтитулВерхнийЛевый = ПолучитьИмяВременногоФайла(".bmp");
	
	КартинкаКолонтитулВерхнийЛевый = ПолучитьЛоготип(Организация, "КолонтитулВерхнийЛевый");
	КартинкаКолонтитулВерхнийЛевый.Записать(ИмяФайлаКартинкиКолонтитулВерхнийЛевый);
	
	Workbook.ActiveSheet.PageSetup.LeftHeaderPicture.Filename = ИмяФайлаКартинкиКолонтитулВерхнийЛевый; 
	Workbook.ActiveSheet.PageSetup.LeftHeader = "&G";
	
	//ЦЕНТР КОЛОНТИТУЛ
	ИмяФайлаКартинкиКолонтитулВерхнийЦентр = ПолучитьИмяВременногоФайла(".bmp");
	
	КартинкаКолонтитулВерхнийЦентр = ПолучитьЛоготип(Организация, "КолонтитулВерхнийЦентр");
	КартинкаКолонтитулВерхнийЦентр.Записать(ИмяФайлаКартинкиКолонтитулВерхнийЦентр);
	
	Workbook.ActiveSheet.PageSetup.CenterHeaderPicture.Filename = ИмяФайлаКартинкиКолонтитулВерхнийЦентр; 
	Workbook.ActiveSheet.PageSetup.CenterHeader = "&G";
	
	//ПРАВЫЙ КОЛОНТИТУЛ
	ИмяФайлаКартинкиКолонтитулВерхнийПравый = ПолучитьИмяВременногоФайла(".bmp");
	
	КартинкаКолонтитулВерхнийПравый = ПолучитьЛоготип(Организация, "КолонтитулВерхнийПравый");
	КартинкаКолонтитулВерхнийПравый.Записать(ИмяФайлаКартинкиКолонтитулВерхнийПравый);
	
	Workbook.ActiveSheet.PageSetup.RightHeaderPicture.Filename = ИмяФайлаКартинкиКолонтитулВерхнийПравый; 
	Workbook.ActiveSheet.PageSetup.RightHeader = "&G";
	
	//
	Workbook.ActiveSheet.PageSetup.Orientation = 2;
	Workbook.ActiveSheet.PageSetup.Zoom = False;
    Workbook.ActiveSheet.PageSetup.FitToPagesTall = 1;
    Workbook.ActiveSheet.PageSetup.FitToPagesWide = 1;

    //
	Workbook.Save();
	//Workbook.Close();
	
	//
	COMОбъект.Visible = Истина;
	
	//
	УдалитьФайлы(ИмяФайлаКартинкиКолонтитулВерхнийЛевый);
	УдалитьФайлы(ИмяФайлаКартинкиКолонтитулВерхнийЦентр);
	УдалитьФайлы(ИмяФайлаКартинкиКолонтитулВерхнийПравый);
	
КонецПроцедуры	


////////////////////////////////////////////////////////////////////////////////////////////

//
//
Функция СократитьФИО(Знач z1)
	
	//
	РезультатФИО = "";
	
	//
	z1 = СтрЗаменить(z1, "  ", " ");
	z1 = СтрЗаменить(z1, "  ", " ");
	
	//
	z1 = СокрЛП(СтрЗаменить(z1, " ", Символы.ПС));
	
	//
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(z1);
	
	//
	Для Сч = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		
		//
		ТекущаяСтрока = СокрЛП(ТекстовыйДокумент.ПолучитьСтроку(Сч));
		
		//
		Если Сч = 1 Тогда
			РезультатФИО = РезультатФИО + СокрЛП(ТекущаяСтрока) + " ";
			Продолжить;
		КонецЕсли;	
		
		//
		РезультатФИО = РезультатФИО + ВРЕГ(Лев(СокрЛП(ТекущаяСтрока), 1)) + ".";
		
	КонецЦикла;	
	
	//
	Возврат РезультатФИО;

 КонецФункции

//
//
Функция ВывестиСПроверкойВывода(ТабличныйДокумент, ВыводимаяОбласть,  ВерхнийКолонтитул = Неопределено, НижнийКолонтитул = Неопределено)
	
	//
	МассивВыводимыхОбластей = Новый Массив;
	
	//
	Если ТипЗнч(ВыводимаяОбласть) = Тип("Массив") Тогда
		Для Каждого ЭлементМассива Из ВыводимаяОбласть Цикл
			МассивВыводимыхОбластей.Добавить(ЭлементМассива);
		КонецЦикла;	
	Иначе
		МассивВыводимыхОбластей.Добавить(ВыводимаяОбласть);
	КонецЕсли;	
	
	//
	Если НижнийКолонтитул <> Неопределено Тогда
			
		Если ТипЗнч(НижнийКолонтитул) = Тип("Массив") Тогда
			Для Каждого ЭлементМассива Из НижнийКолонтитул Цикл
				МассивВыводимыхОбластей.Добавить(ЭлементМассива);
			КонецЦикла;	
		Иначе
			МассивВыводимыхОбластей.Добавить(НижнийКолонтитул);
		КонецЕсли;	
			
	КонецЕсли;
	
	//
	Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
		
		//
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		//
		Если ВерхнийКолонтитул <> Неопределено Тогда
				
			Если ТипЗнч(ВерхнийКолонтитул) = Тип("Массив") Тогда
				Для Каждого ЭлементМассива Из ВерхнийКолонтитул Цикл
					ТабличныйДокумент.Вывести(ЭлементМассива);
				КонецЦикла;
			Иначе
				ТабличныйДокумент.Вывести(ВерхнийКолонтитул);
			КонецЕсли;	
				
		КонецЕсли;
	
	КонецЕсли;
	
	//
	Для Сч = 0 По МассивВыводимыхОбластей.Количество() - 1 Цикл
			
		//
		ЭлементМассива = МассивВыводимыхОбластей[Сч];
		ТабличныйДокумент.Вывести(ЭлементМассива);
	
	КонецЦикла;
	
КонецФункции

//
//
Функция ПолучитьИнформациюОКонтактномЛице(Объект, ФИО = Истина, ФИОСокращенно = Ложь, ТелефонВид = Неопределено, АдресЭПВид = Неопределено, АдресВид = Неопределено, Разделитель = ",")
	
	//
	РезультатИнформация = "";
	
	//
	ТекстЗапроса = "ВЫБРАТЬ
	               |	КонтактныеЛицаПартнеров.Ссылка КАК КонтактноеЛицо,
	               |	КонтактныеЛицаПартнеров.Наименование КАК Наименование,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.Тип,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.Вид,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.Представление,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.ЗначенияПолей,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.Страна,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.Регион,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.Город,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.АдресЭП,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.ДоменноеИмяСервера,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.НомерТелефона,
	               |	КонтактныеЛицаПартнеровКонтактнаяИнформация.НомерТелефонаБезКодов,
	               |	ВЫБОР
	               |		КОГДА КонтактныеЛицаПартнеровКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
	               |			ТОГДА 1
	               |		КОГДА КонтактныеЛицаПартнеровКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	               |			ТОГДА 2
	               |		КОГДА КонтактныеЛицаПартнеровКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	               |			ТОГДА 3
	               |	КОНЕЦ КАК Порядок
	               |ИЗ
	               |	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛицаПартнеров.КонтактнаяИнформация КАК КонтактныеЛицаПартнеровКонтактнаяИнформация
	               |		ПО (КонтактныеЛицаПартнеровКонтактнаяИнформация.Ссылка = КонтактныеЛицаПартнеров.Ссылка)
	               |ГДЕ
	               |	КонтактныеЛицаПартнеров.Ссылка = &Ссылка
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	КонтактноеЛицо,
	               |	Порядок
	               |ИТОГИ
	               |	МАКСИМУМ(Наименование)
	               |ПО
	               |	КонтактноеЛицо";
				   
	//			   
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст = ТекстЗапроса;
	
	//
	ПостроительЗапроса.Параметры.Вставить("Ссылка", Объект);
	
	//
	ПостроительЗапроса.Выполнить();
	
	//
	ВыборкаКЛ = ПостроительЗапроса.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаКЛ.Следующий() Тогда
		
		//
		КонтактноеЛицо = ВыборкаКЛ.КонтактноеЛицо;
		
		//
		Если ФИО = Истина Тогда
			РезультатИнформация = РезультатИнформация + ВыборкаКЛ.Наименование + Разделитель + " ";
		ИначеЕсли ФИОСокращенно = Истина Тогда	
			РезультатИнформация = РезультатИнформация + СократитьФИО(ВыборкаКЛ.Наименование) + Разделитель + " ";
		КонецЕсли;	
		
		//
		ВыборкаКИ = ВыборкаКЛ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаКИ.Следующий() Цикл
			
			Если ВыборкаКИ.Вид = ТелефонВид Тогда
				РезультатИнформация = РезультатИнформация + СокрЛП(ВыборкаКИ.Представление) + Разделитель + " ";
			ИначеЕсли ВыборкаКИ.Вид = АдресЭПВид Тогда
				РезультатИнформация = РезультатИнформация + СокрЛП(ВыборкаКИ.Представление) + Разделитель + " ";
			ИначеЕсли ВыборкаКИ.Вид = АдресВид Тогда
				РезультатИнформация = РезультатИнформация + СокрЛП(ВыборкаКИ.Представление) + Разделитель + " ";
			КонецЕсли;	
			
		КонецЦикла;	
		
		//
		РезультатИнформация = Лев(РезультатИнформация, СтрДлина(РезультатИнформация) - 2);
		
	КонецЕсли;	
	
	//
	Возврат РезультатИнформация;
	
КонецФункции	

//
//
Функция ПолучитьРеквизитыШапки(Ссылка)
	
	//
	ТекстЗапроса = "ВЫБРАТЬ
	               |	Таблица.Номер,
	               |	Таблица.Дата,
	               |	Таблица.Партнер,
	               |	Таблица.КонтактноеЛицоПартнера КАК ПартнерКонтактноеЛицо,
	               |	Таблица.Транспорт,
	               |	Таблица.ДатаВремя КАК ТранспортДатаВремя,
	               |	Таблица.Информация,
	               |	Таблица.Ответственный,
	               |	Таблица.Комментарий,
	               |	Таблица.Организация
	               |ИЗ
	               |	Документ.АК_ЗаказНаДоставку КАК Таблица
	               |ГДЕ
	               |	Таблица.Ссылка = &Ссылка";
				   
	//
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст = ТекстЗапроса;
	ПостроительЗапроса.Параметры.Вставить("Ссылка", Ссылка);
	
	//
	ПостроительЗапроса.Выполнить();
	
	//
	Выборка = ПостроительЗапроса.Результат.Выбрать();
	Выборка.Следующий();
	
	//
	Возврат Выборка;
	
КонецФункции	

//
//
Функция ПолучитьЛоготип(Организация, ИмяФайла)
	
	//
	РезультатКартинка = Новый Картинка;
	
	//
	ТекстЗапроса = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ОрганизацииПрисоединенныеФайлы.Ссылка,
	               |	ПрисоединенныеФайлы.ХранимыйФайл
	               |ИЗ
	               |	Справочник.ОрганизацииПрисоединенныеФайлы КАК ОрганизацииПрисоединенныеФайлы
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПрисоединенныеФайлы КАК ПрисоединенныеФайлы
	               |		ПО ОрганизацииПрисоединенныеФайлы.Ссылка = ПрисоединенныеФайлы.ПрисоединенныйФайл
	               |ГДЕ
	               |	ОрганизацииПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	               |	И ОрганизацииПрисоединенныеФайлы.Наименование = &Наименование
	               |	И (НЕ ОрганизацииПрисоединенныеФайлы.ПометкаУдаления)";
				   
	//
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст = ТекстЗапроса;
	
	//
	ПостроительЗапроса.Параметры.Вставить("ВладелецФайла", Организация);
	ПостроительЗапроса.Параметры.Вставить("Наименование", ИмяФайла);
	
	//
	ПостроительЗапроса.Выполнить();
	
	//
	Выборка = ПостроительЗапроса.Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		//
		РезультатКартинка = Новый Картинка(Выборка.ХранимыйФайл.Получить());
		
	КонецЕсли;	
	
	//
	Возврат РезультатКартинка;
	
	//КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////////////////

//
//
Функция ПечатьЛистаДоставки(МассивОбъектов, ОбъектыПечати)
	
	// Создаем табличный документ и устанавливаем имя параметров печати.
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_ЗаказНаДоставку"; 	
	
	//
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	
	//
	ПервыйДокумент = Истина;	
	
	//
	Для Каждого СсылкаНаОбъект из МассивОбъектов Цикл
		
		//
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Макет и области
		Макет = ПолучитьМакет("ЛистДоставки");	
		
		//
		РеквизитыШапки = ПолучитьРеквизитыШапки(СсылкаНаОбъект);
		
		////ЛОГОТИП
		//
		////
		_ТД_Логотип = Новый ТабличныйДокумент;
		//
		////
		//ШапкаЛоготип = Макет.ПолучитьОбласть("Логотип");
		//
		////
		//ОбластьРисунок = ШапкаЛоготип.Области.Найти("РисунокЛоготип");
		//ОбластьРисунок.Картинка = ПолучитьЛоготип(РеквизитыШапки.Организация, "ЛоготипЛандшафт");
		//
		////
		//_ТД_Логотип.Вывести(ШапкаЛоготип);
		//
		////
		//ТабличныйДокумент.Вывести(_ТД_Логотип);
		
		//ЗАГОЛОВОК
		Заголовок = Макет.ПолучитьОбласть("Заголовок");
		
		//
		Заголовок.Параметры.Заполнить(РеквизитыШапки);
		
		//
		Заголовок.Параметры.Номер = РеквизитыШапки.Номер;
		Заголовок.Параметры.Дата = Формат(РеквизитыШапки.Дата, "ДЛФ=DD");
		
		//
		Заголовок.Параметры.ТранспортДата = Формат(РеквизитыШапки.ТранспортДатаВремя, "ДЛФ=DD");
		
		//
		Заголовок.Параметры.ПартнерКонтактнаяИнформация = ПолучитьИнформациюОКонтактномЛице(РеквизитыШапки.ПартнерКонтактноеЛицо, Истина, Ложь, Справочники.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛица, Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица,);
		
		//
		ТабличныйДокумент.Вывести(Заголовок);
		
		//ЗАПРОС ПО ТОВАРАМ
		
		//
		Запрос = Новый Запрос;
		Запрос.Текст ="ВЫБРАТЬ
		              |	Таблица.НомерСтроки,
		              |	Таблица.Номенклатура,
		              |	Таблица.Количество КАК Количество,
		              |	Таблица.Номенклатура.Артикул КАК Артикул,
		              |	Таблица.Номенклатура.Код КАК Код,
		              |	Таблица.Номенклатура.Описание КАК Описание,
		              |	ГабаритныеРазмеры.Значение КАК Габариты,
		              |	Производитель.Значение КАК Производитель
		              |ПОМЕСТИТЬ ТЗ_Товары
		              |ИЗ
		              |	Документ.АК_ЗаказНаДоставку.Товары КАК Таблица
		              |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура.ДополнительныеРеквизиты КАК ГабаритныеРазмеры
		              |		ПО Таблица.Номенклатура = ГабаритныеРазмеры.Ссылка
		              |			И (ГабаритныеРазмеры.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.АК_ГабаритныеРазмеры))
		              |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура.ДополнительныеРеквизиты КАК Производитель
		              |		ПО Таблица.Номенклатура = Производитель.Ссылка
		              |			И (Производитель.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.АК_Производитель))
		              |ГДЕ
		              |	Таблица.Ссылка = &Ссылка
		              |;
		              |
		              |////////////////////////////////////////////////////////////////////////////////
		              |ВЫБРАТЬ
		              |	НоменклатураДополнительныеРеквизиты.Свойство,
		              |	НоменклатураДополнительныеРеквизиты.Значение,
		              |	НоменклатураДополнительныеРеквизиты.ТекстоваяСтрока,
		              |	НоменклатураДополнительныеРеквизиты.Ссылка КАК Номенклатура
		              |ПОМЕСТИТЬ ТЗ_Свойства
		              |ИЗ
		              |	Справочник.Номенклатура.ДополнительныеРеквизиты КАК НоменклатураДополнительныеРеквизиты
		              |ГДЕ
		              |	НоменклатураДополнительныеРеквизиты.Ссылка В
		              |			(ВЫБРАТЬ
		              |				ТЗ_Товары.Номенклатура
		              |			ИЗ
		              |				ТЗ_Товары)
		              |	И (НЕ НоменклатураДополнительныеРеквизиты.Свойство В (ЗНАЧЕНИЕ(ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.АК_ГабаритныеРазмеры), ЗНАЧЕНИЕ(ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.АК_Производитель)))
		              |;
		              |
		              |////////////////////////////////////////////////////////////////////////////////
		              |ВЫБРАТЬ
		              |	ТЗ_Товары.НомерСтроки,
		              |	ТЗ_Товары.Номенклатура,
		              |	ТЗ_Товары.Количество,
		              |	ТЗ_Товары.Артикул,
		              |	ТЗ_Товары.Код,
		              |	ТЗ_Товары.Описание,
		              |	ТЗ_Товары.Габариты,
		              |	ТЗ_Товары.Производитель
		              |ИЗ
		              |	ТЗ_Товары КАК ТЗ_Товары
		              |;
		              |
		              |////////////////////////////////////////////////////////////////////////////////
		              |ВЫБРАТЬ РАЗЛИЧНЫЕ
		              |	ТЗ_Свойства.Свойство
		              |ИЗ
		              |	ТЗ_Свойства КАК ТЗ_Свойства
		              |
		              |УПОРЯДОЧИТЬ ПО
		              |	ТЗ_Свойства.Свойство.АК_ПорядокВывода,
		              |	ТЗ_Свойства.Свойство.Наименование
		              |;
		              |
		              |////////////////////////////////////////////////////////////////////////////////
		              |ВЫБРАТЬ
		              |	ТЗ_Свойства.Свойство,
		              |	ТЗ_Свойства.Значение,
		              |	ТЗ_Свойства.ТекстоваяСтрока,
		              |	ТЗ_Свойства.Номенклатура КАК Номенклатура
		              |ИЗ
		              |	ТЗ_Свойства КАК ТЗ_Свойства";
		
		//							
		Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);	
		Результат = Запрос.ВыполнитьПакет();	
		
		//
		тзТовары = Результат.Получить(Результат.Количество()-3).Выгрузить();
		тзСвойства = Результат.Получить(Результат.Количество()-2).Выгрузить();
		тзСвойстваИЗначения = Результат.Получить(Результат.Количество()-1).Выгрузить();
		
		//
		ТекстЗапроса = "ВЫБРАТЬ
		               |	Таблица.Операция,
		               |	Таблица.Партнер,
		               |	Таблица.КонтактноеЛицо,
		               |	Таблица.ПунктНазначения,
		               |	Таблица.ПунктНазначения.Адрес,
		               |	Таблица.ДатаВремя,
		               |	Таблица.КлючСтрокиМаршрута
		               |ИЗ
		               |	Документ.АК_ЗаказНаДоставку.Маршрут КАК Таблица
		               |ГДЕ
		               |	Таблица.Ссылка = &Ссылка
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Таблица.НомерСтроки";
		
		//
		ПостроительЗапроса = Новый ПостроительЗапроса;
		ПостроительЗапроса.Текст = ТекстЗапроса;
		ПостроительЗапроса.Параметры.Вставить("Ссылка", СсылкаНаОбъект);
		
		//
		ПостроительЗапроса.Выполнить();
		
		//МАРШРУТ
		МаршрутШапкаПостоянная = Макет.ПолучитьОбласть("МаршрутШапка|Постоянная");
		МаршрутШапкаПеременная = Макет.ПолучитьОбласть("МаршрутШапка|Переменная");
		МаршрутШапкаПримечание = Макет.ПолучитьОбласть("МаршрутШапка|Примечание");
		
		//
		МаршрутСтрокаПостоянная = Макет.ПолучитьОбласть("МаршрутСтрока|Постоянная");
		МаршрутСтрокаПеременная = Макет.ПолучитьОбласть("МаршрутСтрока|Переменная");
		МаршрутСтрокаПримечание = Макет.ПолучитьОбласть("МаршрутСтрока|Примечание");
		
		//
		тзМаршрут = ПостроительЗапроса.Результат.Выгрузить();
		тзМаршрут.Колонки.Добавить("НомерДатаСчета");
		тзМаршрут.Колонки.Добавить("НомерДатаДоговора");
		тзМаршрут.Колонки.Добавить("КоличествоДоговоров");
		
		// заполним номера и даты счетов и договоров
		Для Каждого СтрокаМаршрута Из тзМаршрут Цикл
			
			//
			НомерДатаСчета = "";
			НомерДатаДоговора = "";
			КоличествоДоговоров = 0;
			
			//
			ПолучитьНомерДатуСчетаДоговораПоКлючуСтрокиМаршрута(СсылкаНаОбъект, СтрокаМаршрута.КлючСтрокиМаршрута, НомерДатаСчета, НомерДатаДоговора, КоличествоДоговоров);
			
			//
			СтрокаМаршрута.НомерДатаСчета = НомерДатаСчета;
			СтрокаМаршрута.НомерДатаДоговора = НомерДатаДоговора;
			СтрокаМаршрута.КоличествоДоговоров = КоличествоДоговоров;
			
		КонецЦикла;
		
		//
		ДоговорыОтсутствуют = (тзМаршрут.Итог("КоличествоДоговоров") = 0);
		
		//
		_ТД = Новый ТабличныйДокумент;
		
		//
		_ТД.Вывести(МаршрутШапкаПостоянная);
		
		//
		НачалоПеременнойСекции = _ТД.ШиринаТаблицы;
		
		//
		Для Каждого СтрокаТЗ Из тзСвойства Цикл
			_ТД.Присоединить(МаршрутШапкаПеременная);
		КонецЦикла;
		
		//
		ОкончаниеПеременнойСекции = _ТД.ШиринаТаблицы;
		
		//
		Обл = _ТД.Область(_ТД.ВысотаТаблицы, НачалоПеременнойСекции, _ТД.ВысотаТаблицы, ОкончаниеПеременнойСекции);
		Обл.Объединить();
		
		//
		_ТД.Присоединить(МаршрутШапкаПримечание); 
		
		//
		Если ДоговорыОтсутствуют Тогда
			Обл = _ТД.Область(_ТД.ВысотаТаблицы, НачалоПеременнойСекции, _ТД.ВысотаТаблицы, _ТД.ШиринаТаблицы);
			Обл.Объединить();
		КонецЕсли;
		
		//
		ВывестиСПроверкойВывода(ТабличныйДокумент, _ТД, _ТД_Логотип);
		
		//
		МассивВерхнийКолонтитул = Новый Массив;
		МассивВерхнийКолонтитул.Добавить(_ТД_Логотип);
		МассивВерхнийКолонтитул.Добавить(_ТД);
		
		//
		Для Каждого СтрокаМаршрута Из тзМаршрут Цикл
			
			//
			_ТД = Новый ТабличныйДокумент;
			
			//
			МаршрутСтрокаПостоянная.Параметры.Заполнить(СтрокаМаршрута);
			
			//
			Телефон = УправлениеКонтактнойИнформацией.ПолучитьКонтактнуюИнформацияОбъекта(СтрокаМаршрута.КонтактноеЛицо, Справочники.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛица);
			Если НЕ ЗначениеЗаполнено(Телефон) Тогда
				Телефон = УправлениеКонтактнойИнформацией.ПолучитьКонтактнуюИнформацияОбъекта(СтрокаМаршрута.КонтактноеЛицо, Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица);
			КонецЕсли;
			
			//
			МаршрутСтрокаПостоянная.Параметры.КонтактноеЛицоТелефон = Телефон;
			
			// тодо
			НомерДатаСчета = "";
			НомерДатаДоговора = "";
			КоличествоДоговоров = 0;
			
			//
			МаршрутСтрокаПостоянная.Параметры.НомерДатаСчета = СтрокаМаршрута.НомерДатаСчета;
			
			//
			_ТД.Вывести(МаршрутСтрокаПостоянная);
			
			//
			Для Каждого СтрокаТЗ Из тзСвойства Цикл
				_ТД.Присоединить(МаршрутСтрокаПеременная);
			КонецЦикла;
			
			//
			Обл = _ТД.Область(_ТД.ВысотаТаблицы, НачалоПеременнойСекции, _ТД.ВысотаТаблицы, ОкончаниеПеременнойСекции);
			Обл.Объединить();

			//
			МаршрутСтрокаПримечание.Параметры.НомерДатаДоговора = СтрокаМаршрута.НомерДатаДоговора;
			_ТД.Присоединить(МаршрутСтрокаПримечание);
			
			// Объединим счета и договоры
			Если ДоговорыОтсутствуют Тогда
				Обл = _ТД.Область(_ТД.ВысотаТаблицы, НачалоПеременнойСекции, _ТД.ВысотаТаблицы, _ТД.ШиринаТаблицы);
				Обл.Объединить();
			КонецЕсли;
			
			//
			ВывестиСПроверкойВывода(ТабличныйДокумент, _ТД, МассивВерхнийКолонтитул);
			
		КонецЦикла;
		
		//ТОВАРЫ
		
		//
		ТоварыШапкаПостоянная = Макет.ПолучитьОбласть("ТоварыШапка|Постоянная");
		ТоварыШапкаПеременная = Макет.ПолучитьОбласть("ТоварыШапка|Переменная"); 
		ТоварыШапкаПримечание = Макет.ПолучитьОбласть("ТоварыШапка|Примечание");
		
		//
		ТоварыСтрокаПостоянная = Макет.ПолучитьОбласть("ТоварыСтрока|Постоянная");
		ТоварыСтрокаПеременная = Макет.ПолучитьОбласть("ТоварыСтрока|Переменная"); 
		ТоварыСтрокаПримечание = Макет.ПолучитьОбласть("ТоварыСтрока|Примечание");
		
		//ШАПКА "ТОВАРЫ"
		
		//
		ТоварыШапкаПостоянная = Макет.ПолучитьОбласть("ТоварыШапка|Постоянная");
		ТоварыШапкаПеременная = Макет.ПолучитьОбласть("ТоварыШапка|Переменная"); 
		ТоварыШапкаПримечание = Макет.ПолучитьОбласть("ТоварыШапка|Примечание");
		
		//
		_ТД_ТоварыШапка = Новый ТабличныйДокумент;
		
		//
		_ТД_ТоварыШапка.Вывести(ТоварыШапкаПостоянная);
		
		//
		Для Каждого СтрокаТЗ Из тзСвойства Цикл
			ТоварыШапкаПеременная.Параметры.Свойство = СтрокаТЗ.Свойство;
			_ТД_ТоварыШапка.Присоединить(ТоварыШапкаПеременная);
		КонецЦикла;
		
		//
		_ТД_ТоварыШапка.Присоединить(ТоварыШапкаПримечание);
		
		//
		МассивВерхнийКолонтитул = Новый Массив;
		МассивВерхнийКолонтитул.Добавить(_ТД_Логотип);
		МассивВерхнийКолонтитул.Добавить(_ТД_ТоварыШапка);
		
		//ТОВАРЫ
		
		//
		ТоварыСтрокаПостоянная = Макет.ПолучитьОбласть("ТоварыСтрока|Постоянная");
		ТоварыСтрокаПримечание = Макет.ПолучитьОбласть("ТоварыСтрока|Примечание");
		
		//
		КоличествоВсего = 0;
		
		//
		Для Каждого СтрокаТЗ из тзТовары Цикл
			
			//
			_ТД = Новый ТабличныйДокумент;
			
			//
			ТоварыСтрокаПостоянная.Параметры.Заполнить(СтрокаТЗ);
			_ТД.Вывести(ТоварыСтрокаПостоянная);
			
			//
			Для Каждого СтрокаСвойство Из тзСвойства Цикл
				
				//
				ТоварыСтрокаПеременная = Макет.ПолучитьОбласть("ТоварыСтрока|Переменная");
				
				//
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("Номенклатура", СтрокаТЗ.Номенклатура);
				СтруктураПоиска.Вставить("Свойство", СтрокаСвойство.Свойство);
				
				//
 				НайденныеСтроки = тзСвойстваИЗначения.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество() > 0 Тогда
					ТоварыСтрокаПеременная.Параметры.СвойствоЗначение = НайденныеСтроки[0].Значение;
				КонецЕсли;	
				
				//
				_ТД.Присоединить(ТоварыСтрокаПеременная);
				
			КонецЦикла;	
			
			//
			_ТД.Присоединить(ТоварыСтрокаПримечание);
			
			//
			Если тзТовары.Индекс(СтрокаТЗ) = 0 Тогда
				
				//
				МассивВерхнийКолонтитул = Новый Массив;
				МассивВерхнийКолонтитул.Добавить(_ТД_Логотип);
				
				//
				МассивСтрока = Новый Массив;
				МассивСтрока.Добавить(_ТД_ТоварыШапка);
				МассивСтрока.Добавить(_ТД);
				
				//
				ВывестиСПроверкойВывода(ТабличныйДокумент, МассивСтрока, МассивВерхнийКолонтитул);
				
			Иначе	
				
				//
				МассивВерхнийКолонтитул = Новый Массив;
				МассивВерхнийКолонтитул.Добавить(_ТД_Логотип);
				МассивВерхнийКолонтитул.Добавить(_ТД_ТоварыШапка);
				
				//
				ВывестиСПроверкойВывода(ТабличныйДокумент, _ТД, МассивВерхнийКолонтитул);
			
			КонецЕсли;
			
			//
			КоличествоВсего = КоличествоВсего + СтрокаТЗ.Количество;
			
		КонецЦикла;	
		
		//ПОДВАЛ ТОВАРЫ
		
		//
		ТоварыПодвалПостоянная = Макет.ПолучитьОбласть("ТоварыПодвал|Постоянная");
		ТоварыПодвалПеременная = Макет.ПолучитьОбласть("ТоварыПодвал|Переменная"); 	
		ТоварыПодвалПримечание = Макет.ПолучитьОбласть("ТоварыПодвал|Примечание");
		
		//
		ТоварыПодвалПостоянная.Параметры.КоличествоВсего = КоличествоВсего;
		ВывестиСПроверкойВывода(ТабличныйДокумент, ТоварыПодвалПостоянная, _ТД_Логотип);
		
		//
		Для Каждого СтрокаСвойство Из тзСвойства Цикл
			ТабличныйДокумент.Присоединить(ТоварыПодвалПеременная);
		КонецЦикла;	
			
		//
		ТабличныйДокумент.Присоединить(ТоварыПодвалПримечание);
		
		
		//ПОДВАЛ
		
		//
		ПодвалПостоянная = Макет.ПолучитьОбласть("Подвал");	
		
		//
		СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(РеквизитыШапки.Организация, КонецДня(РеквизитыШапки.Дата));
		
		//
		ПодвалПостояннаяПараметры = Новый Структура;
		ПодвалПостояннаяПараметры.Вставить("ОрганизацияКонтактноеЛицо", РеквизитыШапки.Ответственный.Наименование); 
		ПодвалПостояннаяПараметры.Вставить("ОрганизацияКонтактноеЛицоДолжность", РеквизитыШапки.Ответственный.АК_Должность);
		ПодвалПостояннаяПараметры.Вставить("Организация", СведенияОбОрганизации.ПолноеНаименование);
		ПодвалПостояннаяПараметры.Вставить("ОрганизацияТелефон", "Тел.: " + СведенияОбОрганизации.Телефоны);
		ПодвалПостояннаяПараметры.Вставить("ОрганизацияКонтактноеЛицоТелефон", УправлениеКонтактнойИнформацией.ПолучитьКонтактнуюИнформацияОбъекта(РеквизитыШапки.Ответственный, Справочники.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛица));
		ПодвалПостояннаяПараметры.Вставить("ОрганизацияАдресЭП", УправлениеКонтактнойИнформацией.ПолучитьКонтактнуюИнформацияОбъекта(РеквизитыШапки.Организация, Справочники.ВидыКонтактнойИнформации.EmailОрганизации));
		
		//
		ПодвалПостоянная.Параметры.Заполнить(ПодвалПостояннаяПараметры);
		
		//
		ВывестиСПроверкойВывода(ТабличныйДокумент, ПодвалПостоянная, _ТД_Логотип);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно 
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, СсылкаНаОбъект);
		
		//
		//ВывестиВExcel(ТабличныйДокумент, РеквизитыШапки.Организация, СсылкаНаОбъект.Метаданные().Синоним + " от " + СсылкаНаОбъект.Номер);
		
	КонецЦикла;
	
	////
	//ШиринаТаблицыВПикселях = 0;
	//Для Сч = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
	//	Область = ТабличныйДокумент.Область(, Сч, , Сч);
	//	ШиринаТаблицыВПикселях = ШиринаТаблицыВПикселях + Область.ШиринаКолонки;
	//КонецЦикла;
	//
	////
	//Для Каждого Рисунок Из ТабличныйДокумент.Рисунки Цикл
	//	Рисунок.Ширина = ШиринаТаблицыВПикселях*1.835;
	//КонецЦикла;	
	
	//
	Возврат ТабличныйДокумент;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////

//
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,
	ОбъектыПечати, ПараметрыВывода) Экспорт
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЛистДоставки") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ЛистДоставки", "Заказ на доставку", ПечатьЛистаДоставки(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////

//
//
Функция ПолучитьЗначениеСвойства(Номенклатура, Свойство)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НоменклатураДополнительныеРеквизиты.Значение КАК ЗначениеСвойства
		|ИЗ
		|	Справочник.Номенклатура.ДополнительныеРеквизиты КАК НоменклатураДополнительныеРеквизиты
		|ГДЕ
		|	НоменклатураДополнительныеРеквизиты.Свойство = &Свойство
		|	И НоменклатураДополнительныеРеквизиты.Ссылка = &Номенклатура";
		
	Запрос.УстановитьПараметр("Свойство", Свойство);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Резульат = Запрос.Выполнить();
	Если Резульат.Пустой() Тогда
		Возврат "";
	Иначе
		Выборка = Резульат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ЗначениеСвойства;
	КонецЕсли;
	
КонецФункции

//
//
Функция ФИОСИнициаламиВДатПадеже(Объект)
	
	ТипОбъекта = ТипЗнч(Объект);

	Если ТипОбъекта = Тип("Строка") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(Объект)," ");
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ФизическиеЛица") Или ТипОбъекта = Тип("СправочникОбъект.ФизическиеЛица") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(Объект.Наименование)," ");
	Иначе
		
		// используем возможно переданные отдельные строки
		Возврат Объект;
		
	КонецЕсли;
	
	КоличествоПодстрок = ФИО.Количество();
	Фамилия            = ?(КоличествоПодстрок > 0,ФИО[0],"");
	Имя                = ?(КоличествоПодстрок > 1,ФИО[1],"");
	Отчество           = ?(КоличествоПодстрок > 2,ФИО[2],"");
	
	Возврат ?(Не ПустаяСтрока(Фамилия), 
				ВрегПоПервым(ПадежП(Фамилия, 3, 0)) + ?(Не ПустаяСтрока(Имя)," " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество),Лев(Отчество,1)+".", ""), ""),
				""); 

	
КонецФункции

//
//
Функция ПадежС(z1,Знач z2=2,Знач z3="*",z4=0) Экспорт
  z5=Найти(z1,"-");
  z6=?(z5=0,"","-"+ПадежС(Сред(z1,z5+1,СтрДлина(z1)-z5+1),z2,z3,z4));
  z1=НРег(?(z5=0,z1,Лев(z1,z5-1)));
  z7=Прав(z1,3);z8=Прав(z7,2);z9=Прав(z8,1);
  z5=СтрДлина(z1);
  za=Найти("ая ия ел ок яц ий па да ца ша ба та га ка",z8);
  zb=Найти("аеёийоуэюяжнгхкчшщ",Лев(z7,1));
  zc=Макс(z2,-z2);
  zd=?(za=4,5,Найти("айяь",z9));
  zd=?((zc=1)или(z9=".")или((z4=2)и(Найти("оиеу"+?(z3="ч","","бвгджзклмнпрстфхцчшщъ"),z9)>0))или((z4=1)и(Найти("мия мяэ лия кия жая лея",z7)>0)),9,?((zd=4)и(z3="ч"),2,?(z4=1,?(Найти("оеиую",z9)+Найти("их ых аа еа ёа иа оа уа ыа эа юа яа",z8)>0,9,?(z3<>"ч",?(za=1,7,?(z9="а",?(za>18,1,6),9)),?(((Найти("ой ый",z8)>0)и(z5>4)и(Прав(z1,4)<>"опой"))или((zb>10)и(za=16)),8,zd))),zd)));
  ze=Найти("лец вей бей дец пец мец нец рец вец аец иец ыец бер",z7);
  zf=?((zd=8)и(zc<>5),?((zb>15)или(Найти("жий ний",z7)>0),"е","о"),?(z1="лев","ьв",?((Найти("аеёийоуэюя",Сред(z1,z5-3 ,1))=0)и((zb>11)или(zb=0))и(ze<>45),"",?(za=7,"л",?(za=10,"к",?(za=13,"йц",?(ze=0,"",?(ze<12,"ь"+?(ze=1,"ц",""),?(ze<37,"ц",?(ze<49,"йц","р"))))))))));
//  zf=?((zd=9)или((z4=3)и(z3="ы")),z1,Лев(z1,z5-?((zd>6)или(zf<>""),2,?(zd>0,1,0)))+zf+СокрП(Сред("а у а "+Сред("оыые",Найти("внч",z9)+1,1)+"ме "+?(Найти("гжкхш",Лев(z8,1))>0,"и","ы")+" е у ойе я ю я ем"+?(za=16,"и","е")+" и е ю ейе и и ь ьюи и и ю ейи ойойу ойойойойуюойойгомуго"+?((zf="е")или(za=16)или((zb>12)и(zb<16)),"и","ы")+"мм",10*zd+2*zc-3,2)));
  zf=?((zd=9)или((z4=3)и(Прав(z1,1)="ы")),z1,Лев(z1,z5-?((zd>6)или(zf<>""),2,?(zd>0,1,0)))+zf+СокрП(Сред("а у а "+Сред("оыые",Найти("внч",z9)+1,1)+"ме "+?(Найти("гжкхш",Лев(z8,1))>0,"и","ы")+" е у ойе я ю я ем"+?(za=16,"и","е")+" и е ю ейе и и ь ьюи и и ю ейи ойойу ойойойойуюойойгомуго"+?((zf="е")или(za=16)или((zb>12)и(zb<16)),"и","ы")+"мм",10*zd+2*zc-3,2)));
Возврат ?(""=z1,"",?(z4>0,ВРег(Лев(zf,1))+?((z2<0)и(z4>1),".",Сред(zf,2)),zf)+z6);
КонецФункции

//
//
Функция ПадежП(Знач z1,Знач z2,z3=0) Экспорт
		
  z1=СокрЛП(z1);z4=Найти(z1+" "," ")+1;z5=Лев(z1,z4-2);z6=Прав(z5,2);
  z7=?((Найти("ая ий ый",z6)>0)и(Найти("ющий нный",Сред(z1,z4-5,4))=0)и(z3=0),"1","*");
Возврат НРег(?((z6="ая")или(Прав(z6,1)="а"),ПадежС(z5,z2,z7,1)+" "+ПадежС(Сред(z1,z4),z2),ПадежС(z5,z2,"ч",1)+?((z6="ий")и(Найти(z1," ")=0),""," "+?(z7="1",ПадежП(Сред(z1,z4),z2,Число(z7)),Сред(z1,z4)))));
КонецФункции

//
//
Функция ВрегПоПервым(Переменная)
	
	Попытка
		Тмп = Лев(Переменная, 1);
	    Остаток = Сред(Переменная, 2, СтрДлина(Переменная) - 1);
		
		СтрДляВозврата =  Врег(Тмп) + Остаток;
		
		Возврат СтрДляВозврата;
	Исключение
		Возврат Переменная;
	КонецПопытки;
	
	
КонецФункции

//
//
Процедура ПолучитьНомерДатуСчетаДоговораПоКлючуСтрокиМаршрута(ДокументЗаказ, КлючСтрокиМаршрута, НомерДатаСчета, НомерДатаДоговора, КоличествоДоговоров)
	
	СтруктураОтбора = Новый Структура("КлючСтрокиМаршрута", КлючСтрокиМаршрута);
	СтрокиПоКлючу = ДокументЗаказ.Заказы.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого Элемент Из СтрокиПоКлючу Цикл
		
		СтрокаДобавленияСчета = "";
		СтрокаДобавленияДоговора = "";
		
		Заказ = Элемент.Заказ;
		Если ТипЗнч(Заказ) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			СтрокаДобавленияСчета = "" + Заказ.Номер + " / " + Формат(Заказ.Дата, "ДФ=dd.MM.yy");
			Если ЗначениеЗаполнено(Заказ.Соглашение) И Не Заказ.Соглашение.Типовое Тогда
				СтрокаДобавленияДоговора = "" + Заказ.Соглашение.Номер + " / " + Формат(Заказ.Соглашение.Дата, "ДФ=dd.MM.yy");
			КонецЕсли;
		ИначеЕсли ТипЗнч(Заказ) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			
			СтрокаДобавленияСчета = "" + Заказ.Номер + " / " + Формат(Заказ.Дата, "ДФ=dd.MM.yy");
			Если ЗначениеЗаполнено(Заказ.Соглашение) Тогда
				СтрокаДобавленияДоговора = "" + Заказ.Соглашение.Номер + " / " + Формат(Заказ.Соглашение.Дата, "ДФ=dd.MM.yy");
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаДобавленияСчета) И Найти(НомерДатаСчета, СтрокаДобавленияСчета) = 0 Тогда
			НомерДатаСчета = НомерДатаСчета + СтрокаДобавленияСчета + ", ";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаДобавленияДоговора) И Найти(НомерДатаДоговора, СтрокаДобавленияДоговора) = 0 Тогда
			НомерДатаДоговора = НомерДатаДоговора + СтрокаДобавленияДоговора + ", ";
			КоличествоДоговоров = КоличествоДоговоров + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(НомерДатаСчета) И Прав(НомерДатаСчета, 2) = ", " Тогда
		НомерДатаСчета = Лев(НомерДатаСчета, СтрДлина(НомерДатаСчета) - 2);
	КонецЕсли;
	Если ЗначениеЗаполнено(НомерДатаДоговора)И Прав(НомерДатаДоговора, 2) = ", " Тогда
		НомерДатаДоговора = Лев(НомерДатаДоговора, СтрДлина(НомерДатаДоговора) - 2);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////

//
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт

	//
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	//
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата КАК Период,
	|	ДанныеШапки.Партнер КАК Партнер,
	|	ДанныеШапки.Организация КАК Организация,
	|	ДанныеШапки.Ссылка КАК ЗаказНаДоставку
	|ИЗ
	|	Документ.АК_ЗаказНаДоставку КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	
	//
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
    //
	Запрос.УстановитьПараметр("Период",          Реквизиты.Период);
	Запрос.УстановитьПараметр("ЗаказНаДоставку", Реквизиты.ЗаказНаДоставку);
	Запрос.УстановитьПараметр("Период",          Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация",     Реквизиты.Организация);
	
	//
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	

	//+++АК
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&Период КАК Период,
	               |	&Ссылка КАК Регистратор,
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	               |	Таблица.ЗаказКлиента КАК ЗаказКлиента,
	               |	Таблица.Номенклатура КАК Номенклатура,
	               |	Таблица.Характеристика КАК Характеристика,
	               |	Таблица.ЗаказКлиентаКодСтроки КАК КодСтроки,
	               |	АК_ЗаказыКлиентовРазмещениеОстаткиИОбороты.ЗаказПоставщику КАК ЗаказПоставщику,
	               |	0 КАК НеЗаказаноУПоставщика,
	               |	ВЫБОР
	               |		КОГДА Таблица.Количество > ЕСТЬNULL(АК_ЗаказыКлиентовРазмещениеОстаткиИОбороты.НеЗаказанаДоставкаОстаток, 0)
	               |			ТОГДА ЕСТЬNULL(АК_ЗаказыКлиентовРазмещениеОстаткиИОбороты.НеЗаказанаДоставкаОстаток, 0)
	               |		ИНАЧЕ Таблица.Количество
	               |	КОНЕЦ КАК НеЗаказанаДоставка
	               |ПОМЕСТИТЬ ТЗ
	               |ИЗ
	               |	Документ.АК_ЗаказНаДоставку.Товары КАК Таблица
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.АК_ЗаказыКлиентовРазмещение.Остатки(&Период, ) КАК АК_ЗаказыКлиентовРазмещениеОстаткиИОбороты
	               |		ПО Таблица.ЗаказКлиента = АК_ЗаказыКлиентовРазмещениеОстаткиИОбороты.ЗаказКлиента
	               |			И Таблица.Номенклатура = АК_ЗаказыКлиентовРазмещениеОстаткиИОбороты.Номенклатура
	               |			И Таблица.ЗаказКлиентаКодСтроки = АК_ЗаказыКлиентовРазмещениеОстаткиИОбороты.КодСтроки
	               |			И (АК_ЗаказыКлиентовРазмещениеОстаткиИОбороты.НеЗаказанаДоставкаОстаток > 0)
	               |ГДЕ
	               |	Таблица.Ссылка = &Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТЗ.Период,
	               |	ТЗ.Регистратор,
	               |	ТЗ.ВидДвижения КАК ВидДвижения,
	               |	ТЗ.ЗаказКлиента,
	               |	ТЗ.Номенклатура,
	               |	ТЗ.Характеристика,
	               |	ТЗ.КодСтроки,
	               |	ТЗ.ЗаказПоставщику,
	               |	СУММА(ТЗ.НеЗаказаноУПоставщика) КАК НеЗаказаноУПоставщика,
	               |	СУММА(ТЗ.НеЗаказанаДоставка) КАК НеЗаказанаДоставка
	               |ИЗ
	               |	ТЗ КАК ТЗ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТЗ.Период,
	               |	ТЗ.Регистратор,
	               |	ТЗ.ЗаказКлиента,
	               |	ТЗ.Номенклатура,
	               |	ТЗ.Характеристика,
	               |	ТЗ.КодСтроки,
	               |	ТЗ.ЗаказПоставщику,
	               |	ТЗ.ВидДвижения
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВидДвижения УБЫВ,
	               |	ТЗ.КодСтроки";
				   
	//
	Результат = Запрос.Выполнить();
	
	//
	ТаблицыДляДвижений.Вставить("ТаблицаЗаказыКлиентовРазмещение", Результат.Выгрузить());
	
	//---АК
	
КонецПроцедуры


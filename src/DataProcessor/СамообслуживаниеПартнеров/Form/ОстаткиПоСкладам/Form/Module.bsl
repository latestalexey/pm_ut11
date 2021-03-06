﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Соглашение") Тогда
		Соглашение = Параметры.Соглашение;
	КонецЕсли;
	
	Если Параметры.Свойство("ДанныеКорзины") Тогда
		КорзинаПокупателя.Загрузить(Параметры.ДанныеКорзины.Выгрузить(,"Номенклатура,Характеристика,Упаковка,КоличествоУпаковок"));
	КонецЕсли;
	
	Сформировать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура Сформировать()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КорзинаПокупателя.Номенклатура,
	|	КорзинаПокупателя.Характеристика,
	|	КорзинаПокупателя.Упаковка,
	|	КорзинаПокупателя.КоличествоУпаковок
	|ПОМЕСТИТЬ КорзинаПокупателя
	|ИЗ
	|	&КорзинаПокупателя КАК КорзинаПокупателя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Склады.Ссылка,
	|	Склады.Наименование,
	|	Склады.ВариантКонтроля,
	|	Склады.ГраницаГрафикаДоступности,
	|	Склады.СрокПоставки
	|ПОМЕСТИТЬ Склады
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ Склады.Ссылка = &Склад
	|		КОНЕЦ
	|	И (НЕ Склады.ЭтоГруппа)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Склады.Ссылка КАК Склад,
	|	КорзинаПокупателя.Номенклатура,
	|	КорзинаПокупателя.Характеристика
	|ПОМЕСТИТЬ ВсеТоварыИСклады
	|ИЗ
	|	Склады КАК Склады,
	|	КорзинаПокупателя КАК КорзинаПокупателя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеТоварыИСклады.Номенклатура,
	|	ВсеТоварыИСклады.Характеристика,
	|	ВсеТоварыИСклады.Склад КАК Склад,
	|	ЕСТЬNULL(ДоступностьТоваровДляВнешнихПользователейСрезПервых.Доступно, 0) КАК Доступно,
	|	ЕСТЬNULL(ДоступностьТоваровДляВнешнихПользователейСрезПервых.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК Период,
	|	ВЫБОР
	|		КОГДА ПараметрыОбеспеченияТоварами.МетодУправления ЕСТЬ NULL 
	|			ТОГДА ВЫБОР
	|					КОГДА ЕСТЬNULL(XYZКлассификацияНоменклатурыСрезПоследних.Класс, ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.НеКлассифицирован)) = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.НеКлассифицирован)
	|							ИЛИ ЕСТЬNULL(XYZКлассификацияНоменклатурыСрезПоследних.Класс, ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.НеКлассифицирован)) = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ZКласс)
	|							ИЛИ ЕСТЬNULL(ABCКлассификацияНоменклатурыСрезПоследних.Класс, ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.НЕКлассифицирован)) = ЗНАЧЕНИЕ(Перечисление.ABCКлассификация.НЕКлассифицирован)
	|						ТОГДА ЗНАЧЕНИЕ(Перечисление.МетодыУправленияЗапасами.ЗаказПодЗаказ)
	|					ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.МетодыУправленияЗапасами.ПустаяСсылка)
	|				КОНЕЦ
	|		ИНАЧЕ ПараметрыОбеспеченияТоварами.МетодУправления
	|	КОНЕЦ КАК МУЗ
	|ПОМЕСТИТЬ ДанныеПоДоступностиИМУЗ
	|ИЗ
	|	ВсеТоварыИСклады КАК ВсеТоварыИСклады
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДоступностьТоваровДляВнешнихПользователей.СрезПервых(
	|				&ТекущаяДата,
	|				Склад В
	|						(ВЫБРАТЬ
	|							Склады.Ссылка
	|						ИЗ
	|							Склады КАК Склады)
	|					И Номенклатура В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							КорзинаПокупателя.Номенклатура
	|						ИЗ
	|							КорзинаПокупателя КАК КорзинаПокупателя)
	|					И Характеристика В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							КорзинаПокупателя.Характеристика
	|						ИЗ
	|							КорзинаПокупателя КАК КорзинаПокупателя)) КАК ДоступностьТоваровДляВнешнихПользователейСрезПервых
	|		ПО ВсеТоварыИСклады.Номенклатура = ДоступностьТоваровДляВнешнихПользователейСрезПервых.Номенклатура
	|			И ВсеТоварыИСклады.Характеристика = ДоступностьТоваровДляВнешнихПользователейСрезПервых.Характеристика
	|			И ВсеТоварыИСклады.Склад = ДоступностьТоваровДляВнешнихПользователейСрезПервых.Склад
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыОбеспеченияТоварами КАК ПараметрыОбеспеченияТоварами
	|		ПО ВсеТоварыИСклады.Номенклатура = ПараметрыОбеспеченияТоварами.Номенклатура
	|			И ВсеТоварыИСклады.Характеристика = ПараметрыОбеспеченияТоварами.Характеристика
	|			И ВсеТоварыИСклады.Склад = ПараметрыОбеспеченияТоварами.Склад
	|			И ПараметрыОбеспеченияТоварами.МетодУправления <> ЗНАЧЕНИЕ(Перечисление.МетодыУправленияЗапасами.ПустаяСсылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияНоменклатуры.СрезПоследних(
	|				&ТекущаяДата,
	|				РазделКлассификации В
	|						(ВЫБРАТЬ
	|							Склады.Ссылка
	|						ИЗ
	|							Склады КАК Склады)
	|					И Номенклатура В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							КорзинаПокупателя.Номенклатура
	|						ИЗ
	|							КорзинаПокупателя КАК КорзинаПокупателя)
	|					И Характеристика В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							КорзинаПокупателя.Характеристика
	|						ИЗ
	|							КорзинаПокупателя КАК КорзинаПокупателя)
	|					И ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.Выручка)
	|					И ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.ABC)) КАК ABCКлассификацияНоменклатурыСрезПоследних
	|		ПО ВсеТоварыИСклады.Номенклатура = ABCКлассификацияНоменклатурыСрезПоследних.Номенклатура
	|			И ВсеТоварыИСклады.Характеристика = ABCКлассификацияНоменклатурыСрезПоследних.Характеристика
	|			И ВсеТоварыИСклады.Склад = ABCКлассификацияНоменклатурыСрезПоследних.РазделКлассификации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияНоменклатуры.СрезПоследних(
	|				&ТекущаяДата,
	|				РазделКлассификации В
	|						(ВЫБРАТЬ
	|							Склады.Ссылка
	|						ИЗ
	|							Склады КАК Склады)
	|					И Номенклатура В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							КорзинаПокупателя.Номенклатура
	|						ИЗ
	|							КорзинаПокупателя КАК КорзинаПокупателя)
	|					И Характеристика В
	|						(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|							КорзинаПокупателя.Характеристика
	|						ИЗ
	|							КорзинаПокупателя КАК КорзинаПокупателя)
	|					И ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.Количество)
	|					И ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.XYZ)) КАК XYZКлассификацияНоменклатурыСрезПоследних
	|		ПО ВсеТоварыИСклады.Номенклатура = XYZКлассификацияНоменклатурыСрезПоследних.Номенклатура
	|			И ВсеТоварыИСклады.Характеристика = XYZКлассификацияНоменклатурыСрезПоследних.Характеристика
	|			И ВсеТоварыИСклады.Склад = XYZКлассификацияНоменклатурыСрезПоследних.РазделКлассификации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеПоДоступностиИМУЗ.Склад КАК Склад,
	|	ДанныеПоДоступностиИМУЗ.Номенклатура КАК Номенклатура,
	|	ДанныеПоДоступностиИМУЗ.Характеристика КАК Характеристика,
	|	ДанныеПоДоступностиИМУЗ.Период КАК Период,
	|	ДанныеПоДоступностиИМУЗ.Доступно КАК Доступно,
	|	ВЫБОР
	|		КОГДА ВидыНоменклатуры.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|			ТОГДА &СтрокаУслугаДоступна
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ДанныеПоДоступностиИМУЗ.МУЗ = ЗНАЧЕНИЕ(Перечисление.МетодыУправленияЗапасами.ЗаказПодЗаказ)
	|					ТОГДА &СтрокаДоступноПодЗаказ
	|				ИНАЧЕ ВЫБОР
	|						КОГДА Склады.ВариантКонтроля = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.НеКонтролировать)
	|								ИЛИ Склады.ВариантКонтроля = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.Остатки)
	|							ТОГДА &СтрокаВНаличии
	|						КОГДА Склады.ВариантКонтроля = ЗНАЧЕНИЕ(Перечисление.ВариантыКонтроля.ОстаткиСУчетомРезерва)
	|							ТОГДА ВЫБОР
	|									КОГДА ДанныеПоДоступностиИМУЗ.Доступно > 0
	|										ТОГДА &СтрокаВНаличии
	|									ИНАЧЕ &СтрокаНетНаСкладе
	|								КОНЕЦ
	|						ИНАЧЕ &СтрокаСогласноГрафика
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК Доступность,
	|	Склады.ГраницаГрафикаДоступности,
	|	Склады.СрокПоставки,
	|	КорзинаПокупателя.Упаковка КАК Упаковка,
	|	КорзинаПокупателя.КоличествоУпаковок КАК КоличествоУпаковок,
	|	СправочникНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА УпаковкиНоменклатуры.Ссылка ЕСТЬ NULL 
	|			ТОГДА КорзинаПокупателя.КоличествоУпаковок
	|		ИНАЧЕ КорзинаПокупателя.КоличествоУпаковок * УпаковкиНоменклатуры.Коэффициент
	|	КОНЕЦ КАК Количество,
	|	Склады.ВариантКонтроля
	|ИЗ
	|	ДанныеПоДоступностиИМУЗ КАК ДанныеПоДоступностиИМУЗ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Склады КАК Склады
	|		ПО ДанныеПоДоступностиИМУЗ.Склад = Склады.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КорзинаПокупателя КАК КорзинаПокупателя
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиНоменклатуры КАК УпаковкиНоменклатуры
	|			ПО КорзинаПокупателя.Упаковка = УпаковкиНоменклатуры.Ссылка
	|		ПО ДанныеПоДоступностиИМУЗ.Номенклатура = КорзинаПокупателя.Номенклатура
	|			И ДанныеПоДоступностиИМУЗ.Характеристика = КорзинаПокупателя.Характеристика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры КАК ВидыНоменклатуры
	|			ПО СправочникНоменклатура.ВидНоменклатуры = ВидыНоменклатуры.Ссылка
	|		ПО ДанныеПоДоступностиИМУЗ.Номенклатура = СправочникНоменклатура.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеПоДоступностиИМУЗ.Склад.Наименование
	|ИТОГИ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Упаковка,
	|	ЕдиницаИзмерения,
	|	КоличествоУпаковок,
	|	Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Склады.Ссылка,
	|	Склады.Наименование
	|ИЗ
	|	Склады КАК Склады
	|
	|УПОРЯДОЧИТЬ ПО
	|	Склады.Наименование";
	
	Запрос.УстановитьПараметр("КорзинаПокупателя",КорзинаПокупателя.Выгрузить());
	Запрос.УстановитьПараметр("ТекущаяДата",НачалоДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("Склад", Соглашение.Склад);
	Запрос.УстановитьПараметр("СтрокаВНаличии",НСтр("ru = 'В наличии'"));
	Запрос.УстановитьПараметр("СтрокаВыберитеСклад",НСтр("ru = 'Выберите склад'"));
	Запрос.УстановитьПараметр("СтрокаДоступноПодЗаказ",НСтр("ru = 'Доступно под заказ'"));
	Запрос.УстановитьПараметр("СтрокаНетНаСкладе",НСтр("ru = 'Нет в наличии'"));
	Запрос.УстановитьПараметр("СтрокаСогласноГрафика",НСтр("ru = 'Согласно графика'"));
	Запрос.УстановитьПараметр("СтрокаУслугаДоступна",НСтр("ru = 'Услуга доступна'"));
	
	МассивРезультатовЗапросов = Запрос.ВыполнитьПакет();
	
	Если МассивРезультатовЗапросов[5].Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не МассивРезультатовЗапросов[4].Пустой() Тогда
		Вывести(МассивРезультатовЗапросов[4], МассивРезультатовЗапросов[5]);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Вывести(РезультатЗапроса,РезультатЗапросаСклады)
	
	ТабличныйДокумент.Очистить();
	
	ИспользованиеХарактеристикНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	Макет = Обработки.СамообслуживаниеПартнеров.ПолучитьМакет("ОстаткиПоСкладам");
	
	ОбластьШапкаНоменклатура              = Макет.ПолучитьОбласть("Шапка|Номенклатура");
	ОбластьШапкаХарактеристика            = Макет.ПолучитьОбласть("Шапка|Характеристика");
	ОбластьШапкаУпаковкаКоличество        = Макет.ПолучитьОбласть("Шапка|УпаковкаКоличество");
	ОбластьШапкаСклад                     = Макет.ПолучитьОбласть("Шапка|Склад");
	
	ОбластьСтрокаНоменклатура             = Макет.ПолучитьОбласть("Строка|Номенклатура");
	ОбластьСтрокаХарактеристика           = Макет.ПолучитьОбласть("Строка|Характеристика");
	ОбластьСтрокаУпаковкаКоличество       = Макет.ПолучитьОбласть("Строка|УпаковкаКоличество");
	ОбластьСтрокаСклад                    = Макет.ПолучитьОбласть("Строка|Склад");
	ОбластьСтрокаОтрицательноеСклад       = Макет.ПолучитьОбласть("СтрокаОтрицательноеЧисло|Склад");
	
	// Шапка отчета
	ТабличныйДокумент.Вывести(ОбластьШапкаНоменклатура);
	Если ИспользованиеХарактеристикНоменклатуры Тогда
		ТабличныйДокумент.Присоединить(ОбластьШапкаХарактеристика);
	КонецЕсли;
	
	ТабличныйДокумент.Присоединить(ОбластьШапкаУпаковкаКоличество);
	ВыборкаСклады = РезультатЗапросаСклады.Выбрать();
	Пока ВыборкаСклады.Следующий() Цикл
		
		ОбластьШапкаСклад.Параметры.Склад = ВыборкаСклады.Наименование;
		ТабличныйДокумент.Присоединить(ОбластьШапкаСклад);
		
	КонецЦикла;
	
	НомерСтроки = 0;
	
	ВыборкаНоменклатура = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаНоменклатура.Следующий() Цикл
		ВыборкаХарактеристика = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаХарактеристика.Следующий() Цикл
			ВыборкаУпаковка = ВыборкаХарактеристика.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаУпаковка.Следующий() Цикл
				ВыборкаЕдИзм = ВыборкаУпаковка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаЕдИзм.Следующий() Цикл
					
					ВыборкаКоличество = ВыборкаЕдИзм.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					Пока ВыборкаКоличество.Следующий() Цикл
						НомерСтроки = НомерСтроки + 1;
						ОбластьСтрокаНоменклатура.Параметры.НомерСтроки  = НомерСтроки;
						ОбластьСтрокаНоменклатура.Параметры.Номенклатура = ВыборкаНоменклатура.Номенклатура;
						ТабличныйДокумент.Вывести(ОбластьСтрокаНоменклатура);
						Если ИспользованиеХарактеристикНоменклатуры Тогда
							ОбластьСтрокаХарактеристика.Параметры.Характеристика = ВыборкаХарактеристика.Характеристика;
							ТабличныйДокумент.Присоединить(ОбластьСтрокаХарактеристика);
						КонецЕсли;
						ОбластьСтрокаУпаковкаКоличество.Параметры.Упаковка = ?(ВыборкаКоличество.Упаковка = Справочники.УпаковкиНоменклатуры.ПустаяСсылка(),ВыборкаКоличество.ЕдиницаИзмерения,Строка(ВыборкаКоличество.Упаковка)+ ","+ Строка(ВыборкаКоличество.ЕдиницаИзмерения));
						ОбластьСтрокаУпаковкаКоличество.Параметры.Количество = ВыборкаКоличество.КоличествоУпаковок;
						ТабличныйДокумент.Присоединить(ОбластьСтрокаУпаковкаКоличество);
						ВыборкаСклад = ВыборкаКоличество.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						Пока ВыборкаСклад.Следующий() Цикл
							ВыборкаДетали = ВыборкаСклад.Выбрать();
							Пока ВыборкаДетали.Следующий() Цикл
								ЗначениеДоступность = "";
								Если ВыборкаДетали.ВариантКонтроля = Перечисления.ВариантыКонтроля.ОстаткиСУчетомГрафика Тогда
									Если ВыборкаДетали.Доступность = НСтр("ru = 'Согласно графика'") Тогда
										Если ВыборкаДетали.Доступно > 0 Тогда
											ЗначениеДоступность = ?(НачалоДня(ТекущаяДата()) = ВыборкаДетали.Период,НСтр("ru = 'В наличии'"),НСтр("ru = 'Ожидается '") + Формат(ВыборкаДетали.Период,"ДФ=dd.MM.yy"));
										Иначе
											Если ВыборкаДетали.ГраницаГрафикаДоступности > ТекущаяДата() Тогда
												ЗначениеДоступность = НСтр("ru = 'Ожидается '") + Формат(ВыборкаДетали.ГраницаГрафикаДоступности,"ДФ=dd.MM.yy");
											Иначе
												ЗначениеДоступность = НСтр("ru = 'Ожидается '") + Формат(ТекущаяДата() + ВыборкаДетали.СрокПоставки * 86400,"ДФ=dd.MM.yy");
											КонецЕсли;
											
										КонецЕсли;
									Иначе
										ЗначениеДоступность = ВыборкаДетали.Доступность;
									КонецЕсли;
								ИначеЕсли ВыборкаДетали.ВариантКонтроля = Перечисления.ВариантыКонтроля.ОстаткиСУчетомРезерва Тогда
									Если ВыборкаДетали.Доступность = НСтр("ru = 'Доступно под заказ'") ИЛИ ВыборкаДетали.Доступно <= 0 Тогда
										ЗначениеДоступность = ВыборкаДетали.Доступность;
									Иначе
										Если ВыборкаДетали.Количество/ВыборкаДетали.Доступно < 0.5 Тогда
											ЗначениеДоступность = НСтр("ru = 'В наличии'");
										Иначе 
											ЗначениеДоступность = НСтр("ru = 'Требует уточнения'");
										КонецЕсли;
									КонецЕсли;
								Иначе	
									ЗначениеДоступность = ВыборкаДетали.Доступность;
								КонецЕсли; 
								Если ЗначениеДоступность = НСтр("ru = 'Нет в наличии'") Тогда
									ОбластьСтрокаОтрицательноеСклад.Параметры.Доступность = ЗначениеДоступность;
									ТабличныйДокумент.Присоединить(ОбластьСтрокаОтрицательноеСклад);
								Иначе
									ОбластьСтрокаСклад.Параметры.Доступность = ЗначениеДоступность;
									ТабличныйДокумент.Присоединить(ОбластьСтрокаСклад);
								КонецЕсли;
							КонецЦикла;
						КонецЦикла;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Если ИспользованиеХарактеристикНоменклатуры Тогда
		ТабличныйДокумент.ФиксацияСлева = 3;
	Иначе
		ТабличныйДокумент.ФиксацияСлева = 2;
	КонецЕсли;
	
КонецПроцедуры



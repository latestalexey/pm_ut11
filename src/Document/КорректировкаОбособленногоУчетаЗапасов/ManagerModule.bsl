﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Проведение

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Склад КАК Склад
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	ИнициализироватьКлючиАналитикиНоменклатуры(Реквизиты);
	СоответствиеВидовЗапасов = ИнициализироватьВидыЗапасов(Реквизиты);
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Склад", Реквизиты.Склад);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.КорректировкаОбособленногоУчета);
	Запрос.УстановитьПараметр("СоответствиеВидовЗапасов", СоответствиеВидовЗапасов);
	
	Запрос.Текст = ТекстЗапросаТаблицаТоварыОрганизаций()
		+ ТекстЗапросаТаблицаДатыПоступленияТоваровОрганизаций()
		+ ТекстЗапросаВтАналитика()
		+ ТекстЗапросаТаблицаСебестоимостьТоваров()
		;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицыДляДвижений = СтруктураДополнительныеСвойства.ТаблицыДляДвижений;
	// МассивРезультатов[0] - ВтСоответствиеВидовЗапасов
	ТаблицыДляДвижений.Вставить("ТаблицаТоварыОрганизаций",                 МассивРезультатов[1].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаДатыПоступленияТоваровОрганизаций", МассивРезультатов[2].Выгрузить());
	// МассивРезультатов[3] - ВтАналитика
	ТаблицыДляДвижений.Вставить("ТаблицаСебестоимостьТоваров",              МассивРезультатов[4].Выгрузить());
	
КонецПроцедуры

Процедура ИнициализироватьКлючиАналитикиНоменклатуры(Реквизиты)

	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&Склад КАК Склад,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов.Товары КАК ТаблицаТовары
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаТовары.Номенклатура = Аналитика.Номенклатура
	|		И ТаблицаТовары.Характеристика = Аналитика.Характеристика
	|		И &Склад = Аналитика.Склад
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И Аналитика.КлючАналитики ЕСТЬ NULL
	|");
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("Склад", Реквизиты.Склад);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РегистрыСведений.АналитикаУчетаНоменклатуры.СоздатьКлючАналитики(Выборка)
	КонецЦикла;

КонецПроцедуры

Функция ИнициализироватьВидыЗапасов(Реквизиты)

	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&Организация КАК Организация,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасов.ТипЗапасов КАК ТипЗапасов,
	|	ТаблицаВидыЗапасов.ВидЗапасов.Комитент КАК Комитент,
	|	ТаблицаВидыЗапасов.ВидЗапасов.Соглашение КАК Соглашение,
	|	ТаблицаВидыЗапасов.ВидЗапасов.Валюта КАК Валюта,
	|	ТаблицаВидыЗапасов.ВидЗапасов.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ТаблицаВидыЗапасов.ВидЗапасов.Поставщик КАК Поставщик,
	|	ТаблицаВидыЗапасов.ВидЗапасов.ДеятельностьОблагаетсяЕНВД КАК ДеятельностьОблагаетсяЕНВД,
	|	ТаблицаВидыЗапасов.ВидЗапасов.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|
	|	ДанныеДокумента.НовоеПодразделение КАК Подразделение,
	|	ДанныеДокумента.НовыйМенеджер КАК Менеджер,
	|	ДанныеДокумента.НоваяСделка КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|
	|	ВЫБОР КОГДА ДанныеДокумента.НовоеПредназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера) ТОГДА
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|	КОГДА ДанныеДокумента.НовоеПредназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения) ТОГДА
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.НеВедется)
	|	КОНЕЦ КАК ВариантОбособленногоУчетаТоваров,
	|
	|	ЕСТЬNULL(ДанныеДокумента.НоваяСделка.ОбособленныйУчетТоваровПоСделке, ЛОЖЬ) КАК ОбособленныйУчетТоваровПоСделке,
	|
	|	ВЫБОР КОГДА ТаблицаВидыЗапасов.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар) ТОГДА
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаКомиссию)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)
	|	КОНЕЦ КАК ХозяйственнаяОперация
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов.ВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.КорректировкаОбособленногоУчетаЗапасов КАК ДанныеДокумента
	|	ПО
	|		&Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ТаблицаВидыЗапасов.Ссылка = &Ссылка
	|");
	Запрос.УстановитьПараметр("Ссылка", Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	
	СоответствиеВидовЗапасов = Новый ТаблицаЗначений;
	СоответствиеВидовЗапасов.Колонки.Добавить("ВидЗапасов", Новый ОписаниеТипов("СправочникСсылка.ВидыЗапасов")); 
	СоответствиеВидовЗапасов.Колонки.Добавить("НовыйВидЗапасов", Новый ОписаниеТипов("СправочникСсылка.ВидыЗапасов")); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НовыйВидЗапасов = Справочники.ВидыЗапасов.ВидЗапасовДокумента(
			Выборка.Организация,
			Выборка.ХозяйственнаяОперация,
			Выборка
		);
		НоваяСтрока = СоответствиеВидовЗапасов.Добавить();
		НоваяСтрока.ВидЗапасов = Выборка.ВидЗапасов;
		НоваяСтрока.НовыйВидЗапасов = НовыйВидЗапасов;
		
	КонецЦикла;
	
	Возврат СоответствиеВидовЗапасов;

КонецФункции

Функция ТекстЗапросаТаблицаТоварыОрганизаций()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СоответствиеВидовЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	СоответствиеВидовЗапасов.НовыйВидЗапасов КАК НовыйВидЗапасов
	|ПОМЕСТИТЬ ВтСоответствиеВидовЗапасов
	|ИЗ
	|	&СоответствиеВидовЗапасов КАК СоответствиеВидовЗапасов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Организация КАК Организация,
	|	&Организация КАК ОрганизацияОтгрузки,
	|	&Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Номенклатура КАК Номенклатура,
	|	ТаблицаВидыЗапасов.Характеристика КАК Характеристика,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	КлючиАналитики.КлючАналитики КАК АналитикаУчетаНоменклатуры,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация
	|
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов.ВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК КлючиАналитики
	|		ПО ТаблицаВидыЗапасов.Номенклатура = КлючиАналитики.Номенклатура
	|			И ТаблицаВидыЗапасов.Характеристика = КлючиАналитики.Характеристика
	|			И (&Склад = КлючиАналитики.Склад)
	|ГДЕ
	|	ТаблицаВидыЗапасов.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2,
	|	ТаблицаВидыЗапасов.НомерСтроки,
	|	&Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	&Организация,
	|	НЕОПРЕДЕЛЕНО,
	|	&Склад,
	|	ТаблицаВидыЗапасов.Номенклатура,
	|	ТаблицаВидыЗапасов.Характеристика,
	|	ВтСоответствиеВидовЗапасов.НовыйВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД,
	|	ТаблицаВидыЗапасов.Количество,
	|	NULL,
	|	&ХозяйственнаяОперация
	|
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов.ВидыЗапасов КАК ТаблицаВидыЗапасов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтСоответствиеВидовЗапасов КАК ВтСоответствиеВидовЗапасов
	|		ПО ТаблицаВидыЗапасов.ВидЗапасов = ВтСоответствиеВидовЗапасов.ВидЗапасов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|		ПО ТаблицаВидыЗапасов.Номенклатура = АналитикаУчетаНоменклатуры.Номенклатура
	|			И ТаблицаВидыЗапасов.Характеристика = АналитикаУчетаНоменклатуры.Характеристика
	|			И (&Склад = АналитикаУчетаНоменклатуры.Склад)
	|ГДЕ
	|	ТаблицаВидыЗапасов.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	Порядок
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДатыПоступленияТоваровОрганизаций()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПоступленияТоваров.ДатаПоступления КАК ДатаПоступления,
	|	ТаблицаВидыЗапасов.Номенклатура КАК Номенклатура,
	|	ТаблицаВидыЗапасов.Характеристика КАК Характеристика,
	|	ВтСоответствиеВидовЗапасов.НовыйВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов.ВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСоответствиеВидовЗапасов КАК ВтСоответствиеВидовЗапасов
	|	ПО
	|		ТаблицаВидыЗапасов.ВидЗапасов = ВтСоответствиеВидовЗапасов.ВидЗапасов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ДатыПоступленияТоваровОрганизаций КАК ПоступленияТоваров
	|	ПО
	|		ТаблицаВидыЗапасов.ВидЗапасов = ПоступленияТоваров.ВидЗапасов
	|		И ТаблицаВидыЗапасов.Номенклатура = ПоступленияТоваров.Номенклатура
	|		И ТаблицаВидыЗапасов.Характеристика = ПоступленияТоваров.Характеристика
	|		И ТаблицаВидыЗапасов.НомерГТД = ПоступленияТоваров.НомерГТД
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ДатыПоступленияТоваровОрганизаций КАК ПоступленияТоваровПолучатель
	|	ПО
	|		ВтСоответствиеВидовЗапасов.НовыйВидЗапасов = ПоступленияТоваровПолучатель.ВидЗапасов
	|		И ТаблицаВидыЗапасов.Номенклатура = ПоступленияТоваровПолучатель.Номенклатура
	|		И ТаблицаВидыЗапасов.Характеристика = ПоступленияТоваровПолучатель.Характеристика
	|		И ТаблицаВидыЗапасов.НомерГТД = ПоступленияТоваровПолучатель.НомерГТД
	|
	|ГДЕ
	|	ТаблицаВидыЗапасов.Ссылка = &Ссылка
	|	И ТаблицаВидыЗапасов.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И (ПоступленияТоваровПолучатель.ДатаПоступления ЕСТЬ NULL
	|		ИЛИ ПоступленияТоваровПолучатель.ДатаПоступления < &Период)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаВидыЗапасов.Номенклатура,
	|	ТаблицаВидыЗапасов.Характеристика,
	|	ТаблицаВидыЗапасов.НомерГТД
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВтАналитика()
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АналитикаНоменклатуры.КлючАналитики КАК АналитикаНоменклатуры,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика
	|
	|ПОМЕСТИТЬ ВтАналитика
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов.Товары КАК ТаблицаТовары
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаНоменклатуры
	|	ПО
	|		ТаблицаТовары.Номенклатура = АналитикаНоменклатуры.Номенклатура
	|		И ТаблицаТовары.Характеристика = АналитикаНоменклатуры.Характеристика
	|		И &Склад = АналитикаНоменклатуры.Склад
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаСебестоимостьТоваров()

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	ВтАналитика.АналитикаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах) КАК РазделУчета,
	|   ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	0 КАК Стоимость,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах) КАК КорРазделУчета,
	|	ВтСоответствиеВидовЗапасов.НовыйВидЗапасов КАК КорВидЗапасов,
	|	ВтАналитика.АналитикаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	Неопределено КАК АналитикаУчетаПоПартнерам,
	|	Неопределено КАК Подразделение
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов.ВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтАналитика КАК ВтАналитика
	|	ПО
	|		ТаблицаВидыЗапасов.Номенклатура = ВтАналитика.Номенклатура
	|		И ТаблицаВидыЗапасов.Характеристика = ВтАналитика.Характеристика
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСоответствиеВидовЗапасов КАК ВтСоответствиеВидовЗапасов
	|	ПО
	|		ТаблицаВидыЗапасов.ВидЗапасов = ВтСоответствиеВидовЗапасов.ВидЗапасов
	|ГДЕ
	|	ТаблицаВидыЗапасов.Ссылка = &Ссылка
	|	И ТаблицаВидыЗапасов.ВидЗапасов.ТипЗапасов <> ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2 КАК Порядок,
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	ВтАналитика.АналитикаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах) КАК РазделУчета,
	|	ВтСоответствиеВидовЗапасов.НовыйВидЗапасов КАК ВидЗапасов,
	|
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	0 КАК Стоимость,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах) КАК КорРазделУчета,
	|   ТаблицаВидыЗапасов.ВидЗапасов КАК КорВидЗапасов,
	|	ВтАналитика.АналитикаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	Неопределено КАК АналитикаУчетаПоПартнерам,
	|	Неопределено КАК Подразделение
	|
	|ИЗ
	|	Документ.КорректировкаОбособленногоУчетаЗапасов.ВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ВтАналитика КАК ВтАналитика
	|	ПО
	|		ТаблицаВидыЗапасов.Номенклатура = ВтАналитика.Номенклатура
	|		И ТаблицаВидыЗапасов.Характеристика = ВтАналитика.Характеристика
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВтСоответствиеВидовЗапасов КАК ВтСоответствиеВидовЗапасов
	|	ПО
	|		ТаблицаВидыЗапасов.ВидЗапасов = ВтСоответствиеВидовЗапасов.ВидЗапасов
	|ГДЕ
	|	ТаблицаВидыЗапасов.Ссылка = &Ссылка
	|	И ТаблицаВидыЗапасов.ВидЗапасов.ТипЗапасов <> ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|	
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	Порядок
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";

	Возврат ТекстЗапроса;
	
КонецФункции

#КонецЕсли
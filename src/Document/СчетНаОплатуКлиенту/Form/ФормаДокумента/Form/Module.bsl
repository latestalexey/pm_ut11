﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ДенежныеСредстваСервер.УстановитьВидимостьОплатыПлатежнойКартой(ЭтаФорма, Элементы.ФормаОплаты);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		Если Параметры.Свойство("Основание") Тогда
			Основание = Параметры.Основание;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументОснование", "Видимость", ЗначениеЗаполнено(Объект.ДокументОснование));
	
	// Подсистема "ЭлектронныеДокументы"
	УстановитьТекстСостоянияЭДНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ФинансыКлиент.ПроверитьЗаполнениеДокументаНаОсновании(
			Объект,
			Основание
		);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		СуммаЭтаповОплаты = Объект.ЭтапыГрафикаОплаты.Итог("СуммаПлатежа");
		
		Если Объект.СуммаДокумента = 0 Тогда
			
			Объект.СуммаДокумента = СуммаЭтаповОплаты;
			
		ИначеЕсли Объект.СуммаДокумента <> СуммаЭтаповОплаты Тогда
			
			ТекстВопроса = НСтр("ru='Сумма этапов графика оплаты не совпадает с суммой документа. Скорректировать сумму этапов оплаты?'");
			ОтветНаВопрос = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
			Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
				ЦенообразованиеКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияУТ.ПолучитьКартинкуКомментария(Объект.Комментарий);
	
	// Подсистема "ЭлектронныеДокументы"
	УстановитьТекстСостоянияЭДНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "ЭлектронныеДокументы"
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		УстановитьТекстСостоянияЭДНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьНазначениеПлатежа(Команда)
	ЗаполнитьНазначениеПлатежа();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ФормаОплатыПриИзменении(Элемент)

	ПриИзмененииФормыОплатыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичнаяОплатаПриИзменении(Элемент)
	
	Если Не Объект.ЧастичнаяОплата И ЗначениеЗаполнено(ОБъект.ДокументОснование) Тогда
		Если Объект.ЭтапыГрафикаОплаты.Количество() > 0 Тогда
			ОтветНаВопрос = Вопрос(НСтр("ru='Таблица этапов оплаты будет заполнена по основанию. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
			Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
				Объект.ЧастичнаяОплата = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьЭтапыОплатыПоОснованиюСервер();
	Иначе
		УстановитьДоступностьЭлементовПоЧастичнойОплате();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	
	ЦенообразованиеКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЭДНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектронныеДокументыКлиент.ОткрытьАктуальныйЭД(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ ЭТАПЫ ГРАФИКА ОПЛАТЫ

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПослеУдаления(Элемент)
	
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элемент)
	
	ЦенообразованиеКлиент.ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные, Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элемент)

	ЦенообразованиеКлиент.ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные, Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ЭлектронныеДокументы"

&НаСервере
Процедура УстановитьТекстСостоянияЭДНаСервере()
	
	ТекстСостоянияЭД = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСостоянияЭД(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УправлениеЭлементамиФормы();
	УстановитьДоступностьЭлементовПоЧастичнойОплате();
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияУТ.ПолучитьКартинкуКомментария(Объект.Комментарий);
	Элементы.ЧастичнаяОплата.Видимость = ТипЗнч(Объект.ДокументОснование) <> Тип("СправочникСсылка.ДоговорыКонтрагентов");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(Форма)
	
	ПроцентПлатежейОбщий = 0;
	ПредыдущееЗначениеДаты = Дата(1, 1, 1);
	Форма.НомерСтрокиПолнойОплаты = 0;
	Для Каждого ТекСтрока Из Форма.Объект.ЭтапыГрафикаОплаты Цикл
		ПроцентПлатежейОбщий = ПроцентПлатежейОбщий + ТекСтрока.ПроцентПлатежа;
		ТекСтрока.ПроцентЗаполненНеВерно = (ПроцентПлатежейОбщий > 100);
		ТекСтрока.ДатаЗаполненаНеВерно = (ПредыдущееЗначениеДаты > ТекСтрока.ДатаПлатежа);
		ПредыдущееЗначениеДаты = ТекСтрока.ДатаПлатежа;
		Если ПроцентПлатежейОбщий = 100 Тогда
			Форма.НомерСтрокиПолнойОплаты = ТекСтрока.НомерСтроки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Касса", "Видимость", Объект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная);
	
	УстановитьПривилегированныйРежим(Истина);
	Соглашение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "Соглашение");
		
		ИспользуютсяДоговорыКонтрагентов = 
		ЗначениеЗаполнено(Соглашение)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Соглашение, "ИспользуютсяДоговорыКонтрагентов");
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Договор", "Видимость", ИспользуютсяДоговорыКонтрагентов);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииФормыОплатыСервер()
	
	УправлениеЭлементамиФормы();
	Объект.БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Объект.Организация, , Объект.БанковскийСчет);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовПоЧастичнойОплате()
	
	МассивЭлементов = Новый Массив();
	
	МассивЭлементов.Добавить("ЭтапыГрафикаОплаты");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Не Объект.ЧастичнаяОплата);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СуммаДокумента", "ТолькоПросмотр", Не Объект.ЧастичнаяОплата);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭтапыОплатыПоОснованиюСервер()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ЭтапыОплаты.ДатаПлатежа    КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаПлатежа   КАК СуммаПлатежа
			|ИЗ
			|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ЭтапыОплаты.ДатаПлатежа    КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаПлатежа   КАК СуммаПлатежа
			|ИЗ
			|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|";
		
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа    КАК ДатаПлатежа,
			|	100                            КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаДокумента КАК СуммаПлатежа
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа         КАК ДатаПлатежа,
			|	100                                 КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаВознаграждения КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомитенту КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионера") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа    КАК ДатаПлатежа,
			|	100                            КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаДокумента КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомиссионера КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионераОСписании") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа    КАК ДатаПлатежа,
			|	100                            КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаДокумента КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомиссионераОСписании КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	Иначе
		ТекстЗапроса = "";
	КонецЕсли;
	
		Если Не ПустаяСтрока(ТекстЗапроса) Тогда
			
			Если Объект.ЭтапыГрафикаОплаты.Количество() > 0 Тогда
				Объект.ЭтапыГрафикаОплаты.Очистить();
			КонецЕсли;
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				НовыйЭтап = Объект.ЭтапыГрафикаОплаты.Добавить();
				ЗаполнитьЗначенияСвойств(НовыйЭтап, Выборка);
			КонецЦикла;
			
			Объект.СуммаДокумента = Объект.ЭтапыГрафикаОплаты.Итог("СуммаПлатежа");
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
	
	УстановитьДоступностьЭлементовПоЧастичнойОплате();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНазначениеПлатежа()
	Объект.НазначениеПлатежа = "По счету № " +	ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Объект.Номер) +
	                    " от " + Формат(Объект.Дата, "ДФ=dd.MM.yyyy");
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

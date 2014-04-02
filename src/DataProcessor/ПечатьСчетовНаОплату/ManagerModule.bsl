﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетНаОплату") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СчетНаОплату", "Счет на оплату", СформироватьПечатнуюФормуСчетНаОплату(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуСчетНаОплату(СтруктураТипов, ОбъектыПечати, ПараметрыПечати, КомплектыПечати = Неопределено) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СЧЕТНАОПЛАТУ";
	
	НомерТипаДокумента = 0;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыСчетаНаОплату(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументСчетаНаОплату(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, КомплектыПечати);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции



Процедура ЗаполнитьРеквизитыШапкиСчетаНаОплату(ДанныеПечати, Макет, ТабличныйДокумент, ТаблицаЭтапыОплаты)
	
	СведенияОПоставщике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Организация, ДанныеПечати.Дата);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокСчета");
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
	
	Если ТаблицаЭтапыОплаты.Количество() = 0 Тогда
		ДатаПлатежа = '00010101';
	ИначеЕсли ТаблицаЭтапыОплаты.Количество() = 1 Тогда
		ДатаПлатежа = ТаблицаЭтапыОплаты[0].ДатаПлатежа;
	Иначе
		ДатаПлатежа = ТаблицаЭтапыОплаты[ТаблицаЭтапыОплаты.Количество()-1].ДатаПлатежа;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаПлатежа) Тогда
		
		НадписьСрокДействия = НСтр("ru='Счет действителен до %СрокДействия%. '");
		НадписьСрокДействия = СтрЗаменить(НадписьСрокДействия, "%СрокДействия%", Формат(ДатаПлатежа, "ДЛФ=D"));
		ОбластьМакета.Параметры.СрокДействия = НадписьСрокДействия;
		
	КонецЕсли;
	
	ОбластьМакета.Параметры.ИНН             = СведенияОПоставщике.ИНН;
	ОбластьМакета.Параметры.КПП             = СведенияОПоставщике.КПП;
	ПредставлениеПоставщикаДляПлатПоручения = "";
	
	Если ЗначениеЗаполнено(ДанныеПечати.БанковскийСчет) Тогда
		
		Если ЗначениеЗаполнено(ДанныеПечати.БанковскийСчет.БанкДляРасчетов) Тогда
			Если ДанныеПечати.БанковскийСчет.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
				Банк       = ДанныеПечати.БанковскийСчет.НаименованиеБанкаДляРасчетов;
				БИК        = ДанныеПечати.ДанныеПечати.БанковскийСчет.БИКБанкаДляРасчетов;
				КоррСчет   = ДанныеПечати.БанковскийСчет.КоррСчетБанкаДляРасчетов;
				ГородБанка = ДанныеПечати.БанковскийСчет.ГородБанкаДляРасчетов;
			Иначе
				Банк       = ДанныеПечати.БанковскийСчет.БанкДляРасчетов;
				БИК        = ДанныеПечати.БанковскийСчет.БанкДляРасчетов.Код;
				КоррСчет   = ДанныеПечати.БанковскийСчет.БанкДляРасчетов.КоррСчет;
				ГородБанка = ДанныеПечати.БанковскийСчет.БанкДляРасчетов.Город;
			КонецЕсли;
			Если ДанныеПечати.БанковскийСчет.РучноеИзменениеРеквизитовБанка Тогда
				НомерСчета = ДанныеПечати.БанковскийСчет.КоррСчетБанка;
			Иначе
				НомерСчета = ДанныеПечати.БанковскийСчет.Банк.КоррСчет;
			КонецЕсли;
		Иначе
			Если ДанныеПечати.БанковскийСчет.РучноеИзменениеРеквизитовБанка Тогда
				Банк       = ДанныеПечати.БанковскийСчет.НаименованиеБанка;
				БИК        = ДанныеПечати.БанковскийСчет.БИКБанка;
				КоррСчет   = ДанныеПечати.БанковскийСчет.КоррСчетБанка;
				ГородБанка = ДанныеПечати.БанковскийСчет.ГородБанка;
			Иначе
				Банк       = ДанныеПечати.БанковскийСчет.Банк;
				БИК        = ДанныеПечати.БанковскийСчет.Банк.Код;
				КоррСчет   = ДанныеПечати.БанковскийСчет.Банк.КоррСчет;
				ГородБанка = ДанныеПечати.БанковскийСчет.Банк.Город;
			КонецЕсли;
			НомерСчета = ДанныеПечати.БанковскийСчет.НомерСчета;
		КонецЕсли;
		
		ОбластьМакета.Параметры.БИКБанкаПолучателя               = БИК;
		ОбластьМакета.Параметры.БанкПолучателя                   = Банк;
		ОбластьМакета.Параметры.БанкПолучателяПредставление      = СокрЛП(Банк) + " " + ГородБанка;
		ОбластьМакета.Параметры.СчетБанкаПолучателя              = КоррСчет;
		ОбластьМакета.Параметры.СчетБанкаПолучателяПредставление = КоррСчет;
		ОбластьМакета.Параметры.СчетПолучателяПредставление      = НомерСчета;
		ОбластьМакета.Параметры.СчетПолучателя                   = НомерСчета;
		ПредставлениеПоставщикаДляПлатПоручения                  = ДанныеПечати.БанковскийСчетТекстКорреспондента;
		
	КонецЕсли;
	
	Если ПустаяСтрока(ПредставлениеПоставщикаДляПлатПоручения) Тогда
		ПредставлениеПоставщикаДляПлатПоручения = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПоставщике, "ПолноеНаименование,");
	КонецЕсли;
	
	ОбластьМакета.Параметры.НазначениеПлатежа  			            = ДанныеПечати.НазначениеПлатежа;
	ОбластьМакета.Параметры.ПредставлениеПоставщикаДляПлатПоручения = ПредставлениеПоставщикаДляПлатПоручения;
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	
	ТекстЗаголовка = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(ДанныеПечати, НСтр("ru='Счет на оплату'"));
	ОбластьМакета.Параметры.ТекстЗаголовка = ТекстЗаголовка;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.ОрганизацияПоставщик, ДанныеПечати.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ФормированиеПечатныхФорм.ОписаниеОрганизации(ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Контрагент, ДанныеПечати.Дата), "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес,Телефоны,");
	ТабличныйДокумент.Вывести(ОбластьМакета);
			
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПодвалаСчетаНаОплату(ДанныеПечати, Макет, ТабличныйДокумент, ТаблицаЭтапыОплаты, СоответствиеСтавокНДС)
	
	// Вывести этапы графика оплаты
	Если ТаблицаЭтапыОплаты.Количество() > 1 Тогда
		
		ИмяКолонкиДатыОплаты = ?(ДанныеПечати.СчетКВозврату, НСтр("ru='Дата оплаты или возврата'"), НСтр("ru='Дата оплаты'"));
		
		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицыЭтапыОплаты");
		ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ИтогоЭтапыОплаты");
		ОбластьШапкаТаблицы.Параметры.ИмяКолонкиДатыОплаты = ИмяКолонкиДатыОплаты;
		МассивПроверкиВывода = Новый Массив;
		МассивПроверкиВывода.Добавить(ОбластьШапкаТаблицы);
		МассивПроверкиВывода.Добавить(ОбластьПодвалТаблицы);
		
		ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицыЭтапыОплаты");
		
		Для Каждого ТекЭтап Из ТаблицаЭтапыОплаты Цикл
			
			ОбластьСтрокаТаблицы.Параметры.Заполнить(ТекЭтап);
			ОбластьСтрокаТаблицы.Параметры.ТекстНДС = ФормированиеПечатныхФорм.СформироватьТекстНДСЭтапаОплаты(СоответствиеСтавокНДС, ТекЭтап.ПроцентПлатежа);
			МассивПроверкиВывода.Добавить(ОбластьСтрокаТаблицы);
			
			Если ТабличныйДокумент.ПроверитьВывод(МассивПроверкиВывода) Тогда
				Если ТекЭтап.НомерСтроки = 1 Тогда
					ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
					МассивПроверкиВывода.Удалить(0);
				КонецЕслИ;
			Иначе
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
			МассивПроверкиВывода.Удалить(МассивПроверкиВывода.ВГраница());
			
		КонецЦикла;
		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицы);
		
	КонецЕсли;
	
	// Вывести дополнительную информацию
	Если ЗначениеЗаполнено(ДанныеПечати.ДополнительнаяИнформация) Тогда
		
		Область = Макет.ПолучитьОбласть("ДополнительнаяИнформация");
		Область.Параметры.ДополнительнаяИнформация = ДанныеПечати.ДополнительнаяИнформация;
		ТабличныйДокумент.Вывести(Область);
		
	КонецЕсли;
	
	// Вывести подписи
	Область = Макет.ПолучитьОбласть("ПодвалСчета");
	Область.Параметры.ФИОРуководителя = ДанныеПечати.Руководитель;
	Область.Параметры.ФИОБухгалтера = ДанныеПечати.ГлавныйБухгалтер;
	Область.Параметры.ФИОМенеджер = ФизическиеЛица.ФамилияИнициалыФизЛица(ДанныеПечати.Менеджер);
	
	ТабличныйДокумент.Вывести(Область);
	
КонецПроцедуры

Процедура ЗаполнитьТабличныйДокументСчетаНаОплату(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, КомплектыПечати)
	
	ШаблонОшибкиТовары = НСтр("ru = 'В документе %1 отсутствуют товары. Печать счета на оплату не требуется'");
	ШаблонОшибкиЭтапы = НСтр("ru = 'В документе %1 отсутствуют этапы оплаты. Печать счета на оплату не требуется'");
	
	
	ИспользоватьРучныеСкидки         = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
	ИспользоватьАвтоматическиеСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах");
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ЭтапыОплаты = ДанныеДляПечати.РезультатПоЭтапамОплаты.Выгрузить();
	Товары = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
	
	Если Товары.Колонки.Найти("Содержание")=Неопределено Тогда
		ЕстьСодержание = Ложь;
	Иначе
		ЕстьСодержание = Истина;
	КонецЕсли;
	
	ПервыйДокумент = Истина;
	КолонкаКодов   = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	ВыводитьКоды = ЗначениеЗаполнено(КолонкаКодов);
	
	Макет = УправлениеПечатью.ПолучитьМакет("Обработка.ПечатьСчетовНаОплату.ПФ_MXL_СчетНаОплату");
	
	Смещать = ТипСмещенияТабличногоДокумента.ПоВертикали;
	ОбластьПервойКолонкиТоваров = Макет.Область("ПерваяКолонкаТовара");
	Если КолонкаКодов <> "Артикул" Тогда
		ОбластьПервойКолонкиТоваров.ШиринаКолонки = ОбластьПервойКолонкиТоваров.ШиринаКолонки + Макет.Область("Артикул").ШиринаКолонки;
		Макет.УдалитьОбласть(Макет.Область("Артикул"), Смещать);
	КонецЕсли;
	Если КолонкаКодов<>"Код" Тогда
		ОбластьПервойКолонкиТоваров.ШиринаКолонки = ОбластьПервойКолонкиТоваров.ШиринаКолонки + Макет.Область("Код").ШиринаКолонки;
		Макет.УдалитьОбласть(Макет.Область("Код"), Смещать);
	КонецЕсли;
	
	// ИГОРЬ 02 04 2014
	Пока ДанныеПечати.Следующий() Цикл
		Для каждого ТекСтавкаНДС из Перечисления.СтавкиНДС цикл
			
			// Для печати комплектов
			Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено Тогда
				КомплектПечатиПоСсылке = КомплектыПечати.Найти(ДанныеПечати.Ссылка,"Ссылка");
				Если КомплектПечатиПоСсылке = Неопределено Тогда
					КомплектПечатиПоСсылке = КомплектыПечати[0];
				КонецЕсли;
				Если КомплектПечатиПоСсылке.Экземпляров = 0 Тогда
					Продолжить
				КонецЕсли;
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
			
			// ИГОРЬ 02 04 2014
			СтруктураПоискаПоТоварам = Новый Структура;
			СтруктураПоискаПоТоварам.Вставить("Ссылка",ДанныеПечати.Ссылка);
			СтруктураПоискаПоТоварам.Вставить("СтавкаНДС",ТекСтавкаНДС);
			ТаблицаТовары = Товары.НайтиСтроки(СтруктураПоискаПоТоварам);
			
			//ТаблицаТовары = Товары.НайтиСтроки(СтруктураПоиска);
			Если НЕ (ТипЗнч(ДанныеПечати.Ссылка) = Тип("ДокументСсылка.СчетНаОплатуКлиенту")
				И ТипЗнч(ДанныеПечати.ДокументОснование) = Тип("СправочникСсылка.ДоговорыКонтрагентов")) 
				И ТаблицаТовары.Количество() = 0 Тогда
				//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибкиТовары, ДанныеПечати.Ссылка), ДанныеПечати.Ссылка);
				Продолжить;
			КонецЕсли;
			ТаблицаЭтапыОплаты = ЭтапыОплаты.НайтиСтроки(СтруктураПоиска);
			Если ТаблицаЭтапыОплаты.Количество() = 0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибкиЭтапы, ДанныеПечати.Ссылка), ДанныеПечати.Ссылка);
				Продолжить;
			КонецЕсли;
			
			// ИГОРЬ 02 04 2014
			// Скорректируем суммы оплаты по коэффициенту
			ПолнаяТаблица = Товары.Скопировать(СтруктураПоиска);
			СОтборром = Товары.Скопировать(СтруктураПоискаПоТоварам);
			Коэффициент = СОтборром.Итог("Сумма") / ПолнаяТаблица.Итог("Сумма");
			Если СОтборром.Итог("Сумма") > 0 тогда
				Для каждого ЭтапОплаты из ТаблицаЭтапыОплаты цикл
					ЭтапОплаты.СуммаПлатежа = ПолнаяТаблица.Итог("Сумма") * ЭтапОплаты.ПроцентПлатежа/100 * Коэффициент;		
				КонецЦикла;
			КонецЕсли;
			
			
			
			Если ПервыйДокумент Тогда
				ПервыйДокумент = Ложь;
			Иначе
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			//Астек в счете скидки не выводим
			//ЗаголовокСкидки = ФормированиеПечатныхФорм.НужноВыводитьСкидки(ТаблицаТовары, ИспользоватьРучныеСкидки Или ИспользоватьАвтоматическиеСкидки);
			ЗаголовокСкидки = ФормированиеПечатныхФорм.НужноВыводитьСкидки(ТаблицаТовары, Ложь);
			ЕстьСкидки = ЗаголовокСкидки.ЕстьСкидки;
			
			СуффиксОбласти = ?(ДанныеПечати.УчитыватьНДС, "СНДС", "") + ?(ЕстьСкидки, "СоСкидкой", "");
			
			ЗаполнитьРеквизитыШапкиСчетаНаОплату(ДанныеПечати, Макет, ТабличныйДокумент, ТаблицаЭтапыОплаты);
			
			Если ДанныеПечати.ЧастичнаяОплата ИЛИ ТипЗнч(ДанныеПечати.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
				
				ТабличныйДокумент.Вывести(Макет.ПолучитьОбласть("ШапкаТаблицыЧастичнаяОплата"));
				
				ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицыЧастичнаяОплата");
				ОбластьСтрокаТаблицы.Параметры.Заполнить(ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
				
				ОбластьИтого = Макет.ПолучитьОбласть("ПодвалТаблицыЧастичнаяОплата");
				ОбластьИтого.Параметры.Заполнить(ДанныеПечати);
				ТабличныйДокумент.Присоединить(ОбластьИтого);
				
				// Вывести ИтогоНДС
				СоответствиеСтавокНДС = Новый Соответствие;
				Если ДанныеПечати.УчитыватьНДС Тогда
					ОбластьИтогоНДС = Макет.ПолучитьОбласть("ПодвалТаблицыНДС");
					Для Каждого СтрокаТовара Из ТаблицаТовары Цикл
						СуммаНДС = СоответствиеСтавокНДС[СтрокаТовара.СтавкаНДС];
						Если СуммаНДС = Неопределено Тогда
							СуммаНДС = СтрокаТовара.СуммаНДС;
						Иначе
							СуммаНДС = СуммаНДС + СтрокаТовара.СуммаНДС;
						КонецЕсли;
						СоответствиеСтавокНДС.Вставить(СтрокаТовара.СтавкаНДС, СуммаНДС);
					КонецЦикла;
					Для Каждого ТекСтавкаНДС Из СоответствиеСтавокНДС Цикл
						ОбластьИтогоНДС.Параметры.НДС = ФормированиеПечатныхФорм.ТекстНДСПоСтавке(ТекСтавкаНДС.Ключ, ДанныеПечати.ЦенаВключаетНДС);
						ОбластьИтогоНДС.Параметры.ВсегоНДС = ФормированиеПечатныхФорм.ФорматСумм(ТекСтавкаНДС.Значение /100 * ДанныеПечати.ПроцентОплаты);
						ТабличныйДокумент.Вывести(ОбластьИтогоНДС);
					КонецЦикла;
					ОбластьПодвалСНДС = Макет.ПолучитьОбласть("ПодвалТаблицыВсего");
					ОбластьПодвалСНДС.Параметры.ВсегоСНДС = ФормированиеПечатныхФорм.ФорматСумм(ДанныеПечати.СуммаДокумента);
					ТабличныйДокумент.Вывести(ОбластьПодвалСНДС);
				КонецЕсли;
				
				// Вывести Сумму прописью
				ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописьюЧастичныйСчет");
				СуммаПрописью = НСтр("ru='Всего на сумму %СуммаПрописью%'");
				СуммаПрописью = СтрЗаменить(СуммаПрописью, "%СуммаПрописью%", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеПечати.СуммаДокумента, ДанныеПечати.Валюта));
				ОбластьМакета.Параметры.СуммаПрописью = СуммаПрописью;
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
			Иначе
				
				// Таблица "Товары"
				ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы" + СуффиксОбласти);
				ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы" + СуффиксОбласти);
				ОбластьПодвалТаблицы =Макет.ПолучитьОбласть("ПодвалТаблицы" + СуффиксОбласти);
				ОбластьПодвалНДС = Макет.ПолучитьОбласть("ПодвалТаблицыНДС");
				
				Если ДанныеПечати.УчитыватьНДС Тогда
					ОбластьПодвалСНДС = Макет.ПолучитьОбласть("ПодвалТаблицыВсего" + СуффиксОбласти);
				КонецЕсли;
				
				Если ЕстьСкидки Тогда
					ОбластьШапкаТаблицы.Параметры.Скидка = ЗаголовокСкидки.Скидка;
					ОбластьШапкаТаблицы.Параметры.СуммаБезСкидки = ЗаголовокСкидки.СуммаСкидки;
				КонецЕсли; 
				
				ОбластьСуммаПрописью = Макет.ПолучитьОбласть(?(ДанныеПечати.СчетКВозврату, "СуммаПрописьюКВозврату", "СуммаПрописью"));
				
				МассивПроверкиВывода = Новый Массив;
				МассивПроверкиВывода.Добавить(ОбластьШапкаТаблицы);
				МассивПроверкиВывода.Добавить(ОбластьПодвалТаблицы);
				МассивПроверкиВывода.Добавить(ОбластьПодвалНДС);
				МассивПроверкиВывода.Добавить(ОбластьСуммаПрописью);
				
				Сумма = 0;
				СуммаНДС = 0;
				ВсегоСкидок = 0;
				ВсегоБезСкидок = 0;
				НомерСтроки = 0;
				СоответствиеСтавокНДС = Новый Соответствие;
				Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
					
					НомерСтроки = НомерСтроки + 1;
					
					Если ЕстьСодержание Тогда
						ОбластьСтрокаТаблицы.Параметры.Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
						СтрокаТовары.НаименованиеПолное,
						СтрокаТовары.Характеристика,
						,
						, // Серия
						СтрокаТовары.Содержание
						);
					Иначе
						ОбластьСтрокаТаблицы.Параметры.Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
						СтрокаТовары.НаименованиеПолное,
						СтрокаТовары.Характеристика
						);
					КонецЕсли;
					
					ОбластьСтрокаТаблицы.Параметры.Заполнить(СтрокаТовары);
					//+АСТЕК пересчитаем цены
					Если ОбластьСтрокаТаблицы.Параметры.Количество = 0 Тогда
						текЦена = ОбластьСтрокаТаблицы.Параметры.Сумма;
					Иначе
						текЦена = ОбластьСтрокаТаблицы.Параметры.Сумма/ОбластьСтрокаТаблицы.Параметры.Количество;
					КонецЕсли;				
					ОбластьСтрокаТаблицы.Параметры.Цена =  текЦена;
					//-АСТЕК
					ОбластьСтрокаТаблицы.Параметры.НомерСтроки = НомерСтроки;
					Если ЗаголовокСкидки.ЕстьСкидки Тогда
						ОбластьСтрокаТаблицы.Параметры.СуммаСкидки = ?(ЗаголовокСкидки.ТолькоНаценка,- СтрокаТовары.СуммаСкидки,СтрокаТовары.СуммаСкидки);
					КонецЕсли; 
					МассивПроверкиВывода.Добавить(ОбластьСтрокаТаблицы);
					
					Если ТабличныйДокумент.ПроверитьВывод(МассивПроверкиВывода) Тогда
						Если НомерСтроки = 1 Тогда
							ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
							МассивПроверкиВывода.Удалить(0);
						КонецЕслИ;
					Иначе
						ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
					КонецЕсли;
					
					ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
					МассивПроверкиВывода.Удалить(МассивПроверкиВывода.ВГраница());
					
					Сумма = Сумма + СтрокаТовары.Сумма;
					СуммаНДС = СуммаНДС + СтрокаТовары.СуммаНДС;
					
					Если ЕстьСкидки Тогда
						ВсегоСкидок = ВсегоСкидок + СтрокаТовары.СуммаСкидки;
						ВсегоБезСкидок = ВсегоБезСкидок + СтрокаТовары.СуммаБезСкидки;
					КонецЕсли;
					
					Если ДанныеПечати.УчитыватьНДС Тогда
						СуммаНДСПоСтавке = СоответствиеСтавокНДС[СтрокаТовары.СтавкаНДС];
						Если СуммаНДСПоСтавке = Неопределено Тогда
							СуммаНДСПоСтавке = 0;
						КонецЕсли;
						СоответствиеСтавокНДС.Вставить(СтрокаТовары.СтавкаНДС, СуммаНДСПоСтавке + СтрокаТовары.СуммаНДС);
					КонецЕсли;
					
				КонецЦикла;
				
				// Подвал таблицы "Товары"
				Если ЕстьСкидки Тогда
					
					ОбластьПодвалТаблицы.Параметры.ВсегоСкидок = ?(ЗаголовокСкидки.ТолькоНаценка,-ВсегоСкидок, ВсегоСкидок);
					ОбластьПодвалТаблицы.Параметры.ВсегоБезСкидок = ВсегоБезСкидок;
					
					Если ДанныеПечати.УчитыватьНДС Тогда
						ОбластьПодвалТаблицы.Параметры.ВсегоСуммаНДС = СуммаНДС;
					КонецЕсли;
					
				КонецЕсли;
				ОбластьПодвалТаблицы.Параметры.Всего = ФормированиеПечатныхФорм.ФорматСумм(Сумма);
				ТабличныйДокумент.Вывести(ОбластьПодвалТаблицы);
				
				// Область "ПодвалТаблицыНДС"
				Если ДанныеПечати.УчитыватьНДС Тогда
					
					Для Каждого ТекСтавкаНДС Из СоответствиеСтавокНДС Цикл
						
						ОбластьПодвалНДС.Параметры.НДС = ФормированиеПечатныхФорм.ТекстНДСПоСтавке(ТекСтавкаНДС.Ключ, ДанныеПечати.ЦенаВключаетНДС);
						ОбластьПодвалНДС.Параметры.ВсегоНДС = ФормированиеПечатныхФорм.ФорматСумм(ТекСтавкаНДС.Значение, ,"-");
						ТабличныйДокумент.Вывести(ОбластьПодвалНДС);
						
					КонецЦикла;
					
					ОбластьПодвалСНДС.Параметры.ВсегоСНДС = ФормированиеПечатныхФорм.ФорматСумм(Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СуммаНДС));
					ТабличныйДокумент.Вывести(ОбластьПодвалСНДС);
					
				Иначе
					ОбластьПодвалНДС.Параметры.НДС = НСтр("ru='Без налога (НДС)'");
					ОбластьПодвалНДС.Параметры.ВсегоНДС = "-";
					ТабличныйДокумент.Вывести(ОбластьПодвалНДС);
				КонецЕсли;
				
				// Вывести Сумму прописью
				СуммаКПрописи = Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СуммаНДС);
				ИтоговаяСтрока = НСтр("ru='Всего наименований %Количество%, на сумму %Сумма%'");
				ИтоговаяСтрока = СтрЗаменить(ИтоговаяСтрока, "%Количество%", НомерСтроки);
				ИтоговаяСтрока = СтрЗаменить(ИтоговаяСтрока, "%Сумма%",      ФормированиеПечатныхФорм.ФорматСумм(СуммаКПрописи, ДанныеПечати.Валюта));
				
				Если ДанныеПечати.СчетКВозврату Тогда
					
					СуммаКВозврату = ДанныеПечати.СуммаКВозврату;
					СуммаИтого = СуммаКПрописи-СуммаКВозврату;
					Если СуммаИтого < 0 Тогда
						СуммаИтого = 0;
					КонецЕсли;
					ОбластьСуммаПрописью.Параметры.СуммаВозврата = ФормированиеПечатныхФорм.ФорматСумм(СуммаКВозврату, ДанныеПечати.Валюта);
					ОбластьСуммаПрописью.Параметры.СуммаИтогоКОплате = ФормированиеПечатныхФорм.ФорматСумм(СуммаИтого, ДанныеПечати.Валюта, "0");
					ОбластьСуммаПрописью.Параметры.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаИтого, ДанныеПечати.Валюта);
				Иначе
					
					ОбластьСуммаПрописью.Параметры.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаКПрописи, ДанныеПечати.Валюта);
				КонецЕсли;
				
				ОбластьСуммаПрописью.Параметры.ИтоговаяСтрока = ИтоговаяСтрока;
				
				ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
			КонецЕсли;
			ЗаполнитьРеквизитыПодвалаСчетаНаОплату(ДанныеПечати, Макет, ТабличныйДокумент, ТаблицаЭтапыОплаты, СоответствиеСтавокНДС);
			
			// Выведем нужное количество экземпляров (при печати комплектов)
			Если КомплектыПечати <> Неопределено И КомплектыПечати.Колонки.Найти("Ссылка") <> Неопределено И КомплектПечатиПоСсылке.Экземпляров > 1 Тогда
				ОбластьКопирования = ТабличныйДокумент.ПолучитьОбласть(НомерСтрокиНачало,,ТабличныйДокумент.ВысотаТаблицы);
				Для Итератор = 2 По КомплектПечатиПоСсылке.Экземпляров Цикл
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ТабличныйДокумент.Вывести(ОбластьКопирования);
				КонецЦикла;
			КонецЕсли;
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
			
		КонецЦикла;
	КонецЦикла;	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
КонецПроцедуры
#КонецЕсли
﻿&НаСервере
Функция ПолучитьСтруктуруДанных(СсылкаНаОбъект)
	УстановитьПривилегированныйРежим(Истина);
	
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();	
	
	//// проверим что соглашение является индивидуальным, а статус у ком. предложения - "Действует"
	//Если ?(СсылкаНаОбъект.Метаданные() = Метаданные.Документы.ЗаказКлиента , СсылкаНаОбъект.ДокументОснование.Соглашение.Типовое = Истина ,СсылкаНаОбъект.Соглашение.Типовое = Истина)  Тогда
	//	ТекСообщение = Новый СообщениеПользователю;
	//	ТекСообщение.Текст = "Договор не может быть распечатан для коммерческого предложения с типовым соглашением!";
	//	ТекСообщение.Сообщить();
	//	Возврат Неопределено ;
	//КонецЕсли;
	//
	//Если ?(СсылкаНаОбъект.Метаданные() = Метаданные.Документы.ЗаказКлиента , СсылкаНаОбъект.ДокументОснование.Статус <> Перечисления.СтатусыКоммерческихПредложенийКлиентам.Действует = Истина ,СсылкаНаОбъект.Статус <> Перечисления.СтатусыКоммерческихПредложенийКлиентам.Действует) Тогда
	//	ТекСообщение =Новый СообщениеПользователю;
	//	ТекСообщение.Текст = "Договор может быть распечатан для коммерческого предложения только со статусом ""Действует""!";
	//	ТекСообщение.Сообщить();
	//	Возврат Неопределено;
	//КонецЕсли;
	
	//
	ТекстЗапроса = "ВЫБРАТЬ
	|	Документ.Соглашение,
	|	Документ.Соглашение.Дата КАК Дата,
	|	Документ.Соглашение.Номер КАК Номер,
	|	Документ.Соглашение.Партнер КАК Партнер,
	|	Документ.Организация КАК Организация,
	|	Документ.Соглашение.АК_ОрганизацияБанковскийСчет КАК ОрганизацияБанковскийСчет,
	|	ЕСТЬNULL(Документ.Организация.НаименованиеПолное, """") КАК ОрганизацияНаименованиеПолное,
	|	Документ.Контрагент КАК Контрагент,
	|	Документ.Соглашение.АК_КонтрагентБанковскийСчет КАК КонтрагентБанковскийСчет,
	|	ЕСТЬNULL(Документ.Контрагент.НаименованиеПолное, """") КАК КонтрагентНаименованиеПолное,
	|	Документ.Контрагент.АК_ТекущийРуководитель КАК КонтрагентРуководитель,
	|	ЕСТЬNULL(Документ.Контрагент.АК_ТекущийРуководитель.Наименование, """") КАК КонтрагентРуководительНаименование,
	|	Документ.Контрагент.АК_ТекущийРуководитель.АК_Должность КАК КонтрагентРуководительДолжность,
	|	Документ.Склад КАК Склад,
	|	Документ.АК_УсловияПоставки КАК АК_УсловияПоставки,
	|	Документ.АК_ПунктНазначения.Адрес КАК АдресДоставки
	|ИЗ
	|	Документ.КоммерческоеПредложениеКлиенту КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &Ссылка";
	
	//
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Документ.КоммерческоеПредложениеКлиенту", СсылкаНаОбъект.Метаданные().ПолноеИмя());
	
	//			   
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	
	//
	РезультатЗапроса = Запрос.Выполнить();
	
	//
	Выборка = РезультатЗапроса.Выбрать();
	СтруктураРезультата = Новый Структура("Соглашение,Дата,Номер,Организация,
	|ОрганизацияНаименованиеПолное,ОрганизацияБанковскийСчет,АК_УсловияПоставки,
	|Партнер,Контрагент,КонтрагентНаименованиеПолное,КонтрагентРуководитель,КонтрагентРуководительНаименование");
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРезультата,Выборка);
		//
		Соглашение = Выборка.Соглашение;
		Дата = Выборка.Дата;
		Номер = Выборка.Номер;
		//
		Организация = Выборка.Организация;
		ОрганизацияНаименованиеПолное = Выборка.ОрганизацияНаименованиеПолное;
		ОтветсвенныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Организация,?(ЗначениеЗаполнено(Дата),Дата,ТекущаяДата()));
		ОрганизацияРуководитель = ОтветсвенныеЛица.Руководитель;
		ОрганизацияРуководительНаименование = ОтветсвенныеЛица.Руководитель.Наименование;
		ОрганизацияРуководительДолжность = "" +  ОтветсвенныеЛица.РуководительДолжность + " " + Организация.НаименованиеСокращенное;
		ОрганизацияРуководительСклонениеФИО = Падеж(ОрганизацияРуководительНаименование, 2, );
		ОрганизацияРуководительСокращенно = СократитьФИО(ОрганизацияРуководительНаименование);
		СтруктураРезультата.Вставить("ОрганизацияРуководительНаименование",ОрганизацияРуководительНаименование);
		СтруктураРезультата.Вставить("ОрганизацияРуководительДолжность",ОрганизацияРуководительДолжность);
		СтруктураРезультата.Вставить("ОрганизацияРуководитель",ОрганизацияРуководительСклонениеФИО);
		СтруктураРезультата.Вставить("ОрганизацияРуководительСокращенно",ОрганизацияРуководительСокращенно);
		
		//
		ОрганизацияБанковскийСчет = Выборка.ОрганизацияБанковскийСчет;
		Если НЕ ЗначениеЗаполнено(ОрганизацияБанковскийСчет) Тогда
			ОрганизацияБанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация);
			СтруктураРезультата.Вставить("ОрганизацияБанковскийСчет",ОрганизацияБанковскийСчет);
		КонецЕсли;	
		
		//
		СведенияОрганизация = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Организация, Дата, , ОрганизацияБанковскийСчет);
		СведенияОрганизацияСтрокаСРеквизитами =  ОписаниеОрганизации(СведенияОрганизация, "ПолноеНаименование,ЮридическийАдрес,ИНН,КПП,НомерСчета,КоррСчет,Банк,БИК,Телефоны");
		СтруктураРезультата.Вставить("СведенияОрганизация",СведенияОрганизация);
		СтруктураРезультата.Вставить("СведенияОрганизацияСтрокаСРеквизитами",СведенияОрганизацияСтрокаСРеквизитами);
		СтруктураРезультата.Вставить("ОрганизацияРеквизиты1",ОписаниеОрганизации(СведенияОрганизация, "ПолноеНаименование"));
		СтруктураРезультата.Вставить("ОрганизацияРеквизиты2",ОписаниеОрганизации(СведенияОрганизация, "ЮридическийАдрес"));
		ОстаткиРеквизитов = ОписаниеОрганизации(СведенияОрганизация, "ИНН")+Символы.ПС+
		ОписаниеОрганизации(СведенияОрганизация, "КПП")+Символы.ПС+
		ОписаниеОрганизации(СведенияОрганизация, "НомерСчета,КоррСчет,Банк,БИК")+Символы.ПС+
		ОписаниеОрганизации(СведенияОрганизация, "Телефоны");
		СтруктураРезультата.Вставить("ОрганизацияРеквизиты3",ОстаткиРеквизитов);
		//
		АК_УсловияПоставки = Выборка.АК_УсловияПоставки;
		ПризнакСамовывоз = Ложь;			
		Если ЗначениеЗаполнено(АК_УсловияПоставки) Тогда
			ПризнакСамовывоз= АК_УсловияПоставки.ПризнакСамовывоз;
			СрокПоставки 	= АК_УсловияПоставки.КоличествоДней; 
		Иначе
			Если ЗначениеЗаполнено(Соглашение.АК_УсловияПоставки) Тогда
				ПризнакСамовывоз= Соглашение.АК_УсловияПоставки.ПризнакСамовывоз;
				СрокПоставки 	= Соглашение.АК_УсловияПоставки.КоличествоДней;  
			КонецЕсли;	
		КонецЕсли;
		СтруктураРезультата.Вставить("ПризнакСамовывоз",ПризнакСамовывоз);
		СтруктураРезультата.Вставить("СрокПоставки",СрокПоставки);
		
		ТекстДляДоговора = ?(НЕ ПризнакСамовывоз, "отгрузки транспортом по выбору Поставщика по адресу Заказчика", "самовывоза Товара в местонахождение Товара по адресу: ");
		ТекстДляДоговора = ТекстДляДоговора + ?(ЗначениеЗаполнено(Соглашение.АК_УсловияПоставки.ТекстДляДоговора) , Соглашение.АК_УсловияПоставки.ТекстДляДоговора , "");
		ТекстДляДоговора = ТекстДляДоговора + ?(ЗначениеЗаполнено(АК_УсловияПоставки.ТекстДляДоговора) , АК_УсловияПоставки.ТекстДляДоговора , "");
		
		
		
		Если ПризнакСамовывоз Тогда
			//Адрес = УправлениеКонтактнойИнформацией.ПолучитьКонтактнуюИнформацияОбъекта(Выборка.Склад , Справочники.ВидыКонтактнойИнформации.АдресСклада);			
			Адрес = "Московская обл., Можайское шоссе, Одинцовский р-н, р.п. Большие Вяземы, ул. Городок-17";
		Иначе
			Адрес = Выборка.АдресДоставки;
		КонецЕсли;
		СтруктураРезультата.Вставить("Адрес",Адрес);
		ТекстДляДоговора = ТекстДляДоговора + ?(ЗначениеЗаполнено(Адрес) , " " + Адрес + "." , ".");
		СтруктураРезультата.Вставить("ТекстДоставки",ТекстДляДоговора);
		
		//
		Партнер = Выборка.Партнер;
		
		//
		Контрагент = Выборка.Контрагент;
		КонтрагентНаименованиеПолное = Выборка.КонтрагентНаименованиеПолное;
		КонтрагентРуководитель = Выборка.КонтрагентРуководитель;
		КонтрагентРуководительНаименование = Выборка.КонтрагентРуководительНаименование;
		КонтрагентРуководительДолжность = "" + Выборка.КонтрагентРуководительДолжность + " " + Контрагент.НаименованиеПолное;
		СтруктураРезультата.Вставить("КонтрагентРуководительДолжность",КонтрагентРуководительДолжность);
		СтруктураРезультата.Вставить("КонтрагентДолжностьСклонение",ПадежФИО(КонтрагентРуководительДолжность,2));
		//
		//КонтрагентРуководительСклонениеФИО = Падеж(КонтрагентРуководительНаименование, 2, );
		КонтрагентРуководительСклонениеФИО = ПадежФИО(КонтрагентРуководительНаименование, 2);
		КонтрагентРуководительСокращенно = СократитьФИО(КонтрагентРуководительНаименование);
		СтруктураРезультата.Вставить("КонтрагентРуководительСклонениеФИО",КонтрагентРуководительСклонениеФИО);
		СтруктураРезультата.Вставить("КонтрагентРуководительСокращенно",КонтрагентРуководительСокращенно);
		
		//
		КонтрагентБанковскийСчет = Выборка.КонтрагентБанковскийСчет;
		Если НЕ ЗначениеЗаполнено(КонтрагентБанковскийСчет) Тогда
			КонтрагентБанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
		КонецЕсли;
		СтруктураРезультата.Вставить("КонтрагентБанковскийСчет",КонтрагентБанковскийСчет);
		
		//
		СведенияКонтрагент = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Контрагент, Дата, , КонтрагентБанковскийСчет);
		СведенияКонтрагент.Вставить("Email" , УправлениеКонтактнойИнформацией.ПолучитьКонтактнуюИнформацияОбъекта(Контрагент.Партнер , Справочники.ВидыКонтактнойИнформации.EmailПартнера));
		СведенияКонтрагентСтрокаСРеквизитами =  ОписаниеОрганизации(СведенияКонтрагент, "ПолноеНаименование,ЮридическийАдрес,ИНН,КПП,НомерСчета,КоррСчет,Банк,БИК,Телефоны,Email");
		СтруктураРезультата.Вставить("СведенияКонтрагентСтрокаСРеквизитами",СведенияКонтрагентСтрокаСРеквизитами);
		
		СтруктураРезультата.Вставить("КонтрагентРеквизиты1",ОписаниеОрганизации(СведенияКонтрагент, "ПолноеНаименование"));
		СтруктураРезультата.Вставить("КонтрагентРеквизиты2",ОписаниеОрганизации(СведенияКонтрагент, "ЮридическийАдрес"));
		ОстаткиРеквизитов = ОписаниеОрганизации(СведенияКонтрагент, "ИНН")+Символы.ПС+
		ОписаниеОрганизации(СведенияКонтрагент, "КПП")+Символы.ПС+
		ОписаниеОрганизации(СведенияКонтрагент, "НомерСчета,КоррСчет,Банк,БИК")+Символы.ПС+
		ОписаниеОрганизации(СведенияКонтрагент, "Телефоны");
		СтруктураРезультата.Вставить("КонтрагентРеквизиты3",ОстаткиРеквизитов);
		//
		СуммаДоговора = 0;
		
		//
		ТекстЗапроса = "ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ЗаказКлиента.СуммаДокумента), 0) КАК СуммаДокумента
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка = &Заказ";
		
		//
		Запрос = Новый Запрос;						   
		Запрос.Текст = ТекстЗапроса;
		
		//
		Запрос.УстановитьПараметр("Заказ", СсылкаНаОбъект);
		
		//
		Результат = Запрос.Выполнить();
		
		//
		ВыборкаСумма = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Если ВыборкаСумма.Следующий() Тогда
			СуммаДоговора = ВыборкаСумма.СуммаДокумента;
		КонецЕсли;
		
		СтруктураРезультата.Вставить("СуммаДоговора",СуммаДоговора);
		
		//+++ laza
		СуммаНДСДоговора = 0;
		
		//
		ТекстЗапроса = "ВЫБРАТЬ
		|ЕСТЬNULL(СУММА(ЗаказКлиента.СуммаНДС), 0) КАК СуммаНДС
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка = &ЗаказКлиента";
		
		//
		Запрос = Новый Запрос;						   
		Запрос.Текст = ТекстЗапроса;
		
		//
		Запрос.УстановитьПараметр("ЗаказКлиента", СсылкаНаОбъект);
		
		//
		Результат = Запрос.Выполнить();
		
		//
		ВыборкаСумма = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Если ВыборкаСумма.Следующий() Тогда
			СуммаНДСДоговора = ВыборкаСумма.СуммаНДС;
		КонецЕсли;
		СтруктураРезультата.Вставить("СуммаНДСДоговора",СуммаНДСДоговора);
		
		//+++ laza
		
		//
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	КонтрагентыКонтактнаяИнформация.АдресЭП
		|ИЗ
		|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
		|ГДЕ
		|	КонтрагентыКонтактнаяИнформация.Ссылка = &Ссылка
		|	И КонтрагентыКонтактнаяИнформация.АдресЭП <> """"");
		
		Запрос.УстановитьПараметр("Ссылка", Контрагент);
		РезультатыЗапроса = Запрос.Выполнить();
		
		ВыборкаАдрес = РезультатыЗапроса.Выбрать();
		Если ВыборкаАдрес.Следующий() Тогда
			СтрокаСРеквизитами = ?(СтрокаСРеквизитами=Неопределено,"",СтрокаСРеквизитами + Символы.ПС) + "e-mail: " + Строка(ВыборкаАдрес.АдресЭП);
		КонецЕсли;
		СтруктураРезультата.Вставить("СуммаНДСДоговора",СуммаНДСДоговора);
		//оплата
		ГрафикОплаты = СсылкаНаОбъект.ГрафикОплаты;			
		
		//
		ПроцентПредоплаты = 50;
		ПроцентПредоплатыКоличествоДней = 5;
		
		//
		ПроцентДоплаты = 50;
		ПроцентДоплатыКоличествоДней = 5;
			
		//
		Если ЗначениеЗаполнено(ГрафикОплаты) Тогда
			
			Для Каждого СтрокаТЧ Из ГрафикОплаты.Этапы Цикл
				
				Если СтрокаТЧ.ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки") Тогда
					
					Если ПроцентПредоплаты = 100 Тогда
						ПроцентПредоплаты = СтрокаТЧ.ПроцентПлатежа; 
						ПроцентПредоплатыКоличествоДней = СтрокаТЧ.Сдвиг;
					Иначе	
						ПроцентДоплаты = СтрокаТЧ.ПроцентПлатежа; 
						ПроцентДоплатыКоличествоДней = СтрокаТЧ.Сдвиг;
					КонецЕсли;	
					
				ИначеЕсли СтрокаТЧ.ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.КредитПослеОтгрузки") Тогда	
					
					ПроцентДоплаты = СтрокаТЧ.ПроцентПлатежа; 
					ПроцентДоплатыКоличествоДней = СтрокаТЧ.Сдвиг;
					
				ИначеЕсли СтрокаТЧ.ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.АвансДоОбеспечения") Тогда	
					
					ПроцентПредоплаты = СтрокаТЧ.ПроцентПлатежа; 	
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		//
		ПроцентПредоплатыКоличествоДней = ?(ПроцентПредоплатыКоличествоДней=0,5,ПроцентПредоплатыКоличествоДней);
		
		//
		НДСПредоплатыТекст = "НДС не облагается";
		НДСДоплатыТекст = "НДС не облагается";
		
		Если СуммаНДСДоговора <> 0 Тогда	
			Если ПроцентПредоплаты = 100 Тогда
				НДСПредоплатыТекст = "в т.ч. НДС: " + Формат(СуммаНДСДоговора, "ЧЦ=15; ЧДЦ=2") + " (" + РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаНДСДоговора, Соглашение.Валюта) + ")";  
			Иначе
				СуммаНДСПредоплата = Формат(Окр(СуммаНДСДоговора * ПроцентПредоплаты/100,2), "ЧЦ=15; ЧДЦ=2"); 
				СуммаПредоплатыПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаНДСДоговора  * ПроцентПредоплаты/100, 2), Соглашение.Валюта);
				НДСПредоплатыТекст = "в т.ч. НДС: " + Строка(СуммаНДСПредоплата) + " (" + СуммаПредоплатыПрописью + ")";  
				
				СуммаНДСДоплата = Формат(СуммаНДСДоговора - Окр(СуммаНДСДоговора * ПроцентПредоплаты/100, 2), "ЧЦ=15; ЧДЦ=2");
				СуммаДоплатыПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаНДСДоговора - Окр(СуммаНДСДоговора * ПроцентПредоплаты/100, 2), Соглашение.Валюта);
				НДСДоплатыТекст = "в т.ч. НДС: " + Строка(СуммаНДСДоплата) + " (" + СуммаДоплатыПрописью + ")";  
			КонецЕсли;
		КонецЕсли;
	
		СтруктураРезультата.Вставить("ПроцентПредоплаты",ПроцентПредоплаты);		
		СтруктураРезультата.Вставить("СуммаПредоплатыЦифры","");		
		СтруктураРезультата.Вставить("НДСПредоплатыТекст",НДСПредоплатыТекст);		
		СтруктураРезультата.Вставить("ПроцентПредоплатыКоличествоДней",ПроцентПредоплатыКоличествоДней);		
		СтруктураРезультата.Вставить("ПроцентДоплаты",ПроцентДоплаты);		
		СтруктураРезультата.Вставить("СуммаДоплатыЦифры","");		
		СтруктураРезультата.Вставить("НДСДоплатыТекст",НДСДоплатыТекст);		
		СтруктураРезультата.Вставить("ПроцентДоплатыКоличествоДней",ПроцентДоплатыКоличествоДней);		
		СтруктураРезультата.Вставить("СтрокаМоментОплаты","");
		СтруктураРезультата.Вставить("СуммаПредоплаты","");
		СтруктураРезультата.Вставить("СуммаДоплаты","");
		
		//
		Если ПроцентПредоплаты = 100 Тогда
			//
			СтруктураРезультата.ПроцентПредоплаты = ПроцентПредоплаты;
			СтруктураРезультата.СуммаПредоплатыЦифры = Формат(СуммаДоговора, "ЧЦ=15; ЧДЦ=2");
			СтруктураРезультата.СуммаПредоплаты = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаДоговора, Соглашение.Валюта);
			СтруктураРезультата.ПроцентПредоплатыКоличествоДней = ЧислоПрописьюСокращенно(ПроцентПредоплатыКоличествоДней);
			СтруктураРезультата.НДСПредоплатыТекст = НДСПредоплатыТекст;
		Иначе	
			//
			СтруктураРезультата.ПроцентПредоплаты = ПроцентПредоплаты;
			СтруктураРезультата.СуммаПредоплатыЦифры = Формат(Окр(СуммаДоговора * ПроцентПредоплаты/100,2), "ЧЦ=15; ЧДЦ=2");
			СтруктураРезультата.СуммаПредоплаты = РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаДоговора * ПроцентПредоплаты/100, 2), Соглашение.Валюта);
			СтруктураРезультата.ПроцентПредоплатыКоличествоДней = ЧислоПрописьюСокращенно(ПроцентПредоплатыКоличествоДней);
			СтруктураРезультата.НДСПредоплатыТекст = НДСПредоплатыТекст;
			//
			СтруктураРезультата.ПроцентДоплаты = ПроцентДоплаты;
			СтруктураРезультата.СуммаДоплатыЦифры = Формат(СуммаДоговора - Окр(СуммаДоговора * ПроцентПредоплаты/100, 2), "ЧЦ=15; ЧДЦ=2");
			СтруктураРезультата.СуммаДоплаты = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаДоговора - Окр(СуммаДоговора * ПроцентПредоплаты/100, 2), Соглашение.Валюта);
			СтруктураРезультата.ПроцентДоплатыКоличествоДней = ЧислоПрописьюСокращенно(ПроцентДоплатыКоличествоДней);
			СтруктураРезультата.НДСДоплатыТекст = НДСДоплатыТекст;
		КонецЕсли;	
		
		
		//модификация
		Если НЕ ЗначениеЗаполнено(СтруктураРезультата.КонтрагентНаименованиеПолное) Тогда
			СтруктураРезультата.КонтрагентПолноеНаименование = "_______________________";
		КонецЕсли;	
		Если НЕ ЗначениеЗаполнено(КонтрагентРуководительСклонениеФИО) Тогда
			СтруктураРезультата.КонтрагентРуководитель = "_______________________";
		КонецЕсли;	
		СтруктураРезультата.Дата = Формат(СтруктураРезультата.Дата,"ДФ=dd.MM.yyyy");
		СтруктураРезультата.Вставить("ОрганизацияКратко",Организация.Наименование);
	КонецЕсли;
	
	//
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);	
	КонецЕсли;
	
	//
	Возврат СтруктураРезультата;
	
	
КонецФункции

&НаСервере
Функция ПолучитьСсылкуНаФайлДоговора()
	Возврат Справочники.Файлы.НайтиПоНаименованию("договор_мебель");
КонецФункции

&НаСервере
Функция ВернутьОбщийМакет()
	АдресФайлаЕксельВХранилище = ПоместитьВоВременноеХранилище( ПолучитьОбщийМакет("АК_Договор"));
    Возврат АдресФайлаЕксельВХранилище;
КонецФункции

&НаСервере
Функция ПолучитьПрисоединенныйФайл(ИмяФайла,СсылкаНаОбъект)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказКлиентаПрисоединенныеФайлы.Ссылка
		|ИЗ
		|	Справочник.ЗаказКлиентаПрисоединенныеФайлы КАК ЗаказКлиентаПрисоединенныеФайлы
		|ГДЕ
		|	ЗаказКлиентаПрисоединенныеФайлы.Наименование = &Наименование
		|	И ЗаказКлиентаПрисоединенныеФайлы.ВладелецФайла = &Ссылка
		|	И ЗаказКлиентаПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ";

	Запрос.УстановитьПараметр("Наименование", ИмяФайла);
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;



КонецФункции

&НаСервере
Функция ДобавитьФайлСервер(СсылкаНаОбъект,ИмяФайлаБезРасширения,АдресФайлаВоВременномХранилище)
	Возврат ПрисоединенныеФайлы.ДобавитьФайл(
			СсылкаНаОбъект,
			ИмяФайлаБезРасширения,
			"docx", 
			ТекущаяДата(), 
			ТекущаяДата(), 
			АдресФайлаВоВременномХранилище, 
			Неопределено,
			Ложь,
			"");
			
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
		
		Для Каждого СсылкаНаОбъект Из ПараметрКоманды Цикл
			//Чечин Петр. проверим сущесвование файла
			ИмяФайлаБезРасширения = "Договор_"+СтрЗаменить(СтрЗаменить(Строка(СсылкаНаОбъект)," ","_"),":","-");
			ПрисоединенныйФайл = ПолучитьПрисоединенныйФайл(ИмяФайлаБезРасширения,СсылкаНаОбъект);
			Если ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
				ДанныеФайла = ПрисоединенныеФайлыКлиент.ПолучитьДанныеФайла(ПрисоединенныйФайл,,Истина);
				ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла,Истина);				
				Продолжить;
			КонецЕсли;
			
			
			//Получаем файл из предопределенного 
			ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИДвоичныеДанные(
			ПолучитьСсылкуНаФайлДоговора());
			ДвоичныеДанные = ДанныеФайла.ДвоичныеДанные;
			//предоставим возможность пользователю выбрать каталог
			КаталокВФ = КаталогВременныхФайлов();
			
			ИмяФайла = КаталокВФ + ИмяФайлаБезРасширения +".docx";
			
			//ИмяФайла = КаталогВременныхФайлов()+"\"+;
			
			ДвоичныеДанные.Записать(ИмяФайла);
			
			//РаботаСФайламиКлиент.СоздатьФайл(
			Попытка  
				КомОбъект = Новый COMОбъект("Word.Application");    
				Документ =КомОбъект.Documents.Add(ИмяФайла);				
			Исключение   
				//если ошибка 
				КомОбъект.Application.Quit();				
				Сообщить("Произошла ошибка открытия файла Microsoft Word", СтатусСообщения.Важное);
				Возврат;
			КонецПопытки;
			СтруктураДанных = ПолучитьСтруктуруДанных(СсылкаНаОбъект);
	
			//сохраняем шаблом под нужным именем - это единсвенный способ установить имя файла.
			Документ.Application.ActiveDocument.SaveAS(ИмяФайла);			
			//замена шаблона <[ИмяПараметра]> в документе ворд, на параметры данных
			попытка
				Для Каждого текЭлемент Из СтруктураДанных Цикл
					
					Замена = Документ.Content.Find;
					Замена.Execute("["+текЭлемент.Ключ+"]", Ложь, Истина, Ложь, , , Истина, , Ложь, Лев(Строка(текЭлемент.Значение),250));
				КонецЦикла;
			Исключение 				
				Сообщить(ОписаниеОшибки()); 				
			КонецПопытки;
			Документ.Application.ActiveDocument.SaveAS(ИмяФайла);
			Документ.Application.ActiveDocument.Close();
			КомОбъект.Application.Quit(); 
			//2013-04-17
			//сохраняем файл в прикрепленные и открываем на редактирование.
			
			//ЗапуститьПриложение(ИмяФайла);
			Попытка
				АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайла), СсылкаНаОбъект.УникальныйИдентификатор());
				Файл = ДобавитьФайлСервер(СсылкаНаОбъект,ИмяФайлаБезРасширения,АдресФайлаВоВременномХранилище);
			Исключение
				Сообщить("Не удалось записать договор для документа: "+ОписаниеОшибки()+" "+СсылкаНаОбъект,СтатусСообщения.ОченьВажное);
			КонецПопытки;
			УдалитьФайлы(ИмяФайла);
			Попытка
				ДанныеФайла = ПрисоединенныеФайлыКлиент.ПолучитьДанныеФайла(Файл,,Истина);
				ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла,Ложь);
			Исключение
				Сообщить("Не удалось открыть договор для редактирования");
			КонецПопытки;
			
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////

Функция ПадежС(z1,Знач z2=2,Знач z3="*",z4=0) 
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

Функция ПадежП(Знач z1,Знач z2,z3=0) 
		
  z1=СокрЛП(z1);z4=Найти(z1+" "," ")+1;z5=Лев(z1,z4-2);z6=Прав(z5,2);
  z7=?((Найти("ая ий ый",z6)>0)и(Найти("ющий нный",Сред(z1,z4-5,4))=0)и(z3=0),"1","*");
Возврат НРег(?((z6="ая")или(Прав(z6,1)="а"),ПадежС(z5,z2,z7,1)+" "+ПадежС(Сред(z1,z4),z2),ПадежС(z5,z2,"ч",1)+?((z6="ий")и(Найти(z1," ")=0),""," "+?(z7="1",ПадежП(Сред(z1,z4),z2,Число(z7)),Сред(z1,z4)))));
КонецФункции

Функция Падеж(Знач z1,Знач z2,z3=0) 
	
	z1 = z1+" ";
	ФИО="";
	Пока Найти(z1," ") Цикл
		z11 = Лев(z1,Найти(z1," ")-1);
		z1 = Сред(z1,Найти(z1," ")+1);
		Если ЗначениеЗаполнено(ФИО) Тогда
			ФИО = ФИО + " ";
		КонецЕсли;	
		ФИО = ФИО+ВРег(Лев(ПадежП(z11,2,),1))+Сред(ПадежП(z11,2,),2);
	КонецЦикла;	
	возврат ФИО;
КонецФункции	

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

Функция ПадежФИО(Знач ФИО,Падеж=1,ТолькоИнициалы=Ложь, Знач пРазделитель=".") 
Если ТипЗнч(ФИО)<>Тип("Строка") Тогда
Сообщить("Неверная строка передана ""падежу ФИО!"""); Возврат ФИО;
КонецЕсли;

// уберем множественные пробелы
//Пока 1=1 Цикл
//ФИО=СокрЛП(СтрЗаменить(ФИО," "," "));
//Если Найти(ФИО," ")=0 Тогда Прервать КонецЕсли;
//КонецЦикла;

Если ТипЗнч(Падеж)=Тип("Строка") Тогда
пад=СокрЛП(НРег(Лев(Падеж,1))); 
Если Найти("ирдвтп",пад)=0 Тогда
Сообщить("Неверный падеж передан ""падежу ФИО""!"); Возврат ФИО;
КонецЕсли;
ИначеЕсли ТипЗнч(Падеж)=Тип("Число") Тогда
Если (Падеж<1) или (Падеж>6) Тогда
Сообщить("Неверный падеж передан ""падежу ФИО""!"); Возврат ФИО;
КонецЕсли; 
пад=Падеж-1;
КонецЕсли;

ФИО=СокрЛП(НРег(ФИО)); // так удобнее

// свой анализатор состава
Фамилия="";
Для й=1 По СтрДлина(ФИО) Цикл
символс=Сред(ФИО,й,1);
Если символс=" " Тогда Прервать КонецЕсли;
Фамилия=Фамилия+символс;
КонецЦикла;
ы=й+1; // перешли пробел
Имя="";
Для й=ы По СтрДлина(ФИО) Цикл
символс=Сред(ФИО,й,1);
Если символс=" " Тогда Прервать КонецЕсли;
Имя=Имя+символс;
КонецЦикла;
ы=й+1; // перешли второй пробел
Отчество="";
Для й=ы По СтрДлина(ФИО) Цикл
символс=Сред(ФИО,й,1);
Если символс=" " Тогда Прервать КонецЕсли;
Отчество=Отчество+символс;
КонецЦикла;

// теперь имеем раздельно Фамилию, Имя и Отчество. 
// начинается собственно блок анализа содержания и падежей

// вернем, если сам именительный. Если установлен возврат ТолькоИнициалы, то преобразуем в инициалы
Если (Лев(Падеж,1)="И") или (Падеж=1) Тогда 
Если НЕ ТолькоИнициалы или Найти(ФИО, ".") Тогда 
Возврат ФИО; // либо уже преобразованная строка, либо не нужно преобразовывать
КонецЕсли;
НовоеФИО = ТРег(Фамилия) + " " + Врег(Лев(Имя,1)) + пРазделитель + Врег(Лев(Отчество,1)) + пРазделитель;
Возврат СокрЛП(НовоеФИО); // на тот случай, если разделитель пробел. Последний срежем
КонецЕсли;


// проанализируем пол М/Ж
Если Прав(Отчество,1)="а" Тогда Пол="Ж" Иначе Пол="М" КонецЕсли;

// создадим структуру таблицы, хранящей окончания слов
ток=Новый ТаблицаЗначений;
ТипСтроки=Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(3));
ТипЧисла=Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(1,0));
ток.Колонки.Добавить("СтарОк",ТипСтроки); // старое окончание 2 символа
// колонки, хранящие новые окончания слов
ток.Колонки.Добавить("р"); // родительный
ток.Колонки.Добавить("д"); // дательный
ток.Колонки.Добавить("в"); // винительный
ток.Колонки.Добавить("т"); // творительный
ток.Колонки.Добавить("п"); // предложный
// для указания, сколько букв с конца слова отсечь,
ток.Колонки.Добавить("КолвоСрез",ТипЧисла); // кол-во срезаемых букв

Гласные="аеэоуиыяюьъ"; // список гласных букв в виде строки

// ======== обработаем фамилию ==========
// заполним таблицу данными для фамилии

Если пол="М" Тогда
строток=ток.Добавить(); // иванов
строток.СтарОк="*s";
строток.р="а"; строток.д="у"; строток.в="а"; строток.т="ым"; строток.п="е";
строток.КолвоСрез=0;

строток=ток.Добавить(); // красинский
строток.СтарОк="*й"; 
строток.р="ого"; строток.д="ому"; строток.в="ого"; строток.т="им"; строток.п="ом";
строток.КолвоСрез=2; 

строток=ток.Добавить(); // всемогущий
строток.СтарОк="щий"; 
строток.р="его"; строток.д="ему"; строток.в="его"; строток.т="им"; строток.п="ем";
строток.КолвоСрез=2; 

строток=ток.Добавить(); // белый
строток.СтарОк="ый";
строток.р="ого"; строток.д="ому"; строток.в="ого"; строток.т="ым"; строток.п="ом";
строток.КолвоСрез=2;

строток=ток.Добавить(); // палей
строток.СтарОк="*й";
строток.р="я"; строток.д="ю"; строток.в="я"; строток.т="ем"; строток.п="е";
строток.КолвоСрез=1;

строток=ток.Добавить(); // рабинович
строток.СтарОк="*ч";
строток.р="а"; строток.д="у"; строток.в="а"; строток.т="ем"; строток.п="е";
строток.КолвоСрез=0;

строток=ток.Добавить(); // починок, зализняк
строток.СтарОк="*к";
строток.р="ка"; строток.д="ку"; строток.в="ка"; строток.т="ком"; строток.п="ке";
строток.КолвоСрез=2;

строток=ток.Добавить(); // шинкарь
строток.СтарОк="*ь";
строток.р="я"; строток.д="ю"; строток.в="я"; строток.т="ем"; строток.п="е";
строток.КолвоСрез=1;

строток=ток.Добавить(); // перельман, оганесян
строток.СтарОк="*н";
строток.р="а"; строток.д="у"; строток.в="а"; строток.т="ом"; строток.п="е";
строток.КолвоСрез=0;

строток=ток.Добавить(); // баранкин
строток.СтарОк="ин";
строток.р="а"; строток.д="у"; строток.в="а"; строток.т="ым"; строток.п="е";
строток.КолвоСрез=0;

ИначеЕсли Пол="Ж" Тогда 
строток=ток.Добавить(); // склодовская
строток.СтарОк="ая";
строток.р="ой"; строток.д="ой"; строток.в="ую"; строток.т="ой"; строток.п="ой";
строток.КолвоСрез=2;

строток=ток.Добавить(); // иванова
строток.СтарОк="*а"; 
строток.р="ой"; строток.д="ой"; строток.в="у"; строток.т="ой"; строток.п="ой";
строток.КолвоСрез=1;
КонецЕсли;

// таблица заполнена. считаем 2 последних буквы и поищем их
Если не ПустаяСтрока(Фамилия) Тогда
пб=Прав(Фамилия,3); кол="СтарОк"; // ищем по ней
новФамилия=Фамилия; // если ничего не изменится, так и будет
стро=ток.Найти(пб,кол);
Если стро<>Неопределено Тогда // нашли строгое сразу
Основа=Лев(Фамилия,СтрДлина(Фамилия)-стро.КолвоСрез);
новФамилия=Основа+СокрЛП(стро[пад]);
Иначе
// строго не нашли по трем последним символам, ищем по двум символам только по последней
пб=Прав(Фамилия,2);
стро=ток.Найти(пб,кол);
Если стро<>Неопределено Тогда
Основа=Лев(Фамилия,СтрДлина(Фамилия)-стро.КолвоСрез);
новФамилия=Основа+СокрЛП(стро[пад]);
Иначе // если по двум не нашли, ищем по одному
пб="*"+Прав(пб,1); 
стро=ток.Найти(пб,кол);
Если стро<>Неопределено Тогда // нашли по последней
Основа=Лев(Фамилия,СтрДлина(Фамилия)-стро.КолвоСрез);
новФамилия=Основа+СокрЛП(стро[пад]);
Иначе // по последней не нашли, ищем по виду буквы
пб="*"+?(Найти(Гласные,Прав(пб,1))=0,"s","g");
стро=ток.Найти(пб,кол);
Если стро<>Неопределено Тогда // нашли по виду
Основа=Лев(Фамилия,СтрДлина(Фамилия)-стро.КолвоСрез);
новФамилия=Основа+СокрЛП(стро[пад]);
КонецЕсли;
КонецЕсли;
КонецЕсли;
КонецЕсли;
Иначе
новФамилия="";
КонецЕсли;

// ======== обработаем имя ==========
// заполним таблицу данными для имени
ток.Очистить();

Если Пол="М" Тогда
// обработаем исключения
Если Имя="лев" Тогда Имя="льв" КонецЕсли;
Если Имя="павел" Тогда Имя="павл" КонецЕсли;

строток=ток.Добавить(); // сергей
строток.старок="*й";
строток.р="я"; строток.д="ю"; строток.в="я"; строток.т="ем"; строток.п="е";
строток.колвосрез=1;

строток=ток.Добавить(); // иван + лев + павел
строток.старок="*s";
строток.р="а"; строток.д="у"; строток.в="а"; строток.т="ом"; строток.п="е";
строток.колвосрез=0;

строток=ток.Добавить(); // никита
строток.старок="*а";
строток.р="ы"; строток.д="е"; строток.в="у"; строток.т="ой"; строток.п="е";
строток.колвосрез=1;

строток=ток.Добавить(); // лука
строток.старок="ка";
строток.р="и"; строток.д="е"; строток.в="у"; строток.т="ой"; строток.п="е";
строток.колвосрез=1;

строток=ток.Добавить(); // иеремия
строток.старок="ия";
строток.р="и"; строток.д="и"; строток.в="ю"; строток.т="ей"; строток.п="и";
строток.колвосрез=1;

строток=ток.Добавить(); // илья
строток.старок="*я";
строток.р="и"; строток.д="е"; строток.в="ю"; строток.т="ей"; строток.п="е";
строток.колвосрез=1;

строток=ток.Добавить(); // игорь
строток.старок="*ь";
строток.р="я"; строток.д="ю"; строток.в="я"; строток.т="ем"; строток.п="е";
строток.колвосрез=1;

ИначеЕсли Пол="Ж" Тогда
// обработаем исключения
//Если Имя="ольга" Тогда Имя="ольгь" КонецЕсли;

строток=ток.Добавить(); // ирина
строток.старок="*а";
строток.р="ы"; строток.д="е"; строток.в="у"; строток.т="ой"; строток.п="е";
строток.колвосрез=1;

строток=ток.Добавить(); // инга, ольга
строток.старок="га";
строток.р="и"; строток.д="е"; строток.в="у"; строток.т="ой"; строток.п="е";
строток.колвосрез=1;

строток=ток.Добавить(); // эсфирь
строток.старок="*ь";
строток.р="и"; строток.д="и"; строток.в="ь"; строток.т="ью"; строток.п="и";
строток.колвосрез=1;

строток=ток.Добавить(); // мария
строток.старок="ия";
строток.р="и"; строток.д="и"; строток.в="ю"; строток.т="ей"; строток.п="и";
строток.колвосрез=1;

строток=ток.Добавить(); // софья
строток.старок="*я";
строток.р="и"; строток.д="е"; строток.в="ю"; строток.т="ей"; строток.п="е";
строток.колвосрез=1;
КонецЕсли;

// таблица заполнена. считаем 2 последних буквы и поищем их
Если не ПустаяСтрока(Имя) Тогда
пб=Прав(Имя,2); кол="СтарОк"; // ищем по ней
новИмя=Имя; // если ничего не изменится, так и будет
стро=ток.Найти(пб,кол);
Если стро<>Неопределено Тогда // нашли строгое сразу
Основа=Лев(Имя,СтрДлина(Имя)-стро.КолвоСрез);
новИмя=Основа+СокрЛП(стро[пад]);
Иначе // строго не нашли, ищем только по последней
пб="*"+Прав(пб,1); 
стро=ток.Найти(пб,кол);
Если стро<>Неопределено Тогда // нашли по последней
Основа=Лев(Имя,СтрДлина(Имя)-стро.КолвоСрез);
новИмя=Основа+СокрЛП(стро[пад]);
Иначе // по последней не нашли, ищем по виду буквы
пб="*"+?(Найти(Гласные,Прав(пб,1))=0,"s","g");
стро=ток.Найти(пб,кол);
Если стро<>Неопределено=1 Тогда // нашли по виду
Основа=Лев(Имя,СтрДлина(Имя)-стро.КолвоСрез);
новИмя=Основа+СокрЛП(стро[пад]);
КонецЕсли;
КонецЕсли;
КонецЕсли;
Иначе
новИмя="";
КонецЕсли;

// ======== обработаем отчество, тут проще ==========
ток.Очистить();

Если Пол="М" Тогда
строток=ток.Добавить();
строток.р="а"; строток.д="у"; строток.в="а"; строток.т="ем"; строток.п="е";
строток.колвосрез=0;
ИначеЕсли Пол="Ж" Тогда
строток=ток.Добавить();
строток.р="ы"; строток.д="е"; строток.в="у"; строток.т="ой"; строток.п="е";
строток.колвосрез=1;
КонецЕсли;
Если не ПустаяСтрока(Отчество) Тогда
Основа=Лев(Отчество,СтрДлина(Отчество)-ток[0].КолвоСрез); 
новОтчество=Основа+СокрЛП(ток[0][пад]);
Иначе
новОтчество="";
КонецЕсли; 

Если ТолькоИнициалы Тогда
новИмя=Лев(новИмя,1); новОтчество=Лев(новОтчество,1);
КонецЕсли;

// установим первые буквы верхним регистром
новФамилия=ВРег(Лев(новФамилия,1))+Сред(новФамилия,2);
новИмя=ВРег(Лев(новИмя,1))+Сред(новИмя,2);
новОтчество=ВРег(Лев(новОтчество,1))+Сред(новОтчество,2);

// и теперь всё вместе 
Если ТолькоИнициалы Тогда // если задан формат инициалов
новФИО=новФамилия+" "+новИмя+пРазделитель+новОтчество+пРазделитель;
Иначе
новФИО=новФамилия+" "+новИмя+" "+новОтчество;
КонецЕсли;

Если Найти(ФИО, ".") Тогда // На тот случай, если входной параметр Фамилию с инициалами. Инициалы не трогаем
новФИО = новФамилия + " " + ТРег(Имя) + Трег(Отчество);
КонецЕсли; 

Возврат СокрЛП(новФИО);
КонецФункции 
 
// 
Функция ЧислоПрописьюСокращенно(Число) 
	
	//
	Окончание = "";
	
	//
	ЧислоСтрока = Строка(Число);
	
	//
	ПоследняяПраваяЦифра = Число(Прав(ЧислоСтрока, 1));
	Если ПоследняяПраваяЦифра = 1 Тогда
		Окончание = "-го";
	ИначеЕсли ПоследняяПраваяЦифра >= 2 И ПоследняяПраваяЦифра < 5 Тогда
		Окончание = "-х";	
	Иначе
		Окончание = "-и";
	КонецЕсли;	
		
	//	
	Возврат "" + Число + Окончание;
	
КонецФункции


// Возвращает структуру данных со сводным описанием контрагента
//
// Параметры: 
//  СписокСведений - список значений со значениями параметров организации
//   СписокСведений формируется функцией СведенияОЮрФизЛице
//  Список         - список запрашиваемых параметров организации
//  СПрефиксом     - Признак выводить или нет префикс параметра организации
//
// Возвращаемое значение:
//  Строка - описатель организации / контрагента / физ.лица.
//
Функция ОписаниеОрганизации(СписокСведений, Список = "", СПрефиксом = Истина) 

	Если ПустаяСтрока(Список) Тогда
		Список = "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет";
	КонецЕсли;

	Результат = "";

	СоответствиеПараметров = Новый Соответствие();
	СоответствиеПараметров.Вставить("ПолноеНаименование", " ");
	СоответствиеПараметров.Вставить("ИНН",                " ИНН ");
	СоответствиеПараметров.Вставить("КПП",                " КПП ");
	СоответствиеПараметров.Вставить("ЮридическийАдрес",   " ");
	СоответствиеПараметров.Вставить("ФактическийАдрес",   " ");
	СоответствиеПараметров.Вставить("Телефоны",           " тел.: ");
	СоответствиеПараметров.Вставить("НомерСчета",         " р/с ");
	СоответствиеПараметров.Вставить("Банк",               " в банке ");
	СоответствиеПараметров.Вставить("БИК",                " БИК ");
	СоответствиеПараметров.Вставить("КоррСчет",           " к/с ");
	СоответствиеПараметров.Вставить("КодПоОКПО",          " Код по ОКПО ");
	СоответствиеПараметров.Вставить("Email",          " Электронная почта: ");

	Список          = Список + ?(Прав(Список, 1) = ",", "", ",");
	ЧислоПараметров = СтрЧислоВхождений(Список, ",");

	Для Счетчик = 1 по ЧислоПараметров Цикл

		ПозЗапятой = Найти(Список, ",");

		Если ПозЗапятой > 0  Тогда
			
			ИмяПараметра = Лев(Список, ПозЗапятой - 1);
			Список       = Сред(Список, ПозЗапятой + 1, СтрДлина(Список));

			Попытка
				СтрокаДополнения = "";
				СписокСведений.Свойство(ИмяПараметра, СтрокаДополнения);

				Если ПустаяСтрока(СтрокаДополнения) Тогда
					Продолжить;
				КонецЕсли;

				Префикс = СоответствиеПараметров[ИмяПараметра];
				Если Не ПустаяСтрока(Результат)  Тогда
					Результат = Результат + Символы.ПС;
				КонецЕсли; 

				Результат = Результат + ?(СПрефиксом = Истина, Префикс, "") + СтрокаДополнения;
			Исключение
				
				ТекстСообщения  = НСтр("ru='Не удалось определить значение параметра организации: %ИмяПараметра%'");
				ТекстСообщения  = СтрЗаменить(ТекстСообщения,"%ИмяПараметра%",ИмяПараметра);
				Сообщение       = Новый СообщениеПользователю();
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Сообщить();
				
			КонецПопытки;

		КонецЕсли;

	КонецЦикла;

	Возврат СокрЛП(Результат);

КонецФункции // ОписаниеОрганизации()



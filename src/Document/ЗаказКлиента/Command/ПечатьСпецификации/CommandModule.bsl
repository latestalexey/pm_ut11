﻿&НаСервере
Функция ПолучитьПрисоединенныйФайл(ИмяФайла,СсылкаНаОбъект)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказКлиентаПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ЗаказКлиентаПрисоединенныеФайлы КАК ЗаказКлиентаПрисоединенныеФайлы
	|ГДЕ
	|	ЗаказКлиентаПрисоединенныеФайлы.Наименование = &Наименование
	|	И ЗаказКлиентаПрисоединенныеФайлы.ВладелецФайла = &Ссылка";
	
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
	СформироватьПечатнуюФормуСпецификации(ПараметрКоманды, Неопределено);
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////

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

Функция ПадежП(Знач z1,Знач z2,z3=0) Экспорт
	
	z1=СокрЛП(z1);z4=Найти(z1+" "," ")+1;z5=Лев(z1,z4-2);z6=Прав(z5,2);
	z7=?((Найти("ая ий ый",z6)>0)и(Найти("ющий нный",Сред(z1,z4-5,4))=0)и(z3=0),"1","*");
	Возврат НРег(?((z6="ая")или(Прав(z6,1)="а"),ПадежС(z5,z2,z7,1)+" "+ПадежС(Сред(z1,z4),z2),ПадежС(z5,z2,"ч",1)+?((z6="ий")и(Найти(z1," ")=0),""," "+?(z7="1",ПадежП(Сред(z1,z4),z2,Число(z7)),Сред(z1,z4)))));
КонецФункции

Функция Падеж(Знач z1,Знач z2,z3=0) Экспорт
	
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

///////////////////////////////////////////////////////////////////////////// 

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
Функция ОписаниеОрганизации(СписокСведений, Список = "", СПрефиксом = Истина) Экспорт
	
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
					Результат = Результат + Символы.ПС + Символы.ВК ;
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


&НаСервере 
Функция ПолучитьДанныеШапки(СсылкаНаОбъект)
	//
	ТекстЗапроса = "ВЫБРАТЬ
	|	Документ.Соглашение,
	|	Документ.Соглашение.Дата КАК Дата,
	|	Документ.Соглашение.Номер КАК Номер,
	|	Документ.Партнер КАК Партнер,
	|	Документ.Организация КАК Организация,
	|	Документ.Соглашение.АК_ОрганизацияБанковскийСчет КАК ОрганизацияБанковскийСчет,
	|	ЕСТЬNULL(Документ.Организация.НаименованиеПолное, """") КАК ОрганизацияНаименованиеПолное,
	|	Документ.Контрагент КАК Контрагент,
	|	Документ.Соглашение.АК_КонтрагентБанковскийСчет КАК КонтрагентБанковскийСчет,
	|	ЕСТЬNULL(Документ.Контрагент.НаименованиеПолное, """") КАК КонтрагентНаименованиеПолное,
	|	Документ.Контрагент.АК_ТекущийРуководитель КАК КонтрагентРуководитель,
	|	ЕСТЬNULL(Документ.Контрагент.АК_ТекущийРуководитель.Наименование, """") КАК КонтрагентРуководительНаименование,
	|	Документ.Контрагент.АК_ТекущийРуководитель.ДолжностьПоВизитке КАК КонтрагентРуководительДолжность,
	|	1 КАК НомерСпецификации,
	|	Документ.Валюта,
	|	ЕСТЬNULL(Документ.ДокументОснование.ГрафикОплаты,"""") КАК ГрафикОплаты,
	|	Документ.ДокументОснование.АК_УсловияПоставки КАК АК_УсловияПоставки,
	|	Документ.ДокументОснование.Партнер КАК ПартнерДок,
	|	Документ.ДокументОснование.СрокПоставки КАК СрокПоставки
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
	Возврат Запрос.Выполнить().Выгрузить();	
КонецФункции

&НаСервере 
Функция ПолучитьДанныеТабЧасти(Ссылка)
	ТекстЗапроса = "ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Номенклатура.Артикул КАК Артикул,
	|	Товары.Номенклатура.Код КАК Код,
	|	Товары.КоличествоУпаковок КАК Количество,
	|	ВЫБОР
	|		КОГДА Товары.СуммаРучнойСкидки <> 0
	|			ТОГДА ВЫРАЗИТЬ(Товары.Цена - Товары.СуммаРучнойСкидки / Товары.КоличествоУпаковок КАК ЧИСЛО(15, 2))
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Товары.СуммаАвтоматическойСкидки <> 0
	|					ТОГДА ВЫРАЗИТЬ(Товары.Цена - Товары.СуммаАвтоматическойСкидки / Товары.КоличествоУпаковок КАК ЧИСЛО(15, 2))
	|				ИНАЧЕ Товары.Цена
	|			КОНЕЦ
	|	КОНЕЦ КАК Цена,
	|	ВЫБОР
	|		КОГДА Товары.Ссылка.ЦенаВключаетНДС
	|			ТОГДА Товары.Сумма
	|		ИНАЧЕ Товары.Сумма + Товары.СуммаНДС
	|	КОНЕЦ КАК Сумма,
	|	Товары.СтавкаНДС,
	|	Товары.Номенклатура.Описание КАК Описание,
	|	Товары.СуммаНДС,
	|	ВЫБОР
	|		КОГДА Товары.Ссылка.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК УчитыватьНДС,
	|	Товары.НомерСтроки,
	|	Товары.АК_ПризнакНестандарт КАК Нестандарт,
	|	Товары.АК_НестандартОписание КАК НестандартОписание
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка";
	
	//
	Запрос = Новый Запрос;						   
	Запрос.Текст = ТекстЗапроса;
	
	//                                    
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	//
	Выборка = Запрос.Выполнить().Выбрать();
	СтруктураСтрок = Новый Структура;
	н = 1;
	Пока выборка.Следующий() Цикл
		ТекСтрока = Новый Структура("Номенклатура,Характеристика,Артикул,
		|Код,Количество,Цена,Сумма,СтавкаНДС,Описание,СуммаНДС,УчитыватьНДС,НомерСтроки,Нестандарт,НестандартОписание");
		ЗаполнитьЗначенияСвойств(ТекСтрока,Выборка);
		СтруктураСтрок.Вставить("Строка"+н,ТекСтрока);
		н=н+1;
	КонецЦикла;
	Возврат СтруктураСтрок;
	
КонецФункции

&НаСервере 
Функция ПолучитьДанные(Ссылка)
	СтруктураДанных = Новый Структура;	
	Шапка=ПолучитьДанныеШапки(Ссылка);
	Если Шапка.Количество() > 0 Тогда
		Выборка = Шапка[0];
		СтруктураДанных.Вставить("Соглашение",Выборка.Соглашение);
		Дата=Выборка.Дата;
		СтруктураДанных.Вставить("Дата",Дата);
		СтруктураДанных.Вставить("Номер",Выборка.Номер);
		СтруктураДанных.Вставить("Валюта",Выборка.Валюта);
		//
		СтруктураДанных.Вставить("НомерСпецификации",Выборка.НомерСпецификации);
		//
		Организация=Выборка.Организация;
		СтруктураДанных.Вставить("Организация",Организация);
		СтруктураДанных.Вставить("ОрганизацияНаименованиеПолное",Выборка.ОрганизацияНаименованиеПолное);
		ОтветсвенныеЛица = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Выборка.Организация,Ссылка.Дата);
		СтруктураДанных.Вставить("ОтветсвенныеЛица",ОтветсвенныеЛица);
		СтруктураДанных.Вставить("ОрганизацияРуководитель",ОтветсвенныеЛица.Руководитель);
		ОрганизацияРуководительНаименование = ОтветсвенныеЛица.Руководитель.Наименование;
		СтруктураДанных.Вставить("ОрганизацияРуководительНаименование",ОрганизацияРуководительНаименование);
		СтруктураДанных.Вставить("ОрганизацияРуководительДолжность","" +  ОтветсвенныеЛица.РуководительДолжность + " " + Организация.НаименованиеСокращенное);
		
		ОрганизацияРуководительСклонениеФИО = Падеж(СтруктураДанных.ОрганизацияРуководительНаименование, 2, );
		СтруктураДанных.Вставить("ОрганизацияРуководительСокращенно",СократитьФИО(ОрганизацияРуководительНаименование));
		ОрганизацияБанковскийСчет = Выборка.ОрганизацияБанковскийСчет;
		СтруктураДанных.Вставить("ОрганизацияБанковскийСчет",ОрганизацияБанковскийСчет);
		Если НЕ ЗначениеЗаполнено(ОрганизацияБанковскийСчет) Тогда
			СтруктураДанных.Вставить("ОрганизацияБанковскийСчет",ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация));
		КонецЕсли;		
		//
		СведенияОрганизация = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Организация, Ссылка.Дата, , ОрганизацияБанковскийСчет);
		СведенияОрганизацияСтрокаСРеквизитами =  ОписаниеОрганизации(СведенияОрганизация, "ПолноеНаименование,ЮридическийАдрес,ИНН,КПП,НомерСчета,КоррСчет,Банк,БИК,Телефоны");
		СтруктураДанных.Вставить("ОрганизацияРеквизиты",СведенияОрганизацияСтрокаСРеквизитами);
		//
		Партнер = Выборка.Партнер;
		СтруктураДанных.Вставить("Партнер",Партнер);	
		//
		Контрагент = Выборка.Контрагент;
		КонтрагентНаименованиеПолное = Выборка.КонтрагентНаименованиеПолное;
		КонтрагентРуководитель = Выборка.КонтрагентРуководитель;
		КонтрагентРуководительНаименование = Выборка.КонтрагентРуководительНаименование;
		КонтрагентРуководительДолжность = Выборка.КонтрагентРуководительДолжность;
		
		СтруктураДанных.Вставить("Контрагент",Контрагент);
		СтруктураДанных.Вставить("КонтрагентНаименованиеПолное",КонтрагентНаименованиеПолное);
		СтруктураДанных.Вставить("КонтрагентРуководитель",КонтрагентРуководитель);
		СтруктураДанных.Вставить("КонтрагентРуководительНаименование",КонтрагентРуководительНаименование);
		СтруктураДанных.Вставить("КонтрагентРуководительДолжность",КонтрагентРуководительДолжность);
		//
		КонтрагентРуководительСклонениеФИО = Падеж(КонтрагентРуководительНаименование, 2, );
		КонтрагентРуководительСокращенно = СократитьФИО(КонтрагентРуководительНаименование);
		СтруктураДанных.Вставить("КонтрагентРуководительСклонениеФИО",КонтрагентРуководительСклонениеФИО);
		СтруктураДанных.Вставить("КонтрагентРуководительСокращенно",КонтрагентРуководительСокращенно);
		//
		КонтрагентБанковскийСчет = Выборка.КонтрагентБанковскийСчет;
		Если НЕ ЗначениеЗаполнено(КонтрагентБанковскийСчет) Тогда
			КонтрагентБанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
		КонецЕсли;
		СтруктураДанных.Вставить("КонтрагентБанковскийСчет",КонтрагентБанковскийСчет);
		//
		СведенияКонтрагент = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Контрагент, Ссылка.Дата, , КонтрагентБанковскийСчет);
		СведенияКонтрагентСтрокаСРеквизитами =  ОписаниеОрганизации(СведенияКонтрагент, "ПолноеНаименование,ЮридическийАдрес,ИНН,КПП,НомерСчета,КоррСчет,Банк,БИК,Телефоны");
		СтруктураДанных.Вставить("СведенияКонтрагентСтрокаСРеквизитами",СведенияКонтрагентСтрокаСРеквизитами);
		//Доработка + (Станислав)
		СтруктураДанных.Вставить("ГрафикОплаты",Выборка.ГрафикОплаты);
		СтруктураДанных.Вставить("УсловияПоставки",Выборка.АК_УсловияПоставки);
		СтруктураДанных.Вставить("СрокПоставки",Выборка.СрокПоставки);
		//Доработка - (Станислав)
		
	КонецЕсли;
	Возврат СтруктураДанных;
КонецФункции

&НаСервере
Функция ПолучитьМакетВорд()
	Шаблон = Документы.ЗаказКлиента.получитьМакет("Шаблон");
	АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(Шаблон);
	
	Возврат АдресФайлаВХранилище; 	
КонецФункции
//Доработка + (Станислав)
&НаСервере
Функция ПолучитьТекстУсловияПоставки(УсловияПоставки)
	ТекстУсловияПоставки = "";
	Если Справочники.АК_УсловияПоставки.ПустаяСсылка() <> УсловияПоставки Тогда
		ТекстУсловияПоставки = ТекстУсловияПоставки + "Услуги: " + УсловияПоставки.ПолучитьОбъект().ТекстДляДоговора;
	КонецЕсли; 
	Возврат  ТекстУсловияПоставки;
КонецФункции

&НаСервере
Функция ПолучитьТекстУсловияОплаты(ГрафикОплаты,Валюта,СуммаВсего,СуммаНДС)
	Если ГрафикОплаты <> "" Тогда
		ТекстУсловияОплаты = "Заказчик на основании счетов, выставленных Поставщиком, производит оплату:" + Символ(13)+Символ(10);
		Для Каждого  СтрокаСправочника Из ГрафикОплаты.Этапы Цикл
			Если СтрокаСправочника.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.АвансДоОбеспечения Тогда
				ТекстУсловияОплаты = ТекстУсловияОплаты + "-" + СокрЛП(СтрокаСправочника.ПроцентПлатежа) + "% внесение аванса до обеспечения от общей суммы Договора, что составляет " + Формат(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1),"ЧДЦ=2") + " (";
				ТекстУсловияОплаты = ТекстУсловияОплаты + РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1), Валюта) + " )";
				Если СуммаНДС Тогда
					ТекстУсловияОплаты = ТекстУсловияОплаты + " (в т.ч. НДС: " +  РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаНДС * СтрокаСправочника.ПроцентПлатежа / 100,2,1), Валюта)+ ") ";
				Иначе
					ТекстУсловияОплаты = ТекстУсловияОплаты + "(НДС не облагается) ";
				КонецЕсли;
				ТекстУсловияОплаты = ТекстУсловияОплаты + "в течении " + СтрокаСправочника.Сдвиг + "-и банковских дней с момента подписания Спецификации." + Символ(13)+Символ(10);
				
			ИначеЕсли СтрокаСправочника.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.КредитПослеОтгрузки Тогда
				Если СтрокаСправочника.ПроцентПлатежа = 100 Тогда
				ТекстУсловияОплаты = ТекстУсловияОплаты + "-" + СокрЛП(СтрокаСправочника.ПроцентПлатежа) + "% после поставки товара от общей суммы Договора, что составляет " + Формат(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1),"ЧДЦ=2") + " (";
				ТекстУсловияОплаты = ТекстУсловияОплаты + РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1), Валюта)+ " )";
				Иначе
				ТекстУсловияОплаты = ТекстУсловияОплаты + "-" + СокрЛП(СтрокаСправочника.ПроцентПлатежа) + "% кредита покупателю от общей суммы Договора, что составляет " + Формат(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1),"ЧДЦ=2") + " (";
				ТекстУсловияОплаты = ТекстУсловияОплаты + РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1), Валюта)+ " )";
	            КонецЕсли;
				Если СуммаНДС > 0 Тогда
					ТекстУсловияОплаты = ТекстУсловияОплаты + " (в т.ч. НДС: " +  РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаНДС * СтрокаСправочника.ПроцентПлатежа / 100,2,1), Валюта)+ ") ";
				Иначе
					ТекстУсловияОплаты = ТекстУсловияОплаты + "(НДС не облагается). ";
				КонецЕсли;
				ТекстУсловияОплаты = ТекстУсловияОплаты + "Заказчик производит оплату в течение " + СтрокаСправочника.Сдвиг + "-и банковских дней  с момента поставки ему товара , если иное не указанно в соответствующей Спецификации." + Символ(13)+Символ(10);
				
			ИначеЕсли СтрокаСправочника.ВариантОплаты = Перечисления.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки тогда
				Если  СтрокаСправочника.ПроцентПлатежа = 100 Тогда
					ТекстУсловияОплаты = "";
					ТекстУсловияОплаты = "Заказчик на основании счетов, выставленных Поставщиком, производит 100% предоплату  в течение 5-и банковских дней с момента подписания спецификации, что составляет " + Формат(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1),"ЧДЦ=2");
				Иначе 		
					
					ТекстУсловияОплаты = ТекстУсловияОплаты + "-" + СокрЛП(СтрокаСправочника.ПроцентПлатежа) + "% предоплаты от общей суммы Договора, что составляет " + Формат(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1),"ЧДЦ=2") + " (";
					ТекстУсловияОплаты = ТекстУсловияОплаты + РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаВсего * СтрокаСправочника.ПроцентПлатежа / 100,2,1), Валюта) + " )";
				КонецЕсли;
				Если СуммаНДС Тогда
					ТекстУсловияОплаты = ТекстУсловияОплаты + " (в т.ч. НДС: " +  РаботаСКурсамиВалют.СформироватьСуммуПрописью(Окр(СуммаНДС * СтрокаСправочника.ПроцентПлатежа / 100,2,1), Валюта)+ ") ";
				Иначе
					ТекстУсловияОплаты = ТекстУсловияОплаты + "(НДС не облагается). ";
				КонецЕсли;
				ТекстУсловияОплаты = ТекстУсловияОплаты + "Заказчик производит оплату в течении " + СтрокаСправочника.Сдвиг + "-и банковских дней  с момента готовности товара к отгрузке по письму-уведомлению, если иное не указанно в соответствующей Спецификации." + Символ(13)+Символ(10);
			КонецЕсли; 
		КонецЦикла;
	Иначе
		Возврат "";	
	КонецЕсли;
	
	Возврат  ТекстУсловияОплаты;
КонецФункции
//Доработка -(Станислав)


&НаСервере
Функция ПолучитьСуммуПрописью(Сумма,Валюта)
	Возврат РаботаСКурсамиВалют.СформироватьСуммуПрописью(Сумма, Валюта);	
КонецФункции

&НаСервере
Функция ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент)
	Возврат ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);	
КонецФункции

&НаСервере
Функция СведенияОЮрФизЛице (Контрагент,Дата,КонтрагентБанковскийСчет)
	Возврат ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Контрагент,Дата,,КонтрагентБанковскийСчет);	
КонецФункции

&НаСервере
Функция ПолучитьГабаритыИзСтроки(СтрокаДляАнализа)       
	Возврат АК_ОбщегоНазначения.ПолучитьГабаритыИзСтроки(Строка(СтрокаДляАнализа));
КонецФункции

&НаКлиенте
Процедура СформироватьПечатнуюФормуСпецификации(МассивОбъектов, ОбъектыПечати)
	
	Для Каждого СсылкаНаОбъект Из МассивОбъектов Цикл
		//Чечин Петр. проверим сущесвование файла
		ИмяФайлаБезРасширения = "Спецификация_"+СтрЗаменить(СтрЗаменить(Строка(СсылкаНаОбъект)," ","_"),":","-");
		//присоединенныйФайл = ПолучитьПрисоединенныйФайл(ИмяФайлаБезРасширения,СсылкаНаОбъект);
		//Если ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		//	ДанныеФайла = ПрисоединенныеФайлыКлиент.ПолучитьДанныеФайла(ПрисоединенныйФайл,,Истина);
		//	ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла,Истина);				
		//	Продолжить;
		//КонецЕсли;
		
		//получить объект из макета. 
		АдресВХранилище = ПолучитьМакетВорд();
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВХранилище);		
		//предоставим возможность пользователю выбрать каталог
		
		КаталокВФ = КаталогВременныхФайлов();
		ИмяФайла = КаталокВФ + ИмяФайлаБезРасширения +".docx";
		
		
		ДвоичныеДанные.Записать(ИмяФайла);
		
		Попытка  
			КомОбъект = Новый COMОбъект("Word.Application");    
			ДокументВорд =КомОбъект.Documents.Add(ИмяФайла);				
		Исключение   
			//если ошибка 
			КомОбъект.Application.Quit();				
			Сообщить("Произошла ошибка открытия файла Microsoft Word", СтатусСообщения.Важное);
			Возврат;
		КонецПопытки;
		
		Ссылка = СсылкаНаОбъект;
		
		//сохраняем шаблом под нужным именем - это единсвенный способ установить имя файла.
		ДокументВорд.Application.ActiveDocument.SaveAS(ИмяФайла);
		
		//
		СтруктураДанных = ПолучитьДанные(СсылкаНаОбъект);
		//
		КонтрагентБанковскийСчет = СтруктураДанных.КонтрагентБанковскийСчет;
		////Доработка +
		//	СрокПоставки 	= СтруктураДанных.СрокПоставки;
		//	ГрафикОплаты 	= СтруктураДанных.ГрафикОплаты;
		//	УсловияПоставки = СтруктураДанных.УсловияПоставки;
		//	Валюта			= СтруктураДанных.Валюта;
		////Доработка -
		
		Если НЕ ЗначениеЗаполнено(КонтрагентБанковскийСчет) Тогда
			КонтрагентБанковскийСчет = ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(СтруктураДанных.Контрагент);
		КонецЕсли;
		СведенияКонтрагент = СведенияОЮрФизЛице(СтруктураДанных.Контрагент, 
		СтруктураДанных.Дата,
		КонтрагентБанковскийСчет);
		ОстаткиРеквизитов = ОписаниеОрганизации(СведенияКонтрагент, "ИНН")+Символы.ПС+ Символы.ВК + 
		ОписаниеОрганизации(СведенияКонтрагент, "КПП")+Символы.ПС+ Символы.ВК +
		ОписаниеОрганизации(СведенияКонтрагент, "НомерСчета,КоррСчет,Банк,БИК")+Символы.ПС+ Символы.ВК +
		ОписаниеОрганизации(СведенияКонтрагент, "Телефоны");																		 
		
		ЗаменитьПараметр(ДокументВорд,"НомерДоговора",СтруктураДанных.Номер);
		ЗаменитьПараметр(ДокументВорд,"ДатаДоговора",Формат(СтруктураДанных.Дата, "ДЛФ=ДД"));
		
		ЗаменитьПараметр(ДокументВорд,"НомерСпецификации",СтруктураДанных.НомерСпецификации);
		ЗаменитьПараметр(ДокументВорд,"ОрганизацияПолноеНаименование",СтруктураДанных.ОрганизацияНаименованиеПолное);
		ЗаменитьПараметр(ДокументВорд,"КонтрагентПолноеНаименование",СтруктураДанных.КонтрагентНаименованиеПолное);
		ЗаменитьПараметр(ДокументВорд,"КонтрагентРеквизиты1",ОписаниеОрганизации(СведенияКонтрагент, "ЮридическийАдрес"));
		ЗаменитьПараметр(ДокументВорд,"КонтрагентРеквизиты2",ОстаткиРеквизитов);
		
		//
		
		//
		НомерСтроки = 1;
		КоличествоВсего = 0;
		СуммаВсего = 0;
		СуммаНДС = 0;
		СуммаНДСВсего = 0;
		
		//
		ДокументВорд.Tables(2).Select(); // если этого не сделать, то не находит таблицу
		НомерСтроки = 1;
		ТЗ = ПолучитьДанныеТабЧасти(СсылкаНаОбъект);
		Для Каждого ТекСтрока ИЗ ТЗ Цикл
			Выборка = ТекСтрока.Значение;
			УчитыватьНДС = Выборка.УчитыватьНДС;
			НомерСтроки = НомерСтроки +1;
			Если Выборка.СуммаНДС = 0 И УчитыватьНДС Тогда
				СуммаНДС = "---";
			Иначе
				СуммаНДС = Формат(Выборка.СуммаНДС,"ЧЦ=15; ЧДЦ=2");
			КонецЕсли;
			//2014-06-24 Чечин Петр. Печатаем не стандартные размеры
			//если есть нестандартные, печатем их. В противном случае
			//берем стандартные из наименования или характеристики.
			ОписаниеНестандарта = "";
			Номенклатура = Выборка.Номенклатура;
			Характеристика = Выборка.Характеристика;
			//1.ищем в характеристике
			ГабаритыСтандарт = ПолучитьГабаритыИзСтроки(Выборка.Характеристика);
			ГабаритыНестандарт = "";
			Если ГабаритыСтандарт = "" Тогда
				//2.ищем в наименовании
				ГабаритыСтандарт = ПолучитьГабаритыИзСтроки(Выборка.Номенклатура);		
			КонецЕсли;
			
			
			Если Выборка.Нестандарт Тогда
				ГабаритыНестандарт = ПолучитьГабаритыИзСтроки(Выборка.НестандартОписание);
				ОписаниеНестандарта = ?(СокрЛП(Выборка.НестандартОписание)<>"",
				"," +СтрЗаменить(СокрЛП(Выборка.НестандартОписание),ГабаритыНестандарт,""),
				"");
			КонецЕсли;	
			
			ГабаритыДляПечати = ?(ГабаритыНестандарт = "",ГабаритыСтандарт,ГабаритыНестандарт);
			
			//если есть в описании габариты, замених их
			Если ГабаритыНестандарт <> "" Тогда
				//1.ищем в наименовании
				ГабаритыСтандарт = ПолучитьГабаритыИзСтроки(Выборка.Номенклатура);
				Если ГабаритыСтандарт <> "" Тогда
					Номенклатура = СтрЗаменить(Выборка.Номенклатура,ГабаритыСтандарт,ГабаритыНестандарт);		
				КонецЕсли;
				//2.ищем в характеристике
				ГабаритыСтандарт = ПолучитьГабаритыИзСтроки(Выборка.Характеристика);
				Если ГабаритыСтандарт <> "" Тогда
					Характеристика = СтрЗаменить(Выборка.Характеристика,ГабаритыСтандарт,ГабаритыНестандарт);		
				КонецЕсли;
				
			КонецЕсли;
			//(н)Чечин 2015-07-29
			//Последняя строка таблицы и подписи не переносятся на новый лист
			Если Выборка.НомерСтроки = ТЗ.Количество() Тогда
				Если ТЗ.Количество() = 1 Тогда
					ДокументВорд.Tables(2).Rows(НомерСтроки).Select(); 
					ДокументВорд.Application.Selection.Rows.Delete();
				КонецЕсли;
				НомерСтроки = 1;
				ДокументВорд.Tables(2).Tables(1).Select(); 
				ТаблицаВорд = ДокументВорд.Tables(2).Tables(1);
			Иначе
				ТаблицаВорд = ДокументВорд.Tables(2);
			КонецЕсли;
			//(к)
			
			ТаблицаВорд.Cell(НомерСтроки, 2).Range.Text = Строка(Выборка.НомерСтроки);
			//Доработка + 13.08.2014
			ТаблицаВорд.Cell(НомерСтроки, 3).Range.Text = Строка(Номенклатура)+" "+ОписаниеНестандарта;
			//ДокументВорд.Tables(1).Cell(НомерСтроки, 3).Range.Text = Строка(Номенклатура)+" "+Характеристика+ОписаниеНестандарта;
			//Доработка -
			ТаблицаВорд.Cell(НомерСтроки, 4).Range.Text = ГабаритыДляПечати;
			ТаблицаВорд.Cell(НомерСтроки, 5).Range.Text = Строка(Выборка.Описание);
			ТаблицаВорд.Cell(НомерСтроки, 6).Range.Text = Строка(Выборка.Артикул);
			ТаблицаВорд.Cell(НомерСтроки, 7).Range.Text = Строка(Выборка.Код);
			ТаблицаВорд.Cell(НомерСтроки, 8).Range.Text = Формат(Выборка.Количество,"ЧЦ=15; ЧДЦ=2");
			ТаблицаВорд.Cell(НомерСтроки, 9).Range.Text = Формат(Выборка.Цена,"ЧЦ=15; ЧДЦ=2");
			ТаблицаВорд.Cell(НомерСтроки, 10).Range.Text = Строка(Выборка.СтавкаНДС);
			ТаблицаВорд.Cell(НомерСтроки, 11).Range.Text = Строка(СуммаНДС);
			ТаблицаВорд.Cell(НомерСтроки, 12).Range.Text = Формат(Выборка.Сумма,"ЧЦ=15; ЧДЦ=2");
			Если Выборка.НомерСтроки < ТЗ.Количество()-1 Тогда
				ТаблицаВорд.Cell(НомерСтроки, 12).Select(); // выбираем последнюю ячейку в последней строке (хз зачем, но видимо так надо было)					
				ДокументВорд.Application.Selection.InsertRowsBelow(1);    //<<<<<< тут добавляется строка снизу					
			КонецЕсли; 				
			//
			КоличествоВсего = КоличествоВсего + Выборка.Количество;
			СуммаВсего = СуммаВсего + Выборка.Сумма;
			СуммаНДСВсего   = СуммаНДСВсего + Выборка.СуммаНДС;
			
		КонецЦикла;	
		ЗаменитьПараметр(ДокументВорд,"СуммаНДСВсего",Формат(СуммаНДСВсего, "ЧДЦ=2; ЧН=0,00"));
		ЗаменитьПараметр(ДокументВорд,"КоличествоВсего",КоличествоВсего);
		ЗаменитьПараметр(ДокументВорд,"СуммаВсего",Формат(СуммаВсего,"ЧЦ=15; ЧДЦ=2"));
		
		СуммаПрописью = ПолучитьСуммуПрописью(СуммаВсего, СтруктураДанных.Валюта);
		Если СуммаНДСВсего > 0 Тогда
			СуммаПрописью = СуммаПрописью + " (в т.ч. НДС: " +  ПолучитьСуммуПрописью(СуммаНДСВсего, СтруктураДанных.Валюта) + " )";
		КонецЕсли;
		
		ЗаменитьПараметр(ДокументВорд,"СуммаПрописью",СуммаПрописью);
		
		//Доработка + (Станислав)
		ТекстУсловияОплаты = ПолучитьТекстУсловияОплаты(СтруктураДанных.ГрафикОплаты,СтруктураДанных.Валюта,СуммаВсего,СуммаНДСВсего);
		ТекстУсловияПоставки =ПолучитьТекстУсловияПоставки(СтруктураДанных.УсловияПоставки);
		//ТекстУсловияОплаты = ГрафикОплаты.ПолучитьОбъект();
		ТекстСрокПоставки  	= "Срок поставки: " + СокрЛП(СтруктураДанных.СрокПоставки) + " рабочих дней";
		
		ЗаменитьПараметрМногострочный(ДокументВорд,"УсловияОплаты",ТекстУсловияОплаты);
		ЗаменитьПараметр(ДокументВорд,"УсловияПоставки",ТекстУсловияПоставки);
		ЗаменитьПараметр(ДокументВорд,"СрокПоставки",ТекстСрокПоставки);
		//Доработка - (Станислав)
		
		//
		ЗаменитьПараметр(ДокументВорд,"ОрганизацияРеквизиты",СтруктураДанных.ОрганизацияРеквизиты);
		//ЗаменитьПараметр(ДокументВорд,"ОрганизацияРуководительДолжность",СтруктураДанных.ОрганизацияРуководительДолжность);
		// Доработка +
		ЗаменитьПараметр(ДокументВорд,"ОрганизацияРуководитель","Соколенко Д.В.");
		//ЗаменитьПараметр(ДокументВорд,"ОрганизацияРуководитель",СтруктураДанных.ОрганизацияРуководительСокращенно);
		// Доработка -
		
		ЗаменитьПараметр(ДокументВорд,"КонтрагентРеквизиты",СтруктураДанных.СведенияКонтрагентСтрокаСРеквизитами);
//		ЗаменитьПараметр(ДокументВорд,"КонтрагентРуководительДолжность",СтруктураДанных.КонтрагентРуководительДолжность);
		// Доработка +
		Если НЕ ПустаяСтрока(СтруктураДанных.КонтрагентРуководительДолжность) Тогда
	    ЗаменитьПараметр(ДокументВорд,"КонтрагентРуководительДолжность"," " + СтруктураДанных.КонтрагентРуководительДолжность + " " +СтруктураДанных.КонтрагентНаименованиеПолное);	
		Иначе
		ЗаменитьПараметр(ДокументВорд,"КонтрагентРуководительДолжность",СтруктураДанных.КонтрагентРуководительДолжность);	
		КонецЕсли;
	    // Доработка -
		ЗаменитьПараметр(ДокументВорд,"КонтрагентРуководитель",СтруктураДанных.КонтрагентРуководительСокращенно);
		
		
		
		//ДокументВорд.Application.Visible = Истина;
		ДокументВорд.Application.ActiveDocument.SaveAS(ИмяФайла);
		ДокументВорд.Application.ActiveDocument.Close();
		КомОбъект.Application.Quit(); 
		//2013-04-17
		//сохраняем файл в прикрепленные и открываем на редактирование.
		
		//ЗапуститьПриложение(ИмяФайла);
		Попытка
			АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайла), СсылкаНаОбъект.УникальныйИдентификатор());
			Файл = ДобавитьФайлСервер(СсылкаНаОбъект,ИмяФайлаБезРасширения,АдресФайлаВоВременномХранилище);
		Исключение
			Сообщить("Не удалось записать спецификацию для документа: "+ОписаниеОшибки()+" "+СсылкаНаОбъект,СтатусСообщения.ОченьВажное);
		КонецПопытки;
		УдалитьФайлы(ИмяФайла);
		Попытка
			ДанныеФайла = ПрисоединенныеФайлыКлиент.ПолучитьДанныеФайла(Файл,,Истина);
			ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла,истина ); //ложь);
		Исключение
			Сообщить("Не удалось открыть спецификацию для редактирования");
		КонецПопытки;
		
		
	КонецЦикла;
	
КонецПроцедуры // 



&НаКлиенте
Процедура ЗаменитьПараметр(Документ,Ключ,Значение)
	Замена = Документ.Content.Find;
	Замена.Execute("["+Ключ+"]", Ложь, Истина, Ложь, , , Истина, , Ложь, Лев(Строка(Значение),250));
КонецПроцедуры
&НаКлиенте
Процедура ЗаменитьПараметрМногострочный(Документ,Ключ,Значение)
	//Замена = Документ.Content.Find;
	//Замена.Execute("["+Ключ+"]", Ложь, Истина, Ложь, , , Истина, , Ложь, Лев(Строка(Значение),250));
	//ТекстПоиска = "@" + СокрЛП(ТекстПоиска) + "@"; 
	
	//wdReplaceAll = 2;
	//wdFindContinue = 1;
	//
	//Find = Документ.Content.Find;
	//
	//ОстатокТекстаЗамены = СтрДлина(Значение);    
	//i = 1;
	//
	//Для Счетчик = 1 По СтрЧислоСтрок(Значение) Цикл
	//	
	//	ТекСтрока = СтрПолучитьСтроку(Значение, Счетчик);
	//	Find.Forward = True;
	//	Find.Wrap = wdFindContinue;
	//	Find.Format = False;
	//	Find.MatchCase = False;
	//	Find.MatchWholeWord = False;
	//	Find.MatchWildcards = False;
	//	Find.MatchSoundsLike = False;
	//	Find.MatchAllWordForms = False;    
	//	
	//	Если Счетчик = СтрЧислоСтрок(Значение) Тогда
	//		Find.Execute("["+Ключ+"]", , , , , , , , ,"" + СокрЛП(ТекСтрока), wdReplaceAll);
	//	Иначе
	//		Find.Execute("["+Ключ+"]", , , , , , , , ,СокрЛП(ТекСтрока) + Символ(13)+Символ(10) + "["+Ключ+"]", wdReplaceAll);
	//	КонецЕсли;
	//
	//КонецЦикла;
	
	wdReplaceAll = 3;
	wdFindContinue = 1;
	
	Find = Документ.Content.Find;
	Если  СтрДлина(Значение) > 231 Тогда
		
		ОстатокТекстаЗамены = СтрДлина(Значение);    
		i = 1;
		
		Пока ОстатокТекстаЗамены > 231 Цикл
			ПорцияТекстаНаЗамену255 = Сред(Значение, i, 231);         
			Find.Forward = True;
			Find.Wrap = wdFindContinue;
			Find.Format = False;
			Find.MatchCase = False;
			Find.MatchWholeWord = False;
			Find.MatchWildcards = False;
			Find.MatchSoundsLike = False;
			Find.MatchAllWordForms = False;  
			
			
			//		Find.Execute("["+Ключ+"]", , , , , , , , ,"" + СокрЛП(ТекСтрока), wdReplaceAll);
			//	Иначе
			//		Find.Execute("["+Ключ+"]", , , , , , , , ,СокрЛП(ТекСтрока) + Символ(13)+Символ(10) + "["+Ключ+"]", wdReplaceAll);
			//	КонецЕсли;
			
			
			Find.Execute("["+Ключ+"]", , , , , , , , ,СокрЛП(ПорцияТекстаНаЗамену255) + "["+Ключ+"]", wdReplaceAll);
			i = i + 231;
			ОстатокТекстаЗамены = СтрДлина(Значение) - i;
		КонецЦикла;
		ПорцияТекстаНаЗамену255 = Сред(Значение, i, 231); 
		//Find.Execute("["+Ключ+"]", , , , , , , , ,СокрЛП(ПорцияТекстаНаЗамену255) , wdReplaceAll);
		Find.Execute("["+Ключ+"]", Ложь, Истина, Ложь, , , Истина, , Ложь, СокрЛП(ПорцияТекстаНаЗамену255));
	Иначе
		Find.Execute("["+Ключ+"]", Ложь, Истина, Ложь, , , Истина, , Ложь, Лев(Строка(Значение),250));
	КонецЕсли;
	
	
	
КонецПроцедуры


﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,"ИспользованиеХарактеристикТовар","Видимость",ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры"));
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Объект, "ГруппаДополнительныеРеквизиты");
	
	НастроитьЭлементыДополнительныхРеквизитов();
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	НаименованиеЕдиницыИзмеренияВеса = Строка(Константы.ЕдиницаИзмеренияВеса.Получить());
	НаименованиеЕдиницыИзмеренияОбъема = Строка(Константы.ЕдиницаИзмеренияОбъема.Получить());
	
	Если НЕ Объект.ИспользоватьУпаковки Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НаборУпаковок",
			"ТолькоПросмотр", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьУпаковки",
			"ТолькоПросмотр", Ложь);
	КонецЕсли;
	
	УправлениеДоступом.ПриСозданииФормыЗначенияДоступа(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЕстьПравоРедактирования = Справочники.ГруппыДоступаНоменклатуры.ЕстьПравоИзменения(Объект);
		ЭтаФорма.ТолькоПросмотр = НЕ ЕстьПравоРедактирования;
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "АдресКартинки",
			"ТолькоПросмотр", НЕ ЕстьПравоРедактирования);
	Иначе
		ЕстьПравоРедактирования = Истина;
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьУпаковки",
		"ТолькоПросмотр", Объект.ИспользоватьУпаковки);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НаборУпаковок",
		"ТолькоПросмотр", Объект.ИспользоватьУпаковки);
	
	ИспользоватьАссортимент = ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ХарактеристикаМногооборотнаяТара",
		"Видимость", ПолучитьФункциональнуюОпцию("ИспользоватьМногооборотнуюТару"));
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ШаблонРабочегоНаименованияНоменклатуры");
	СтруктураРеквизитов.Вставить("ЗапретРедактированияРабочегоНаименованияНоменклатуры");
	СтруктураРеквизитов.Вставить("ШаблонНаименованияДляПечатиНоменклатуры");
	СтруктураРеквизитов.Вставить("ЗапретРедактированияНаименованияНоменклатурыДляПечати");
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидНоменклатуры, СтруктураРеквизитов);
	
	ШаблонНаименованияДляПечати = РеквизитыОбъекта.ШаблонНаименованияДляПечатиНоменклатуры;
	ШаблонРабочегоНаименования  = РеквизитыОбъекта.ШаблонРабочегоНаименованияНоменклатуры;
	
	ЗапретРедактированияНаименованияДляПечати = РеквизитыОбъекта.ЗапретРедактированияНаименованияНоменклатурыДляПечати;
	ЗапретРедактированияРабочегоНаименования  = РеквизитыОбъекта.ЗапретРедактированияРабочегоНаименованияНоменклатуры;
	
	ПриСозданииЧтенииНаСервере();

	Если Не Объект.ФайлКартинки.Пустая() Тогда
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	Конецесли;
	
	Если Не Объект.ФайлОписанияДляСайта.Пустая() Тогда
		ПутьКФайлуОписанию = Строка(Объект.ФайлОписанияДляСайта);
	КонецЕсли;
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИспользоватьИндивидуальныйШаблонЦенника  = ?(Объект.ИспользоватьИндивидуальныйШаблонЦенника,1,0);
	ИспользоватьИндивидуальныйШаблонЭтикетки = ?(Объект.ИспользоватьИндивидуальныйШаблонЭтикетки,1,0);
	
	Если Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар
		Или Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.МногооборотнаяТара Тогда
		
		СтруктураРеквизитов = Новый Структура;
		СтруктураРеквизитов.Вставить("НастройкаИспользованияСерий");
		
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидНоменклатуры, СтруктураРеквизитов);
		УстановитьЗаголовокНастройкиИспользованияСерий(РеквизитыОбъекта.НастройкаИспользованияСерий);
		
	КонецЕсли;
	
	НастроитьПанельНавигации();
	
	ОбновитьДоступностьПоВидуНоменклатуры();
	ОбновитьДоступностьЕдиницыИзмерения(ЭтаФорма);
	ДоступностьШаблоновЭтикеток = ИспользоватьИндивидуальныйШаблонЭтикетки = 1;
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ШаблонЭтикетки",
		"Доступность", ДоступностьШаблоновЭтикеток);
	ДоступностьШаблоновЦенников = ИспользоватьИндивидуальныйШаблонЦенника = 1;
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ШаблонЦенника",
		"Доступность", ДоступностьШаблоновЦенников);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "НаборУпаковок",
		"Доступность", Объект.ИспользоватьУпаковки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обработчик механизма "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ПрисоединенныйФайл" Тогда
		
		Модифицированность = Истина;
		СсылкаНаФайл = ?(ТипЗнч(Источник) = Тип("Массив"), Источник[0], Источник);
		
		Если ВыборИзображения Тогда
			
			Объект.ФайлКартинки = СсылкаНаФайл;
			АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор);
			
		ИначеЕсли ВыборФайлаОписания Тогда
			
			Объект.ФайлОписанияДляСайта = СсылкаНаФайл;
			ПутьКФайлуОписанию = СсылкаНаФайл;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_ВидыНоменклатуры" Тогда
		
		НастроитьПанельНавигации();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.ИспользоватьИндивидуальныйШаблонЭтикетки = ?(ИспользоватьИндивидуальныйШаблонЭтикетки=1,Истина,Ложь);
	Объект.ИспользоватьИндивидуальныйШаблонЦенника = ?(ИспользоватьИндивидуальныйШаблонЦенника=1,Истина,Ложь);
	
	ФормироватьРабочееНаименование = Ложь;
	ФормироватьНаименованиеДляПечати = Ложь;
	
	Если (Не ЗначениеЗаполнено(Объект.Наименование)
		И ЗначениеЗаполнено(ШаблонРабочегоНаименования))
		Или ЗапретРедактированияРабочегоНаименования Тогда
		
		ФормироватьРабочееНаименование = Истина;
		
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(Объект.НаименованиеПолное)
		И ЗначениеЗаполнено(ШаблонНаименованияДляПечати))
		Или ЗапретРедактированияНаименованияДляПечати Тогда
		
		ФормироватьНаименованиеДляПечати = Истина;
		
	КонецЕсли;
	
	Если ФормироватьРабочееНаименование
		И ФормироватьНаименованиеДляПечати Тогда
		
		ЗаполнитьНаименованиеПоШаблонуКлиент("Оба");
		
	ИначеЕсли ФормироватьРабочееНаименование Тогда
		
		ЗаполнитьНаименованиеПоШаблонуКлиент("Рабочее");
		
	ИначеЕсли ФормироватьНаименованиеДляПечати Тогда
		
		ЗаполнитьНаименованиеПоШаблонуКлиент("ДляПечати");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	Если Не Объект.ЭтоГруппа Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочееНаименованиеСформировано");
		ТекущийОбъект.ДополнительныеСвойства.Вставить("НаименованиеДляПечатиСформировано");
		
		КонтролироватьУникальностьРабочегоНаименования = Константы.КонтролироватьУникальностьРабочегоНаименованияНоменклатурыИХарактеристик.Получить();
		
		Если Не ЗначениеЗаполнено(ТекущийОбъект.Наименование) Тогда
			ТекстСообщения = НСтр("ru='Поле ""Рабочее наименование"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Наименование", "Объект"); 
			Отказ = Истина;
		КонецЕсли;
		
		Если КонтролироватьУникальностьРабочегоНаименования
			И Не Отказ Тогда
			
			НаименованиеУникально = Справочники.Номенклатура.РабочееНаименованиеУникально(ТекущийОбъект);
			
			Если Не НаименованиеУникально Тогда
				ТекстСообщения = НСтр("ru='Значение поля ""Рабочее наименование"" не уникально'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Наименование", "Объект"); 
				Отказ = Истина;
			КонецЕсли;
			
			ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочееНаименованиеПроверено", Истина);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	НастроитьПанельНавигации();
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьУпаковки",
		"ТолькоПросмотр", Объект.ИспользоватьУпаковки);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НаборУпаковок",
		"ТолькоПросмотр", Объект.ИспользоватьУпаковки);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ФайлКартинкиПриИзменении(Элемент)

	Если Не Объект.ФайлКартинки.Пустая() Тогда
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	Конецесли;

КонецПроцедуры // ФайлКартинкиПриИзменении()

&НаКлиенте
Процедура НаборУпаковокПриИзменении(Элемент)
	
	ИндивидуальныеУпаковки = Объект.НаборУпаковок = ПредопределенноеЗначение("Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры");
	
	Если Объект.ИспользоватьУпаковки
		И Не ИндивидуальныеУпаковки  Тогда
		НаборУпаковокПриИзмененииСервер();
	КонецЕсли;
	
	ОбновитьДоступностьЕдиницыИзмерения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборУпаковокОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Объект.НаборУпаковок = ПредопределенноеЗначение("Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
			
			Если НЕ ЭтаФорма.Записать() Тогда
				
				ТекстСообщения = НСтр("ru='Ошибка записи элемента!'");
				Предупреждение(ТекстСообщения);
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Отбор = Новый Структура;
		Отбор.Вставить("Владелец", Объект.Ссылка);
		
		ОткрытьФорму("Справочник.УпаковкиНоменклатуры.Форма.ФормаСписка", Новый Структура("Отбор", Отбор), ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияМногострочногоТекста(Элемент.ТекстРедактирования,
		Объект.Описание, Модифицированность, НСтр("ru = 'Дополнительная информация'"));
	
КонецПроцедуры

&НаКлиенте
Процедура АдресКартинкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗаблокироватьДанныеФормыДляРедактирования();
	ДобавитьИзображениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУпаковкиПриИзменении(Элемент)
	
	Если Не Объект.ИспользоватьУпаковки Тогда
		Объект.НаборУпаковок = Неопределено;
	КонецЕсли;
	
	ОбновитьДоступностьЕдиницыИзмерения(ЭтаФорма);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "НаборУпаковок",
		"Доступность", Объект.ИспользоватьУпаковки);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОписанияДляСайтаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьФайлОписаниеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИндивидуальныйШаблонЭтикеткаПриИзменении(Элемент)
	
	Если ИспользоватьИндивидуальныйШаблонЭтикетки = 0 Тогда
		Объект.ШаблонЭтикетки = ПредопределенноеЗначение("Справочник.ШаблоныЭтикетокИЦенников.ПустаяСсылка");
	КонецЕсли;
	
	ДоступностьШаблоновЭтикеток = ИспользоватьИндивидуальныйШаблонЭтикетки = 1;
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ШаблонЭтикетки",
		"Доступность", ДоступностьШаблоновЭтикеток);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИндивидуальныйШаблонЦенникПриИзменении(Элемент)
	
	Если ИспользоватьИндивидуальныйШаблонЦенника = 0 Тогда
		Объект.ШаблонЦенника = ПредопределенноеЗначение("Справочник.ШаблоныЭтикетокИЦенников.ПустаяСсылка");
	КонецЕсли;
	
	ДоступностьШаблоновЦенников = ИспользоватьИндивидуальныйШаблонЦенника = 1;
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ШаблонЦенника",
		"Доступность", ДоступностьШаблоновЦенников);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОписанияДляСайтаОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.ФайлОписанияДляСайта = ПредопределенноеЗначение("Справочник.НоменклатураПрисоединенныеФайлы.ПустаяСсылка");
	ПутьКФайлуОписанию = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	ВидНоменклатурыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)

	Если ПустаяСтрока(Объект.НаименованиеПолное) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПроизводительПриИзменении(Элемент)
	
	Если ИспользоватьАссортимент Тогда
		ПроизводительПриИзмененииСервер()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставляетсяВМногооборотнойТареПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовМногооборотнойТары(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура НоменклатураМногооборотнаяТараПриИзменении(Элемент)
	НоменклатураМногооборотнаяТараПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ТоварнаяКатегорияПриИзменении(Элемент)
	
	ТоварнаяКатегорияПриИзмененииСервер();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		
		Результат = ОткрытьФормуМодально("Справочник.Номенклатура.Форма.РазблокированиеРеквизитов");
		
		Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
			
			ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаименованиеДляПечатиПоШаблону(Команда)
	
	ЗаполнитьНаименованиеПоШаблонуКлиент("ДляПечати");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРабочееНаименованиеПоШаблону(Команда)
	
	ЗаполнитьНаименованиеПоШаблонуКлиент("Рабочее");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКартинкуИзПрисоединенныхФайлов(Команда)
	
	ПараметрыВыбора = Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе", Объект.Ссылка, Истина);
	ЗначениеВыбора = ОткрытьФормуМодально("ОбщаяФорма.ВыборПрисоединенныхФайлов", ПараметрыВыбора);
	
	Если ЗначениеЗаполнено(ЗначениеВыбора) Тогда
		
		Объект.ФайлКартинки = ЗначениеВыбора;
		АдресКартинки = НавигационнаяСсылкаКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОписаниеИзПрисоединенныхФайлов(Команда)
	
	ПараметрыВыбора = Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе", Объект.Ссылка, Истина);
	ЗначениеВыбора = ОткрытьФормуМодально("ОбщаяФорма.ВыборПрисоединенныхФайлов", ПараметрыВыбора);
	
	Если ЗначениеЗаполнено(ЗначениеВыбора) Тогда
		
		Объект.ФайлОписанияДляСайта = ЗначениеВыбора;
		ПутьКФайлуОписанию = ЗначениеВыбора;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображение(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Записать();
		Иначе 
			Возврат
		КонецЕсли;
		
	КонецЕсли;
	
	ВыборИзображения = Истина;
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	
	ПрисоединенныеФайлыКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла);
	ВыборИзображения = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИзображение(Команда)
	
	Объект.ФайлКартинки = ПредопределенноеЗначение("Справочник.НоменклатураПрисоединенныеФайлы.ПустаяСсылка");
	АдресКартинки = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьИзображение(Команда)
	
	ПросмотретьПрисоединенныйФайл();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИзображение(Команда)
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		
		ПрисоединенныеФайлыКлиент.ОткрытьФормуПрисоединенногоФайла(Объект.ФайлКартинки);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутствует изображение для редактирования'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// При изменении реквизитов

&НаСервере
Процедура ВидНоменклатурыПриИзмененииНаСервере()
	
	ОбновитьЭлементыДополнительныхРеквизитов();
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ШаблонРабочегоНаименованияНоменклатуры");
	СтруктураРеквизитов.Вставить("ЗапретРедактированияРабочегоНаименованияНоменклатуры");
	СтруктураРеквизитов.Вставить("ШаблонНаименованияДляПечатиНоменклатуры");
	СтруктураРеквизитов.Вставить("ЗапретРедактированияНаименованияНоменклатурыДляПечати");
	СтруктураРеквизитов.Вставить("ТипНоменклатуры");
	СтруктураРеквизитов.Вставить("ИспользованиеХарактеристик");
	СтруктураРеквизитов.Вставить("ГруппаДоступа");
	СтруктураРеквизитов.Вставить("ВариантОформленияПродажи");
	СтруктураРеквизитов.Вставить("НастройкаИспользованияСерий");
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидНоменклатуры, СтруктураРеквизитов);
	
	ШаблонНаименованияДляПечати = РеквизитыОбъекта.ШаблонНаименованияДляПечатиНоменклатуры;
	ШаблонРабочегоНаименования  = РеквизитыОбъекта.ШаблонРабочегоНаименованияНоменклатуры;
	
	ЗапретРедактированияНаименованияДляПечати = РеквизитыОбъекта.ЗапретРедактированияНаименованияНоменклатурыДляПечати;
	ЗапретРедактированияРабочегоНаименования  = РеквизитыОбъекта.ЗапретРедактированияРабочегоНаименованияНоменклатуры;
	
	Объект.ТипНоменклатуры            = РеквизитыОбъекта.ТипНоменклатуры;
	Объект.ИспользованиеХарактеристик = РеквизитыОбъекта.ИспользованиеХарактеристик;
	Объект.ВариантОформленияПродажи   = РеквизитыОбъекта.ВариантОформленияПродажи;
	Объект.ГруппаДоступа              =
		Справочники.ГруппыДоступаНоменклатуры.ПолучитьГруппуДоступаПоУмолчанию(
			Новый Структура("ГруппаДоступа, Ссылка", РеквизитыОбъекта.ГруппаДоступа, Объект.Ссылка));
	
	Если Объект.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Товар
		И Объект.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.МногооборотнаяТара Тогда
		
		Объект.ИспользоватьУпаковки = Ложь;
		Объект.ВестиУчетПоГТД       = Ложь;
		Объект.ПодакцизныйТовар     = Ложь;
		Объект.НаборУпаковок        = Справочники.НаборыУпаковок.ПустаяСсылка();
		Объект.Вес                  = 0;
		Объект.Объем                = 0;
		Объект.СкладскаяГруппа      = Справочники.СкладскиеГруппыНоменклатуры.ПустаяСсылка();
		Объект.Качество             = Перечисления.ГрадацииКачества.Новый;
		
	Иначе
		
		УстановитьЗаголовокНастройкиИспользованияСерий(РеквизитыОбъекта.НастройкаИспользованияСерий)
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ВидНоменклатуры) Тогда
		
		Если ЗначениеЗаполнено(ШаблонРабочегоНаименования) Тогда
			Объект.Наименование = "";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ШаблонНаименованияДляПечати) Тогда
			Объект.НаименованиеПолное = "";
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьДоступностьПоВидуНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПанельНавигации()
	
	РеквизитыВидаНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидНоменклатуры,
		"ИспользованиеХарактеристик, ИспользоватьСерии");
	
	ЭтоТовар  = (Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар);
	ЭтоМногооборотнаяТара  = (Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.МногооборотнаяТара);
	ЭтоРабота = (Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа);
	ИспользоватьСерииНоменклатурыКонтекст = РеквизитыВидаНоменклатуры.ИспользоватьСерии;
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьСерииНоменклатуры",    ИспользоватьСерииНоменклатурыКонтекст);
	СтруктураНастроек.Вставить("ИспользоватьУпаковкиНоменклатуры", Объект.ИспользоватьУпаковки);
	
	СтруктураНастроек.Вставить("ИспользоватьХарактеристикиНоменклатуры", 
	    ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") 
	    И (РеквизитыВидаНоменклатуры.ИспользованиеХарактеристик) 
	       <> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать);
	
	СтруктураНастроек.Вставить("ИспользоватьСборкуРазборку", 
	    ЭтоТовар И ПолучитьФункциональнуюОпцию("ИспользоватьСборкуРазборку"));
		
	ИспользоватьРазмещениеВЯчейках = (ПолучитьФункциональнуюОпцию("ИспользоватьАдресноеХранение", Новый Структура)
									Или ПолучитьФункциональнуюОпцию("ИспользоватьПодпиткуЗонБыстрогоОтбора", Новый Структура)
									Или ПолучитьФункциональнуюОпцию("ИспользоватьАдресноеХранениеСправочно", Новый Структура))
									И (ЭтоТовар Или ЭтоМногооборотнаяТара);
	
	СтруктураНастроек.Вставить("ИспользоватьЛогистическиеПараметры",          ЭтоТовар ИЛИ ЭтоМногооборотнаяТара ИЛИ ЭтоРабота);
	СтруктураНастроек.Вставить("ИспользоватьРазмещениеВЯчейках",              ИспользоватьРазмещениеВЯчейках);
	СтруктураНастроек.Вставить("ИспользоватьФинансовыйУчет",                  ЭтоТовар ИЛИ ЭтоМногооборотнаяТара);
	СтруктураНастроек.Вставить("ИспользоватьABCXYZКлассификациюНоменклатуры", ЭтоТовар ИЛИ ЭтоМногооборотнаяТара);
	СтруктураНастроек.Вставить("ИспользоватьПодобныеТовары",                  ЭтоТовар ИЛИ ЭтоМногооборотнаяТара);
	СтруктураНастроек.Вставить("ИспользоватьОтчетыПоДвижениямИОстаткам",      ЭтоТовар ИЛИ ЭтоМногооборотнаяТара);
	
	ОбщегоНазначенияУТ.НастроитьФормуПоПараметрам(ЭтаФорма, СтруктураНастроек);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыДополнительныхРеквизитов()
	
	Для Каждого Элемент Из Элементы.ГруппаДополнительныеРеквизиты.ПодчиненныеЭлементы Цикл
		
		Если Элемент.Вид = ВидПоляФормы.ПолеВвода Тогда
			
			Если Элемент.МногострочныйРежим <> Истина Тогда
				
				Элемент.РастягиватьПоГоризонтали = Ложь;
				
			Иначе
				
				Элемент.ПоложениеЗаголовка       = ПоложениеЗаголовкаЭлементаФормы.Лево;
				Элемент.РастягиватьПоВертикали   = Ложь;
				Элемент.РастягиватьПоГоризонтали = Истина;
				
			КонецЕсли;
			
		ИначеЕсли Элемент.Вид = ВидПоляФормы.ПолеФлажка Тогда
			
			Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НаборУпаковокПриИзмененииСервер()
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.НаборУпаковок, Новый Структура("ЕдиницаИзмерения"));
	ЗаполнитьЗначенияСвойств(Объект, РеквизитыОбъекта);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НавигационнаяСсылкаКартинки(ФайлКартинки, ИдентификаторФормы)
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(ФайлКартинки, ИдентификаторФормы).СсылкаНаДвоичныеДанныеФайла;
	
КонецФункции

&НаСервере
Процедура УстановитьЗаголовокНастройкиИспользованияСерий(НастройкаИспользованияСерийСсылка)
	Если Не ЗначениеЗаполнено(НастройкаИспользованияСерийСсылка) Тогда
		НастройкаИспользованияСерий = НСтр("ru = 'Не используются'");
	ИначеЕсли НастройкаИспользованияСерийСсылка= Перечисления.НастройкиИспользованияСерийНоменклатуры.ПартияТоваровПоНомеру Тогда
		НастройкаИспользованияСерий = НСтр("ru = 'Партии товаров с одинаковым номером'");
	ИначеЕсли НастройкаИспользованияСерийСсылка = Перечисления.НастройкиИспользованияСерийНоменклатуры.ПартияТоваровПоНомеруИСрокуГодности Тогда
		НастройкаИспользованияСерий = НСтр("ru = 'Партии товаров с одинаковым номером и сроком годности'");
	ИначеЕсли НастройкаИспользованияСерийСсылка = Перечисления.НастройкиИспользованияСерийНоменклатуры.ПартияТоваровПоСрокуГодности Тогда
		НастройкаИспользованияСерий = НСтр("ru = 'Партии товаров с одинаковым сроком годности'");
	ИначеЕсли НастройкаИспользованияСерийСсылка = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара Тогда
		НастройкаИспользованияСерий = НСтр("ru = 'Экземпляры товаров с уникальным серийным номером'");
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьПоВидуНоменклатуры()
	
	ЭтоТовар = Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар;
	ЭтоМногооборотнаяТара = Объект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.МногооборотнаяТара;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПоставляетсяВМногооборотнойТаре",
		"Доступность",
		ЭтоТовар);
	ОбновитьДоступностьЭлементовМногооборотнойТары(ЭтаФорма);
	
	Если ЭтоТовар Или ЭтоМногооборотнаяТара Тогда
		Элементы.СтраницыТоварУслуга.ТекущаяСтраница = Элементы.СтраницаТовар;
	Иначе
		Элементы.СтраницыТоварУслуга.ТекущаяСтраница = Элементы.СтраницаУслуга;
	КонецЕсли;
	
	ЗаполненВидНоменклатуры = ЗначениеЗаполнено(Объект.ВидНоменклатуры);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ЗаполнитьНаименованиеДляПечатиПоШаблону",
		"Доступность", ЗаполненВидНоменклатуры И ЗначениеЗаполнено(ШаблонНаименованияДляПечати));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ЗаполнитьРабочееНаименованиеПоШаблону",
		"Доступность", ЗаполненВидНоменклатуры И ЗначениеЗаполнено(ШаблонРабочегоНаименования));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "Наименование",
		"ТолькоПросмотр", ЗаполненВидНоменклатуры И ЗапретРедактированияРабочегоНаименования);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "НаименованиеПолное",
		"ТолькоПросмотр", ЗаполненВидНоменклатуры И ЗапретРедактированияНаименованияДляПечати);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ТоварнаяКатегория",
		"Доступность", ЗаполненВидНоменклатуры);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьЕдиницыИзмерения(Форма)
	
	ИндивидуальныеУпаковки = Форма.Объект.НаборУпаковок = ПредопределенноеЗначение("Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ЕдиницаИзмерения",
		"Доступность", (ИндивидуальныеУпаковки И Форма.Объект.ИспользоватьУпаковки) Или Не Форма.Объект.ИспользоватьУпаковки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьЭлементовМногооборотнойТары(Форма)
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"НоменклатураМногооборотнаяТара",
		"Доступность",
		Форма.Объект.ПоставляетсяВМногооборотнойТаре);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ХарактеристикаМногооборотнаяТара",
		"Доступность",
		Форма.Объект.ПоставляетсяВМногооборотнойТаре И Форма.ИспользуютсяХарактеристикиМногооборотнойТары);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	НастроитьЭлементыДополнительныхРеквизитов();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьИзображениеНаКлиенте()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора изображения необходимо записать объект. Записать?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Записать();
		Иначе 
			Возврат
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		
		ПросмотретьПрисоединенныйФайл();
		
	ИначеЕсли ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Не ЕстьПравоРедактирования Тогда
			
			ТекстИсключения = НСтр("ru = 'Нарушение прав доступа!'");
			ВызватьИсключение ТекстИсключения;
			
		КонецЕсли;
		
		ВыборИзображения = Истина;
		ИдентификаторФайла = Новый УникальныйИдентификатор;
		
		ПрисоединенныеФайлыКлиент.ДобавитьФайлы(Объект.Ссылка,
			ИдентификаторФайла, НоменклатураКлиент.ФильтрФайловИзображений());
		ВыборИзображения = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлОписаниеНаКлиенте()
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru='Для выбора файла описания необходимо записать объект. Записать?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Записать();
		Иначе 
			Возврат
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ФайлОписанияДляСайта) Тогда
		
		ПрисоединенныеФайлыКлиент.ОткрытьФормуПрисоединенногоФайла(Объект.ФайлОписанияДляСайта);
		
	Иначе
		
		ВыборФайлаОписания = Истина;
		ИдентификаторФайла = Новый УникальныйИдентификатор;
		
		ПрисоединенныеФайлыКлиент.ДобавитьФайлы(Объект.Ссылка, ИдентификаторФайла);
		ВыборФайлаОписания = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьПрисоединенныйФайл()
	
	ОчиститьСообщения();
	
	Если ЗначениеЗаполнено(Объект.ФайлКартинки) Тогда
		
		ДанныеФайла = ПрисоединенныеФайлыСлужебныйВызовСервера.ПолучитьДанныеФайла(ЭтаФорма.Объект.ФайлКартинки,
			УникальныйИдентификатор);
		ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Отсутствует изображение для просмотра'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресКартинки");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Номенклатура", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПроизводительПриИзмененииСервер()
		
	Объект.Марка = Справочники.Марки.ПолучитьМаркуПоУмолчанию(Объект.Производитель);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиенте
Процедура ЗаполнитьНаименованиеПоШаблонуКлиент(ВариантФормирования)
	
	ФормулыНаименования = ФормулыНаименования();
	
	Если ВариантФормирования = "Рабочее" Тогда
		Объект.Наименование = НоменклатураКлиент.НаименованиеПоФормуле(
								ФормулыНаименования.ФормулаРабочегоНаименования,
								Объект.ВидНоменклатуры);
	ИначеЕсли ВариантФормирования = "ДляПечати" Тогда 
		Объект.НаименованиеПолное = НоменклатураКлиент.НаименованиеПоФормуле(
								ФормулыНаименования.ФормулаНаименованияДляПечати,
								Объект.ВидНоменклатуры,
								Объект.Наименование);
	ИначеЕсли ВариантФормирования = "Оба" Тогда
		Объект.Наименование = НоменклатураКлиент.НаименованиеПоФормуле(
								ФормулыНаименования.ФормулаРабочегоНаименования,
								Объект.ВидНоменклатуры);
		Объект.НаименованиеПолное = НоменклатураКлиент.НаименованиеПоФормуле(
								ФормулыНаименования.ФормулаНаименованияДляПечати,
								Объект.ВидНоменклатуры,
								Объект.Наименование);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ФормулыНаименования()
	
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, Объект);
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	
	Результат = Новый Структура;
	Результат.Вставить("ФормулаРабочегоНаименования",
		НоменклатураСервер.ФормулаНаименования(ШаблонРабочегоНаименования, СправочникОбъект));
	Результат.Вставить("ФормулаНаименованияДляПечати",
		НоменклатураСервер.ФормулаНаименования(ШаблонНаименованияДляПечати, СправочникОбъект));
	
	Возврат Результат; 
		
КонецФункции

&НаКлиенте
Процедура ТоварнаяКатегорияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ТоварныеКатегории.ФормаВыбора", Новый Структура("Владелец",Объект.ВидНоменклатуры), Элемент);
КонецПроцедуры

&НаСервере
Процедура ТоварнаяКатегорияПриИзмененииСервер()
	
	АссортиментСервер.ПроверитьСоответствиеКатегорииВидуНоменклатуры(Объект);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураМногооборотнаяТараПриИзмененииСервер()
	
	ИспользуютсяХарактеристикиМногооборотнойТары = Справочники.Номенклатура.ХарактеристикиИспользуются(Объект.ХарактеристикаМногооборотнаяТара);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", Объект.ХарактеристикаМногооборотнаяТара);

	СтруктураСтроки = Новый Структура;
	СтруктураСтроки.Вставить("Номенклатура", Объект.НоменклатураМногооборотнаяТара);
	СтруктураСтроки.Вставить("Характеристика", Объект.ХарактеристикаМногооборотнаяТара);
	СтруктураСтроки.Вставить("ХарактеристикиИспользуются", ИспользуютсяХарактеристикиМногооборотнойТары);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтруктураСтроки, СтруктураДействий, Неопределено);

	Объект.НоменклатураМногооборотнаяТара = СтруктураСтроки.Номенклатура;
	Объект.ХарактеристикаМногооборотнаяТара = СтруктураСтроки.Характеристика;
	
	ИспользуютсяХарактеристикиМногооборотнойТары = СтруктураСтроки.ХарактеристикиИспользуются;
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ХарактеристикаМногооборотнаяТара",
		"Доступность", ИспользуютсяХарактеристикиМногооборотнойТары);
	
КонецПроцедуры
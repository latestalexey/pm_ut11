﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьОтчеты();
	
	УстановитьВидимостьГруппыПоиска(Элементы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ ВЫБРАННЫЕ ОТЧЕТЫ

&НаКлиенте
Процедура ВыбранныеОтчетыДоступностьПриИзменении(Элемент)
	
	ВыбранныйПользователь = Элементы.ВыбранныеОтчеты.ТекущиеДанные;
	
	ОбновляемаяСтрока = Отчеты.НайтиПоИдентификатору(ВыбранныйПользователь.ИдентификаторСтрокиОтчета);
	ОбновляемаяСтрока.Доступность = ВыбранныйПользователь.Доступность;
	
	Если НЕ ВыбранныйПользователь.Доступность Тогда
		
		ВыбранныеОтчеты.Удалить(ВыбранныеОтчеты.Индекс(ВыбранныйПользователь));
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Если Элементы.СтраницыВыбораОтчетов.ТекущаяСтраница = Элементы.СтраницаВыбранныхОтчетов Тогда
		Для Каждого ВыбранныйОтчет Из ВыбранныеОтчеты Цикл
			ТекущиеДанные = Отчеты.НайтиПоИдентификатору(ВыбранныйОтчет.ИдентификаторСтрокиОтчета);
			ТекущиеДанные.Доступность = ВыбранныйОтчет.Доступность;
			
		КонецЦикла; 
	Иначе
		ВыбранныеОтчеты.Очистить();
		
		ЗаполнитьСписокВыбранныхОтчетов();
		
	КонецЕсли;
	
	АдресХранилищаВыбранныхОтчетов = АдресХранилищаВыбранныхОтчетов();
	
	Закрыть(АдресХранилищаВыбранныхОтчетов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	//Установим отметку доступности
	Для Каждого ВариантОтчета Из Отчеты Цикл 
		ВариантОтчета.Доступность = Истина;
		
	КонецЦикла;
	
	ОбновитьСписокВыбранныхОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьТолькоВыбранныеОтчеты(Команда)
	
	ТолькоВыбранные = Элементы.ФормаПоказатьТолькоВыбранныеОтчеты.Пометка;
	
	Если ТолькоВыбранные Тогда
		
		Для Каждого ВыбранныйПользователь Из ВыбранныеОтчеты Цикл 
			
			ТекущиеДанные = Отчеты.НайтиПоИдентификатору(ВыбранныйПользователь.ИдентификаторСтрокиОтчета);
			ТекущиеДанные.Доступность = ВыбранныйПользователь.Доступность;
			
		КонецЦикла;
		
		Элементы.СтраницыВыбораОтчетов.ТекущаяСтраница = Элементы.СтраницаОтчетов;
		
	Иначе
		
		ВыбранныеОтчеты.Очистить();
		
		ЗаполнитьСписокВыбранныхОтчетов();
		
		Элементы.СтраницыВыбораОтчетов.ТекущаяСтраница = Элементы.СтраницаВыбранныхОтчетов;
		
	КонецЕсли;
	
	Элементы.ФормаПоказатьТолькоВыбранныеОтчеты.Пометка = Не ТолькоВыбранные;
	
	УстановитьВидимостьГруппыПоиска(Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	
	//Снимем отметку доступности
	Для Каждого ВариантОтчета Из Отчеты Цикл 
		ВариантОтчета.Доступность = Ложь;
		
	КонецЦикла;
	
	ОбновитьСписокВыбранныхОтчетов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Помещает во временное хранилище таблицу значений с выбранными отчетами
// и возвращает адрес
// 
// Возвращаемое значение:
//	Строка - адрес хранилища значений таблицы значений во временном хранилище
//
&НаСервере 
Функция АдресХранилищаВыбранныхОтчетов()
	
	ВыбранныеОтчетыОбъект = ДанныеФормыВЗначение(ВыбранныеОтчеты, Тип("ТаблицаЗначений"));
	
	АдресХранилищаВыбранныхОтчетов = ПоместитьВоВременноеХранилище(Новый ХранилищеЗначения(ВыбранныеОтчетыОбъект));
	
	Возврат АдресХранилищаВыбранныхОтчетов;
	
КонецФункции

&НаСервере 
Процедура ЗаполнитьОтчеты()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВариантыОтчетов", Параметры.ВариантыОтчетов.Выгрузить(,"ВариантОтчета"));
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ВариантыОтчетов.Ссылка КАК ВариантОтчета
	               |ПОМЕСТИТЬ ВариантыОтчетов
	               |ИЗ
	               |	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВариантыОтчетов.Ссылка КАК ВариантОтчета,
	               |	ВЫБОР
	               |		КОГДА ВариантыОтчетовВНесохраненномВариантеРасчета.Количество = 1
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК Доступность
	               |ИЗ
	               |	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ВариантыОтчетов.ВариантОтчета КАК ВариантОтчета,
	               |			КОЛИЧЕСТВО(ВариантыОтчетов.ВариантОтчета) КАК Количество
	               |		ИЗ
	               |			ВариантыОтчетов КАК ВариантыОтчетов
	               |		ГДЕ
	               |			ВариантыОтчетов.ВариантОтчета В(&ВариантыОтчетов)
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ВариантыОтчетов.ВариантОтчета) КАК ВариантыОтчетовВНесохраненномВариантеРасчета
	               |		ПО ВариантыОтчетов.Ссылка = ВариантыОтчетовВНесохраненномВариантеРасчета.ВариантОтчета
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВариантыОтчетов.Наименование";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		ОтчетыИзЗапроса = РезультатЗапроса.Выгрузить();
		
		Для каждого ОтчетИзЗапроса из ОтчетыИзЗапроса Цикл
			НовыйВариантОтчета = Отчеты.Добавить();
			
			ЗаполнитьЗначенияСвойств(НовыйВариантОтчета, ОтчетИзЗапроса);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗаполнитьСписокВыбранныхОтчетов()
	
	Для Каждого Отчет Из Отчеты Цикл
		
		Если Отчет.Доступность Тогда
			ИдентификаторСтрокиОтчета = Отчет.ПолучитьИдентификатор();
			
			НовыйВыбранныйПользователь = ВыбранныеОтчеты.Добавить();
			НовыйВыбранныйПользователь.ВариантОтчета = Отчет.ВариантОтчета;
			НовыйВыбранныйПользователь.Доступность = Истина;
			НовыйВыбранныйПользователь.ИдентификаторСтрокиОтчета = ИдентификаторСтрокиОтчета;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ВыбранныеОтчеты.Сортировать("ВариантОтчета");
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбновитьСписокВыбранныхОтчетов()
	
	ВыбранныеОтчеты.Очистить();
	
	ЗаполнитьСписокВыбранныхОтчетов();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура УстановитьВидимостьГруппыПоиска(Элементы)
	
	ТолькоВыбранные = Элементы.ФормаПоказатьТолькоВыбранныеОтчеты.Пометка;
	
	Элементы.ГруппаПоискаПоВсемОтчетам.Видимость = Не ТолькоВыбранные;
	Элементы.ГруппаПоискаПоВыбранным.Видимость = ТолькоВыбранные;

КонецПроцедуры



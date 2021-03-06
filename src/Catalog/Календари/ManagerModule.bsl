﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция читает данные календаря из регистра
//
// Параметры
//	Календарь		- Ссылка на текущий элемент справочника
//	НомерГода		- Номер года, за который необходимо прочитать календарь
//
// Возвращаемое значение
//	Массив		- массив, в котором хранятся даты, входящие в календарь
//
Функция ПрочитатьДанныеГрафикаИзРегистра(Календарь, НомерГода) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Календарь",	Календарь);
	Запрос.УстановитьПараметр("ТекущийГод",	НомерГода);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КалендарныеГрафики.ДатаГрафика КАК ДатаКалендаря
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Календарь = &Календарь
	|	И КалендарныеГрафики.Год = &ТекущийГод
	|	И КалендарныеГрафики.ДеньВключенВГрафик";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДатаКалендаря");
	
КонецФункции

// Функция формирует данные календаря на основе производственного календаря
//
// Параметры
//	Календарь		- Ссылка на текущий элемент справочника
//	НомерГода		- Номер года, за который необходимо прочитать календарь
//
// Возвращаемое значение
//	Массив		- массив, в котором хранятся даты, входящие в календарь
//
Функция ЗаполнитьПоДаннымПроизводственногоКалендаря(ПроизводственныйКалендарь, НомерГода, ВидКалендаря) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДанныеПроизводственногоКалендаря.Дата
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|ГДЕ
	|	ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
	|	И ДанныеПроизводственногоКалендаря.Год = &Год
	|	И ВЫБОР
	|			КОГДА &ВидКалендаря = ЗНАЧЕНИЕ(Перечисление.ВидыКалендарей.Пятидневка)
	|				ТОГДА ДанныеПроизводственногоКалендаря.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
	|			КОГДА &ВидКалендаря = ЗНАЧЕНИЕ(Перечисление.ВидыКалендарей.Шестидневка)
	|				ТОГДА ДанныеПроизводственногоКалендаря.ВидДня В (ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный), ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Суббота))
	|		КОНЕЦ");
	
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь",	ПроизводственныйКалендарь);
	Запрос.УстановитьПараметр("ВидКалендаря", 				ВидКалендаря);
	Запрос.УстановитьПараметр("Год", 						НомерГода);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Дата");
КонецФункции

// Процедура записывает данные графика в регистр
//
// Параметры
//	Календарь	- Ссылка на текущий элемент справочника
//	НомерГода	- Номер года, за который необходимо записать календарь
//	СписокДат	- список значений, в котором указано, какие даты входят в календарь
//
// Возвращаемое значение
//	Нет
//
Процедура ЗаписатьДанныеГрафикаВРегистр(Календарь, НомерГода, СписокДат) Экспорт
	
	НаборЗаписей = РегистрыСведений.КалендарныеГрафики.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Календарь.Установить(Календарь);
	НаборЗаписей.Отбор.Год.Установить(НомерГода);
	
	КоличествоРабочихДнейСНачалаГода = 0;
	
	Для НомерМесяца = 1 По 12 Цикл
		Для НомерДня = 1 По День(КонецМесяца(Дата(НомерГода, НомерМесяца, 1))) Цикл
			ДатаГрафика = Дата(НомерГода, НомерМесяца, НомерДня);
			
			Если ТипЗнч(СписокДат) = Тип("СписокЗначений") Тогда
				СтрокаТаблицыРегистра = СписокДат.НайтиПоЗначению(ДатаГрафика);
			Иначе 
				СтрокаТаблицыРегистра = СписокДат[ДатаГрафика];
			КонецЕсли;
			
			Если СтрокаТаблицыРегистра <> Неопределено Тогда
				КоличествоРабочихДнейСНачалаГода = КоличествоРабочихДнейСНачалаГода + 1;
			КонецЕсли;
			
			Строка = НаборЗаписей.Добавить();
			Строка.Календарь							= Календарь;
			Строка.Год									= НомерГода;
			Строка.ДатаГрафика							= ДатаГрафика;
			Строка.ДеньВключенВГрафик					= СтрокаТаблицыРегистра <> Неопределено;
			Строка.КоличествоДнейВГрафикеСНачалаГода	= КоличествоРабочихДнейСНачалаГода;
		КонецЦикла;
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

// Обновляет календарь в соответствии с изменениями производственного календаря
//
// Параметры
// Изменения - ТаблицаЗначний с колонками ПроизводственныйКалендарь, Год, Дата, ВидДня, УПОРЯДОЧИТЬ ПО ПроизводственныйКалендарь, Год, Дата
//
Процедура ОбновитьКалендариПоДаннымПроизводственныхКалендарей(Изменения) Экспорт
	
	ТекущийКалендарь = Неопределено;
	ТекущийГод = Неопределено;
	НаборыДней = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Календари.Ссылка КАК Календарь
	               |ИЗ
	               |	РегистрСведений.РучноеИзменениеКалендарей КАК РучноеИзменениеКалендарей
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
	               |		ПО РучноеИзменениеКалендарей.Календарь = Календари.Ссылка
	               |ГДЕ
	               |	Календари.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
	               |	И РучноеИзменениеКалендарей.РучноеИзменение = ЛОЖЬ";
				   
	Для Каждого Изменение из Изменения Цикл 
		
		Если ТекущийКалендарь <> Изменение.ПроизводственныйКалендарь Или ТекущийГод <> Изменение.Год Тогда
			Если НаборыДней.Количество() > 0 Тогда
				Для Каждого НаборДней Из НаборыДней Цикл 
					ЗаписатьДанныеГрафикаВРегистр(НаборДней.Ключ, ТекущийГод, НаборДней.Значение);
				КонецЦикла;
				НаборыДней.Очистить();
			КонецЕсли;
				
			Запрос.УстановитьПараметр("ПроизводственныйКалендарь", Изменение.ПроизводственныйКалендарь);
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				НаборыДней.Вставить(Выборка.Календарь, СоответствиеДней(ПрочитатьДанныеГрафикаИзРегистра(
					Выборка.Календарь, Изменение.Год)));
			КонецЦикла;
			ТекущийКалендарь = Изменение.ПроизводственныйКалендарь;
			ТекущийГод = Изменение.Год;
			
		КонецЕсли;
		
		Для Каждого НаборДней Из НаборыДней Цикл 
			Если Изменение.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Или
				Изменение.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный Или
				(Изменение.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота И 
				НаборДней.Ключ.ВидКалендаря = Перечисления.ВидыКалендарей.Шестидневка) Тогда
				// выходной -> рабочий
				НаборДней.Значение.Вставить(Изменение.Дата, Истина);
			Иначе
				// рабочий -> выходной
				НаборДней.Значение.Удалить(Изменение.Дата);
			КонецЕсли
		КонецЦикла;			
	КонецЦикла;
	
	Если НаборыДней.Количество() > 0 Тогда
		Для Каждого НаборДней Из НаборыДней Цикл 
			ЗаписатьДанныеГрафикаВРегистр(НаборДней.Ключ, ТекущийГод, НаборДней.Значение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция СоответствиеДней(Знач ДниГрафика)
	
	Результат = Новый Соответствие;
	Для каждого День из ДниГрафика Цикл
		Результат.Вставить(День, Истина);
	КонецЦикла;
	
	Возврат Результат
КонецФункции


#КонецЕсли
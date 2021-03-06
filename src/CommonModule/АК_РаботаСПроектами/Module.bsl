﻿
// Заполняет коды СДР всех задач проекта 
Процедура ЗаполнитьКодыСДРПроектныхЗадач(Проект) Экспорт
	
	// Коды СДР обычных задач
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПроектныеЗадачи.Ссылка,
	|	ПроектныеЗадачи.акНомерЗадачиВУровне КАК НомерЗадачиВУровне,
	|	ПроектныеЗадачи.Наименование,
	|	ПроектныеЗадачи.ПометкаУдаления,
	|	ПроектныеЗадачи.акКодСДР КАК КодСДР
	|ИЗ
	|	Справочник.ЗадачиПроектов КАК ПроектныеЗадачи
	|ГДЕ
	|	ПроектныеЗадачи.Родитель = ЗНАЧЕНИЕ(Справочник.ЗадачиПроектов.ПустаяСсылка)
	|	И ПроектныеЗадачи.Владелец = &Проект
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПроектныеЗадачи.акНомерЗадачиВУровне,
	|	ПроектныеЗадачи.Наименование";
	Запрос.УстановитьПараметр("Проект", Проект);
	
	Результат = Запрос.Выполнить();	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Счетчик = 1;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПометкаУдаления Тогда
			КодСДР = "";
			НомерЗадачиВУровне = 9999;
		Иначе
			КодСДР = Строка(Счетчик);
			НомерЗадачиВУровне = Счетчик;
			
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если (Выборка.НомерЗадачиВУровне <> НомерЗадачиВУровне) Или (Выборка.КодСДР <> КодСДР) Тогда 
		    ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			ЗадачаОбъект.акНомерЗадачиВУровне = НомерЗадачиВУровне;
			ЗадачаОбъект.акКодСДР = КодСДР;
			
			ЗадачаОбъект.Записать();
		КонецЕсли; 
		
		ЗаполнитьКодыСДРПодчиненныхЗадач(Выборка.Ссылка);
	КонецЦикла;

КонецПроцедуры  

// Заполняет коды СДР подчиненных задач 
Процедура ЗаполнитьКодыСДРПодчиненныхЗадач(РодительСсылка, ИзмененныеЗадачи = Неопределено) Экспорт
	
	Если ИзмененныеЗадачи = Неопределено Тогда 
		ИзмененныеЗадачи = Новый Массив;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПроектныеЗадачи.Ссылка,
	|	ПроектныеЗадачи.акНомерЗадачиВУровне,
	|	ПроектныеЗадачи.Наименование,
	|	ПроектныеЗадачи.ПометкаУдаления,
	|	ПроектныеЗадачи.акКодСДР
	|ИЗ
	|	Справочник.ЗадачиПроектов КАК ПроектныеЗадачи
	|ГДЕ
	|	ПроектныеЗадачи.Родитель = &РодительСсылка
	|	И ПроектныеЗадачи.Владелец = &Проект
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПроектныеЗадачи.акНомерЗадачиВУровне,
	|	ПроектныеЗадачи.Наименование";
	Запрос.УстановитьПараметр("РодительСсылка", РодительСсылка);
	Запрос.УстановитьПараметр("Проект", РодительСсылка.Владелец);
	
	КодРодителя = РодительСсылка.акКодСДР;
	
	Результат = Запрос.Выполнить();	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Счетчик = 1;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПометкаУдаления Тогда
			КодСДР = "";
			НомерЗадачиВУровне = 9999;
		Иначе	
			Если Не ЗначениеЗаполнено(КодРодителя) Тогда
				КодСДР = Строка(Счетчик);
			Иначе
				КодСДР = КодРодителя + "." + Строка(Счетчик);
			КонецЕсли;
			НомерЗадачиВУровне = Счетчик;
			
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если (Выборка.акНомерЗадачиВУровне <> НомерЗадачиВУровне) Или (Выборка.акКодСДР <> КодСДР) Тогда 
		    ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			ЗадачаОбъект.акНомерЗадачиВУровне = НомерЗадачиВУровне;
			ЗадачаОбъект.акКодСДР = КодСДР; 
		
			ЗадачаОбъект.Записать();
			ИзмененныеЗадачи.Добавить(ЗадачаОбъект.Ссылка);
		КонецЕсли;
		
		ЗаполнитьКодыСДРПодчиненныхЗадач(Выборка.Ссылка, ИзмененныеЗадачи);
	КонецЦикла;	
	
КонецПроцедуры

// Возвращает массив проектных задач одного уровня с переданной 
Функция ПолучитьМассивЗадачОдногоУровняСУказанной(Проект, Задача) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПроектныеЗадачи.Ссылка
	|ИЗ
	|	Справочник.ЗадачиПроектов КАК ПроектныеЗадачи
	|ГДЕ
	|	ПроектныеЗадачи.Родитель = &Родитель
	|	И ПроектныеЗадачи.Владелец = &Проект
	|	И НЕ ПроектныеЗадачи.ПометкаУдаления";
		
	Запрос.УстановитьПараметр("Родитель", Задача.Родитель);
	Запрос.УстановитьПараметр("Проект", Проект);	
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции


// Возвращает максимальный номер проектной задачи в пределах родителя 
Функция ПолучитьМаксимальныйНомерЗадачиУровня(Проект, РодительСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(ПроектныеЗадачи.акНомерЗадачиВУровне), 0) КАК НомерЗадачиВУровне
	|ИЗ
	|	Справочник.ЗадачиПроектов КАК ПроектныеЗадачи
	|ГДЕ
	|	ПроектныеЗадачи.Родитель = &РодительСсылка
	|	И ПроектныеЗадачи.Владелец = &Проект
	|	И Не ПроектныеЗадачи.ПометкаУдаления";
		
	Запрос.УстановитьПараметр("РодительСсылка", РодительСсылка);	
	Запрос.УстановитьПараметр("Проект", Проект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.НомерЗадачиВУровне;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

Функция ПолучитьКодСДРИНомерЗадачиВУровне(Проект, Родитель) Экспорт 
	
	МаксимальныйНомер = ПолучитьМаксимальныйНомерЗадачиУровня(Проект, Родитель);
	КодСДРСтрока = "";
	Если ЗначениеЗаполнено(Родитель) Тогда
		КодСДРСтрока = Родитель.акКодСДР;	
	КонецЕсли;
	НомерЗадачиВУровне = МаксимальныйНомер + 1;
	КодСДР = 
		КодСДРСтрока
		+ ?(ЗначениеЗаполнено(КодСДРСтрока), ".", "")
		+ Строка(НомерЗадачиВУровне);
		
	ДанныеВозврата = Новый Структура;
	ДанныеВозврата.Вставить("КодСДР", КодСДР);
	ДанныеВозврата.Вставить("НомерЗадачиВУровне", НомерЗадачиВУровне);
	
	Возврат ДанныеВозврата;
	
КонецФункции

Функция ЕстьПроектныеЗадачи(Проект) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	Справочник.ЗадачиПроектов КАК ПроектныеЗадачи
	|ГДЕ
	|	ПроектныеЗадачи.Владелец = &Проект
	|	И НЕ ПроектныеЗадачи.ПометкаУдаления";
	Запрос.УстановитьПараметр("Проект", Проект);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция СформироватьДанныеВыбораЗадачиПроекта(Текст, Проект) Экспорт 
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПроектныеЗадачи.Ссылка КАК Ссылка,
		|	ПроектныеЗадачи.акКодСДР
		|ИЗ
		|	Справочник.ЗадачиПроектов КАК ПроектныеЗадачи
		|ГДЕ
		|	ПроектныеЗадачи.Владелец = &Проект
		|	И (ПроектныеЗадачи.Наименование ПОДОБНО &Текст
		|			ИЛИ ПроектныеЗадачи.акКодСДР ПОДОБНО &Текст)
		|	И (НЕ ПроектныеЗадачи.ПометкаУдаления)";
	
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, Строка(Выборка.Ссылка) + " (" + Строка(Выборка.акКодСДР) + ")");
	КонецЦикла;	
	
	Возврат ДанныеВыбора;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////

// Возвращает предшественников переданной задачи без учета суммарных задач
Функция ПолучитьПредшественников(ПроектнаяЗадача, ВключатьНачалоПроекта = Истина) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПроектныеЗадачиПредшественники.Ссылка КАК Ссылка,
	|	ПроектныеЗадачиПредшественники.Предшественник КАК Предшественник,
	|	ПроектныеЗадачиПредшественники.ТипЗависимости
	|ИЗ
	|	Справочник.ЗадачиПроектов.Предшественники КАК ПроектныеЗадачиПредшественники
	|ГДЕ
	|	ПроектныеЗадачиПредшественники.Ссылка = &ПроектнаяЗадача
	|	И НЕ ПроектныеЗадачиПредшественники.Предшественник.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ПроектнаяЗадача", ПроектнаяЗадача);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если ВключатьНачалоПроекта Тогда 
		Если Результат.Найти(ПроектнаяЗадача, "Ссылка") = Неопределено Тогда 
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.Ссылка = ПроектнаяЗадача;
			НоваяСтрока.ТипЗависимости = Перечисления.ТипыЗависимостейПроектныхЗадач.ОкончаниеНачало;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	

// Возвращает всех предшественников переданной задачи с учетом суммарных задач
Функция ПолучитьВсехПредшественников(ПроектнаяЗадача, ВключатьНачалоПроекта = Истина) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗадач = Новый СписокЗначений;
	
	ТекРодитель = ПроектнаяЗадача;
	Пока ЗначениеЗаполнено(ТекРодитель) Цикл
		СписокЗадач.Добавить(ТекРодитель);
		ТекРодитель = ТекРодитель.Родитель;
	КонецЦикла;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПроектныеЗадачиПредшественники.Ссылка КАК Ссылка,
	|	ПроектныеЗадачиПредшественники.Предшественник КАК Предшественник,
	|	ПроектныеЗадачиПредшественники.ТипЗависимости
	|ИЗ
	|	Справочник.ЗадачиПроектов.Предшественники КАК ПроектныеЗадачиПредшественники
	|ГДЕ
	|	ПроектныеЗадачиПредшественники.Ссылка В(&СписокЗадач)
	|	И НЕ ПроектныеЗадачиПредшественники.Предшественник.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("СписокЗадач", СписокЗадач);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если ВключатьНачалоПроекта Тогда 
		НачалоПроекта = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ПроектнаяЗадача.Владелец, "ТекущийПланНачало");
		Для Каждого Строка Из СписокЗадач Цикл
			Если Результат.Найти(Строка.Значение, "Ссылка") = Неопределено Тогда 
				НоваяСтрока = Результат.Добавить();
				НоваяСтрока.Ссылка = Строка.Значение;
				НоваяСтрока.ТипЗависимости = Перечисления.ТипыЗависимостейПроектныхЗадач.ОкончаниеНачало;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции	


// Выдает исключение, если по проектной задаче указаны некорректные предшественники
Процедура ПроверитьПредшественников(ПроектнаяЗадача) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Формируем родительские задачи
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроектныеЗадачи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЗадачиПроектов КАК ПроектныеЗадачи
		|ГДЕ
		|	ПроектныеЗадачи.Ссылка = &ПроектнаяЗадача
		|	И НЕ ПроектныеЗадачи.ПометкаУдаления
		|ИТОГИ ПО
		|	Ссылка ТОЛЬКО ИЕРАРХИЯ";

	Запрос.УстановитьПараметр("ПроектнаяЗадача", ПроектнаяЗадача);

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	ПроектныеЗадачиРодители = Новый СписокЗначений();
	
	Пока Выборка.Следующий() Цикл
		Если ПроектныеЗадачиРодители.НайтиПоЗначению(Выборка.Ссылка) = Неопределено Тогда
			ПроектныеЗадачиРодители.Добавить(Выборка.Ссылка);	
		КонецЕсли;
	КонецЦикла;
	
	// Формируем подчиненные задачи
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроектныеЗадачи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЗадачиПроектов КАК ПроектныеЗадачи
		|ГДЕ
		|	ПроектныеЗадачи.Ссылка В ИЕРАРХИИ(&ПроектнаяЗадача)
		|	И НЕ ПроектныеЗадачи.ПометкаУдаления
		|ИТОГИ ПО
		|	Ссылка ТОЛЬКО ИЕРАРХИЯ";

	Запрос.УстановитьПараметр("ПроектнаяЗадача", ПроектнаяЗадача);

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	ПроектныеЗадачиПодчиненные = Новый СписокЗначений();

	Пока Выборка.Следующий() Цикл
		Если ПроектныеЗадачиПодчиненные.НайтиПоЗначению(Выборка.Ссылка) = Неопределено Тогда
			ПроектныеЗадачиПодчиненные.Добавить(Выборка.Ссылка);	
		КонецЕсли;
	КонецЦикла;

	// Проверка предшественников
	Для Каждого СтрокаТаблЧасти Из ПроектнаяЗадача.Предшественники Цикл
		Если СтрокаТаблЧасти.Предшественник = ПроектнаяЗадача Тогда
			ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Проектная задача не может быть предшественником самой себя'"), ПроектнаяЗадача));	
		КонецЕсли;
		Если ПроектныеЗадачиРодители.НайтиПоЗначению(СтрокаТаблЧасти.Предшественник) <> Неопределено Тогда
			ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Подчиненная задача %1 не может иметь в качестве предшественника одну из родительских задач'"), ПроектнаяЗадача));	
		КонецЕсли;
		Если ПроектныеЗадачиПодчиненные.НайтиПоЗначению(СтрокаТаблЧасти.Предшественник) <> Неопределено Тогда
			ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Суммарная задача %1 не может иметь в качестве предшественника одну из подчиненных задач'"), ПроектнаяЗадача));	
		КонецЕсли; 
	КонецЦикла;
	
	ОбработанныеЗадачи = Новый Массив;
	ПроверитьПредшественниковНаЗацикливание(ПроектнаяЗадача, ОбработанныеЗадачи);
	
	Для Каждого Строка Из ПроектныеЗадачиПодчиненные Цикл
		ОбработанныеЗадачи = Новый Массив;
		ПроверитьПредшественниковНаЗацикливание(Строка.Значение, ОбработанныеЗадачи);
	КонецЦикла;	
	
КонецПроцедуры

Процедура ПроверитьПредшественниковНаЗацикливание(ПроектнаяЗадача, ОбработанныеЗадачи) 
	
	Если ОбработанныеЗадачи.Найти(ПроектнаяЗадача) <> Неопределено  Тогда 
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Обнаружено зацикливание предшественников на задаче ""%1"".'"),
			Строка(ПроектнаяЗадача));
		
	Иначе	
		
		КопияОбработанныеЗадачи = Новый Массив;
		Для Каждого Элемент Из ОбработанныеЗадачи Цикл
			КопияОбработанныеЗадачи.Добавить(Элемент);
		КонецЦикла;	
		
		КопияОбработанныеЗадачи.Добавить(ПроектнаяЗадача);
		
		Предшественники = ПолучитьВсехПредшественников(ПроектнаяЗадача, Ложь);
		Для Каждого Строка Из Предшественники Цикл
			ПроверитьПредшественниковНаЗацикливание(Строка.Предшественник, КопияОбработанныеЗадачи);
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры	

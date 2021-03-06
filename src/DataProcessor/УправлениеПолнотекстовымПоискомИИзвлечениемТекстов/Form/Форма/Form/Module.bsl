﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Инициализация набора констант
	НаборКонстантОбъект = ДанныеФормыВЗначение(НаборКонстант, Тип("КонстантыНабор"));
	НаборКонстантОбъект.Прочитать();
	ЗначениеВДанныеФормы(НаборКонстантОбъект, НаборКонстант);
	
	// Синхронизируем константу с текущим состоянием полнотекстового поиска 
	НаборКонстант.ИспользоватьПолнотекстовыйПоиск = (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить);
	УстановитьЗначениеКонстантыПоИмени("ИспользоватьПолнотекстовыйПоиск");
		
	// ППД
	ОбновитьСтатус();
	
	// Автоматическое извлечение текстов
	ИнтервалВремениВыполнения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения");
	Если ИнтервалВремениВыполнения = 0 Тогда
		ИнтервалВремениВыполнения = 60;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	КонецЕсли;	
	
	УстановитьВидимостьДоступностьЗависимыхЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ВебКлиент Тогда
	УстановитьДоступностьЭлементовИзвлеченияТекстов(Ложь);
	Элементы.ГруппаПредупреждениеОПоддержкеИзвлеченияТекстов.Видимость = Истина;
#Иначе
	Элементы.ГруппаПредупреждениеОПоддержкеИзвлеченияТекстов.Видимость = Ложь;
#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Полнотекстовый поиск данных

&НаКлиенте
Процедура НаборКонстантИспользоватьПолнотекстовыйПоискПриИзменении(Элемент)
	
	ОчиститьСообщения();
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИспользоватьПолнотекстовыйПоискПриПодбореТоваровПриИзменении(Элемент)
	
	ОчиститьСообщения();
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Автоматическое извлечение текстов

&НаКлиенте
Процедура ИзвлекатьТекстыФайловНаСервереПриИзменении(Элемент)
	
	СохранитьЗначениеКонстанты(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалВремениВыполненияПриИзменении(Элемент)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("АвтоматическоеИзвлечениеТекстов", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// Полнотекстовый поиск данных

&НаКлиенте
Процедура ОбновитьИндексВыполнить()
	
	Состояние(НСтр("ru = 'Идет обновление полнотекстового индекса...
					|Пожалуйста, подождите.'"));
	ОбновитьИндексСервер();
	ОбновитьСтатус();
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИндексВыполнить()
	
	ОчиститьИндексСервер();	
	ОбновитьСтатус();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Автоматическое извлечение текстов

&НаКлиенте
Процедура ЗапуститьСейчас(Команда)
	
#Если НЕ ВебКлиент Тогда
	ИзвлечениеТекстовКлиент();
#КонецЕсли

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// При изменении реквизитов

&НаСервере 
Процедура СохранитьЗначениеКонстанты(ИмяКонстанты)
	
	УстановитьЗначениеКонстантыПоИмени(ИмяКонстанты);
	
	ВыполнитьМетодыПослеУстановкиЗначенияКонстанты(ИмяКонстанты);
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьЗначениеКонстантыПоИмени(ИмяКонстанты)
	
 	Константы[ИмяКонстанты].Установить(НаборКонстант[ИмяКонстанты]);
	
	УстановитьВидимостьДоступностьЗависимыхЭлементовФормы(ИмяКонстанты);
	
	УстановитьЗначенияЗависимыхКонстант(ИмяКонстанты);
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьВидимостьДоступностьЗависимыхЭлементовФормы(ИмяКонстанты = Неопределено)
	
	Если ИмяКонстанты = "ИспользоватьПолнотекстовыйПоиск" ИЛИ ИмяКонстанты = Неопределено Тогда
		Элементы.ОбновитьИндекс.Доступность = НаборКонстант.ИспользоватьПолнотекстовыйПоиск И Не ИндексАктуален;
		Элементы.ОчиститьИндекс.Доступность = НаборКонстант.ИспользоватьПолнотекстовыйПоиск;
		Элементы.ИспользоватьПолнотекстовыйПоискПриПодбореТоваров.Доступность = НаборКонстант.ИспользоватьПолнотекстовыйПоиск;
		
		Элементы.ИзвлекатьТекстыФайловНаСервере.Доступность = НаборКонстант.ИспользоватьПолнотекстовыйПоиск;
		УстановитьВидимостьДоступностьЗависимыхЭлементовФормы("ИзвлекатьТекстыФайловНаСервере");
		
	КонецЕсли;
	
	Если ИмяКонстанты = "ИзвлекатьТекстыФайловНаСервере" ИЛИ ИмяКонстанты = Неопределено Тогда
		Элементы.ИнтервалВремениВыполнения.Доступность = НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
		Элементы.ЗапуститьСейчас.Доступность = НаборКонстант.ИзвлекатьТекстыФайловНаСервере;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьЗначенияЗависимыхКонстант(ИмяРодительскойКонстанты)
	
	Если ИмяРодительскойКонстанты = "ИспользоватьПолнотекстовыйПоиск" Тогда
		Если Не НаборКонстант.ИспользоватьПолнотекстовыйПоиск Тогда
			НаборКонстант.ИспользоватьПолнотекстовыйПоискПриПодбореТоваров = Ложь;
			НаборКонстант.ИзвлекатьТекстыФайловНаСервере = Ложь;
			
			УстановитьЗначениеКонстантыПоИмени("ИспользоватьПолнотекстовыйПоискПриПодбореТоваров");
			УстановитьЗначениеКонстантыПоИмени("ИзвлекатьТекстыФайловНаСервере");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура ВыполнитьМетодыПослеУстановкиЗначенияКонстанты(ИмяКонстанты)
	
	Если ИмяКонстанты = "ИспользоватьПолнотекстовыйПоиск" Тогда
		Попытка
			Если НаборКонстант.ИспользоватьПолнотекстовыйПоиск Тогда
				ПолнотекстовыйПоиск.УстановитьРежимПолнотекстовогоПоиска(РежимПолнотекстовогоПоиска.Разрешить);
			Иначе
				ПолнотекстовыйПоиск.УстановитьРежимПолнотекстовогоПоиска(РежимПолнотекстовогоПоиска.Запретить);
			КонецЕсли;
		Исключение
			ТекстСообщения = НСтр("ru= 'Не удалось изменить режим полнотекстового поиска.'") 
							+ Символы.ПС + НСтр("ru= 'Для изменения режима требуется завершение сеансов всех пользователей, кроме текущего.'"); 
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "НаборКонстант.ИспользоватьПолнотекстовыйПоиск");
			
			// Синхронизируем константу с текущим состоянием полнотекстового поиска 
			НаборКонстант.ИспользоватьПолнотекстовыйПоиск = (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить);
			
			УстановитьЗначениеКонстантыПоИмени(ИмяКонстанты);
			
		КонецПопытки;
		
		ОбновитьСтатус();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Полнотекстовый поиск данных

&НаСервере
Процедура ОбновитьИндексСервер()
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
КонецПроцедуры

// Очистить индекс
//
&НаСервере
Процедура ОчиститьИндексСервер()
	ПолнотекстовыйПоиск.ОчиститьИндекс();
КонецПроцедуры	

// Обновить статус - доступность кнопок, дата актуальности индекса.
&НаСервере
Процедура ОбновитьСтатус()
	
	РазрешитьПолнотекстовыйПоиск = (ПолнотекстовыйПоиск.ПолучитьРежимПолнотекстовогоПоиска() = РежимПолнотекстовогоПоиска.Разрешить);
	Если РазрешитьПолнотекстовыйПоиск Тогда
		ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
		ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
	КонецЕсли;	
	
	СтатусИндекса = "";
	
	Если РазрешитьПолнотекстовыйПоиск Тогда
		
		Элементы.ОбновитьИндекс.Доступность = НЕ ИндексАктуален;
		
		Если ИндексАктуален Тогда
			СтатусИндекса = НСтр("ru = 'Обновление индекса не требуется'");
		Иначе
			СтатусИндекса = НСтр("ru = 'Требуется обновление индекса'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Автоматическое извлечение текстов

&НаСервереБезКонтекста
Процедура ЗаписьЖурналаРегистрацииСервер(ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Извлечение текста файла'"), УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
	
КонецПроцедуры

#Если НЕ ВебКлиент Тогда
// Извлекает текст из файлов на диске на клиенте
&НаКлиенте
Процедура ИзвлечениеТекстовКлиент()
	
	ПрогнозируемоеВремяНачалаИзвлечения = ТекущаяДата() + ИнтервалВремениВыполнения;
	
	Состояние(НСтр("ru = 'Начато извлечение текста'"));
	
	Попытка
		
		МассивФайлов = ПолучитьФайлыДляИзвлеченияТекста();
		
		Если МассивФайлов.Количество() = 0 Тогда
			Состояние(НСтр("ru = 'Нет файлов для извлечения текста'"));
			Возврат;
		КонецЕсли;
		
		Для Индекс = 0 По МассивФайлов.Количество() - 1 Цикл
			
			Расширение = МассивФайлов[Индекс].Расширение;
			НаименованиеФайла = МассивФайлов[Индекс].Наименование;
			ФайлИлиВерсияФайла = МассивФайлов[Индекс].Ссылка;
			
			АдресФайла = ПолучитьНавигационнуюСсылкуФайла(ФайлИлиВерсияФайла, УникальныйИдентификатор);
			
			ИмяСРасширением = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(НаименованиеФайла, Расширение);
			Прогресс = Индекс * 100 / МассивФайлов.Количество();
			Состояние(НСтр("ru = 'Идет извлечение текста файла'"), Прогресс, ИмяСРасширением);
			
			ФайловыеФункцииСлужебныйКлиент.ИзвлечьТекстВерсии(ФайлИлиВерсияФайла, АдресФайла, Расширение, УникальныйИдентификатор);
		КонецЦикла;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								 НСтр("ru = 'Извлечение текста завершено. Обработано файлов: %1'"), 
								 МассивФайлов.Количество());
		Состояние(ТекстСообщения);
		
	Исключение
		
		ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Во время извлечения текста из файла ""%1"" произошла неизвестная ошибка.'"), 
								Строка(ФайлИлиВерсияФайла));
								
		ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
		
		Состояние(ТекстСообщения);
		
		// запись в журнал регистрации
		ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
		
	КонецПопытки;
	
КонецПроцедуры
#КонецЕсли

&НаСервереБезКонтекста
Функция ПолучитьФайлыДляИзвлеченияТекста()
	
	Результат = Новый Массив;
	ТекстЗапроса = Неопределено;
	СтандартныеПодсистемыПереопределяемый.ПолучитьТекстЗапросаДляИзвлеченияТекста(ТекстЗапроса);
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Для Каждого Строка Из Запрос.Выполнить().Выгрузить() Цикл
		Результат.Добавить(Новый Структура("Ссылка, Расширение, Наименование", 
			Строка.Ссылка, Строка.Расширение, Строка.Наименование));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуФайла(ФайлИлиВерсияФайла, УникальныйИдентификатор)
	
	Возврат СтандартныеПодсистемыПереопределяемый.ПолучитьНавигационнуюСсылкуФайла(ФайлИлиВерсияФайла, УникальныйИдентификатор);
	
КонецФункции

Процедура УстановитьДоступностьЭлементовИзвлеченияТекстов(Доступность)
	
	Элементы.ГруппаИзвлекатьТекстыФайловНаСервере.Доступность = Доступность;
	Элементы.ГруппаИнтервалВремениВыполнения.Доступность = Доступность;
	Элементы.ЗапуститьСейчас.Доступность = Доступность;
	
КонецПроцедуры



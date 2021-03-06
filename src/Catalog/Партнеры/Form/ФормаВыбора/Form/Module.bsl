﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПартнерыИКонтрагенты.ПартнерыФормаВыбораСпискаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Не Параметры.Контрагент.Пустая() Тогда
		Элементы.ПоКонтрагенту.Видимость = Истина;
		Партнер = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Контрагент, Новый Структура("Партнер")).Партнер;
		СписокПартнеров.ЗагрузитьЗначения(ПартнерыИКонтрагенты.ПолучитьНижестоящихПартнеров(Партнер));
		Элементы.ПоКонтрагенту.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='По контрагенту ""%1""'"), Параметры.Контрагент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если Не Параметры.Контрагент.Пустая() Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПартнерыИКонтрагенты.ПартнерыФормаВыбораСпискаПриЗагрузкеДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
	Сегмент = Настройки["Сегмент"];
	
	Если ЗначениеЗаполнено(Сегмент) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Сегмент", СегментыВызовСервера.СписокЗначений(Сегмент), ВидСравненияКомпоновкиДанных.ВСписке, Истина);
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		
	КонецЕсли;
	
	Если Не Параметры.Контрагент.Пустая() Тогда
		
		ЗагрузитьНастройки();
		Элементы.ВключаяНижестоящих.Видимость = ПоКонтрагенту И СписокПартнеров.Количество() > 1;
		Если ПоКонтрагенту Тогда
			УстановитьОтборПартнеров(ЭтаФорма, ВключаяНижестоящих);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ПартнерыИКонтрагенты.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПартнерыИКонтрагентыКлиент.ПанельНавигацииУправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТолькоМоиПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораТолькоМоиПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеВыбораНажатие(Элемент, СтандартнаяОбработка)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораОснованиеВыбораНажатие(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СегментПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораСегментПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	СпискиВыбораКлиентСервер.АвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоКонтрагентуПриИзменении(Элемент)
	
	ВключаяНижестоящих = ПоКонтрагенту;
	Элементы.ВключаяНижестоящих.Видимость = (СписокПартнеров.Количество() > 1 И ПоКонтрагенту);
	Если ПоКонтрагенту Тогда
		УстановитьОтборПартнеров(ЭтаФорма, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Ссылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключаяНижестоящихПриИзменении(Элемент)
	
	УстановитьОтборПартнеров(ЭтаФорма, ВключаяНижестоящих);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипФильтраОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФильтрПриИзменении(Элемент)
	
	ПартнерыИКонтрагентыКлиент.ПанельНавигацииУправлениеДоступностью(ЭтаФорма);
	ОбработатьАктивизациюСтрокиДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписокФильтрыПриАктивизацииСтроки(Элемент)
	
	Если Элемент.Имя = "БизнесРегионы" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаБизнесРегионы Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "ГруппыДоступаПартнеров" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаГруппыДоступа Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Менеджеры" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаМенеджеры Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Свойства" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаСвойства Тогда
		Возврат;
	ИначеЕсли Элемент.Имя = "Категории" И Элементы.СтраницыТипФильтра.ТекущаяСтраница <> Элементы.СтраницаКатегории Тогда
		Возврат;
	КонецЕсли;
	
	Если НеОтрабатыватьАктивизациюПанелиНавигации Тогда
		НеОтрабатыватьАктивизациюПанелиНавигации = Ложь;
	Иначе
		Если Элемент.Имя = "БизнесРегионы" И ТекущееЗначениеФильтра = Элементы.БизнесРегионы.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "ГруппыДоступаПартнеров" И ТекущееЗначениеФильтра = Элементы.ГруппыДоступаПартнеров.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Менеджеры" И ТекущееЗначениеФильтра = Элементы.Менеджеры.ТекущаяСтрока Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Свойства" И ТекущееЗначениеФильтра = Свойства.НайтиПоИдентификатору(Элементы.Свойства.ТекущаяСтрока) Тогда
			Возврат;
		ИначеЕсли Элемент.Имя = "Категории" И ТекущееЗначениеФильтра = Категории.НайтиПоИдентификатору(Элементы.Категории.ТекущаяСтрока) Тогда
			Возврат;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиДинамическогоСписка",0.2,Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыПартнераНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПартнерыИКонтрагентыКлиент.КонтрагентыПартнераНажатие(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактныеЛицаПартнераНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПартнерыИКонтрагентыКлиент.КонтактныеЛицаПартнераНажатие(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПоВсемПриИзменении(Элемент)

	ИзменитьОтборСписок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипФильтраПриИзменении(Элемент)
	
	ТребуетсяЗаполнениеСтраницыСвойств = ЛОЖЬ;
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииТипФильтраПриИзменении(ЭтаФорма, Элемент, ТребуетсяЗаполнениеСтраницыСвойств);
	ИзменитьОтборСписок(Истина, ТребуетсяЗаполнениеСтраницыСвойств);
	Если ТребуетсяЗаполнениеСтраницыСвойств Тогда
		Для каждого СтрокаДерева Из Свойства.ПолучитьЭлементы() Цикл
			Элементы.Свойства.Развернуть(СтрокаДерева.ПолучитьИдентификатор());
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииПроверкаПеретаскивания(ЭтаФорма, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) 
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	КоличествоЗаписанных = 0;
	ПартнерыИКонтрагентыКлиент.ФильтрыПанельНавигацииПеретаскивание(КоличествоЗаписанных, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле);
	
	Если КоличествоЗаписанных > 0 Тогда
		ИзменитьОтборСписок();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ СПИСОК

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка",0.2,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораСписокПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьНового(Команда)
	
	ПартнерыИКонтрагентыКлиент.ПартнерыФормаСпискаВыбораСоздатьНового(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиПП(Команда)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Полнотекстовый поиск

&НаКлиенте
Процедура ПроверитьИндексПолнотекстовогоПоиска()
	
	Если Не ИндексПолнотекстовогоПоискаАктуален И ИнформационнаяБазаФайловая Тогда
		
		Результат = Вопрос(НСтр("ru='Индекс полнотекстового поиска неактуален. Обновить индекс?'"), РежимДиалогаВопрос.ДаНет); 
		
		Если Результат = КодВозвратаДиалога.Да Тогда
			ПодключитьОбработчикОжидания("ОбновитьИндексПолнотекстовогоПоиска",0.2,Истина);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьПолнотекстовыйПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндексПолнотекстовогоПоиска()
	
	Состояние(НСтр("ru = 'Идет обновление индекса полнотекстового поиска ...'"));
	ОбновитьИндексПолнотекстовогоПоискаСервер();
	ИндексПолнотекстовогоПоискаАктуален = Истина;
	Состояние(НСтр("ru = 'Обновление индекса полнотекстового поиска завершено...'"));
	
	ВыполнитьПолнотекстовыйПоиск();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИндексПолнотекстовогоПоискаСервер()
	
	ПартнерыИКонтрагенты.ОбновитьИндексПолнотекстовогоПоиска();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПолнотекстовыйПоиск()
	
	ТекстОшибки = НайтиПартнеровПолнотекстовыйПоиск();
	Если ТекстОшибки = Неопределено Тогда
		РасширенныйПоиск = Истина;
		ПартнерыИКонтрагентыКлиент.ЗаполнитьСтрокуОснования(ЭтаФорма);
	Иначе
		Если НЕ ТекстОшибки = НСтр("ru = 'Ничего не найдено'") Тогда
			ПоказатьОповещениеПользователя(ТекстОшибки);
		Иначе
			ПартнерыИКонтрагентыКлиент.ВостановитьОтображениеСпискаПослеПолнотекстовогоПоиска(ЭтаФорма);
			РасширенныйПоиск = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Функция НайтиПартнеровПолнотекстовыйПоиск()
	
	Возврат ПартнерыИКонтрагенты.НайтиПартнеровПолнотекстовыйПоиск(ЭтаФорма)
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПоиск()
	
	Если СтрокаПоиска <> "" Тогда
		
		ПроверитьИндексПолнотекстовогоПоиска();
		ЭтаФорма.ТекущийЭлемент = ?(НЕ РасширенныйПоиск, Элементы.СтрокаПоиска, Элементы.Список);
		
	Иначе
		
		ПартнерыИКонтрагентыКлиент.ВостановитьОтображениеСпискаПослеПолнотекстовогоПоиска(ЭтаФорма);
		РасширенныйПоиск = Ложь;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Поиск", Неопределено, ВидСравненияКомпоновкиДанных.Равно,, Ложь);
		ОснованиеВыбора = "";
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Отборы

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПартнеров(Форма, ВключаяНижестоящих = Истина)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Форма.Список.Отбор, "Ссылка");
	Если ВключаяНижестоящих Тогда
		
		//создать элемент группы - отбор по партнеру
		ТекущийПартнер = Форма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ТекущийПартнер.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
		ТекущийПартнер.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка");
		ТекущийПартнер.ПравоеЗначение = Форма.СписокПартнеров;
		ТекущийПартнер.Использование  = Истина;
		
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Форма.Список.Отбор, "Ссылка", Форма.Партнер, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	КонецЕсли;
	
КонецПроцедуры 

////////////////////////////////////////////////////////////////////////////////
// Настройки

&НаСервере
Процедура СохранитьНастройки()

	Перем Настройки;
	
	Настройки = Новый Соответствие;
	Настройки.Вставить("ВключаяНижестоящих",ВключаяНижестоящих);
	Настройки.Вставить("ПоКонтрагенту",ПоКонтрагенту);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Справочники.Партнеры",КлючНастроек, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройки()
	
	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Справочники.Партнеры", КлючНастроек);
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда
		ВключаяНижестоящих = ЗначениеНастроек.Получить("ВключаяНижестоящих");
		ПоКонтрагенту      = ЗначениеНастроек.Получить("ПоКонтрагенту");
	Иначе
		ПоКонтрагенту      = Истина;
		ВключаяНижестоящих = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	Если Не ПартнерыИКонтрагентыКлиент.ПозиционированиеКорректно("Список",ЭтаФорма) Тогда
		
		Если ТекущийАктивныйПартнер <> ПредопределенноеЗначение("Справочник.Партнеры.ПустаяСсылка") Тогда
			ЗаполнитьПанельИнформацииПоДаннымПартнера( Неопределено);
		КонецЕсли;
		ОснованиеВыбора = "";
		
	Иначе
		
		Если ТекущийАктивныйПартнер <> Элементы.Список.ТекущаяСтрока Тогда
			ЗаполнитьПанельИнформацииПоДаннымПартнера(Элементы.Список.ТекущаяСтрока);
		КонецЕсли;
		
		Если РасширенныйПоиск Тогда
			ПартнерыИКонтрагентыКлиент.ЗаполнитьСтрокуОснования(ЭтаФорма);
		Иначе
			ОснованиеВыбора = "";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПанельИнформацииПоДаннымПартнера(Партнер)

	ПартнерыИКонтрагенты.ЗаполнитьПанельИнформацииПоДаннымПартнера(ЭтаФорма, Партнер);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиДинамическогоСписка()

	ИзменитьОтборСписок();

КонецПроцедуры

&НаСервере
Процедура ИзменитьОтборСписок(ПереформированиеПанелиНавигации = Ложь, ТребуетсяЗаполнениеСтраницыСвойств = Ложь)

	ПартнерыИКонтрагенты.ИзменитьОтборСписок(ЭтаФорма, ПереформированиеПанелиНавигации, ТребуетсяЗаполнениеСтраницыСвойств);

КонецПроцедуры

&НаКлиенте
Процедура СтрокаОтбораПриИзменении(Элемент)
//Доработка +	
ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Наименование",  СтрокаОтбора, ВидСравненияКомпоновкиДанных.Содержит,, ЗначениеЗаполнено(СтрокаОтбора));
//Доработка -
КонецПроцедуры

&НаКлиенте
Процедура НайтиПартнера(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры



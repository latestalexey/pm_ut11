﻿
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Свойство("Организация") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Организация", Параметры.Организация);
		Список.Параметры.УстановитьЗначениеПараметра("ПоВсемОрганизациям", Параметры.Организация = Справочники.Организации.ПустаяСсылка());
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("Организация", Справочники.Организации.ПустаяСсылка());
		Список.Параметры.УстановитьЗначениеПараметра("ПоВсемОрганизациям", Истина);
	КонецЕсли;
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		
		ЭлементОтбораДатаНач = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДатаНач.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбораДатаНач.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбораДатаНач.ПравоеЗначение = НачалоМесяца(Параметры.ПериодРегистрации);
		ЭлементОтбораДатаНач.Использование = Истина;
		
		ЭлементОтбораДатаКон = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДатаКон.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбораДатаКон.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбораДатаКон.ПравоеЗначение = КонецМесяца(Параметры.ПериодРегистрации);
		ЭлементОтбораДатаКон.Использование = Истина;
		
	КонецЕсли;
	
	Если Параметры.Свойство("НеПомеченныеНаУдаление") Тогда
		
		ЭлементОтбораБезПометки = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораБезПометки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
		ЭлементОтбораБезПометки.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораБезПометки.ПравоеЗначение = Ложь;
		ЭлементОтбораБезПометки.Использование = Истина;
		
	КонецЕсли;
	
КонецПроцедуры


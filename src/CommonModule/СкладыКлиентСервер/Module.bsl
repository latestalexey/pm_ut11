﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура согласует и устанавливает значения признаков использования адресного хранения.
//
Процедура СогласоватьЗначенияПризнаков(ОбъектСправочник) Экспорт
	
	Если Не ЗначениеЗаполнено(ОбъектСправочник.НастройкаАдресногоХранения) Тогда
		ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать");
	КонецЕсли;
	
	Если Не (ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке
	 И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриПоступлении
	 И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач)
		 Или ОбъектСправочник.ТипСклада = ПредопределенноеЗначение("Перечисление.ТипыСкладов.РозничныйМагазин") Тогда
		
		ОбъектСправочник.ИспользоватьСкладскиеПомещения = Ложь;
		
	КонецЕсли;

	Если Не (ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке
	 И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриПоступлении
	 И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач) Тогда
		Если ОбъектСправочник.НастройкаАдресногоХранения <> ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиСправочно") Тогда
			ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать");
		КонецЕсли;
	КонецЕсли;	
	
	Если Не ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке Тогда
		ОбъектСправочник.НачинатьОтгрузкуПослеФормированияЗаданияНаПеревозку = Ложь;
	КонецЕсли;
	
	Если Не ОбъектСправочник.ТипСклада = ПредопределенноеЗначение("Перечисление.ТипыСкладов.РозничныйМагазин") Тогда
		ОбъектСправочник.РозничныйВидЦены = ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка");
		ОбъектСправочник.КонтролироватьАссортимент = Ложь;
		ОбъектСправочник.ФорматМагазина = ПредопределенноеЗначение("Справочник.ФорматыМагазинов.ПустаяСсылка");
	КонецЕсли;
	
	Если ОбъектСправочник.ИспользоватьСкладскиеПомещения Тогда
		ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения");
	ИначеЕсли ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения") Тогда
		ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать");
	КонецЕсли;
	
	Если ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения")
	 Или ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать") Тогда
		ОбъектСправочник.ИспользоватьАдресноеХранение 			= Ложь;
		ОбъектСправочник.ИспользоватьАдресноеХранениеСправочно 	= Ложь;
	ИначеЕсли ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиОстатки") Тогда
		ОбъектСправочник.ИспользоватьАдресноеХранение 			= Истина;
		ОбъектСправочник.ИспользоватьАдресноеХранениеСправочно 	= Ложь;
	ИначеЕсли ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиСправочно") Тогда
		ОбъектСправочник.ИспользоватьАдресноеХранение 			= Ложь;
		ОбъектСправочник.ИспользоватьАдресноеХранениеСправочно 	= Истина;
	Иначе
		ОбъектСправочник.ИспользоватьАдресноеХранение 			= Ложь;
		ОбъектСправочник.ИспользоватьАдресноеХранениеСправочно 	= Ложь;
	КонецЕсли;
	
	Если ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения") Тогда
		ОбъектСправочник.ИспользованиеРабочихУчастков = ПредопределенноеЗначение("Перечисление.ИспользованиеСкладскихРабочихУчастков.ОпределяетсяНастройкамиПомещения");
	ИначеЕсли ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать") Тогда
		ОбъектСправочник.ИспользованиеРабочихУчастков = ПредопределенноеЗначение("Перечисление.ИспользованиеСкладскихРабочихУчастков.НеИспользовать");
	КонецЕсли;
	
	Если (ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения")
		Или ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиОстатки")
		Или ОбъектСправочник.ИспользоватьСерииНоменклатуры)
		И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке Тогда
		ОбъектСправочник.ИспользоватьСтатусыРасходныхОрдеров = Истина;
	КонецЕсли;
	
	Если Не ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке Тогда
		ОбъектСправочник.ИспользоватьСтатусыРасходныхОрдеров = Ложь;
	КонецЕсли;
	
	Если Не ОбъектСправочник.ИспользоватьОрдернуюСхемуПриПоступлении Тогда
		ОбъектСправочник.ИспользоватьСтатусыПриходныхОрдеров = Ложь;
	КонецЕсли;	
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

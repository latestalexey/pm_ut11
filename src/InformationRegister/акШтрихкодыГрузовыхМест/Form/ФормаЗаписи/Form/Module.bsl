﻿&НаКлиенте
Процедура НовыйШтрихкод(Команда)
	
	//ПрефиксВесовогоТовара = 1;
	//Если ЭтоВесовойТовар(Запись.Номенклатура, Запись.Упаковка) Тогда
	//	Результат = ВвестиЧисло(ПрефиксВесовогоТовара, НСтр("ru = 'Введите префикс весового товара'"), 1, 0);
	//	Если Результат Тогда
	//		Запись.Штрихкод = СформироватьШтрихкодEAN13ВесовогоТовара(ПрефиксВесовогоТовара);
	//	КонецЕсли;
	//Иначе
		Запись.ШтрихкодГрузовогоМеста = СформироватьШтрихкодEAN13();
	//КонецЕсли;
	
КонецПроцедуры


//&НаСервереБезКонтекста
//Функция ЭтоВесовойТовар(Номенклатура, Упаковка)
//	
//	Если ЗначениеЗаполнено(Упаковка) Тогда
//		Если Упаковка.ЕдиницаИзмерения.ТипЕдиницыИзмерения = Перечисления.ТипыЕдиницИзмерения.Весовая Тогда
//			Возврат Истина;
//		Иначе
//			Возврат Ложь;
//		КонецЕсли;
//	Иначе
//		Если Номенклатура.ЕдиницаИзмерения.ТипЕдиницыИзмерения = Перечисления.ТипыЕдиницИзмерения.Весовая Тогда
//			Возврат Истина;
//		Иначе
//			Возврат Ложь;
//		КонецЕсли;
//	КонецЕсли;
//	
//КонецФункции

&НаСервереБезКонтекста
Функция СформироватьШтрихкодEAN13()
	
	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодEAN13(РегистрыСведений.ШтрихкодыНоменклатуры.ПрефиксШтучногоТовара());
	
КонецФункции

&НаКлиенте
Процедура НоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	      
	Если НЕ ПроверитьНаличиеХарактеристики(ВыбранноеЗначение) Тогда
		Элементы.ХарактеристикаНоменклатуры.Доступность = ЛОЖЬ;
	Иначе
		Элементы.ХарактеристикаНоменклатуры.Доступность = ИСТИНА;

		КонецЕсли;
		
КонецПроцедуры


//{ ООО "АСТЭК" Разработчик: Бурыкин Александр  11.11.2013
&НаСервере
Функция ПроверитьНаличиеХарактеристики(ВыбраннаяНоменклатура);
	
	Если ВыбраннаяНоменклатура.ВидНоменклатуры.ИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать Тогда
		ХарактеристикаЕсть = Ложь;
	Иначе
		ХарактеристикаЕсть = Истина;
	КонецЕсли;
	
	Возврат ХарактеристикаЕсть;
КонецФункции
   //}

   
//   &НаСервереБезКонтекста
//Функция СформироватьШтрихкодEAN13ВесовогоТовара(ПрефиксВесовогоТовара = "1")
//	
//	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодВесовогоТовараEAN13(ПрефиксВесовогоТовара);
//	
//КонецФункции

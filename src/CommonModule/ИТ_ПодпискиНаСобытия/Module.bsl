﻿
Процедура ПриЗаписиДокументов(Источник, Отказ) Экспорт
	
	 Если ТипЗнч(Источник) = Тип("ДокументОбъект.ЗаказПоставщику") Тогда
		 
		Если ЗначениеЗаполнено(Источник.Ссылка) Тогда
	 		ПриЗаписиЗаказПоставщику(Источник);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Источник) = Тип("ДокументОбъект.ПоступлениеБезналичныхДенежныхСредств") Тогда	
		
		Если ЗначениеЗаполнено(Источник.Ссылка) Тогда
	 		ПриЗаписиЗаказПоступлениеБезналичныхДС(Источник);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
 
Процедура ПриЗаписиЗаказПоставщику(Источник)
	//отсечем заказы на доставку и монтаж
	Если Источник.АК_ТипУслуги = Перечисления.АК_ТипУслуги.Доставка ИЛИ 
		 Источник.АК_ТипУслуги = Перечисления.АК_ТипУслуги.Монтаж Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа
	|ГДЕ
	|	ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Заказ = &Заказ
	|	И ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.Проведен
	|	И НЕ ЗаявкаНаРасходованиеДенежныхСредствРасшифровкаПлатежа.Ссылка.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Заказ", Источник.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;	
	
	НовыйОбъект = Документы.ЗаявкаНаРасходованиеДенежныхСредств.СоздатьДокумент();
		
	НовыйОбъект.Заполнить(Источник.Ссылка);
	
	НовыйОбъект.Дата = ТекущаяДата();
	
	НовыйОбъект.Записать(РежимЗаписиДокумента.Проведение);	
	
КонецПроцедуры	

Процедура ПриЗаписиЗаказПоступлениеБезналичныхДС(Источник)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПоступлениеБезналичныхДенежныхСредствРасшифровкаПлатежа.Ссылка,
	|	ПоступлениеБезналичныхДенежныхСредствРасшифровкаПлатежа.Заказ,
	|	ПоступлениеБезналичныхДенежныхСредствРасшифровкаПлатежа.Ссылка.НазначениеПлатежа КАК Назначение,
	|	ПоступлениеБезналичныхДенежныхСредствРасшифровкаПлатежа.ОснованиеПлатежа
	|ИЗ
	|	Документ.ПоступлениеБезналичныхДенежныхСредств.РасшифровкаПлатежа КАК ПоступлениеБезналичныхДенежныхСредствРасшифровкаПлатежа
	|ГДЕ
	|	ПоступлениеБезналичныхДенежныхСредствРасшифровкаПлатежа.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Источник.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();	
	Если ЗначениеЗаполнено(Выборка.ОснованиеПлатежа) Тогда
		Возврат;
	КонецЕсли;	
		
	ДлинаНазначения = СтрДлина(Выборка.Назначение);
	НовыйНомер = "";
	ПервыйСимвол = 0;
	ДлинаСимволов = 1;
	
	Для Символ = 1 По ДлинаНазначения Цикл
		
		ТекСимвол = Сред(Выборка.Назначение, Символ, 1);
		
		Если ТекСимвол = " " Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекСимвол = "." Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			Если ТипЗнч(Число(ТекСимвол)) = Тип("Число") Тогда
				ДлинаСимволов = ДлинаСимволов + 1;
				Для ДлинаСимволов = 1 По ДлинаНазначения Цикл
					ТекСимвол = Сред(Выборка.Назначение, Символ+ДлинаСимволов, 1);
					ТекНомер = Сред(Выборка.Назначение, Символ, ДлинаСимволов);
					Если ТекСимвол = " " Тогда
						НовыйНомер = ТекНомер;
						Символ = Символ+ДлинаСимволов;
						Прервать
					КонецЕсли;	
				КонецЦикла;	
				Продолжить;
			КонецЕсли;
		Исключение
		КонецПопытки;
					
		// Проверить слово от
		Если ВРег(Сред(Выборка.Назначение, Символ, 2)) = "ОТ" Тогда
			//Строка.Результат = НовыйНомер;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(НовыйНомер) Тогда
		Возврат;
	КонецЕсли;	
	
	Номер = НовыйНомер;
	НужнаяДлина = 5;
	ТекДлина = СтрДлина(НовыйНомер);
	Для Длина = ТекДлина По НужнаяДлина Цикл
		Номер = "0" + Номер;
	КонецЦикла;
	
	Номер = "ПМ00-" + Номер;
	//Строка.Результат = Номер;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Номер = &Номер
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказКлиента.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("Номер", Номер);
	
	ВыборкаДок = Запрос.Выполнить().Выбрать();
	
	Документ = Неопределено;
	
	Если ВыборкаДок.Следующий() Тогда
		Документ = ВыборкаДок.Ссылка;
		Для Каждого Строка Из Источник.РасшифровкаПлатежа Цикл
			Строка.ОснованиеПлатежа = Документ;
			Строка.Заказ = Документ;
		КонецЦикла;
		Источник.Записать();
	КонецЕсли;
	
КонецПроцедуры	
	

﻿

//////////////////////////////////////////////////////////////////
// Работа с Бизнес процессами

&НаСервере
Процедура ЗапуститьБизнесПроцессОбеспечение(Источник, Отказ) Экспорт
	
	Если АК_БизнесПроцессыСервер.БППоОбеспечениюЗапущен(Источник.ссылка) и ЗначениеЗаполнено(Источник.Ссылка) тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.Статус <> Перечисления.СтатусыЗаказовКлиентов.КОбеспечению Тогда
		Возврат;
	КонецеСЛИ;
	
	НовыйБизнесПроцесс = БизнесПроцессы.акЗакупкаТовара.СоздатьБизнесПроцесс();
	НовыйБизнесПроцесс.Дата = ТекущаяДата();
	НовыйБизнесПроцесс.Заполнить(Источник.Ссылка);
	НовыйБизнесПроцесс.Записать();
	НовыйБизнесПроцесс.Старт();
	
КонецПроцедуры

 &НаСервере
Функция БППоОбеспечениюЗапущен(ЗаказКлиента) экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	акЗакупкаТовара.Ссылка
	|ИЗ
	|	БизнесПроцесс.акЗакупкаТовара КАК акЗакупкаТовара
	|ГДЕ
	|	акЗакупкаТовара.Предмет = &ЗаказКлиента";
	
	Запрос.УстановитьПараметр("ЗаказКлиента",ЗаказКлиента );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	Иначе
		Возврат ложь;
	КонецЕсли;
КонецФункции

&НаСервере
Функция БППоДоставкеЗапущен(ЗаказКлиента) экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	акОбеспечениеЗаказаКлиента.Ссылка
	|ИЗ
	|	БизнесПроцесс.акЗаказыНаДоставку КАК акОбеспечениеЗаказаКлиента
	|ГДЕ
	|	акОбеспечениеЗаказаКлиента.ЗаказКлиента = &ЗаказКлиента";
	
	Запрос.УстановитьПараметр("ЗаказКлиента",ЗаказКлиента );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	Иначе
		Возврат ложь;
	КонецЕсли;
КонецФункции

&НаСервере
Функция БППоМонтажуЗапущен(ЗаказКлиента) экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	акОбеспечениеЗаказаКлиента.Ссылка
	|ИЗ
	|	БизнесПроцесс.акЗаказыНаМонтаж КАК акОбеспечениеЗаказаКлиента
	|ГДЕ
	|	акОбеспечениеЗаказаКлиента.ЗаказКлиента = &ЗаказКлиента";
	
	Запрос.УстановитьПараметр("ЗаказКлиента",ЗаказКлиента );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	Иначе
		Возврат ложь;
	КонецЕсли;
КонецФункции



/////////////////////////////////////////////////////////////////
// Подписки на события


&НаСервере
Процедура акУстановитьПредметВыполнениеЗакупкиПриЗаписи(Источник, Отказ) Экспорт
	// Вставить содержимое обработчика.
	Если Источник.Проведен  Тогда
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		|	акВыполнениеЗакупки.Ссылка
		|ИЗ
		|	БизнесПроцесс.акВыполнениеЗакупки КАК акВыполнениеЗакупки
		|ГДЕ
		|	акВыполнениеЗакупки.ЗаказКлиента = &ЗаказКлиента
		|	И акВыполнениеЗакупки.Поставщик = &Поставщик";
		Запрос.УстановитьПараметр("ЗаказКлиента",Источник.ДокументОснование);
		Запрос.УстановитьПараметр("Поставщик",Источник.Партнер);
		Результат=Запрос.Выполнить().Выгрузить();
		Для каждого строка из Результат Цикл
			ТекущийБП=строка.Ссылка;
			Если ТекущийБП.Завершен тогда 
				Продолжить;
			КонецЕсли;
			
			Если НЕ значениеЗаполнено(ТекущийБП.Предмет) Тогда
				
				УстановитьПривилегированныйРежим(Истина);
				НачатьТранзакцию();
				Попытка
					
					
					ЗаблокироватьДанныеДляРедактирования(ТекущийБП);
					ТекущийБПОбъект=ТекущийБП.ПолучитьОбъект();
					
					ТекущийБПОбъект.Предмет=Источник.Ссылка;
					ТекущийБПОбъект.Записать();
					Запрос = Новый Запрос(
					"ВЫБРАТЬ
					|	Задачи.Ссылка КАК Ссылка
					|ИЗ
					|	Задача.ЗадачаИсполнителя КАК Задачи
					|ГДЕ
					|	Задачи.БизнесПроцесс = &БизнесПроцесс");
					
					Запрос.УстановитьПараметр("БизнесПроцесс", ТекущийБП);
					Результат = Запрос.Выполнить();
					
					Блокировка = Новый БлокировкаДанных;
					ВыборкаДетальныеЗаписи = Результат.Выбрать();
					Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
						ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
						ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
						ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаДетальныеЗаписи.Ссылка);
					КонецЦикла;
					Блокировка.Заблокировать();
					
					ВыборкаДетальныеЗаписи.Сбросить();
					Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
						ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
						ЗадачаОбъект.Предмет = Источник.Ссылка;
						ЗадачаОбъект.Записать();
					КонецЦикла;
					ЗафиксироватьТранзакцию();
				Исключение
					ОтменитьТранзакцию();
					ВызватьИсключение;
				КонецПопытки;
				
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
КонецПроцедуры

 &НаСервере
Процедура АК_ПриЗаписиЗаказаПриЗаписи(Источник, Отказ) Экспорт
	АК_БизнесПроцессыСервер.ЗапуститьБизнесПроцессОбеспечение(Источник, Отказ);	
КонецПроцедуры



/////////////////////////////////////////////////////////////////
// Прочее


&НаСервере
Функция ЕстьДоставка(ЗаказКлиента) экспорт
	Отбор = Новый Структура();
	Отбор.Вставить("Номенклатура",Справочники.Номенклатура.АК_Доставка);
	//чечин петр. иногда доставка выделяется отдельно в товары
	НайденныеСтроки1 = ЗаказКлиента.АК_УслугиДополнительные.НайтиСтроки(Отбор);
	НайденныеСтроки2 = ЗаказКлиента.Товары.НайтиСтроки(Отбор);
	Если (НайденныеСтроки1.Количество()>0) ИЛИ ( НайденныеСтроки2.Количество()>0) тогда
		Возврат ИСТИНА;
	ИНаче
		Возврат ЛОЖЬ;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ЕстьМонтаж(ЗаказКлиента) экспорт
	Отбор = Новый Структура();
	Отбор.Вставить("Номенклатура",Справочники.Номенклатура.АК_Монтаж);
	
	НайденныеСтроки = ЗаказКлиента.АК_УслугиДополнительные.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() > 0 тогда
		Возврат ИСТИНА;
	ИНаче
		Возврат ЛОЖЬ;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура СозданиеСобытийСервер() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ЗадачаИсполнителяЗадачиПоИсполнителю.БизнесПроцесс,
	               |	ЗадачаИсполнителяЗадачиПоИсполнителю.Исполнитель
	               |ИЗ
	               |	Задача.ЗадачаИсполнителя.ЗадачиПоИсполнителю(
	               |			,
	               |			ТочкаМаршрута = &ТочкаМаршрута
	               |				И БизнесПроцесс.Завершен = ЛОЖЬ) КАК ЗадачаИсполнителяЗадачиПоИсполнителю";
	
	Запрос.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.акЗаказыНаДоставку.ТочкиМаршрута.СформироватьЗаказНаДоставку);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.БизнесПроцесс.Напоминание14 и ТекущаяДата()>(Выборка.БизнесПроцесс.ЗаказКлиента.ДатаОтгрузки -14*60*60*24) тогда
			НоваяЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			НоваяЗадача.Автор = ПараметрыСеанса.ТекущийПользователь;
			НоваяЗадача.АвторСтрокой = ПараметрыСеанса.ТекущийПользователь;
			НоваяЗадача.БизнесПроцесс = Выборка.БизнесПроцесс;
			НоваяЗадача.Важность =Перечисления.ВариантыВажностиЗадачи.Высокая;
			НоваяЗадача.Дата = ТекущаяДата();
			НоваяЗадача.Исполнитель = Выборка.Исполнитель;
			НоваяЗадача.Наименование = "Позвонить клиенту за доставку " + Выборка.БизнесПроцесс.ЗаказКлиента.Партнер;
			НоваяЗадача.Описание = "Позвонить клиенту по доставке по "+ Выборка.БизнесПроцесс.ЗаказКлиента;
			НоваяЗадача.Записать();
			
			ТО = Выборка.БизнесПроцесс.ПолучитьОбъект();
			ТО.Напоминание14 = Истина;
			ТО.Записать();
		КонецЕсли;
		Если Не Выборка.БизнесПроцесс.Напоминание3 и ТекущаяДата()>(Выборка.БизнесПроцесс.ЗаказКлиента.ДатаОтгрузки -3*60*60*24) тогда
			НоваяЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			НоваяЗадача.Автор = ПараметрыСеанса.ТекущийПользователь;
			НоваяЗадача.АвторСтрокой = ПараметрыСеанса.ТекущийПользователь;
			НоваяЗадача.БизнесПроцесс = Выборка.БизнесПроцесс;
			НоваяЗадача.Важность =Перечисления.ВариантыВажностиЗадачи.Высокая;
			НоваяЗадача.Дата = ТекущаяДата();
			НоваяЗадача.Исполнитель = Выборка.Исполнитель;
			НоваяЗадача.Наименование = "Позвонить клиенту  за доставку " + Выборка.БизнесПроцесс.ЗаказКлиента.Партнер;;
			НоваяЗадача.Описание = "Позвонить клиенту по доставке по "+ Выборка.БизнесПроцесс.ЗаказКлиента;
			НоваяЗадача.Записать();
			
			ТО = Выборка.БизнесПроцесс.ПолучитьОбъект();
			ТО.Напоминание3 = Истина;
			ТО.Записать();
		КонецЕсли;
	КонецЦикла;
	
	
	
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗадачаИсполнителяЗадачиПоИсполнителю.БизнесПроцесс,
	|	ЗадачаИсполнителяЗадачиПоИсполнителю.Исполнитель
	|ИЗ
	|	Задача.ЗадачаИсполнителя.ЗадачиПоИсполнителю(
	|			,
	|			ТочкаМаршрута = &ТочкаМаршрута
	|				И БизнесПроцесс.Завершен = ЛОЖЬ) КАК ЗадачаИсполнителяЗадачиПоИсполнителю";
	
	Запрос.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.акЗаказыНаМонтаж.ТочкиМаршрута.СформироватьЗаказНаДоставку);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ПОка  Выборка.Следующий() Цикл
		Если Не Выборка.БизнесПроцесс.Напоминание14 и ТекущаяДата()>(Выборка.БизнесПроцесс.ЗаказКлиента.ДатаОтгрузки -14*60*60*24) тогда
			НоваяЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			НоваяЗадача.Автор = ПараметрыСеанса.ТекущийПользователь;
			НоваяЗадача.АвторСтрокой = ПараметрыСеанса.ТекущийПользователь;
			НоваяЗадача.БизнесПроцесс = Выборка.БизнесПроцесс;
			НоваяЗадача.Важность =Перечисления.ВариантыВажностиЗадачи.Высокая;
			НоваяЗадача.Дата = ТекущаяДата();
			НоваяЗадача.Исполнитель = Выборка.Исполнитель;
			НоваяЗадача.Наименование = "Позвонить клиенту за монтаж " + Выборка.БизнесПроцесс.ЗаказКлиента.Партнер;
			НоваяЗадача.Описание = "Позвонить клиенту по монтажу по "+ Выборка.БизнесПроцесс.ЗаказКлиента;
			НоваяЗадача.Записать();
			
			ТО = Выборка.БизнесПроцесс.ПолучитьОбъект();
			ТО.Напоминание14 = Истина;
			ТО.Записать();
		КонецЕсли;
		Если Не Выборка.БизнесПроцесс.Напоминание3 и ТекущаяДата()>(Выборка.БизнесПроцесс.ЗаказКлиента.ДатаОтгрузки -3*60*60*24) тогда
			НоваяЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			НоваяЗадача.Автор = ПараметрыСеанса.ТекущийПользователь;
			НоваяЗадача.АвторСтрокой = ПараметрыСеанса.ТекущийПользователь;
			НоваяЗадача.БизнесПроцесс = Выборка.БизнесПроцесс;
			НоваяЗадача.Важность =Перечисления.ВариантыВажностиЗадачи.Высокая;
			НоваяЗадача.Дата = ТекущаяДата();
			НоваяЗадача.Исполнитель = Выборка.Исполнитель;
			НоваяЗадача.Наименование = "Позвонить клиенту  за монтаж " + Выборка.БизнесПроцесс.ЗаказКлиента.Партнер;;
			НоваяЗадача.Описание = "Позвонить клиенту по монажу по "+ Выборка.БизнесПроцесс.ЗаказКлиента;
			НоваяЗадача.Записать();
			
			ТО = Выборка.БизнесПроцесс.ПолучитьОбъект();
			ТО.Напоминание3 = Истина;
			ТО.Записать();
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Функция ЗаказНеДоступенДляРедактирования(ЗаказКлиента) Экспорт
	
	Если ЗаказКлиента.Статус<>Перечисления.СтатусыЗаказовКлиентов.КОбеспечению Тогда
		Возврат Ложь;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	акЗакупкаТовара.Ссылка
	|ИЗ
	|	БизнесПроцесс.акЗакупкаТовара КАК акЗакупкаТовара
	|ГДЕ
	|	акЗакупкаТовара.Предмет = &ЗаказКлиента
	|	И акЗакупкаТовара.Завершен = ЛОЖЬ
	|	И акЗакупкаТовара.ЗаказПроверен = ИСТИНА";
	
	Запрос.УстановитьПараметр("ЗаказКлиента",ЗаказКлиента );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Если  
			//Найти(ПараметрыСеанса.ТекущийПользователь.Наименование,"Пировских") > 0 или 
			//Найти(ПараметрыСеанса.ТекущийПользователь.Наименование,"Савина") > 0 или
			//Найти(ПараметрыСеанса.ТекущийПользователь.Наименование,"Ефременко") > 0 или 
			РольДоступна("ИТ_Закупки") тогда
			Возврат Ложь;	
		Иначе 
			возврат Истина;
		конецесли;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции


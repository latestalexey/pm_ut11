﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача 
//   ТочкаМаршрутаБизнесПроцесса – точка маршрута 
//
// Возвращаемое значение:
//   Структура   – структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы.
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	ИмяФормы = "БизнесПроцесс.акВыполнениеЗакупки.Форма.Действие" + ТочкаМаршрутаБизнесПроцесса.Имя;
	
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", ИмяФормы);
	Возврат Результат;

КонецФункции


// Вызывается при выполнении задачи из формы списка.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача 
//   ТочкаМаршрутаСсылка – точка маршрута 
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	//TODO: Сюда нужно добавить код вызова проверки выполнения самого бизнес процесса	
//	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.Задание.ТочкиМаршрута.Проверить Тогда
//		УстановитьПривилегированныйРежим(Истина);
//		ЗаданиеОбъект = БизнесПроцессСсылка.ПолучитьОбъект();
//		ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
//		ЗаданиеОбъект.Выполнено = Истина;
//		ЗаданиеОбъект.Подтверждено = Истина;
//		ЗаданиеОбъект.Записать();
//	КонецЕсли;
	
КонецПроцедуры

// Вызывается при перенаправлении задачи.
//
// Параметры
//   ЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – перенаправляемая задача.
//   НоваяЗадачаСсылка  – ЗадачаСсылка.ЗадачаИсполнителя – задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	
	БизнесПроцессОбъект = ЗадачаСсылка.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
	БизнесПроцессОбъект.РезультатВыполнения = РезультатВыполненияПриПеренаправлении(ЗадачаСсылка) + 
		БизнесПроцессОбъект.РезультатВыполнения;
	УстановитьПривилегированныйРежим(Истина);
	БизнесПроцессОбъект.Записать();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Установка значений реквизитов предопределенных элементов справочника РолиИсполнителей,
// относящихся к согласованию закупок
// Вызывается при первоначальном заполнении ИБ.
//
Процедура ИнициализироватьРолиИсполнителей() Экспорт
	
	//РольОбъект = Справочники.РолиИсполнителей.акОтвественныйЗаДоставку.ПолучитьОбъект();
	//РольОбъект.ИспользуетсяБезОбъектовАдресации = Истина;
	//РольОбъект.Записать();
		
КонецПроцедуры


// Устанавливает состояние элементов формы задачи
Процедура УстановитьСостояниеЭлементовФормыЗадачи(Форма) Экспорт
	
	//Если Форма.Элементы.Найти("РезультатВыполнения") <> Неопределено Тогда
	//	Форма.Элементы.РезультатВыполнения.Видимость = НЕ ПустаяСтрока(Форма.ЗаданиеРезультатВыполнения);
	//КонецЕсли;
	//
	//Форма.Элементы.Предмет.Гиперссылка = Форма.Объект.Предмет <> Неопределено И НЕ Форма.Объект.Предмет.Пустая();
	//Форма.Элементы.Проект.Гиперссылка = Форма.Объект.БизнесПроцесс.акПроект <> Неопределено И НЕ Форма.Объект.БизнесПроцесс.акПроект.Пустая();

	//Форма.ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Форма.Объект.Предмет);	
	//Форма.ПроектСтрокой = ОбщегоНазначения.ПредметСтрокой(Форма.Объект.БизнесПроцесс.акПроект);	
	
КонецПроцедуры	
////////////////////////////////////////////////////////////////////////////////
// Прочее


Функция РезультатВыполненияПриПеренаправлении(Знач ЗадачаСсылка)
	
	СтрокаФормат = НСтр("ru = '%1, %2 перенаправил(а) задачу:
		|%3
		|'");
	
	Комментарий = СокрЛП(ЗадачаСсылка.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат,
	              ЗадачаСсылка.ДатаИсполнения,
	              ЗадачаСсылка.Исполнитель,
	              Комментарий);
	
	Возврат Результат;

КонецФункции


#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	
	ФормироватьРабочееНаименование =		Не (ДополнительныеСвойства.Свойство("РабочееНаименованиеСформировано"));
	ФормироватьНаименованиеДляПечати =		Не (ДополнительныеСвойства.Свойство("НаименованиеДляПечатиСформировано"));
	
	Если ФормироватьРабочееНаименование
		Или ФормироватьНаименованиеДляПечати Тогда
		
		СтруктураРеквизитов = Новый Структура;
		
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
			СтруктураРеквизитов.Вставить("ШаблонРабочегоНаименованияХарактеристики");
			СтруктураРеквизитов.Вставить("ЗапретРедактированияРабочегоНаименованияХарактеристики");
			СтруктураРеквизитов.Вставить("ШаблонНаименованияДляПечатиХарактеристики");
			СтруктураРеквизитов.Вставить("ЗапретРедактированияНаименованияХарактеристикиДляПечати");
		Иначе 
			СтруктураРеквизитов.Вставить("ШаблонРабочегоНаименованияХарактеристики","ВидНоменклатуры.ШаблонРабочегоНаименованияХарактеристики");
			СтруктураРеквизитов.Вставить("ЗапретРедактированияРабочегоНаименованияХарактеристики","ВидНоменклатуры.ЗапретРедактированияРабочегоНаименованияХарактеристики");
			СтруктураРеквизитов.Вставить("ШаблонНаименованияДляПечатиХарактеристики","ВидНоменклатуры.ШаблонНаименованияДляПечатиХарактеристики");
			СтруктураРеквизитов.Вставить("ЗапретРедактированияНаименованияХарактеристикиДляПечати","ВидНоменклатуры.ЗапретРедактированияНаименованияХарактеристикиДляПечати");
		КонецЕсли;
	
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, СтруктураРеквизитов);
		
		Если ФормироватьРабочееНаименование 
			И ЗначениеЗаполнено(РеквизитыОбъекта.ШаблонРабочегоНаименованияХарактеристики) 
			И (РеквизитыОбъекта.ЗапретРедактированияРабочегоНаименованияХарактеристики 
			Или Не ЗначениеЗаполнено(Наименование)) Тогда
			ШаблонНаименования = РеквизитыОбъекта.ШаблонРабочегоНаименованияХарактеристики;
			Наименование = НоменклатураСервер.НаименованиеПоШаблону(ШаблонНаименования, ЭтотОбъект);
		КонецЕсли;
		
		Если ФормироватьНаименованиеДляПечати
			И ЗначениеЗаполнено(РеквизитыОбъекта.ШаблонНаименованияДляПечатиХарактеристики) 
			И (РеквизитыОбъекта.ЗапретРедактированияНаименованияХарактеристикиДляПечати 
			Или Не ЗначениеЗаполнено(НаименованиеПолное)) Тогда
			ШаблонНаименованияДляПечати = РеквизитыОбъекта.ШаблонНаименованияДляПечатиХарактеристики;
			НаименованиеПолное = НоменклатураСервер.НаименованиеПоШаблону(ШаблонНаименованияДляПечати, ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		ТекстИсключения = НСтр("ru='Поле ""Рабочее наименование"" не заполнено'");
		ВызватьИсключение ТекстИсключения; 
		Отказ = Истина;
	КонецЕсли;
	
	КонтролироватьРабочееНаименование = Константы.КонтролироватьУникальностьРабочегоНаименованияНоменклатурыИХарактеристик.Получить()
	И Не (ДополнительныеСвойства.Свойство("РабочееНаименованиеПроверено"));
	
	Если КонтролироватьРабочееНаименование
		И Не Отказ Тогда
		Если Не Справочники.ХарактеристикиНоменклатуры.РабочееНаименованиеУникально(ЭтотОбъект) Тогда
			ТекстИсключения = НСтр("ru='Значение поля ""Рабочее наименование"" не уникально'");
			ВызватьИсключение ТекстИсключения; 
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Обработка смены пометки удаления.
	Если Не ЭтоНовый() Тогда
		
		Если РольДоступна("ИТ_ИзменениеХарактеристик") Тогда
			
			Иначе
			   Отказ = Истина;
			   ВызватьИсключение "Для изменения характеристики номенклатуры нет прав!!!";
		
		КонецЕсли;


		Если ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
			Справочники.КлючиАналитикиУчетаНоменклатуры.УстановитьПометкуУдаления(Новый Структура("Характеристика", Ссылка), ПометкаУдаления);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ПередЗаписью()

Процедура ПередУдалением(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Характеристика = &Характеристика";
	
	Запрос.УстановитьПараметр("Характеристика", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Штрихкод.Значение = Выборка.Штрихкод;
		НаборЗаписей.Отбор.Штрихкод.Использование = Истина;
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры // ПередУдалением()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

#КонецЕсли
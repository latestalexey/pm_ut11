﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ЗаписьКнигиПокупок.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДоходыИРасходыСервер.ОтразитьНДСЗаписиКнигиПокупок(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьЖурналУчетаСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ЗаписьДополнительногоЛиста Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КорректируемыйПериод");
	КонецЕсли; 
	
	Если НЕ ПредъявленСчетФактура Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерСчетаФактуры");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаСчетаФактуры");
	КонецЕсли; 
	
	Если НЕ ПредъявленСчетФактура ИЛИ Дата < Константы.ДатаНачалаПримененияПостановления1137.Получить() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КодВидаОперации");
	КонецЕсли; 
	
	Если СпособКорректировкиНДС = Перечисления.СпособыКорректировкиНДС.Отложить
		ИЛИ СпособКорректировкиНДС = Перечисления.СпособыКорректировкиНДС.Заблокировать Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Ценности.ВидЦенности");
		МассивНепроверяемыхРеквизитов.Добавить("Ценности.Событие");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Ценности.Номенклатура");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаДокумента = Ценности.Итог("Сумма") + Ценности.Итог("СуммаНДС");
	
	Если НЕ ЗначениеЗаполнено(ДокументРасчетов) И ДокументРасчетов <> Неопределено Тогда
		ДокументРасчетов = Неопределено
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ЗАПОЛНЕНИЕ ДОКУМЕНТА

Процедура ЗаполнитьРеквизитыПоУмолчанию()

	Ответственный	= Пользователи.ТекущийПользователь();
	Организация		= ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация",);
	Организация		= ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта			= Константы.ВалютаРегламентированногоУчета.Получить();
	
КонецПроцедуры

#КонецЕсли
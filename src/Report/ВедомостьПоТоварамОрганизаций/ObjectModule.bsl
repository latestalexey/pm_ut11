﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);	
	
	Параметр = НастройкаПараметра("УчитыватьПередачиЗапасовДругихОрганизаций");
	Параметр.Использование = Истина;
		
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

///////////////////////////////////////////////////////////////////////////////
// Прочее

Функция НастройкаПараметра(ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

#КонецЕсли
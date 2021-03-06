﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Очищает всю информацию ABC-классификаци клиентов.
Процедура ОчиститьABCКлассификацию() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ABCXYZКлассификацияКлиентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ТипКлассификации.Установить(Перечисления.ТипыКлассификации.ABC);
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Очищает всю информацию XYZ-классификаци клиентов.
Процедура ОчиститьXYZКлассификацию() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ABCXYZКлассификацияКлиентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ТипКлассификации.Установить(Перечисления.ТипыКлассификации.XYZ);
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецЕсли
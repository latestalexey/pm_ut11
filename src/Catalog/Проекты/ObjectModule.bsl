﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКопировании(ОбъектКопирования)
	
	Завершен = Ложь;
	ПлановаяДатаНачала = ТекущаяДата();
	ПлановаяДатаОкончания = Дата(1,1,1);
	ДатаНачала = ТекущаяДата();
	ПлановаяДатаОкончания = Дата(1,1,1);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Взаимодействия.УстановитьАктивностьПредмета(Ссылка,(НЕ Завершен) И (Не ПометкаУдаления));
	
КонецПроцедуры

#КонецЕсли
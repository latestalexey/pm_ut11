﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Отчет.ВыполнениеУсловийСоглашенийСКлиентами.Форма",
		Новый Структура("Отбор,СформироватьПриОткрытии", Новый Структура("Соглашение", ПараметрКоманды), Истина),
		,
		"Соглашение=" + ПараметрКоманды,
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Отчет.АнализЦенПоставщиков.Форма",
		Новый Структура("КлючВарианта, Отбор, СформироватьПриОткрытии", 
			"АнализЦенПоставщиков",
			Новый Структура("Документ", ПараметрКоманды), 
			Истина),
		,
		"Документ=" + ПараметрКоманды,
		ПараметрыВыполненияКоманды.Окно
	);

КонецПроцедуры
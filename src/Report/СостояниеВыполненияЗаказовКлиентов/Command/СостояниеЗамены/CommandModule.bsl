﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Отчет.СостояниеВыполненияЗаказовКлиентов.Форма",
		Новый Структура("КлючВарианта, Отбор, СформироватьПриОткрытии", 
			"СостояниеВыполненияЗаказовКлиентов",
			Новый Структура("Заказ", ПараметрКоманды), 
			Истина),
		,
		"Заказ=" + ПараметрКоманды,
		ПараметрыВыполненияКоманды.Окно
	);
		
КонецПроцедуры

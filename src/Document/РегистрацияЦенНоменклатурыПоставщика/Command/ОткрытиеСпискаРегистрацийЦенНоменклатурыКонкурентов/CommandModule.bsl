﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("ДоступноДляПродажиКлиентам", Истина);
	
	ОткрытьФорму(
		"Документ.РегистрацияЦенНоменклатурыПоставщика.Форма.ФормаСписка",
		СтруктураОтбора,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры

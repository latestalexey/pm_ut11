﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.ПриходныйКассовыйОрдер",
			"КО1",
			ПараметрКоманды,
			ПараметрыВыполненияКоманды.Источник,
			Неопределено
		);
	КонецЕсли;
	
КонецПроцедуры

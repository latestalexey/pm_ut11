﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.СверкаВзаиморасчетов",
			"АктСверкиВзаимныхРасчетов",
			ПараметрКоманды,
			Неопределено,
			Неопределено
		);
		
	КонецЕсли;

КонецПроцедуры

﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
	
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.ВозвратТоваровПоставщику",
			"ВозвратПоставщику",
			ПараметрКоманды,
			Неопределено,
			Неопределено
		);
	
	КонецЕсли;

КонецПроцедуры

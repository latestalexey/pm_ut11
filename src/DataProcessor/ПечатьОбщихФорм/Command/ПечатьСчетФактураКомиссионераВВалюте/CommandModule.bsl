﻿// Процедура - обработчик события "ОбработкаКоманды".
//
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.ПечатьОбщихФорм",
			"СчетФактураВВалюте",
			ПараметрКоманды,
			ПараметрыВыполненияКоманды.Источник,
			Новый Структура("ВидФормы, ПечатьВВалюте", "Комиссионер", Истина)   // Вид печатной формы
		);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаКоманды()

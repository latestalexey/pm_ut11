﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЭлектронныеДокументыКлиентПереопределяемый.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
		ЭлектронныеДокументыКлиент.СформироватьНовыйЭД(ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры

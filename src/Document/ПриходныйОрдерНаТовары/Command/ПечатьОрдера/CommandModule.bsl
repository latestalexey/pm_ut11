﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
    	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ПриходныйОрдерНаТовары", "ПриходныйОрдерНаТовары", ПараметрКоманды,Неопределено,Новый Структура);
	КонецЕсли;
КонецПроцедуры

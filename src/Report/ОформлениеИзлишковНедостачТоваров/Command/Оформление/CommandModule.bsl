﻿&НаСервере
Функция ОснованиеОформленияИзлишковНедостачТоваров(ПараметрКоманды)
	Возврат СкладыСервер.ОснованиеОформленияИзлишковНедостачТоваров(ПараметрКоманды);
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Основание = ОснованиеОформленияИзлишковНедостачТоваров(ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура(
		"Отбор, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии",
		Новый Структура("Основание",Основание),
		"ОформлениеИзлишковНедостачКонтекст",
		"ОформлениеИзлишковНедостачКонтекст",
		Истина);

	ОткрытьФорму("Отчет.ОформлениеИзлишковНедостачТоваров.Форма",
				ПараметрыФормы,
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность,
				ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Отбор, Заголовок", Новый Структура("Контрагент", ПараметрКоманды), НСтр("ru='Договоры по контрагенту'"));
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаСписка",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры

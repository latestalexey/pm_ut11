﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Отбор, Заголовок", Новый Структура("Контрагент", ПараметрКоманды), НСтр("ru='Кредиты и депозиты контрагента'"));	
		
	ОткрытьФорму("Справочник.ДоговорыКредитовИДепозитов.ФормаСписка",
				 ПараметрыФормы,
				 ПараметрыВыполненияКоманды.Источник,
				 ПараметрыВыполненияКоманды.Уникальность,
				 ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры

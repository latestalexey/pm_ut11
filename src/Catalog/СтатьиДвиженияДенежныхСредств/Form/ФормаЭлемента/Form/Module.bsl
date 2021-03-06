﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДенежныеСредстваСервер.УстановитьВидимостьОперацийПередачиМеждуОрганизациями(ЭтаФорма, Элементы.ХозяйственнаяОперация);
	ДенежныеСредстваСервер.УстановитьВидимостьОперацийВнутреннейПередачи(ЭтаФорма, Элементы.ХозяйственнаяОперация);
	ДенежныеСредстваСервер.УстановитьВидимостьОперацииПеречислениеТаможне(ЭтаФорма, Элементы.ХозяйственнаяОперация);
	
	Если Метаданные.ПланыСчетов.Найти("Хозрасчетный") <> Неопределено Тогда
		Элементы.КорреспондирующийСчет.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	Объект.КорреспондирующийСчет = "";
	
КонецПроцедуры

&НаКлиенте
Процедура КорреспондирующийСчетНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокСчетов = Новый СписокЗначений;
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочиеДоходы") Тогда
		
		СписокСчетов.Добавить("91.01", "Прочие доходы (91.01)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочиеРасходы") Тогда
		
		СписокСчетов.Добавить("25", "Общепроизводственные расходы (25)");
		СписокСчетов.Добавить("26", "Общехозяйственные расходы (26)");
		СписокСчетов.Добавить("44.01", "Издержки обращения (44.01)");
		СписокСчетов.Добавить("44.02", "Коммерческие расходы (44.02)");
		СписокСчетов.Добавить("70", "Расчеты с персоналом по оплате труда (70)");
		СписокСчетов.Добавить("91.02", "Прочие расходы (91.02)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств") Тогда
		
		СписокСчетов.Добавить("57.02", "Приобретение иностранной валюты (57.02)");
		СписокСчетов.Добавить("57.22", "Реализация иностранной валюты (57.22)");
		СписокСчетов.Добавить("66.01", "Краткосрочные кредиты (66.01)");
		СписокСчетов.Добавить("67.01", "Долгосрочные кредиты (67.01)");
		СписокСчетов.Добавить("76.09", "Прочие расчеты с разными дебиторами и кредиторами (76.09)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств") Тогда
		
		СписокСчетов.Добавить("57.02", "Приобретение иностранной валюты (57.02)");
		СписокСчетов.Добавить("57.22", "Реализация иностранной валюты (57.22)");
		СписокСчетов.Добавить("66.01", "Краткосрочные кредиты (66.01)");
		СписокСчетов.Добавить("67.01", "Долгосрочные кредиты (67.01)");
		СписокСчетов.Добавить("76.09", "Прочие расчеты с разными дебиторами и кредиторами (76.09)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу") Тогда
		
		СписокСчетов.Добавить("50.01", "Касса организации (50.01)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаПоставщику") Тогда
		
		СписокСчетов.Добавить("60.01", "Расчеты с поставщиками и подрядчиками (60.01)");
		СписокСчетов.Добавить("60.02", "Расчеты по авансам выданным (60.02)");
		СписокСчетов.Добавить("76.05", "Расчеты с прочими поставщиками и подрядчиками (76.05)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка") Тогда
		
		СписокСчетов.Добавить("51", "Расчетные счета (51)");
		СписокСчетов.Добавить("52", "Валютные счета (52)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента") Тогда
		
		СписокСчетов.Добавить("62.01", "Расчеты с покупателями и заказчиками (62.01)");
		СписокСчетов.Добавить("62.02", "Расчеты по авансам полученным (62.02)");
		СписокСчетов.Добавить("76.06", "Расчеты с прочими покупателями и заказчиками (76.06)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СдачаДенежныхСредствВБанк") Тогда
		
		СписокСчетов.Добавить("51", "Расчетные счета (51)");
		СписокСчетов.Добавить("52", "Валютные счета (52)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию") Тогда
		
		СписокСчетов.Добавить("60.01", "Расчеты с поставщиками и подрядчиками (60.01)");
		СписокСчетов.Добавить("60.02", "Расчеты по авансам выданным (60.02)");
		СписокСчетов.Добавить("76.05", "Расчеты с прочими поставщиками и подрядчиками (76.05)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВКассуККМ") Тогда
		
		СписокСчетов.Добавить("50.01", "Касса организации (50.01)");
		СписокСчетов.Добавить("50.02", "Операционная касса (50.02)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ") Тогда
		
		СписокСчетов.Добавить("50.01", "Касса организации (50.01)");
		СписокСчетов.Добавить("50.02", "Операционная касса (50.02)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника") Тогда
		
		СписокСчетов.Добавить("71.01", "Расчеты с подотчетными лицами (71.01)");
		СписокСчетов.Добавить("71.21", "Расчеты с подотчетными лицами (в валюте) (71.21)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика") Тогда
		
		СписокСчетов.Добавить("60.01", "Расчеты с поставщиками и подрядчиками (60.01)");
		СписокСчетов.Добавить("60.02", "Расчеты по авансам выданным (60.02)");
		СписокСчетов.Добавить("76.05", "Расчеты с прочими поставщиками и подрядчиками (76.05)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту") Тогда
		
		СписокСчетов.Добавить("62.01", "Расчеты с покупателями и заказчиками (62.01)");
		СписокСчетов.Добавить("62.02", "Расчеты по авансам полученным (62.02)");
		СписокСчетов.Добавить("76.06", "Расчеты с прочими покупателями и заказчиками (76.06)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику") Тогда
		
		СписокСчетов.Добавить("71.01", "Расчеты с подотчетными лицами (71.01)");
		СписокСчетов.Добавить("71.21", "Расчеты с подотчетными лицами (в валюте) (71.21)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы") Тогда
		
		СписокСчетов.Добавить("50.01", "Касса организации (50.01)");
		СписокСчетов.Добавить("50.21", "Касса организации (в валюте) (50.21)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств") Тогда
		
		СписокСчетов.Добавить("79.02", "Расчеты по текущим операциям (79.02)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.КонвертацияВалюты") Тогда
		
		СписокСчетов.Добавить("57.02", "Приобретение иностранной валюты (57.02)");
		СписокСчетов.Добавить("57.22", "Реализация иностранной валюты (57.22)");
		
	ИначеЕсли Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗаработнойПлатыПоВедомостям")
		Или Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗаработнойПлатыРаботнику") Тогда
		
		СписокСчетов.Добавить("70", "Расчеты с персоналом по оплате труда (70)");
		
	КонецЕсли;
	
	Если СписокСчетов.Количество() > 0 Тогда
		ВыбранноеЗначение = ВыбратьИзМеню(СписокСчетов, Элементы.КорреспондирующийСчет);
		Если ВыбранноеЗначение <> Неопределено Тогда
			Объект.КорреспондирующийСчет = ВыбранноеЗначение.Значение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


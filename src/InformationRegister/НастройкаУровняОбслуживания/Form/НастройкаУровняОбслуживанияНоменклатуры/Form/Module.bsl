﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Номенклатура") Тогда

		Номенклатура = Параметры.Отбор.Номенклатура;

		Если Номенклатура.ВидНоменклатуры.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.Товар
			И Номенклатура.ВидНоменклатуры.ТипНоменклатуры <> Перечисления.ТипыНоменклатуры.МногооборотнаяТара Тогда
			
			АвтоЗаголовок = Ложь;
			Заголовок = НСтр("ru = 'Для услуг (работ) настройка уровня обслуживания не используется'");

			Элементы.НастройкаУровняОбслуживания.ТолькоПросмотр = Истина;
			
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

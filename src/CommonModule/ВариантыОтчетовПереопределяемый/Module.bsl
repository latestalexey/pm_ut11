﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Варианты отчетов" (сервер, переопределяемый)
// 
// Выполняется на сервере, изменяется под специфику прикладной конфигурации,
// но предназначен для использования только данной подсистемой.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Определяет разделы, в которых доступна панель отчетов.
//
// Параметры:
//   Разделы (Массив) из (ОбъектМетаданных)
//
// Описание:
//   В Разделы необходимо добавить метаданные подсистем тех разделов,
//   в которых размещены команды вызова панелей отчетов.
//
// Например:
//	Разделы.Добавить(Метаданные.Подсистемы.ИмяПодсистемы);
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ОпределитьРазделыСВариантамиОтчетов(Разделы);
	
КонецПроцедуры

// Содержит настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//   Настройки (ДеревоЗначений) Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//
// Описание:
//   В данной процедуре необходимо указать каким именно образом предопределенные варианты отчетов
//   будут регистрироваться в системе и показываться в панели отчетов.
//
// Вспомогательные функции:
//   Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//   Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "<ИмяВарианта>");
//
//   Данные функции получают описание отчета или варианта отчета следующей структуры:
//       |- Включен (Булево)
//            Если Ложь, то вариант отчета не регистрируется в подсистеме.
//              Используется для удаления технических и контекстных вариантов отчетов из всех интерфейсов.
//              Эти варианты отчета по прежнему можно открывать в форме отчета программно при помощи
//              параметров открытия (см. справку по "Расширение управляемой формы для отчета.КлючВарианта").
//       |- ВидимостьПоУмолчанию (Булево)
//            Если Ложь, то вариант отчета по умолчанию скрыт в панели отчетов.
//              Пользователь может "включить" его в режиме настройки панели отчетов
//              или открыть через форму "Все отчеты".
//       |- Описание (Строка)
//            Дополнительная информация по варианту отчета.
//              В панели отчетов выводится в качестве подсказки.
//              Должно расшифровывать для пользователя содержимое варианта отчета
//              и не должно дублировать наименование варианта отчета.
//       |- Размещение (Соответствие) Настройки размещения варианта отчета в разделах
//           |- Ключ     (ОбъектМетаданных) Подсистема, в которой размещается отчет или вариант отчета
//           |- Значение (Строка)           Необязательный. Настройки размещения в подсистеме.
//               |- ""        - Выводить отчет в своей группе обычным шрифтом.
//               |- "Важный"  - Выводить отчет в своей группе жирным шрифтом.
//               |- "СмТакже" - Выводить отчет в группе "См. также".
//
// Например:
//
//  (1) Оставить в подсистеме только один из вариантов отчета
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	Отчет.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела);
//
//  (2) Отключить вариант отчета
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "ИмяВарианта1");
//	Вариант.Включен = Ложь;
//
//  (3) Отключить все варианты отчета, кроме требуемого
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Включен = Ложь;
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта");
//	Вариант.Включен = Истина;
//
//  (4) Результат исполнения любого из двух фрагментов кода будет одинаковым:
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта2");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта3");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта2");
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта3");
//	Отчет.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//
// Важно:
//   Начальная настройка размещения отчетов по разделам зачитывается из метаданных,
//   ее дублирование в коде не требуется.
//   
//   Настройки варианта имеют приоритет над настройками отчета.
//   
//   Настройки варианта при получении формируются из настроек отчета
//   и после получения не зависят от настроек отчета (становятся самостоятельными, см. примеры 3 и 4).
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.НастроитьВариантыОтчетов(Настройки);
	
КонецПроцедуры 

// Содержит описания изменений имен вариантов отчетов. Используется
//   при обновлении информационной базы, в целях контроля ссылочной целостности
//   и для сохранения настроек варианта, сделанных администратором.
//
// Параметры:
//   Изменения (ТаблицаЗначений) Таблица изменений имен вариантов
//       |- Отчет (ОбъектМетаданных)
//       |- СтароеИмяВарианта (Строка)
//       |- АктуальноеИмяВарианта (Строка)
//
// Описание:
//   В Изменения необходимо добавить описания изменений имен вариантов
//   отчетов, подключенных к подсистеме.
//
// Например:
//	Изменение = Изменения.Добавить();
//	Изменение.Отчет = Метаданные.Отчеты.<ИмяОтчета>;
//	Изменение.СтароеИмяВарианта = "<СтароеИмяВарианта>";
//	Изменение.АктуальноеИмяВарианта = "<АктуальноеИмяВарианта>";
//
// Важно:
//   Старое имя варианта резервируется и не может быть использовано в дальнейшем.
//   Если изменений было несколько, то каждое изменение необходимо зарегистрировать,
//   указывая в актуальном имени варианта последнее (текущее) имя варианта отчета.
//   Поскольку имена вариантов отчетов не выводятся в пользовательском интерфейсе,
//   то рекомендуется задавать их таким образом, что бы затем не менять.
//
Процедура ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения);
	
КонецПроцедуры

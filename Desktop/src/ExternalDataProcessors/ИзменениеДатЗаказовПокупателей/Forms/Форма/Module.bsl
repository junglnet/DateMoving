&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	СтраницыПриСменеСтраницыНаСервере();
КонецПроцедуры

// Смена вкладки
&НаСервере
Процедура СтраницыПриСменеСтраницыНаСервере()
	ЗаказыПокупателейТаблица.Очистить();
КонецПроцедуры

//// Начало Обработка пользовательский настроек
&НаСервере
Процедура СохранитьНастройкиНаСервере(КлючОбъекта, КлючНастроек, Пользователь = Неопределено)
    // ключи могут быть произвольными строками, например:
    //КлючОбъекта  = "СохранениеНастроекПользователяФорма";
    //КлючНастроек = "ВсеНастройки";
    
    Настройки = Новый Структура; 
	Для Каждого Элем ИЗ Элементы Цикл 
		 
		Если Элем.Родитель = Элементы.Опции Тогда
		
			Если ТипЗнч(Элем) = Тип("ПолеФормы") Тогда
	            
	            Если Объект.Свойство(Элем.Имя) Тогда 
	                Настройки.Вставить(Элем.Имя, Объект[Элем.Имя]);
	            Иначе
	                Настройки.Вставить(Элем.Имя, ЭтаФорма[Элем.Имя]);
	            
	            КонецЕсли;
			
			КонецЕсли;	
		
		КонецЕсли;
		
		Если Элем.Родитель = Элементы.Отбор Тогда
		
			Если ТипЗнч(Элем) = Тип("ПолеФормы") Тогда
	            
	            Если Объект.Свойство(Элем.Имя) Тогда 
	                Настройки.Вставить(Элем.Имя, Объект[Элем.Имя]);
	            Иначе
	                Настройки.Вставить(Элем.Имя, ЭтаФорма[Элем.Имя]);
	            
	            КонецЕсли;
			
			КонецЕсли;	
		
		КонецЕсли;
		
    КонецЦикла;
    
    //если пользователя не указать (значение Неопределено),
    // то настройки будут сохранены для ТЕКУЩЕГО пользователя
    Попытка
    	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта,  КлючНастроек, Настройки,, Пользователь);
    	Сообщить("Настройки сохранены");
    Исключение
        Сообщить(ОписаниеОшибки());
    КонецПопытки;
    
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиНаСервере(КлючОбъекта, КлючНастроек, Пользователь = Неопределено)
    //КлючОбъекта  = "СохранениеНастроекПользователяФорма";
    //КлючНастроек = "ВсеНастройки";
    
    СтруктураНастроек = Неопределено;
    Попытка
        СтруктураНастроек = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта,КлючНастроек, ,Пользователь);
        // если настроек нет, то будет возвращено значение "Неопределено"
    Исключение
        Сообщить(ОписаниеОшибки());
    КонецПопытки;
    
    Если СтруктураНастроек <> Неопределено Тогда
        Для Каждого Настройка Из СтруктураНастроек Цикл
            Если Объект.Свойство(Настройка.Ключ) Тогда 
                Объект[Настройка.Ключ] = Настройка.Значение;
            Иначе
                ЭтаФорма[Настройка.Ключ] = Настройка.Значение;
            КонецЕсли;
        КонецЦикла;
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	СохранитьНастройкиНаСервере("ПереносЗаказовФорма", "ПереносЗаказовНастройка");
	
КонецПроцедуры


#Область СдвигДатЗаказов

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВосстановитьНастройкиНаСервере("ПереносЗаказовФорма", "ПереносЗаказовНастройка");
	
	//ПоДатеОтгрузки = Истина;
	
	ПоДатеСтарта  = Истина;  
	
	ИспДатаОтгрузки = Истина;

	ИспДатаКомплектовки = Истина;

	ИспДатаПокраски = Истина;

	ИспДатаСборки = Истина;

	ИспДатаСтарта = Истина;

	//ИскПроизведенные = Ложь;

		 
КонецПроцедуры

&НаКлиенте
Процедура ПоДатеОтгрузкиПриИзменении(Элемент)
	
	Если ПоДатеОтгрузки = Истина Тогда
		
		ПоДатеСтарта = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоДатеСтартаПриИзменении(Элемент)
	
	Если ПоДатеСтарта = Истина Тогда
		
		ПоДатеОтгрузки = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьКоманда(Команда)
	
	ОтобратьЗаказы();
	
КонецПроцедуры

&НаСервере
Процедура ОтобратьЗаказы()
	
	Запрос = Новый Запрос;
	
	Если ПоДатеОтгрузки = Истина Тогда
		
		Запрос.Текст =   "ВЫБРАТЬ
		|	ЗаказПокупателя.Ссылка КАК Ссылка,
		|	ЗаказПокупателя.ББ_ДатаСтарта КАК ДатаСтарта,
		|	ЗаказПокупателя.ДатаОтгрузки КАК ДатаОтгрузки,
		|	ЗаказПокупателя.ББ_комплект КАК Комплект,
		|	ЗаказПокупателя.ББ_ДатаСборки КАК ДатаСборки,
		|	ЗаказПокупателя.ББ_ДатаПокраски КАК ДатаПокраски,
		|	ЗаказПокупателя.ББ_ДатаКомплектовки КАК ДатаКомплектовки,
		|	1 КАК Изм,
		|	ЗаказПокупателя.ВидЗаказа КАК ВидЗаказа,
		|	ЗаказПокупателя.ББ_Материал КАК Материал,
		|   ЗаказПокупателя.Контрагент КАК Покупатель,
		|   ЗаказПокупателя.СостояниеЗаказа КАК Состояние
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
		|ГДЕ
		|	ЗаказПокупателя.ББ_комплект В ИЕРАРХИИ (&ББ_комплект)
		|	И ЗаказПокупателя.ДатаОтгрузки МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ЗаказПокупателя.ББ_ФактОтгрузки = ЛОЖЬ
		|	И ЗаказПокупателя.ВидЗаказа В ИЕРАРХИИ (&ВидЗаказа)		
		|УПОРЯДОЧИТЬ ПО
		|	ДатаОтгрузки";     
		
	КонецЕсли;
	
	Если ПоДатеСтарта = Истина Тогда
		
		Запрос.Текст =   "ВЫБРАТЬ
		|	ЗаказПокупателя.Ссылка КАК Ссылка,
		|	ЗаказПокупателя.ББ_ДатаСтарта КАК ДатаСтарта,
		|	ЗаказПокупателя.ДатаОтгрузки КАК ДатаОтгрузки,
		|	ЗаказПокупателя.ББ_комплект КАК Комплект,
		|	ЗаказПокупателя.ББ_ДатаСборки КАК ДатаСборки,
		|	ЗаказПокупателя.ББ_ДатаПокраски КАК ДатаПокраски,
		|	ЗаказПокупателя.ББ_ДатаКомплектовки КАК ДатаКомплектовки,
		|	1 КАК Изм,
		|	ЗаказПокупателя.ВидЗаказа КАК ВидЗаказа,
		|	ЗаказПокупателя.ББ_Материал КАК Материал,
		|	ЗаказПокупателя.Контрагент КАК Покупатель,
		|   ЗаказПокупателя.СостояниеЗаказа КАК Состояние
		|ИЗ
		|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
		|ГДЕ
		|	ЗаказПокупателя.ББ_комплект В ИЕРАРХИИ (&ББ_комплект)
		|	И ЗаказПокупателя.ББ_ДатаСтарта МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ЗаказПокупателя.ББ_ФактОтгрузки = ЛОЖЬ
		|	И ЗаказПокупателя.ВидЗаказа В ИЕРАРХИИ (&ВидЗаказа)
		|УПОРЯДОЧИТЬ ПО
		|	ДатаСтарта,
		|	Ссылка";     
		
	КонецЕсли;

	
		
	Запрос.УстановитьПараметр("ББ_комплект", ВариантыКомплектовки);
	Запрос.УстановитьПараметр("ВидЗаказа", ВидыЗаказовПокупателей);
	//Запрос.УстановитьПараметр("ББ_Материал", Материал);
	Запрос.УстановитьПараметр("НачалоПериода", ДиапазонНачало);
	Запрос.УстановитьПараметр("КонецПериода", ДиапазонКонец);		
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(Таблица, "ЗаказыПокупателейТаблица");
		
	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДатыКоманда(Команда)
	
	  ИзменитьДатыСервер();
		
КонецПроцедуры

&НаСервере
Процедура ИзменитьДатыСервер()	
	
	Если КоличествоДней <> 0 Тогда 
		
		Для Каждого Строка Из ЗаказыПокупателейТаблица Цикл 			
			
			Если Строка.Изм = Ложь Тогда
				
				Сообщить("Заказ " + Строка.Ссылка + " пропущен");
				
				Продолжить;	
				
			КонецЕсли;
			
			СпрНомОбъект = Строка.Ссылка.ПолучитьОбъект();
			
			ИзмДатаОтгрузки = ЛОЖЬ;
			
			
			// Изменение даты отгрузки			
			Если ЗначениеЗаполнено(СпрНомОбъект.ДатаОтгрузки) И ИспДатаОтгрузки Тогда				
				
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ДатаОтгрузки) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
					
					СпрНомОбъект.ДатаОтгрузки = КонецДня(СпрНомОбъект.ДатаОтгрузки) + (86400 * КоличествоДней);
					
				КонецЕсли; 								  
				
				
				
			КонецЕсли;
			 
			 
			// Изменение даты комплектовки
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаКомплектовки) И ИспДатаКомплектовки Тогда
								
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ББ_ДатаКомплектовки) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
					
					СпрНомОбъект.ББ_ДатаКомплектовки = КонецДня(СпрНомОбъект.ББ_ДатаКомплектовки) + (86400 * КоличествоДней);
					
				КонецЕсли; 				
			КонецЕсли;
			
			//Изменение даты старта
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаСтарта) И ИспДатаСтарта Тогда				
				
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ББ_ДатаСтарта) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
					
					СпрНомОбъект.ББ_ДатаСтарта = КонецДня(СпрНомОбъект.ББ_ДатаСтарта) + (86400 * КоличествоДней);
					
				КонецЕсли; 				
				 				
			КонецЕсли;
			
			//Изменение даты сборки
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаСборки) И ИспДатаСборки Тогда				
				
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ББ_ДатаСборки) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
					
					СпрНомОбъект.ББ_ДатаСборки = КонецДня(СпрНомОбъект.ББ_ДатаСборки) + (86400 * КоличествоДней);
					
				КонецЕсли; 
				
				
				
			КонецЕсли;
			
			//Изменение даты покраски
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаПокраски) И ИспДатаПокраски Тогда				
				
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ББ_ДатаПокраски) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
										
					СпрНомОбъект.ББ_ДатаПокраски = КонецДня(СпрНомОбъект.ББ_ДатаПокраски) + (86400 * КоличествоДней);
					
				КонецЕсли 				
			КонецЕсли;
			
			Попытка
					
				СпрНомОбъект.Записать();
					
			Исключение
					
				Сообщить("Ошибка записи объекта " + СпрНомОбъект + "!|" + ОписаниеОшибки());
					
			КонецПопытки;
			
		КонецЦикла;      
	
		ОтобратьЗаказы();	
		
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти

#Область МассоваяКорректировкаДатЗаказов
&НаКлиенте
Процедура ОтобратьЗаказыВкладка2(Команда)
	ОтобратьЗаказыВкладка2НаСервере();
КонецПроцедуры
 
&НаСервере
Процедура ОтобратьЗаказыВкладка2НаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст =   "ВЫБРАТЬ
	|	ЗаказПокупателя.Ссылка КАК Ссылка,
	|	ЗаказПокупателя.ББ_ДатаСтарта КАК ДатаСтарта,
	|	ЗаказПокупателя.ДатаОтгрузки КАК ДатаОтгрузки,
	|	ЗаказПокупателя.ББ_комплект КАК Комплект,
	|	ЗаказПокупателя.ББ_ДатаСборки КАК ДатаСборки,
	|	ЗаказПокупателя.ББ_ДатаПокраски КАК ДатаПокраски,
	|	ЗаказПокупателя.ББ_ДатаКомплектовки КАК ДатаКомплектовки,
	|	0 КАК Изм,
	|	ЗаказПокупателя.ВидЗаказа КАК ВидЗаказа,
	|	ЗаказПокупателя.Контрагент КАК Покупатель,
	|	ЗаказПокупателя.ББ_Материал КАК Материал,
	|	ЗаказПокупателя.СостояниеЗаказа КАК Состояние
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	|ГДЕ
	|	(((&Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	ИЛИ ЗаказПокупателя.Контрагент = &Контрагент)
	|	И (&ББ_ДатаСтарта = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	ИЛИ ЗаказПокупателя.ББ_ДатаСтарта = &ББ_ДатаСтарта)
	|	И (&ДатаОтгрузки = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	ИЛИ ЗаказПокупателя.ДатаОтгрузки = &ДатаОтгрузки)))
	|УПОРЯДОЧИТЬ ПО
	|	ДатаСтарта,
	|	Ссылка";   
		
		
	Запрос.УстановитьПараметр("Контрагент", Покупатель);
	Запрос.УстановитьПараметр("ДатаОтгрузки", ДатаОтгрузкиОтбор);
	Запрос.УстановитьПараметр("ББ_ДатаСтарта", ДатаСтартаОтбор);		
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(Таблица, "ЗаказыПокупателейТаблица");
		  
КонецПроцедуры

&НаКлиенте
Процедура ВнестиИзмененияВкладка2(Команда)
	ВнестиИзмененияВкладка2НаСервере();
КонецПроцедуры

&НаСервере
Процедура ВнестиИзмененияВкладка2НаСервере()
	
	Для Каждого Строка Из ЗаказыПокупателейТаблица Цикл 			
			
			Если Строка.Изм = Ложь Тогда
				
				// Сообщить("Заказ " + Строка.Ссылка + " пропущен");
				
				Продолжить;	
				
			КонецЕсли;
			
			СпрНомОбъект = Строка.Ссылка.ПолучитьОбъект();			

			
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаСтарта) Тогда
					
				Если ЗначениеЗаполнено(ДатаСтарта) Тогда
					
					СпрНомОбъект.ББ_ДатаСтарта = ДатаСтарта;
					
				КонецЕсли;
									
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаПокраски) Тогда
				
				Если ЗначениеЗаполнено(ДатаПокраски) Тогда
					СпрНомОбъект.ББ_ДатаПокраски = ДатаПокраски;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаКомплектовки) Тогда
				
				Если ЗначениеЗаполнено(ДатаКомплектовки) Тогда
				
					СпрНомОбъект.ББ_ДатаКомплектовки = ДатаКомплектовки;
				
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаСборки) Тогда
				
				Если ЗначениеЗаполнено(ДатаСборки) Тогда
				
					СпрНомОбъект.ББ_ДатаСборки = ДатаСборки;
				
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СпрНомОбъект.ДатаОтгрузки) Тогда
				
				Если ЗначениеЗаполнено(ДатаОтгрузки) Тогда
				
					СпрНомОбъект.ДатаОтгрузки = ДатаОтгрузки;
				
				КонецЕсли;
				
			КонецЕсли;
						
			

			Попытка
					
				СпрНомОбъект.Записать();
					
			Исключение
					
				Сообщить("Ошибка записи объекта " + СпрНомОбъект + "!|" + ОписаниеОшибки());
					
			КонецПопытки;
			
	КонецЦикла;
	
	ОтобратьЗаказыВкладка2НаСервере();
	   
КонецПроцедуры

#КонецОбласти


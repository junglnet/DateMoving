&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
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
		|	ЗаказПокупателя.ББ_Материал КАК Материал
		|   ЗаказПокупателя.Контрагент КАК Покупатель
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
		|	ЗаказПокупателя.Контрагент КАК Покупатель
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
					
					СпрНомОбъект.ББ_КомментарийКЗадаче = Логирование("Старая дата отгрузки", СпрНомОбъект.ДатаОтгрузки, СпрНомОбъект.ББ_КомментарийКЗадаче);
					
					СпрНомОбъект.ДатаОтгрузки = КонецДня(СпрНомОбъект.ДатаОтгрузки) + (86400 * КоличествоДней);
					
				КонецЕсли; 								  
				
				
				
			КонецЕсли;
			 
			 
			// Изменение даты комплектовки
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаКомплектовки) И ИспДатаКомплектовки Тогда
								
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ББ_ДатаКомплектовки) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
					
					СпрНомОбъект.ББ_КомментарийКЗадаче = Логирование("Старая дата комплект.", СпрНомОбъект.ББ_ДатаКомплектовки, СпрНомОбъект.ББ_КомментарийКЗадаче);
					
					СпрНомОбъект.ББ_ДатаКомплектовки = КонецДня(СпрНомОбъект.ББ_ДатаКомплектовки) + (86400 * КоличествоДней);
					
				КонецЕсли; 				
			КонецЕсли;
			
			//Изменение даты старта
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаСтарта) И ИспДатаСтарта Тогда				
				
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ББ_ДатаСтарта) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
					
					СпрНомОбъект.ББ_КомментарийКЗадаче = Логирование("Старая дата старта.", СпрНомОбъект.ББ_ДатаСтарта, СпрНомОбъект.ББ_КомментарийКЗадаче);
					
					СпрНомОбъект.ББ_ДатаСтарта = КонецДня(СпрНомОбъект.ББ_ДатаСтарта) + (86400 * КоличествоДней);
					
				КонецЕсли; 				
				 				
			КонецЕсли;
			
			//Изменение даты сборки
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаСборки) И ИспДатаСборки Тогда				
				
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ББ_ДатаСборки) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
					
					СпрНомОбъект.ББ_КомментарийКЗадаче = Логирование("Старая дата сборки.", СпрНомОбъект.ББ_ДатаСборки, СпрНомОбъект.ББ_КомментарийКЗадаче);
					
					СпрНомОбъект.ББ_ДатаСборки = КонецДня(СпрНомОбъект.ББ_ДатаСборки) + (86400 * КоличествоДней);
					
				КонецЕсли; 
				
				
				
			КонецЕсли;
			
			//Изменение даты покраски
			Если ЗначениеЗаполнено(СпрНомОбъект.ББ_ДатаПокраски) И ИспДатаПокраски Тогда				
				
				
				Если СпрНомОбъект.ББ_ЗаданиеНаПроизводство И НачалоДня(СпрНомОбъект.ББ_ДатаПокраски) < НачалоДня(ДиапазонНачало) Тогда
					
				Иначе
					
					СпрНомОбъект.ББ_КомментарийКЗадаче = Логирование("Старая дата покраски.", СпрНомОбъект.ББ_ДатаПокраски, СпрНомОбъект.ББ_КомментарийКЗадаче);
					
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

&НаСервере
Функция Логирование(Заголовок, СтараяДата, ПолеЗаписи)
	
	Возврат ПолеЗаписи + Символы.ПС + Заголовок + Символы.НПП + СтараяДата;
	
КонецФункции
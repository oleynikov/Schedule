package engine{
	// ИМПОРТИРУЕМЫЕ ПАКЕТЫ
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.EventDispatcher;
	import flashx.textLayout.elements.ParagraphElement;
	// КЛАСС - ЗАГРУЗЧИК РАСПИСАНИЯ В ФОРМАТЕ XML
	public class XmlLoader extends Array {
		// СВОЙСТВА КЛАССА
		private var sl_XmlLoader:URLLoader;
		public var sl_ScheduleItems:Array;
		public var sl_EventDispatcher:EventDispatcher;
		// КОНСТРУКТОР КЛАССА
		public function XmlLoader(sl_XmlUrl:String):void {
			this.sl_ScheduleItems = new Array();
			this.sl_EventDispatcher = new EventDispatcher();
			sl_XmlRequest(sl_XmlUrl);
		}
		// ОТПРАВКА ЗАПРОСА НА СЕРВЕР
		private function sl_XmlRequest(sl_XmlUrl:String):void {
			var sl_XmlUrlRequest:URLRequest = new URLRequest(sl_XmlUrl);
			this.sl_XmlLoader = new URLLoader(sl_XmlUrlRequest);
			this.sl_XmlLoader.addEventListener(Event.COMPLETE,sl_XmlParse);
		}
		// ПАРСИНГ XML ФАЙЛА;
		private function sl_XmlParse(event:Event):void {
			var sl_Counter:uint = new uint(0);
			var sl_Xml:XML = new XML(this.sl_XmlLoader.data);
			
			var sl_ScheduleLength:Number = sl_Xml.child('item').length();
			for (sl_Counter; sl_Counter < sl_ScheduleLength; sl_Counter++) {
				var sl_ItemMessage:Array = new Array();
				sl_ItemMessage.push(	sl_Xml.child('item')[sl_Counter].attribute('class'),
										sl_Xml.child('item')[sl_Counter].attribute('lesson'),
										sl_Xml.child('item')[sl_Counter].attribute('room'),
										sl_Xml.child('item')[sl_Counter].attribute('replace')
									);
				this.sl_ScheduleItems.push(sl_ItemMessage);
			}
			// ВЫДАЕМ СОБЫТИЕ ОБ ОКОНЧАНИИ ПАРСИНГА
			this.sl_EventDispatcher.dispatchEvent(new Event("XML_PARSED_SUCCESSFULLY"));
		}
	}
}
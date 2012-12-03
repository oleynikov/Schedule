package engine{
	// ИМПОРТИРУЕМ ПАКЕТЫ
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import engine.XmlLoader;
	import engine.StackScroller;
	import flash.text.TextFormat;
	import flash.events.EventDispatcher;

	// КЛАСС - ПРОКРУЧИВАЕМОЕ РАСПИСАНИЕ
	public class Schedule extends Sprite {
		// ОПРЕДЕЛЯЕМ СВОЙСТВА
		private var ss_XmlUrl:String;
		private var ss_StageWidth:uint;
		private var ss_StageHeight:uint;
		private var ss_Backgrounds:Array;
		private var ss_ItemHeight:uint;
		//private var _LineAutoHeight:uint;
		private var ss_ItemsSpacer:uint;
		private var ss_TextFormat:TextFormat;
		private var ss_ScrollSpeed:Number;
		private var ss_ScrollPause:uint;
		private var ss_ScrollPauseDelay:uint;
		private var ss_XmlLoader:XmlLoader;
		private var ss_ScheduleBody:StackScroller;
		// КОНСТРУКТОР КЛАССА
		public function Schedule	(	ss_StageWidth:uint,				// ШИРИНА ОКНА
										ss_StageHeight:uint,			// ВЫСОТА ОКНА
										ss_XmlUrl:String,				// ПУТЬ К XML ФАЙЛУ
										ss_ScrollSpeed:Number,			// СКОРОСТЬ ПРОКРУТКИ
										ss_ScrollPause:uint,			// ПРИОСТАНОВИТЬ ПРОКРУТКУ ПОСЛЕ N-ГО ЭЛЕМЕНТА
										ss_ScrollPauseDelay:uint,		// ВРЕМЯ ПАУЗЫ В СЕКУНДАХ
										ss_ItemHeight:uint,				// ВЫСОТА СТРОКИ РАСПИСАНИЯ
										_LineAutoHeight:uint,			// АВТОПОДБОР ВЫСОТЫ СТРОКИ
										ss_ItemsSpacer:uint,			// РАССТОЯНИЕ МЕЖДУ СТРОКАМИ
										ss_Backgrounds:Array,			// ЦВЕТА ФОНОВ
										ss_TextFormat:TextFormat		// ФОРМАТ ТЕКСТА
									) {
			// ИНИЦИАЛИЗИРУЕМ ПЕРЕМЕННЫЕ
			this.ss_XmlUrl = ss_XmlUrl;
			this.ss_StageWidth = ss_StageWidth;
			this.ss_StageHeight = ss_StageHeight;
			this.ss_ScrollSpeed = ss_ScrollSpeed;
			this.ss_ScrollPause = ss_ScrollPause;
			this.ss_ScrollPauseDelay = ss_ScrollPauseDelay;
			this.ss_Backgrounds = ss_Backgrounds;
			//this._LineAutoHeight = _LineAutoHeight;
			this.ss_ItemsSpacer = ss_ItemsSpacer;
			this.ss_TextFormat = ss_TextFormat;
			if ( _LineAutoHeight > 0 ) {
				this.ss_ItemHeight = ( ss_StageHeight - _LineAutoHeight * ss_ItemsSpacer ) / ( _LineAutoHeight + 1 );
			}
			else {
				this.ss_ItemHeight = ss_ItemHeight;
			}
			// ШАПКА ТАБЛИЦЫ
			var ss_ScheduleHeader = new ScheduleItem	(	0,
															0,
															this.ss_StageWidth,
															this.ss_ItemHeight,
															this.ss_Backgrounds[0],
															0,
															this.ss_TextFormat,
															new Array	(	'Класс',
																		 	'Урок',
																			'Кабинет'
																		)
														);
			this.addChild(ss_ScheduleHeader);
			this.ss_Reload();
		}
		private function ss_Reload () {
			// ЗАГРУЗКА XML ДАННЫХ
			if ( this.getChildByName('ScheduleBody') ) {
				this.removeChild(this.getChildByName('ScheduleBody'));
			}
			this.ss_XmlLoader = new XmlLoader(this.ss_XmlUrl);
			this.ss_XmlLoader.sl_EventDispatcher.addEventListener('XML_PARSED_SUCCESSFULLY',ss_EventXmlParsedSeccessfully);
		}
		private function ss_EventXmlParsedSeccessfully (event:Event):void {
			var ss_Counter:uint = new uint(0);
			var ss_StackItems:Array = new Array();
			var ss_StackLength:Number = this.ss_XmlLoader.sl_ScheduleItems.length;
			var ss_ItemBackground:uint;
			for ( ss_Counter; ss_Counter < ss_StackLength ; ss_Counter ++ ) {
				if ( ss_Counter % 2 == 0 ) {
					ss_ItemBackground = this.ss_Backgrounds[1];
				}
				else {
					ss_ItemBackground = this.ss_Backgrounds[2];
				}
				ss_StackItems.push	(	new ScheduleItem	(	0,
														 		this.ss_ItemHeight * ss_Counter + ss_Counter * 1,
																this.ss_StageWidth,
																this.ss_ItemHeight,
																ss_ItemBackground,
																this.ss_XmlLoader.sl_ScheduleItems[ss_Counter][3],
																this.ss_TextFormat,
																new Array	(	this.ss_XmlLoader.sl_ScheduleItems[ss_Counter][0],
																			 	this.ss_XmlLoader.sl_ScheduleItems[ss_Counter][1],
																				this.ss_XmlLoader.sl_ScheduleItems[ss_Counter][2]
																			)
															)
									 );
			}
			var ss_ScheduleBody:StackScroller = new StackScroller	(	ss_StackItems,
																	 	this.ss_StageWidth,
																		this.ss_StageHeight-this.ss_ItemHeight,
																		this.ss_ScrollSpeed,
																		this.ss_ScrollPause,
																		this.ss_ScrollPauseDelay,
																		this.ss_ItemsSpacer);
			// ПОМЕЩАЕМ РАСПИСАНИЕ ПОСЛЕ ШАПКИ
			ss_ScheduleBody.y = this.ss_ItemHeight + this.ss_ItemsSpacer;
			// ОБНОВЛЕНИЕ XML ИНФОРМАЦИИ О РАСПИСАНИИ
			ss_ScheduleBody._EventDispatcher.addEventListener("STACK_AT_START_POSITION",ss_Update);
			ss_ScheduleBody.name = 'ScheduleBody';
			this.addChild(ss_ScheduleBody);			
		}
		private function ss_Update (event:Event) {
			this.ss_Reload();
		}
	}
}
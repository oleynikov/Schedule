package engine {
	import engine.Label;
	import engine.Input;
	import engine.Button;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.xml.XMLNode;
	import flash.xml.XMLDocument;
	import flash.events.EventDispatcher;
	public class Settings extends Sprite{
		private const _WindowWidth:uint = 600;
		private const _WindowHeight:uint = 500;
		private var _UrlLoader:URLLoader;
		private var _Configuration:ConfigurationLoader;
		private var _WindowPosX:uint;
		private var _WindowPosY:uint;
		private var _StageWidth:uint;
		private var _StageHeight:uint;
		private var _ParametersInputs:Array;
		private var _TextFormat:TextFormat;
		private var _StatusLine:LabelAdvanced;
		public var _EventDispatcher:EventDispatcher;
		public function Settings	(	_StageWidth:uint,		// ШИРИНА ОКНА
										_StageHeight:uint		// ВЫСОТА ОКНА
									) {
			this._EventDispatcher = new EventDispatcher();
			// ФОРМАТ ТЕКСТА
			this._TextFormat = new TextFormat('Tahoma',20,0x292929);
			this._StageWidth = _StageWidth;
			this._StageHeight = _StageHeight;
			// ПЕЛЕНА
			var _Shadow:Shape = new Shape();
				_Shadow.graphics.beginFill(0x000000,0.8);
				_Shadow.graphics.drawRect(0,0,this._StageWidth,this._StageHeight);
			this.addChild(_Shadow);
			// ОКНО
			this._WindowPosX = Math.floor(this._StageWidth / 2 - this._WindowWidth / 2);
			this._WindowPosY = Math.floor(this._StageHeight / 2 - this._WindowHeight / 2);
			var _Body:Shape = new Shape();
				_Body.graphics.beginFill(0xFDF7F1,1);
				_Body.graphics.lineStyle(2,0X292929);
				_Body.graphics.drawRoundRect(this._WindowPosX,this._WindowPosY,this._WindowWidth,this._WindowHeight,10,10);
			this.addChild(_Body);
			// КНОПКА ОТПРАВКИ
			var _ButtonSend:Button = new Button	(	0,
						 								0,
														0,
														0,
														15,
														15,
														'Сохранить настройки',
														this._TextFormat,
														0xF1F9FD,
														1,
														0x292929,
														2,
														10	);
				_ButtonSend.x = this._WindowPosX + _Body.width - _ButtonSend.width - 10;
				_ButtonSend.y = this._WindowPosY + _Body.height - _ButtonSend.height - 10;
				_ButtonSend.addEventListener(MouseEvent.CLICK,_SendSettings);
			this.addChild(_ButtonSend);
			//	СТРОКА СОСТОЯНИЯ
			this._StatusLine = new LabelAdvanced(' ',this._TextFormat,false);
			this._StatusLine.x = this._WindowPosX + 10;
			this._StatusLine.y = this._WindowPosY + this._WindowHeight - 10 - this._StatusLine.height;
			this.addChild(this._StatusLine);
			
			// ЗАГРУЖАЕМ МАССИВ НАСТРОЕК
			this._Configuration = new ConfigurationLoader('xml/config.xml');
			this._Configuration._EventDispatcher.addEventListener('CONFIGURATION_LOADED',event_ConfigurationLoaded);
		}
		// XML ФАЙЛ КОНФИГУРАЦИИ ПОЛУЧЕН
		private function event_ConfigurationLoaded (event:Event):void {
			// РИСУЕМ ТАБЛИЧКУ С НАСТРОЙКАМИ
			var _LabelsPosX:Number = this._WindowPosX + 10;
			var _LabelsPosY:Number = this._WindowPosY + 10;
			var _InputsPosX:Number = this._WindowPosX + 310;
			var _InputsPosY:Number = this._WindowPosY + 10;
			this._ParametersInputs = new Array();
			var _Key:uint = new uint();
			var _ConfigurationLength:uint = this._Configuration._ConfigurationNum.length;
			for ( _Key; _Key < _ConfigurationLength; _Key ++ ) {
				// ДОБАВЛЯЕМ ПОДПИСЬ К НАСТРОЙКЕ
				var _Label:LabelAdvanced = new LabelAdvanced	(	this._Configuration._ConfigurationNum[_Key][2],
																	this._TextFormat,
																	false	);
					_Label.x=_LabelsPosX;
					_Label.y=_LabelsPosY;
				this.addChild(_Label);
				// ДОБАВЛЯЕМ ПОЛЕ ВВОДА
				var _Input:Input = new Input	(	_InputsPosX,
												 	_InputsPosY,
													0,
													0,
													this._Configuration._ConfigurationNum[_Key][1],
													this._TextFormat,
													0xFDF7F1,
													0xFDF7F1	);
				this.addChild(_Input);
				this._ParametersInputs[_Key] = _Input;
				_LabelsPosY += 30;
				_InputsPosY += 30;
			}
		}
		// ОТПРАВКА НАСТРОЕК НА СЕРВЕР
		private function _SendSettings (event:MouseEvent) {
			this._StatusLine.text = 'Сохраняем настройки...';
			// ФОРМИРУЕМ ПАРАМЕТРЫ ЗАПРОСА
			var _ConfigVariables:String = new String();
			var _Key:uint = new uint();
			var _ConfigurationLength:uint = this._Configuration._ConfigurationNum.length;
			for ( _Key; _Key < _ConfigurationLength; _Key ++ ) {
				_ConfigVariables +=	'&' +
									this._Configuration._ConfigurationNum[_Key][0] +
									'=' +
									this._ParametersInputs[_Key].text;
			}
			_ConfigVariables = _ConfigVariables.substr(1);
			var _ConfigUrlVariables:URLVariables = new URLVariables(_ConfigVariables);
			// ФОРМИРУЕМ ЗАПРОС НА ОБНОВЛЕНИЕ НАСТРОЕК
			var _Urlrequest:URLRequest = new URLRequest('xml/configUpdater.php');
				_Urlrequest.method = URLRequestMethod.POST;
				_Urlrequest.data = _ConfigVariables;
			this._UrlLoader = new URLLoader(_Urlrequest);
			this._UrlLoader.addEventListener(Event.COMPLETE,event_SettingsUpdated);
		}
		// НАСТРОЙКИ ОТПРАВЛЕНЫ НА СЕРВЕР
		private function event_SettingsUpdated (event:Event) {
			this._StatusLine.text = 'Настройки сохранены.';
			this._EventDispatcher.dispatchEvent(new Event('SETTINGS_SAVED'));
		}
	}
}
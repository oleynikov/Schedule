package engine{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.xml.XMLDocument;
	public class ConfigurationLoader {
		private var _UrlLoader:URLLoader;
		public var _Configuration:Array;
		public var _ConfigurationNum:Array;
		public var _EventDispatcher:EventDispatcher;
		public function ConfigurationLoader(_Url:String) {
			var _UrlRequest:URLRequest = new URLRequest(_Url);
			this._UrlLoader = new URLLoader(_UrlRequest);
			this._UrlLoader.addEventListener(Event.COMPLETE,_XmlParse);
			this._EventDispatcher = new EventDispatcher();
		}
		private function _XmlParse(_Event:Event):void {
			// ПАРСИМ ХML ДАННЫЕ 
			var _Xml:XMLDocument = new XMLDocument();
				_Xml.ignoreWhite = true;
				_Xml.parseXML(this._UrlLoader.data);
			// ЗАПИСЫВАЕМ XML ДАННЫЕ В МАССИВ;
			this._Configuration = new Array();
			this._ConfigurationNum = new Array();
			var _Counter:uint = new uint();
			for (var _Key:String in _Xml.firstChild.childNodes) {
				var _ParameterName:String = _Xml.firstChild.childNodes[_Key].attributes['name'];
				var _ParameterValue:String = _Xml.firstChild.childNodes[_Key].attributes['value'];
				var _ParameterTitle:String = _Xml.firstChild.childNodes[_Key].attributes['title'];
				this._Configuration[_ParameterName] = new Array(_ParameterValue,_ParameterTitle);
				this._ConfigurationNum[_Counter] = new Array(_ParameterName,_ParameterValue,_ParameterTitle);
				_Counter ++;
			}
			this._EventDispatcher.dispatchEvent(new Event('CONFIGURATION_LOADED'));
		}
	}
}
package engine {
	// НЕОБХОДИМЫЕ ПАКЕТЫ
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	// КЛАСС ПРОКРУЧИВАЕТ ЭЛЕМЕНТЫ МАССИВА
	public class StackScroller extends Sprite {
		private var _Stack:Array;						// МАССИВ ЭЛЕМЕНТОВ
		private var _ScrollSpeed:Number;				// СКОРОСТЬ ПРОКРУТКИ
		private var _StackLength:uint;					// ДЛИНА СТЭКА В ЭЛ-ТАХ
		private var _StackWidth:Number;					// ШИРИНА СТЭКА
		private var _StackHeight:Number;				// ВЫСОТА СТЭКА В ПИКСЕЛАХ
		private var _TopElement:uint;					// ВЕРХНИЙ ЭЛЕМЕНТ
		private var _ItemSpacer:uint;					// ПРОБЕЛ МЕЖДУ СТРОКАМИ
		private var _ItemsScrolled:uint;				// СТОЛЬКО СТРОК УЖЕ ПРОКРУЧЕНО
		private var _ScrollPause:uint;					// ПАУЗА ПОСЛЕ ПРОКРУТКИ n СТРОК
		private var _ScrollPauseTime:uint;				// ВРЕМЯ ПАУЗЫ В МИЛИСЕКУНДАХ
		private var _Tweens:Array;						// МАССИВ ТВИНОВ
		public var _EventDispatcher:EventDispatcher;	// ДИСПЕТЧЕР СОБЫТИЙ
		public var _EventOneStepScrolled:Event;			// СОБЫТИЕ ПРОКРУТКИ НА 1 ШАГ (ЭЛЕМЕНТ)
		// КОНСТРУКТОР
		public function StackScroller	(	_Stack:Array,				// ЭЛЕМЕНТЫ СТЭКА
											_StackWidth:Number,			// ШИРИНА СТЭКА
											_StackHeight:Number,		// ВЫСОТА СТЭКА
											_ScrollSpeed:Number,		// СКОРОСТЬ ПРОКРУТКИ
											_ScrollPause:uint,			// ПРИОСТАНОВИТЬ ПРОКРУТКУ ПОСЛЕ N-ГО ЭЛЕМЕНТА
											_ScrollPauseTime:uint,		// ВРЕМЯ ПАУЗЫ В СЕКУНДАХ
											_ItemSpacer:uint 			// РАССТОЯНИЕ МЕЖДУ ЭЛЕМЕНТАМИ СТЭКА
										) {
			this._ItemsScrolled = new uint();
			this._EventDispatcher = new EventDispatcher();
			this._TopElement = new uint();
			this._Tweens = new Array();
			this._EventOneStepScrolled = new Event('ONE_STEP_SCROLLED');
			this._Stack = _Stack;
			this._StackWidth = _StackWidth;
			this._StackHeight = _StackHeight;
			this._ScrollSpeed = _ScrollSpeed;
			this._ScrollPause = _ScrollPause;
			this._ScrollPauseTime = _ScrollPauseTime;
			this._ItemSpacer = _ItemSpacer;
			this._StackLength = _Stack.length;
			// РАСПОЛАГАЕМ ЭЛЕМЕНТЫ СТЭКА ВЕРТИКАЛЬНО
			var _Key:uint = new uint();
			var _StackHeight:Number = new Number();
			for (_Key; _Key < this._StackLength; _Key ++) {
				if ( _Key != 0 ) {
					// .y ЭЛ-ТА = .y ПРЕДЫДУЩЕГО + .height ПРЕДЫДУЩЕГО + РАССТОЯНИЕ МЕЖДУ СТРОКАМИ
					this._Stack[_Key].y = this._Stack[_Key-1].y + this._Stack[_Key-1].height + this._ItemSpacer;
				}
				// ПРИБАВЛЯЕМ ВЫСОТУ ЭЛ-ТА К ВЫСОТЕ СТЭКА
				_StackHeight +=  this._Stack[_Key].height + this._ItemSpacer;
				// ДОБАВЛЯЕМ ЭЛЕМЕНТ В СТЭК
				this.addChild(this._Stack[_Key]);
			}
			// ДОБАВЛЯЕМ МАСКУ
			var _Mask:Shape = new Shape();
				_Mask.graphics.beginFill(0x000000,1);
				_Mask.graphics.drawRect(0,0,this._StackWidth,this._StackHeight);
				this.addChildAt(_Mask,0);
				this.mask = _Mask;
			// НАЧИНАЕМ ПРОКРУТКУ
			if (_StackHeight > this._StackHeight) {
				this._EventDispatcher.addEventListener(this._EventOneStepScrolled.type,_ScrollOneStep);
				this._EventDispatcher.dispatchEvent(this._EventOneStepScrolled);
			}
		}
		private function _ScrollOneStep (_Event:Event):void {
			var _Key:uint = new uint(0);
			var _ItemPositionCurrent:Number;
			var _ItemHeight:Number;
			for (_Key; _Key < this._StackLength; _Key ++) {
				_ItemPositionCurrent = this._Stack[_Key].y;
				_ItemHeight = this._Stack[_Key].height;
				this._Tweens[_Key] = new Tween(this._Stack[_Key], "y", None.easeIn,  this._Stack[_Key].y, _ItemPositionCurrent - _ItemHeight - this._ItemSpacer, this._ScrollSpeed, true);
				
			}
			_Tweens[0].addEventListener(TweenEvent.MOTION_FINISH,_ScrollPauseStart);
		}
		private function _ScrollPauseStart (_Event:Event) {
			var _Timer:Timer =new Timer(this._ScrollPauseTime,1);
				_Timer.addEventListener(TimerEvent.TIMER,_ScrollPauseEnd);
				_Timer.start();
		}
		private function _ScrollPauseEnd(_Event:Event) {
			this._ElementReplace();
			this._EventDispatcher.dispatchEvent(new Event('ONE_STEP_SCROLLED'));
		}
		private function _ElementReplace ():void {
			var _MoveTo:Number = new Number();
			if ( this._TopElement < 1 ) {
				_MoveTo = this._Stack[this._StackLength-1].y + this._Stack[this._StackLength-1].height + this._ItemSpacer;
			}
			else {
				_MoveTo = this._Stack[this._TopElement-1].y + this._Stack[this._TopElement-1].height + this._ItemSpacer;
			}
			this._Stack[this._TopElement].y = _MoveTo;
			if ( this._TopElement == this._StackLength - 1 ) {
				this._TopElement = 0;
			}
			else {
				this._TopElement ++;
			}
		}
	}
}
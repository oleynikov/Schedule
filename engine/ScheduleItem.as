package engine{
	// ИМПОРТИРУЕМ ПАКЕТЫ
	import engine.Label;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	public class ScheduleItem extends Sprite {
		// КОНСТРУКТОР КЛАССА
		public function ScheduleItem	(	si_PosX:uint,				// ПОЗИЦИЯ ПО Х
											si_PosY:uint,				// ПОЗИЦИЯ ПО У
											si_Width:uint,				// ШИРИНА
											si_Height:uint,				// ВЫСОТА
											si_FillColor:uint,			// ФОН
											si_Border:uint,				// РАМКА
											si_TextFormat:TextFormat,	// ФОРМАТ ТЕКСТА
											si_TextMessage:Array		// ТЕКСТ
										) {
			// УКАЗЫВАЕМ ПОЛОЖЕНИЕ ПУНКТА МЕНЮ
			this.x = si_PosX;
			this.y = si_PosY;
			// РИСУЕМ ФОН
			var si_Background:Shape = new Shape();
				si_Background.graphics.beginFill(si_FillColor,1);
				if (si_Border==1){
					//si_Background.graphics.lineStyle(2,0x66CCFF);
				}
				si_Background.graphics.drawRect(0,0,si_Width,si_Height);
				si_Background.graphics.endFill();
				this.addChild(si_Background);
			// ПЕЧАТАЕМ ТЕКСТ
				// ОПРЕДЕЛЯЕМ ПОЛОЖЕНИЕ ТЕКСТА ПО ВЕРТИКАЛИ
				var si_TextPosVertical:Number = si_Height / 4;
				// КЛАСС
				var si_ClassLabel:Label = new Label(20,si_TextPosVertical,si_TextMessage[0],si_TextFormat);
				this.addChild(si_ClassLabel);
				// УРОК
				var si_LessonLabel:Label = new Label(250,si_TextPosVertical,si_TextMessage[1],si_TextFormat);
				this.addChild(si_LessonLabel);
				// КАБИНЕТ
				var si_RoomLabel:Label = new Label(900,si_TextPosVertical,si_TextMessage[2],si_TextFormat);
				this.addChild(si_RoomLabel);
		}
	}
}
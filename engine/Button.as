package engine{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import engine.LabelAdvanced;
	public class Button extends Sprite {
		public function Button	(	btt_PositionX:uint,			// Х - КООРДИНАТА КНОПКИ
									btt_PositionY:uint,			// у - КООРДИНАТА КНОПКИ
									btt_Width:uint,				// ШИРИНА КНОПКИ
									btt_Height:uint,			// ВЫСОТА КНОПКИ
									btt_PaddingTop:uint,		// ОТСТУП СВЕРХУ
									btt_PaddingLeft:uint,		// ОТСТУП СЛЕВА
									btt_Text:String,			// ТЕКСТ КНОПКИ
									btt_TextFormat:TextFormat,	// ФОРМАТ ТЕКСТА
									btt_BgColor:uint,			// ЦВЕТ ФОНА
									btt_BgAlpha:uint,			// ПРОЗРАЧНОСТЬ ФОНА
									btt_BorderColor:uint,		// ЦВЕТ РАМКИ
									btt_BorderWidth:uint,		// ТОЛЩИНА РАМКИ
									btt_BorderRadius:uint		// РАДИУС СКРУГЛЕНИЯ РАМКИ
								) {
			// УКАЗЫВАЕМ ПОЛОЖЕНИЕ КНОПКИ
			this.x = btt_PositionX;
			this.y = btt_PositionY;
			// СОЗДАЕМ ТЕКСТ
			var btt_Label:LabelAdvanced = new LabelAdvanced	(	btt_Text,
															 	btt_TextFormat,
																false	);
			// ВЫЧИСЛЯЕМ РАЗМЕРЫ ФОНА
			var btt_BgWidth:Number = btt_Label.width + btt_PaddingLeft * 2;
			var btt_BgHeight:Number = btt_Label.height + btt_PaddingTop * 2;
			if (btt_BgWidth < btt_Width) {
				btt_BgWidth = btt_Width;
			}
			if (btt_BgHeight < btt_Height) {
				btt_BgHeight = btt_Height;
			}
			// ДОБАВЛЯЕМ ФОН
			var btt_Bg:Shape = new Shape();
				btt_Bg.graphics.beginFill(btt_BgColor,btt_BgAlpha);
				btt_Bg.graphics.lineStyle(btt_BorderWidth,btt_BorderColor);
				btt_Bg.graphics.drawRoundRect	(	0,
													0,
													btt_BgWidth,
													btt_BgHeight,
													btt_BorderRadius,
													btt_BorderRadius);
			this.addChild(btt_Bg);
			// ДОБАВЛЯЕМ ТЕКСТ
			btt_Label.la_MoveTo	(	btt_BgWidth / 2 - btt_Label.width / 2,
									btt_BgHeight / 2 - btt_Label.height / 2	);
			this.addChild(btt_Label);
		}
	}
}
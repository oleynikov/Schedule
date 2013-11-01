package engine {
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	public class Label extends TextField {
		public function Label	(	l_PositionX:uint,
								 	l_PositionY:uint,
									l_Text:String,
									l_TextFormat:TextFormat
								) {
			this.x = l_PositionX;
			this.y = l_PositionY;
			this.defaultTextFormat = l_TextFormat;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.selectable = false;
			this.text = l_Text;
		}
	}
}

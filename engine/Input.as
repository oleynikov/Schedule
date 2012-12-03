package engine {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	public class Input extends TextField {
		public function Input	(	inp_PositionX:uint,
								 	inp_PositionY:uint,
									inp_Width:uint,
									inp_Height:uint,
									inp_Text:String,
									inp_TextFormat:TextFormat,
									inp_Background:uint,
									inp_Border:uint
								) {
			this.x = inp_PositionX;
			this.y = inp_PositionY;
			this.type = TextFieldType.INPUT;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.defaultTextFormat = inp_TextFormat;
			this.text = inp_Text;
			if ( this.textWidth > inp_Width ) {
				this.width = this.textWidth + 10;
			}
			else {
				this.width = inp_Width;
			}
			if ( this.textHeight > inp_Height ) {
				this.height = this.textHeight + 10;
			}
			else {
				this.height = inp_Height;
			}
			if ( inp_Background ) {
				this.background = true;
				this.backgroundColor = inp_Background;
			}
			if ( inp_Border ) {
				this.border = true;
				this.borderColor = inp_Border;
			}
		}
	}
}

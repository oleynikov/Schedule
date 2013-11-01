package engine {
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	public class LabelAdvanced extends TextField {
		public function LabelAdvanced	(	la_Text:String,
											la_TextFormat:TextFormat,
											la_Selectable:Boolean
										) {
			this.defaultTextFormat = la_TextFormat;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.selectable = la_Selectable;
			this.text = la_Text;
		}
		public function get dimentions ():Array {
			var la_width:Number = this.textWidth;
			var la_height:Number = this.textHeight;
			return new Array(la_width,la_height);
		}
		public function la_MoveTo (la_X:uint,la_Y:uint):void {
			this.x = la_X;
			this.y = la_Y;
		}
	}
}

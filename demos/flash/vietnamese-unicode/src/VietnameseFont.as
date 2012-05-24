/**
Suggested workflow:
- create a fontLibrary subfolder in your project (NOT in /bin or /src)
- for example: /lib/fontLibrary
- copy font files in this location
- create a FontLibrary class in the same location
- one font library can contain several font classes (duplicate embed and registration code)

FlashDevelop QuickBuild options: (just press Ctrl+F8 to compile this library)
@mxmlc -o bin/VietnameseFont.swf -noplay
*/
package {
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * Vietnamese Font library example
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#FFFFFF', frameRate='31', width='600', height='400')]
	public class VietnameseFont extends Sprite {
		/*
		Common unicode ranges:
		Uppercase   : U+0020,U+0041-U+005A
		Lowercase   : U+0020,U+0061-U+007A
		Numerals    : U+0030-U+0039,U+002E
		Punctuation : U+0020-U+002F,U+003A-U+0040,U+005B-U+0060,U+007B-U+007E
		Basic Latin : U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E
		Latin I     : U+0020,U+00A1-U+00FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183
		Latin Ext. A: U+0100-U+01FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183
		Latin Ext. B: U+0180-U+024F,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183
	Latin Ext. Add'l: U+1E00-U+1EFF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183
		Greek       : U+0374-U+03F2,U+1F00-U+1FFE,U+2000-U+206f,U+20A0-U+20CF,U+2100-U+2183
		Cyrillic    : U+0400-U+04CE,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183
		Armenian    : U+0530-U+058F,U+FB13-U+FB17
		Arabic      : U+0600-U+06FF,U+FB50-U+FDFF,U+FE70-U+FEFF
		Hebrew      : U+05B0-U+05FF,U+FB1D-U+FB4F,U+2000-U+206f,U+20A0-U+20CF,U+2100-U+2183
		--------------------------------------
		VN Unicode	: U+00C0-U+00C3,U+00C8-U+00CA,U+00CC-U+00CD,U+00D0,U+00D2-U+00D5,U+00D9-U+00DA,U+00DD,U+00E0-U+00E3,U+00E8-U+00EA,U+00EC-U+00ED,U+00F2-U+00F5,U+00F9-U+00FA,U+00FD,U+0102-U+0103,U+0110-U+0111,U+0128-U+0129,U+0168-U+0169,U+01A0-U+01B0,U+1EA0-U+1EF9
					      ÀÁÂÃ           ÈÉÊ           ÌÍ         Đ       ÒÓÔÕ            ÙÚ         Ý        àáâã           èéê            ìí           òóôõ          ùú         ý         Ăă            Đđ            Ĩĩ           Ũũ            ƠơƯư        the rest
		VN Composite: U+02C6-U+0323
		
		Vietnamese Unicode = Basic Latin + VN Unicode
		Vietnamese Composite = Vietnamese Unicode + VN Composite
		--------------------------------------
		*/
		[Embed(systemFont='Arial'
		,fontFamily  = 'ArialRegularVN'
		,fontName  ='ArialRegularVN'
		,fontStyle   ='normal' // normal|italic
		,fontWeight  ='normal' // normal|bold
		,unicodeRange = 'U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00C0-U+00C3,U+00C8-U+00CA,U+00CC-U+00CD,U+00D0,U+00D2-U+00D5,U+00D9-U+00DA,U+00DD,U+00E0-U+00E3,U+00E8-U+00EA,U+00EC-U+00ED,U+00F2-U+00F5,U+00F9-U+00FA,U+00FD,U+0102-U+0103,U+0110-U+0111,U+0128-U+0129,U+0168-U+0169,U+01A0-U+01B0,U+1EA0-U+1EF9',
		mimeType='application/x-font'
		//,embedAsCFF='false'
		)]
		public static const fontClass:Class;
		
		public function VietnameseFont() {
			Font.registerFont(fontClass);
			
			var tf: TextField = new TextField();
			tf.embedFonts = true;
			var format: TextFormat = new TextFormat("ArialRegularVN", 20, 0);
			tf.width = 600;
			tf.height = 400;
			//tf.autoSize = "left";
			tf.multiline = true;
			tf.wordWrap = true;
			tf.text = "[Number & Punctuation] 1234567890 .,?!:;/\\\"(){}[]<>'+-*/=&%";
			var upStr: String = "[Upper case] ABCDEFGHIJKLMNOPQRSTUVWXYZ Đ ÁÀẢÃẠ ĂẮẰẲẴẶ ÂẤẦẨẪẬ ÉÈẺẼẸ ÊẾỀỂỄỆ ÍÌỈĨỊ ÓÒỎÕỌ ÔỐỒỔỖỘ ƠỚỜỞỠỢ ÚÙỦŨỤ ƯỨỪỬỮỰ ÝỲỶỸỴ"
			var lowStr: String = "[Lower case] abcdefghijklmnopqrstuvwxyz đ áàảãạ ăắằẳẵặ âấầầẫậ éèẻẽẹ êếềểễệ íìỉĩị óòỏõọ ôốồổỗộ ơớờởỡợ úùủũụ ưứừửữự ýỳỷỹỵ";
			var upCompositeStr: String = "[Upper Composite] ÁÀẢÃẠ ẮẰẲẴẶ ẤẦẨẪẬ ÉÈẺẼẸ ẾỀỂỄỆ ÍÌỈĨỊ ÓÒỎÕỌ ỐỒỔỖỘ ƠỚỜỞỠỢ ÚÙỦŨỤ ỨỪỬỮỰ ÝỲỶỸỴ";
			var lowCompositeStr: String = "[Lower Composite] áàảãạ ắằẳẵặ ấầẩẫậ éèẻẽẹ ếềểễệ íìỉĩị óòỏõọ ốồổỗộ ơớờởỡợ úùủũụ ứừửữự ýỳỷỹỵ";
			tf.appendText("\n\n" + upStr);
			tf.appendText("\n\n" + lowStr);
			tf.appendText("\n\n" + upCompositeStr);
			tf.appendText("\n\n" + lowCompositeStr);
			tf.setTextFormat(format);
			tf.type = "input";
			addChild(tf);
			
		}
		
		
	}
	
}
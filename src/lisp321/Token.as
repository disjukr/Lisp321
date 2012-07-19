package lisp321
{
	/**
	 * Lexer에서 tokenize한 결과물입니다.
	 * @author 0xABCDEF
	 */
	public class Token
	{
		/**
		 * @default 여는 괄호( "(" )를 표현하는 토큰을 뜻합니다. 
		 */
		public static var TYPE_OPEN:String = "OPEN";
		/**
		 * @default 닫는 괄호( ")" )를 표현하는 토큰을 뜻합니다. 
		 */
		public static var TYPE_CLOSE:String = "CLOSE";
		/**
		 * @default 숫자를 표현하는 토큰을 뜻합니다. 
		 */
		public static var TYPE_NUMBER:String = "NUMBER";
		/**
		 * @default 문자열을 표현하는 토큰을 뜻합니다. 
		 */
		public static var TYPE_STRING:String = "STRING";
		/**
		 * @default 심볼을 표현하는 토큰을 뜻합니다. 
		 */
		public static var TYPE_SYMBOL:String = "SYMBOL";
		/**
		 * @default 토큰의 타입을 정의합니다. 
		 */
		public var type:String;
		/**
		 * @default 토큰이 담고있는 코드입니다. 
		 */
		public var code:String;
		/**
		 * @default  소스코드에서 토큰의 시작 인덱스를 정의합니다. 
		 */
		public var beginIndex:int;
		/**
		 * @default 소스코드에서 토큰의 끝 인덱스를 정의합니다. 
		 */
		public var endIndex:int;
		/**
		 * @default 토큰이 원시자료를 담는지 여부를 정의합니다. 
		 */
		public var isAtom:Boolean;
		/**
		 * @default 토큰이 담는 자료가 원시자료일 경우 그 값을 정의합니다. 
		 */
		public var value:Object;
		
		/**
		 * 토큰을 생성합니다.
		 * @param code 코드입니다.
		 * @param beginIndex 토큰의 시작 인덱스입니다.
		 * @param endIndex 토큰의 끝 인덱스입니다.
		 */
		public function Token( code:String, beginIndex:int, endIndex:int )
		{
			this.code = code;
			this.beginIndex = beginIndex;
			this.endIndex = endIndex;
			isAtom = false;
			setType( code );
		}
		
		/**
		 * 문자열로 변환합니다.
		 * @return token.type + " " + token.code가 반환됩니다.
		 */
		public function toString():String
		{
			return type+" "+code;
		}
		
		private function setType( token:String ):void
		{
			var head:String = token.charAt( 0 );
			var headCode:Number = head.charCodeAt();
			if( head == "(" )
			{
				type = TYPE_OPEN;
				return;
			}
			if( head == ")" )
			{
				type = TYPE_CLOSE;
				return;
			}
			if( headCode == 46 || headCode >= 48 && headCode <= 57 )
			{
				isAtom = true;
				value = Number( token );
				type = TYPE_NUMBER;
				return;
			}
			if( head == "\"" || head == "\'" )
			{
				isAtom = true;
				value = token.slice( 1, -1 )
					.replace( "\\\"", "\"" )
					.replace( "\\\'", "\'" )
					.replace( "\\n", "\n" )
					.replace( "\\r", "\r" )
					.replace( "\\t", "\t" )
					.replace( "\\\\", "\\" );
				type = TYPE_STRING;
				return;
			}
			type = TYPE_SYMBOL;
		}
	}
}
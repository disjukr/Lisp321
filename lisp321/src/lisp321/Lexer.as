package lisp321
{
	/**
	 * Tokenization을 처리하는 클래스입니다.
	 * @author 0xABCDEF
	 */
	public class Lexer
	{
		
		private static var tokenExp:RegExp =
		new RegExp(
			// OPEN (\()
			"(\\()" // $1
			
			// CLOSE (\))
			+ "|" + "(\\))" // $2
			
			// NUMBER ( 16진수 표현 ) (-?0[Xx][0-9A-Fa-f]+)
			+ "|" + "(-?0[Xx][0-9A-Fa-f]+)" // $3
			
			// NUMBER (-?\d*\.?\d+([Ee]([+-]?\d+)?)?)
			+ "|" + "(-?\\d*\\.?\\d+([Ee]([+-]?\\d+)?)?)" // $4
			
			// STRING ("([^\\"]|\\.)*"|'([^\\']|\\.)*')
			+ "|" + "(\"([^\\\\\"]|\\\\.)*\"|'([^\\\\']|\\\\.)*')" // $7
			
			// SYMBOL ([^0-9\s\\"\\'\\\(\)\s][^\s\\"\\'\\\(\)]*)
			+ "|" + "([^0-9\\s\\\"\\\'\\\\\\(\\)][^\\s\\\"\\\'\\\\\\(\\)]*)" // $10
			
			, "g"
		);
		
		/**
		 * Lexer를 생성합니다.
		 */
		public function Lexer()
		{
		}
		
		/**
		 * 소스코드를 토큰의 리스트로 변환합니다.
		 * @param code 소스코드입니다.
		 * @return 변환된 결과입니다.
		 */
		public static function tokenize( code:String ):Vector.<Token>
		{
			var tokens:Vector.<Token> = new Vector.<Token>;
			tokenExp.lastIndex = 0;
			var token:Object = tokenExp.exec( code );
			var type:String;
			while( token )
			{
				for each( var i:int in { "1":1, "2":2, "3":3, "4":4, "7":7, "10":10 } )
					if( token[ i ] ) break;
				switch( i )
				{
					case 1 :
						type = Token.TYPE_OPEN;
						break;
					case 2 :
						type = Token.TYPE_CLOSE;
						break;
					case 3 :
						type = Token.TYPE_NUMBER;
						break;
					case 4 :
						type = Token.TYPE_NUMBER;
						break;
					case 7 :
						type = Token.TYPE_STRING;
						break;
					case 10 :
						type = Token.TYPE_SYMBOL;
						break;
				}
				tokens.push( new Token( token[ 0 ], type, token.index, tokenExp.lastIndex ) );
				token = tokenExp.exec( code );
			}
			return tokens;
		}
		
	}
}
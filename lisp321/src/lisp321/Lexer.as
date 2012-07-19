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
			// OPEN	(\()
			"(\\()"
			
			// CLOSE	(\))
			+ "|" + "(\\))"
			
			// NUMBER( 16진수 표현 )	(0[Xx][0-9A-Fa-f]+)
			+ "|" + "(0[Xx][0-9A-Fa-f]+)"
			
			// NUMBER	(\d*\.?\d+([Ee]([+-]?\d+)?)?)
			+ "|" + "(\\d*\\.?\\d+([Ee]([+-]?\\d+)?)?)"
			
			// STRING	("([^\\"]|\\.)*"|'([^\\']|\\.)*')
			+ "|" + "(\"([^\\\\\"]|\\\\.)*\"|'([^\\\\']|\\\\.)*')"
			
			// SYMBOL	([^0-9\s#\\"\\'\\\(\)\s][^\s#\\"\\'\\\(\)]*)
			+ "|" + "([^0-9\\s#\\\"\\\'\\\\\\(\\)][^\\s#\\\"\\\'\\\\\\(\\)]*)"
			
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
			while( token )
			{
				tokens.push( new Token( token[ 0 ], token.index, tokenExp.lastIndex ) );
				token = tokenExp.exec( code );
			}
			return tokens;
		}
		
	}
}
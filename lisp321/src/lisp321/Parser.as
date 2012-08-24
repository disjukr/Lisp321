package lisp321
{
	/**
	 * 토큰열을 추상 문법 트리로 만들어주는 클래스입니다.
	 * @author 0xABCDEF
	 */
	public class Parser
	{
		/**
		 * 토큰열을 추상 문법 트리로 변환합니다.
		 * @param tokens 토큰열입니다.
		 * @return 추상 문법 트리를 반환합니다.
		 */
		public static function parse( tokens:Vector.<Token> ):Array
		{
			var stack:Array = [ [] ];
			var list:Array;
			var result:Array;
			for each( var token:Token in tokens )
			{
				if( token.isAtom )
				{
					stack[ stack.length-1 ].push( token.value );
				}
				else
				{
					switch( token.type )
					{
						case Token.TYPE_SYMBOL :
							stack[ stack.length-1 ].push( new Symbol( token.code ) );
							break;
						case Token.TYPE_OPEN :
							stack.push( [] );
							break;
						case Token.TYPE_CLOSE :
							list = stack.pop();
							if( stack.length )
								stack[ stack.length-1 ].push( list );
							else throw new ParsingError( "unmatched-close" );
							break;
					}
				}
			}
			result = stack.pop();
			if( stack.length )
				throw new ParsingError( "unmatched-open" );
			return Pair.list( result ).toArray();
		}
		
	}
}
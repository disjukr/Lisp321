package lisp321
{
	public class Parser
	{
		
		public function Parser()
		{
		}
		
		public static function parse( tokens:Vector.<Token> ):Pair
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
			return Pair.list( result );
		}
		
	}
}
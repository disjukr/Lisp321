package lisp321
{
	public class Parser
	{
		
		public function Parser()
		{
		}
		
		public static function parse( tokens:Vector.<Token> ):Array
		{
			var stack:Array = [ [] ];
			var list:Array;
			for each( var token:Token in tokens )
			{
				if( token.isAtom )
					stack[ stack.length-1 ].push( token.value );
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
							if( stack.length > 1 )
							{
								list = stack.pop();
								stack[ stack.length-1 ].push( list );
							} else {
								//throw( new Error( "괄호 짝 안맞음;" ) );
							}
							break;
					}
				}
			}
			return stack.pop();
		}
		
	}
}
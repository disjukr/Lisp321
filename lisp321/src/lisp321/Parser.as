package lisp321
{
	public class Parser
	{
		
		public function Parser()
		{
		}
		
		public static function parse( tokens:Vector.<Token> ):Array
		{
			var current:Array = [];
			var stack:Array = [];
			for each( var token:Token in tokens )
			{
				if( token.isAtom )
					current.push( token.value );
				else
				{
					switch( token.type )
					{
						case Token.TYPE_SYMBOL :
							current.push( new Symbol( token.code ) );
							break;
						case Token.TYPE_OPEN :
							stack.push( current );
							current.push( [] );
							current = current[ current.length-1 ];
							break;
						case Token.TYPE_CLOSE :
							current = stack.pop();
							break;
					}
				}
			}
			return current;
		}
		
	}
}
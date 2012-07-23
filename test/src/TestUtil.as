package
{
	import lisp321.Symbol;

	public class TestUtil
	{
		
		public static function AST2Format( ast:Object ):Object
		{
			var result:Object = {};
			if( ast is Array )
			{
				result[ "type" ] = "list";
				result[ "list" ] = [];
				for each( var item:Object in ast )
					result[ "list" ].push( AST2Format( item ) );
			}
			else if( ast is Symbol )
			{
				result[ "type" ] = "symbol";
				result[ "symbol" ] = Symbol( ast ).name;
			}
			else if( ast is Number )
			{
				result[ "type" ] = "number";
				result[ "number" ] = ast;
			}
			else if( ast is String )
			{
				result[ "type" ] = "string";
				result[ "string" ] = ast;
			}
			return result;
		}
		
	}
}
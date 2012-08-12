package
{
	import lisp321.Evaluator;
	import lisp321.Pair;
	import lisp321.Symbol;

	public class TestUtil
	{
		
		public static function AST2Format( ast:Object ):Object
		{
			var result:Object = {};
			if( ast is Pair )
			{
				result[ "type" ] = "list";
				result[ "list" ] = [];
				for each( var item:Object in Pair( ast ).toArray() )
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
		
		public static function checkEqual( a:Object, b:Object ):Boolean
		{
			for( var item:String in a )
			{
				if(	a[ item ] is Number
					|| a[ item ] is Boolean
					|| a[ item ] is String
				)
				{
					if( a[ item ] == b[ item ] )
						continue;
					else return false;
				} else {
					if( checkEqual( a[ item ], b[ item ] ) )
						continue;
					else return false;
				}
			}
			return true;
		}
	}
}
package
{
	import lisp321.Evaluator;
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
		
		public static function dataToLiteral( data:Object, environment:Object ):String
		{
			if( data == null )
				return "";
			if( data is Number )
				return String( data );
			if( data is String )
				return "\"" + String( data )
					.replace( "\"", "\\\"" )
					.replace( "\'", "\\\'" )
					.replace( "\n", "\\n" )
					.replace( "\r", "\\r" )
					.replace( "\t", "\\t" )
					.replace( "\\", "\\\\" ) + "\"";
			if( data is Boolean )
				return data? "#t" : "#f";
			if( data is Symbol )
				return dataToLiteral( Evaluator.evaluate( data, environment ), environment );
			if( data is Array )
				return dataToLiteral( Evaluator.evaluate( data, environment ), environment );
			return data.toString();
		}
		
	}
}
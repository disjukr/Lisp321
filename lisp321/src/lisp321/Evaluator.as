package lisp321
{
	public class Evaluator
	{
		private static var specialForms:Object = {
			"define" : function( environment:Object, symbol:Symbol, value:Object ):void
			{
				environment[ symbol.name ] = evaluate( value, environment );
			},
			"lambda" : function( environment:Object, params:Array, body:Object ):Function
			{
				return function( ...args ):Object
				{
					var _environment:Object = {};
					for ( var item:String in environment )
						_environment[ item ] = environment[ item ];
					for( var i:int=0; i<params.length; ++i )
						_environment[ params[ i ] ] = evaluate( args[ i ], _environment );
					return evaluate( body, _environment );
				}
			},
			"if" : function( environment:Object, condition:Object, consequent:Object, alternative:Object ):Object
			{
				return evaluate( evaluate( condition, environment )? consequent : alternative, environment );
			},
			"set!" : function( environment:Object, symbol:Symbol, value:Object ):Object
			{
				environment[ symbol.name ] = evaluate( value, environment );
				return environment[ symbol.name ];
			}
		};
		
		public static function evaluate( form:Object, environment:Object ):Object
		{
			if( form is Symbol )
			{
				var name:String = Symbol( form ).name;
				if( environment.hasOwnProperty( name ) )
					return environment[ name ];
				else throw new EvaluationError( name + " is undefined" );
			}
			if( form is Array )
			{
				var list:Array = form.slice( 1 );
				var first:Object;
				var func:Function;
				first = form[ 0 ];
				if( first is Symbol )
				{
					func = specialForms[ Symbol( first ).name ];
					if( func != null )
					{
						list.unshift( environment );
						return func.apply( null, list );
					}
				}
				func = evaluate( first, environment ) as Function;
				if( !( func is Function ) )
					throw new EvaluationError( first + " is not applicable" );
				for( var item:String in list )
					list[ item] = evaluate( list[ item ], environment );
				return func.apply( null, list );
			}
			//if form is Atom
			return form;
		}
		
	}
}
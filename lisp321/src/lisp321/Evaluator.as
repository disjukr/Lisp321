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
				evaluate( evaluate( condition, environment )? consequent : alternative, environment );
			}
		};
		
		public static function evaluate( form:Object, environment:Object ):Object
		{
			if( form is Symbol )
				return environment[ Symbol( form ).name ];
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
						func.apply( null, list );
				}
				func = evaluate( first, environment ) as Function;
				if( !( func is Function ) ) throw new Error( first + " is not applicable" );
				for each( var item:Object in list )
					item = evaluate( item, environment );
				return func.apply( null, list );
			}
			//if form is Atom
			return form;
		}
		
	}
}
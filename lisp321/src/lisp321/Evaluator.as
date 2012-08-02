package lisp321
{
	public class Evaluator
	{
		private static function define( environment:Object, symbol:Symbol, value:Object ):void
		{
			environment[ symbol.name ] = evaluate( value, environment );
		}
		
		private static var specialForms:Object = {
			"define" : define
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
				try
				{
					func = Function( evaluate( first, environment ) );
				} catch( e:Error ) {
					throw new Error( form + " is not applicable" );
				}
				for each( var item:Object in list )
					item = evaluate( item, environment );
				func.apply( null, list );
			}
			//if form is Atom
			return form;
		}
		
	}
}
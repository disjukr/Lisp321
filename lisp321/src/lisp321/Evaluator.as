package lisp321
{
	/**
	 * 값에대한 평가를 수행하는 클래스입니다.
	 * @author 0xABCDEF
	 */
	public class Evaluator
	{
		private static var specialForms:Object = {
			"define" : function( environment:Object, symbol:Symbol, value:Object ):void
			{
				environment[ symbol.name ] = evaluate( value, environment );
			},
			"lambda" : function( environment:Object, params:Pair, body:Object ):Function
			{
				return function( ...args ):Object
				{
					var _environment:Object = {};
					for ( var item:String in environment )
						_environment[ item ] = environment[ item ];
					var _params:Array = params.toArray();
					for( var i:int=0; i<_params.length; ++i )
						_environment[ _params[ i ] ] = args[ i ];
					return evaluate( body, _environment );
				}
			},
			"if" : function( environment:Object, condition:Object, consequent:Object, alternative:Object ):Object
			{
				return evaluate( evaluate( condition, environment )? consequent : alternative, environment );
			},
			"set!" : function( environment:Object, symbol:Symbol, value:Object ):Object
			{
				return environment[ symbol.name ] = evaluate( value, environment );
			},
			"and" : function( environment:Object, a:Object, b:Object ):Boolean
			{
				return evaluate( a, environment ) && evaluate( b,environment );
			},
			"or" : function( environment:Object, a:Object, b:Object ):Boolean
			{
				return evaluate( a, environment ) || evaluate( b, environment );
			},
			"quote" : function( environment:Object, object:Object ):Object
			{
				return object;
			},
			"list" : function( environment:Object, ...args ):Pair
			{
				var list:Pair = new Pair;
				var current:Pair = list;
				if( args.length )
				{
					for( var i:int=0; i<args.length; ++i )
					{
						current.car = evaluate( args[ i ], environment );
						if( i<args.length-1 )
						{
							current.cdr = new Pair;
							current = current.cdr as Pair;
						}
					}
					return list;
				}
				return null;
			}
		};
		/**
		 * 값에 대한 평가를 수행합니다.
		 * @param form 평가를 수행할 값입니다.
		 * @param environment symbol 들이 들어있는 환경입니다.
		 * @return 평가된 값입니다.
		 */
		public static function evaluate( form:Object, environment:Object ):Object
		{
			if( form is Symbol )
			{
				var name:String = Symbol( form ).name;
				if( environment.hasOwnProperty( name ) )
					return environment[ name ];
				else throw new EvaluationError( name + " is undefined" );
			}
			if( form is Pair )
			{
				var list:Array;
				if( form.cdr is Pair )
					list = form.cdr.toArray();
				else
					list = [];
				var first:Object;
				var func:Function;
				first = form.car;
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
					throw new EvaluationError(
						( first==null? "nil" : first ) + " is not applicable"
					);
				for( var item:String in list )
					list[ item] = evaluate( list[ item ], environment );
				return func.apply( null, list );
			}
			//if form is Atom
			return form;
		}
		
	}
}
package lisp321
{
	/**
	 * 값에대한 평가를 수행하는 클래스입니다.
	 * @author 0xABCDEF
	 */
	public class Evaluator
	{
		private static var specialForms:Object = {
			"define" : function( environment:Environment, symbol:Symbol, value:Object ):void
			{
				environment.set( symbol.name, evaluate( value, environment ) );
			},
			"lambda" : function( environment:Environment, params:Pair, body:Object ):Function
			{
				return function( ...args ):Object
				{
					var _environment:Environment = new Environment( environment );
					if( params )
					{
						var _params:Array = params.toArray();
						for( var i:int=0; i<_params.length; ++i )
							_environment.set( _params[ i ].name, args[ i ] );
					}
					return evaluate( body, _environment );
				}
			},
			"if" : function( environment:Environment, condition:Object, consequent:Object, alternative:Object ):Object
			{
				return evaluate( evaluate( condition, environment )? consequent : alternative, environment );
			},
			"set!" : function( environment:Environment, symbol:Symbol, value:Object ):Object
			{
				return environment.set( symbol.name, evaluate( value, environment ) );
			},
			"and" : function( environment:Environment, a:Object, b:Object ):Boolean
			{
				return evaluate( a, environment ) && evaluate( b,environment );
			},
			"or" : function( environment:Environment, a:Object, b:Object ):Boolean
			{
				return evaluate( a, environment ) || evaluate( b, environment );
			},
			"quote" : function( environment:Environment, object:Object ):Object
			{
				return object;
			},
			"list" : function( environment:Environment, ...args ):Pair
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
				} else return null;
			}
		};
		/**
		 * 값에 대한 평가를 수행합니다.
		 * @param form 평가를 수행할 값입니다.
		 * @param environment symbol 들이 들어있는 환경입니다.
		 * @return 평가된 값입니다.
		 */
		public static function evaluate( form:Object, environment:Environment ):Object
		{
			if( form is Symbol )
			{
				var name:String = Symbol( form ).name;
				if( environment.exists( name ) )
					return environment.get( name );
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
		/**
		 * form을 문자열로 변환해줍니다.
		 * @param form 변환할 form입니다.
		 * @return 변환된 문자열입니다.
		 */
		public static function toString( form:Object ):String
		{
			if( form == null )
				return "nil";
			if( form is Number )
				return form.toString();
			if( form is Boolean )
				return form? "#t" : "#f";
			if( form is String )
				return ( form as String );
			if( form is Symbol )
				return ( form as Symbol ).name;
			if( form is Pair )
			{
				if( Pair.isList( form as Pair ) )
				{
					var list:Array = ( form as Pair ).toArray();
					for( var item:String in list )
						list[ item ] = toString( list[ item ] );
					return "("+list.join( " " )+")";
				}
				else return "(cons " +
					toString( ( form as Pair ).car ) + " " +
					toString( ( form as Pair ).cdr ) + ")";
			}
			return form.toString();
		}
		
	}
}
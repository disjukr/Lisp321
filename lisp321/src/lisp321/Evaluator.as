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
				var executeBody:Function = analyze( body );
				return function( ...args ):Object
				{
					var _environment:Environment = new Environment( environment );
					if( params )
					{
						var _params:Array = params.toArray();
						for( var i:int=0; i<_params.length; ++i )
							_environment.set( _params[ i ].name, args[ i ] );
					}
					return executeBody( _environment );
				}
			},
			"let" : function( environment:Environment, params:Pair, ...args ):Object
			{
				var _environment:Environment = new Environment( environment );
				if( params )
				{
					var _params:Array = params.toArray();
					for each( var item:Pair in _params )
					{
						var _item:Array = item.toArray();
						_environment.set( _item[ 0 ].name, evaluate( _item[ 1 ], environment ) );
					}
				}
				for each( var form:Object in args )
					form = evaluate( form, _environment );
				return form;
			},
			"let*" : function( environment:Environment, params:Pair, ...args ):Object
			{
				var _environment:Environment = new Environment( environment );
				if( params )
				{
					var _params:Array = params.toArray();
					for each( var item:Pair in _params )
					{
						var _item:Array = item.toArray();
						_environment.set( _item[ 0 ].name, evaluate( _item[ 1 ], _environment ) );
					}
				}
				for each( var form:Object in args )
				form = evaluate( form, _environment );
				return form;
			},
			"if" : function( environment:Environment, condition:Object, consequent:Object, alternative:Object ):Object
			{
				return evaluate( evaluate( condition, environment )? consequent : alternative, environment );
			},
			"set!" : function( environment:Environment, symbol:Symbol, value:Object ):Object
			{
				var _environment:Environment = environment;
				while( _environment )
					if( _environment.exists( symbol.name, true ) )
						break;
					else _environment = _environment.parent;
				return _environment.set( symbol.name, evaluate( value, environment ) );
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
		 * 값에 대한 분석을 수행합니다.
		 * @param form 분석을 수행할 값입니다.
		 * @return function( environment:Environment ):Object{ ... } 형식의 값을 반환합니다.
		 */
		public static function analyze( form:Object ):Function
		{
			if( form is Symbol )
			{
				var name:String = Symbol( form ).name;
				return function( environment:Environment ):Object
				{
					if( environment.exists( name ) )
						return environment.get( name );
					else throw new EvaluationError( name + " is undefined" );
				}
			} else if( form is Pair ) {
				var first:Object = form.car;
				if( first is Symbol )
				{
					var func:Function = specialForms[ first.name ];
					if( func != null )
					{
						var params:Array;
						if( form.cdr is Pair )
							params = form.cdr.toArray();
						else
							params = [];
						return function( environment:Environment ):Object
						{
							var args:Array = [ environment ].concat( params );
							return func.apply( null, args );
						}
					}
				}
				var analyzedParams:Array = [];
				for each( var param:Object in form.toArray() )
					analyzedParams.push( analyze( param ) );
				return function( environment:Environment ):Object
				{
					var func:Object = analyzedParams[ 0 ]( environment );
					if( !( func is Function ) )
						throw new EvaluationError(
							toString( first ) + " is not applicable"
						);
					var args:Array = [];
					for each( var param:Function in analyzedParams.slice( 1 ) )
						args.push( param( environment ) );
					return func.apply( null, args );
				}
			} else {
				return function( environment:Environment ):Object
				{
					return form;
				}
			}
		}
		/**
		 * 값에 대한 평가를 수행합니다.
		 * @param form 평가를 수행할 값입니다.
		 * @param environment symbol 들이 들어있는 환경입니다.
		 * @return 평가된 값입니다.
		 */
		public static function evaluate( form:Object, environment:Environment ):Object
		{
			return analyze( form )( environment );
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
				return "\"" + form + "\"";
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
package lisp321
{
	/**
	 * 값에대한 평가를 수행하는 클래스입니다.
	 * @author 0xABCDEF
	 */
	public class Evaluator
	{
		private static var specialForms:Object = {
			"define" : function( symbol:Symbol, value:Object ):Function
			{
				var executeValue:Function = analyze( value );
				return function( environment:Environment ):void
				{
					environment.set( symbol.name, executeValue( environment ) );
				}
			},
			"lambda" : function( params:Pair, body:Object ):Function
			{
				var executeBody:Function = analyze( body );
				var _params:Array = params? params.toArray() : [];
				return function( environment:Environment ):Function
				{
					return function( ...args ):Object
					{
						var _environment:Environment = new Environment( environment );
						for( var i:int=0; i<_params.length; ++i )
							_environment.set( _params[ i ].name, args[ i ] );
						return executeBody( _environment );
					}
				}
			},
			"let" : function( params:Pair, ...args ):Function
			{
				var _params:Array = params? params.toArray() : [];
				var analyzedParams:Object = {};
				for each( var param:Pair in _params )
				analyzedParams[ param.car.name ] = analyze( param.cdr.car );
				var analyzedForms:Array = [];
				for each( var form:Object in args )
					analyzedForms.push( analyze( form ) );
				return function( environment:Environment ):Object
				{
					var _environment:Environment = new Environment( environment );
					for( var param:String in analyzedParams )
						_environment.set( param, analyzedParams[ param ]( environment ) );
					for each( var form:Object in analyzedForms )
						form = form( _environment );
					return form;
				}
			},
			"let*" : function( params:Pair, ...args ):Function
			{
				var _params:Array = params? params.toArray() : [];
				var analyzedForms:Array = [];
				for each( var form:Object in args )
				analyzedForms.push( analyze( form ) );
				return function( environment:Environment ):Object
				{
					var _environment:Environment = new Environment( environment );
					for each( var param:Pair in _params )
						_environment.set( param.car.name, evaluate( param.cdr.car, _environment ) );
					for each( var form:Object in analyzedForms )
						form = form( _environment );
					return form;
				}
			},
			"if" : function( condition:Object, consequent:Object, alternative:Object ):Function
			{
				var executeCondition:Function = analyze( condition );
				var executeConsequent:Function = analyze( consequent );
				var executeAlternative:Function = analyze( alternative );
				return function( environment:Environment ):Object
				{
					return ( executeCondition( environment )?
						executeConsequent : executeAlternative )( environment );
				}
			},
			"set!" : function( symbol:Symbol, value:Object ):Function
			{
				var executeValue:Function = analyze( value );
				return function( environment:Environment ):Object
				{
					var _environment:Environment = environment;
					while( _environment )
						if( _environment.exists( symbol.name, true ) )
							break;
						else _environment = _environment.parent;
					return _environment.set( symbol.name, executeValue( environment ) );
				}
			},
			"and" : function( a:Object, b:Object ):Function
			{
				var executeA:Function = analyze( a );
				var executeB:Function = analyze( b );
				return function( environment:Environment ):Boolean
				{
					return executeA( environment ) && executeB( environment );
				}
			},
			"or" : function( a:Object, b:Object ):Function
			{
				var executeA:Function = analyze( a );
				var executeB:Function = analyze( b );
				return function( environment:Environment ):Boolean
				{
					return executeA( environment ) || executeB( environment );
				}
			},
			"quote" : function( object:Object ):Function
			{
				return function( environment:Environment ):Object
				{
					return object;
				}
			},
			"list" : function( ...args ):Function
			{
				var analyzedArgs:Array = [];
				for each( var arg:Object in args )
					analyzedArgs.push( analyze( arg ) );
				return function( environment:Environment ):Pair
				{
					var list:Pair = new Pair;
					var current:Pair = list;
					if( args.length )
					{
						for( var i:int=0; i<args.length; ++i )
						{
							current.car = analyzedArgs[ i ]( environment );
							if( i<args.length-1 )
							{
								current.cdr = new Pair;
								current = current.cdr as Pair;
							}
						}
						return list;
					} else return null;
				}
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
					var analyzeSpecialForm:Function = specialForms[ first.name ];
					if( analyzeSpecialForm != null )
					{
						var params:Array;
						if( form.cdr is Pair )
							params = form.cdr.toArray();
						else
							params = [];
						return analyzeSpecialForm.apply( null, params );
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
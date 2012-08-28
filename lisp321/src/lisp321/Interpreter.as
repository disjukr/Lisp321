package lisp321
{
	/**
	 * 코드를 해석 및 실행하는 클래스입니다.
	 * @author 0xABCDEF
	 */
	public class Interpreter
	{
		/**
		 * 기초가 되는 form들을 담고있는 객체입니다.
		 */
		public static var basicForms:Object = {
			"nil" : null,
			"#t" : true,
			"#T" : true,
			"#f" : false,
			"#F" : false,
			"+" : function( a:Object, b:Object ):Number
			{
				return a + b;
			},
			"-" : function( a:Object, b:Object ):Number
			{
				return a - b;
			},
			"*" : function( a:Object, b:Object ):Number
			{
				return a * b;
			},
			"/" : function( a:Object, b:Object ):Number
			{
				return a / b;
			},
			"<" : function( a:Object, b:Object ):Boolean
			{
				return a < b;
			},
			">" : function( a:Object, b:Object ):Boolean
			{
				return a > b;
			},
			"<=" : function( a:Object, b:Object ):Boolean
			{
				return a <= b;
			},
			">=" : function( a:Object, b:Object ):Boolean
			{
				return a >= b;
			},
			"=" : function( a:Object, b:Object ):Boolean
			{
				return a === b;
			},
			"/=" : function( a:Object, b:Object ):Boolean
			{
				return a !== b;
			},
			"not" : function( a:Object ):Boolean
			{
				return ! a;
			},
			"null?" : function( a:Object ):Boolean
			{
				return a === null;
			},
			"cons" : function( a:Object, b:Object ):Pair
			{
				return new Pair( a, b );
			},
			"car" : function( a:Object ):Object
			{
				if( a is Pair )
					return a.car;
				else throw new EvaluationError(
					( a? a.toString() : "nil" )+" is not a cons pair"
				);
			},
			"cdr" : function( a:Object ):Object
			{
				if( a is Pair )
					return a.cdr;
				else throw new EvaluationError(
					( a? a.toString() : "nil" )+" is not a cons pair"
				);
			},
			"map" : function( a:Object, b:Object ):Pair
			{
				return ( b as Pair ).map( a as Function );
			},
			"foldl" : function( a:Object, b:Object, c:Object ):Object
			{
				return ( c as Pair ).foldl( a as Function, b );
			},
			"string?" : function( a:Object ):Boolean
			{
				return a is String;
			},
			"string-size" : function( a:Object ):int
			{
				if( a is String )
					return ( a as String ).length;
				else throw new EvaluationError(
					"not string"
				);
			},
			"concat" : function( ...args ):String
			{
				if( args.length )
				{
					for each( var item:Object in args )
						if( !( item is String ) )
							throw new EvaluationError(
								"not string"
							);
					return ( "" ).concat.apply( null, args );
				} else return "";
			},
			"substring" : function( a:Object, b:Object=0, c:Object=null ):String
			{
				if( !( a is String ) )
					throw new EvaluationError(
						"not string"
					);
				if( b != null )
				{
					if( ( b as Number ) < 0 )
						b = ( a as String ).length + ( b as Number );
				} else b = ( a as String ).length;
				if( c != null )
				{
					if( ( c as Number ) < 0 )
						c = ( a as String ).length + ( c as Number );
				} else c = ( a as String ).length;
				return ( a as String ).substring( b as Number, c as Number );
			},
			"split-string" : function( a:Object, b:Object=null ):Pair
			{
				if( b == null )
				{
					b = /\s+/g;
					var c:Array = ( a as String ).split( b );
					if( c[ 0 ] == "" )
						c.shift();
					if( c[ c.length-1 ] == "" )
						c.pop();
					return Pair.list( c );
				} else return Pair.list( ( a as String ).split( b ) );
			},
			"join-string" : function( a:Object, b:Object=null ):String
			{
				if( a == null )
					return "";
				if( b == null )
					b = "";
				return ( a as Pair ).toArray().join( b );
			},
			"number->string" : function( a:Object ):String
			{
				return String( a as Number );
			},
			"string->number" : function( a:Object ):Number
			{
				if( Number( a as String ).toString() == "NaN" )
					throw new EvaluationError(
						"invalid number: \"" + a + "\""
					);
				return Number( a as String );
			},
			"downcase" : function( a:Object ):String
			{
				return ( a as String ).toLowerCase();
			},
			"upcase" : function( a:Object ):String
			{
				return ( a as String ).toUpperCase();
			}
		};
		/**
		 * 코드를 해석하고 실행합니다.
		 * @param code 해석할 코드입니다.
		 * @param environment 코드가 돌아갈 환경입니다.
		 */
		public static function interpret( code:String, environment:Environment=null ):void
		{
			if( environment == null )
				environment = Environment.toEnvironment( Interpreter.basicForms );
			for each( var item:Pair in Parser.parse( Lexer.tokenize( code ) ) )
				Evaluator.evaluate( item, environment );
		}
		
	}
}
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import lisp321.EvaluationError;
	import lisp321.Evaluator;
	import lisp321.Lexer;
	import lisp321.Pair;
	import lisp321.Parser;
	import lisp321.ParsingError;
	import lisp321.Symbol;
	import lisp321.Token;
	
	public class Lisp321TestCase extends Sprite
	{
		private var traceField:TextField;
		private var testCaseRequest:URLRequest;
		private var testCaseLoader:URLLoader;
		private var cases:Object;
		
		public function Lisp321TestCase()
		{
			addEventListener( Event.RESIZE, RESIZE );
			traceField = addChild( new TextField ) as TextField;
			traceField.x = traceField.y = 0;
			traceField.width = stage.stageWidth;
			traceField.height = stage.stageHeight;
			testCaseRequest = new URLRequest( "https://api.github.com/gists/bf8ee516f5806355ed3a?"+Math.random() );
			testCaseLoader = new URLLoader;
			testCaseLoader.load( testCaseRequest );
			testCaseLoader.addEventListener( Event.COMPLETE, COMPLETE );
			println( "loading..." );
		}
		
		private function RESIZE( e:Event ):void
		{
			traceField.width = stage.stageWidth;
			traceField.height = stage.stageHeight;
		}
		
		private function COMPLETE( e:Event ):void
		{
			cases = JSON.parse( testCaseLoader.data );
			println( "test Lexer.as..." );
			print( "\tcase 1 : " );
			test( testLexer, [ "lexer-1.lisp", "lexer-1.txt" ] );
			print( "\tcase 2 : " );
			test( testLexer, [ "lexer-2.lisp", "lexer-2.txt" ] );
			println( "test Parser.as..." );
			print( "\tcase 1 : " );
			test( testParser, [ "parser-1.lisp", "parser-1.json" ] );
			print( "\tcase 2 : " );
			test( testParser, [ "parser-2.lisp", "parser-2.json" ] );
			print( "\tcase 3 : " );
			test( testParser, [ "parser-3.lisp", "parser-3.json" ] );
			println( "test Evaluator.as..." );
			print( "\tcase 1 : " );
			test( testEvaluator, [ "eval-1.lisp", "eval-1.txt" ] );
			print( "\tcase 2 : " );
			test( testEvaluator, [ "eval-2.lisp", "eval-2.txt" ] );
			print( "\tcase 3 : " );
			test( testEvaluator, [ "eval-3.lisp", "eval-3.txt" ] );
			print( "\tcase 4 : " );
			test( testEvaluator, [ "eval-4.lisp", "eval-4.txt" ] );
			print( "\tcase 5 : " );
			test( testEvaluator, [ "eval-5.lisp", "eval-5.txt" ] );
			print( "\tcase 6 : " );
			test( testEvaluator, [ "eval-6.lisp", "eval-6.txt" ] );
			print( "\tcase 7 : " );
			test( testEvaluator, [ "eval-7.lisp", "eval-7.txt" ] );
			print( "\tcase 8 : " );
			test( testEvaluator, [ "eval-8.lisp", "eval-8.txt" ] );
			print( "\tcase 9 : " );
			test( testEvaluator, [ "eval-9.lisp", "eval-9.txt" ] );
		}
		
		private function test( testFunc:Function, args:Array=null ):void
		{
			var testResult:TestResult = testFunc.apply( null, args );
			if( testResult.testSucceed )
				println( "OK" );
			else
			{
				println( "FAIL" );
				print( testResult );
			}
		}
		
		private function testLexer( $input:String, $output:String ):TestResult
		{
			var input:String = cases.files[ $input ].content;
			var output:Array = cases.files[ $output ].content.split( "\n" );
			output.length -= 1; // trim last \n
			var tokens:Vector.<Token> = Lexer.tokenize( input );
			if( tokens.length != output.length )
				return new TestResult( false, 0, String( output.length ), String( tokens.length ) );
			for( var i:int=0; i<output.length; ++i )
			{
				if( tokens[ i ].toString() == output[ i ] )
					continue;
				return new TestResult( false, i, output[ i ], tokens[ i ].toString() );
			}
			return new TestResult( true );
		}
		
		private function testParser( $input:String, $output:String ):TestResult
		{
			var input:String = cases.files[ $input ].content;
			var output:String = JSON.stringify( JSON.parse( cases.files[ $output ].content ) );
			var format:Object = {};
			try
			{
				format.forms = TestUtil.AST2Format( Parser.parse( Lexer.tokenize( input ) ) )[ "list" ];
				format.success = true;
			}
			catch( e:ParsingError )
			{
				format.error = e.message;
				format.success = false;
			}
			var result:String = JSON.stringify( format );
			return new TestResult( TestUtil.checkEqual( format, JSON.parse( output ) ), 0, output, result );
		}
		
		private function testEvaluator( $input:String, $output:String ):TestResult
		{
			var input:String = cases.files[ $input ].content;
			var output:Array = String( cases.files[ $output ].content ).split( "\n" );
			output.length -= 1; // trim last \n
			var expected:String;
			var expectedData:Object;
			var actualData:Object;
			var ast:Array = Parser.parse( Lexer.tokenize( input ) );
			var environment:Object = {
				"+" : function( a:Object, b:Object ):Number{ return a+b },
				"-" : function( a:Number, b:Number ):Number{ return a-b },
				"*" : function( a:Number, b:Number ):Number{ return a*b },
				"/" : function( a:Number, b:Number ):Number{ return a/b },
				"<" : function( a:Number, b:Number ):Boolean{ return a<b },
				">" : function( a:Number, b:Number ):Boolean{ return a>b },
				"<=" : function( a:Number, b:Number ):Boolean{ return a<=b },
				">=" : function( a:Number, b:Number ):Boolean{ return a>=b },
				"=" : function( a:Object, b:Object ):Boolean
				{
					if( typeof a != typeof b ) return false;
					return a==b;
				},
				"/=" : function( a:Object, b:Object ):Boolean{ return a!=b },
				"not" : function( a:Object ):Boolean{ return !a },
				"#t" : true,
				"#f" : false,
				"null?" : function( a:Object ):Boolean{ return a==null },
				"nil" : null,
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
				"cons" : function( a:Object, b:Object ):Pair{ return new Pair( a, b ) },
				"map" : function( a:Function, b:Pair ):Pair{ return b.map( a ) },
				"foldl" : function( a:Function, b:Object, c:Pair ):Object{ return c.foldl( a, b ) },
				"string?" : function( a:Object ):Boolean{ return a is String },
				"string-size" : function( a:Object ):int
				{
					if( !( a is String ) )
						throw new EvaluationError( "not string" );
					return a.length
				},
				"concat" : function( ...args ):String
				{
					if( args.length )
					{
						for( var i:int=0; i<args.length; ++i )
							if( !( args[ i ] is String ) )
								throw new EvaluationError( "not string" );
						return ( "" ).concat.apply( null, args );
					} else return ""
				},
				"substring" : function( a:Object, b:Object=0, c:Object=null ):String
				{
					if( !( a is String ) )
						throw new EvaluationError( "not string" );
					if( b != null )
					{
						if( Number( b )<0 )
							b = String( a ).length+Number( b );
					} else b = String( a ).length;
					if( c != null )
					{
						if( Number( c )<0 )
							c = String( a ).length+Number( c );
					} else c = String( a ).length;
					return String( a ).substring( Number( b ), Number( c ) );
				},
				"split-string" : function( a:String, b:Object=null ):Pair
				{
					if( b == null )
					{
						b = /\s+/g;
						var c:Array = a.split( b );
						if( c[ 0 ] == "" )
							c.shift();
						if( c[ c.length-1 ] == "" )
							c.pop();
						return Pair.list( c );
					}
					return Pair.list( a.split( b ) );
				},
				"join-string" : function( a:Pair, b:String=null ):String
				{
					if( a == null )
						return "";
					if( b == null )
						b = "";
					return a.toArray().join( b );
				},
				"number->string" : function( a:Number ):String
				{
					return String( a );
				},
				"string->number" : function( a:String ):Number
				{
					if( Number( a ).toString() == "NaN" )
						throw new EvaluationError( "invalid number: \"" + a + "\"" );
					return Number( a );
				},
				"downcase" : function( a:String ):String
				{
					return a.toLowerCase();
				},
				"upcase" : function( a:String ):String
				{
					return a.toUpperCase();
				}
			};
			if( ast.length != output.length )
				return new TestResult( false, 0, String( output.length ), String( ast.length ) );
			for( var i:int=0; i<output.length; ++i )
			{
				actualData = ast[ i ];
				expected = output[ i ];
				if( expected.charAt( 0 ) == "!" )
				{
					try
					{
						Evaluator.evaluate( actualData, environment );
					} catch( e:EvaluationError ) {
						expected = expected.slice( 2 );
						if( expected == e.message )
							continue;
						else return new TestResult( false, i, expected, e.message );
					}
				}
				if( expected.length == 1 )
					expectedData = null;
				else
				{
					expected = expected.slice( 2 );
					expectedData = Parser.parse( Lexer.tokenize( expected ) )[ 0 ];
				}
				try
				{
					actualData = Evaluator.evaluate( ast[ i ], environment );
				} catch( e:Error )
				{
					return new TestResult( false, i, expectedData.toString(), e.message );
				}
				if( !TestUtil.checkEqual( expectedData, actualData ) )
					return new TestResult(
						false,
						i,
						expectedData?
						expectedData.toString() : "null",
						actualData?
						actualData.toString() : "null"
					);
			}
			return new TestResult( true );
		}
		
		private function print( text:Object ):void
		{
			if( traceField )if( text ) traceField.appendText( text.toString() );
		}
		
		private function println( text:Object ):void
		{
			if( traceField )if( text ) traceField.appendText( text.toString() + "\n" );
		}
		
	}
}
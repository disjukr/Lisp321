package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import lisp321.Lexer;
	import lisp321.Parser;
	import lisp321.Symbol;
	import lisp321.Token;
	
	public class Lisp321TestCase extends Sprite
	{
		private static var LEXER_INPUT:String = "lexer-input.lisp";
		private static var LEXER_OUTPUT:String = "lexer-output.txt";
		private static var PARSER_INPUT:String = "parser-input.lisp";
		private static var PARSER_OUTPUT:String = "parser-output.json";
		
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
			testCaseRequest = new URLRequest( "https://api.github.com/gists/bf8ee516f5806355ed3a" );
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
			print( "test Lexer.as..." );
			test( testLexer );
			print( "test Parser.as..." );
			test( testParser );
		}
		
		private function test( testFunc:Function ):void
		{
			var testResult:TestResult = testFunc();
			if( testResult.testSucceed )
				println( "OK" );
			else
			{
				println( "FAIL" );
				print( testResult );
			}
		}
		
		private function testLexer():TestResult
		{
			var input:String = cases.files[ LEXER_INPUT ].content;
			var output:Array = cases.files[ LEXER_OUTPUT ].content.split( "\n" );
			var tokens:Vector.<Token> = Lexer.tokenize( input );
			if( tokens.length != output.length )
				return new TestResult( false, 0, "", "", "줄 수가 맞지 않음" );
			for( var i:int=0; i<output.length; ++i )
			{
				if( tokens[ i ].toString() == output[ i ] )
					continue;
				return new TestResult( false, i, tokens[ i ].toString(), output[ i ], "결과 불일치" );
			}
			return new TestResult( true );
		}
		
		private function testParser():TestResult
		{
			var input:String = cases.files[ PARSER_INPUT ].content;
			var output:String = JSON.stringify( JSON.parse( cases.files[ PARSER_OUTPUT ].content ) );
			var result:String = JSON.stringify( Parser.parse( Lexer.tokenize( input ) ) );
			return new TestResult( output == result, 0, output, result );
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
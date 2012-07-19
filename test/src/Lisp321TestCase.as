package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import lisp321.Lexer;
	import lisp321.Token;
	
	public class Lisp321TestCase extends Sprite
	{
		private static var LEXER_INPUT:String = "lexer-input.lisp";
		private static var LEXER_OUTPUT:String = "lexer-output.txt";
		
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
			var lexerResult:TestResult = testLexer();
			print( "test Lexer.as..." );
			if( lexerResult.testSucceed )
				println( "OK" );
			else
			{
				println( "FAIL" );
				print( lexerResult );
			}
		}
		
		private function testLexer():TestResult
		{
			var lexer:Lexer = new Lexer;
			var input:String = cases.files[ LEXER_INPUT ].content;
			var output:Array = cases.files[ LEXER_OUTPUT ].content.split( "\n" );
			var tokens:Vector.<Token> = lexer.tokenize( input );
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
		
		private function print( text:Object ):void
		{
			if( traceField ) traceField.appendText( text.toString() );
		}
		
		private function println( text:Object ):void
		{
			if( traceField ) traceField.appendText( text.toString() + "\n" );
		}
		
	}
}
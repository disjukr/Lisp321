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
		}
		
		private function test( testFunc:Function, args:Array=null ):void
		{
			var testResult:TestResult = testFunc.apply( null, args );
			if( testResult.testSucceed )
				println( "OK" );
			else
				println( "FAIL" );
			print( testResult );
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
				return new TestResult( false, i, tokens[ i ].toString(), output[ i ] );
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
			catch( e:Error )
			{
				format.error = e.message;
				format.success = false;
			}
			var result:String = JSON.stringify( format );
			return new TestResult( output == result, 0, output, result );
		}
		
		private function testEvaluator( $input:String, $output:String ):TestResult
		{
			// TODO : 구현
			return new TestResult;
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
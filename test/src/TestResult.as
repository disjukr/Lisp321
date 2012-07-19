package
{
	public class TestResult
	{
		public var testSucceed:Boolean;
		public var index:int;
		public var expectedCode:String;
		public var actualCode:String;
		public var comment:String;
		
		public function TestResult(
			testSucceed:Boolean = false,
			index:int = 0,
			expectedCode:String = "",
			actualCode:String = "",
			comment:String = ""
		)
		{
			this.testSucceed = testSucceed;
			this.index = index;
			this.expectedCode = expectedCode;
			this.actualCode = actualCode;
			this.comment = comment;
		}
		
		public function toString():String
		{
			return(
				"line index : " + index + "\n" +
				"expected : " + expectedCode + "\n" +
				"actual : " + actualCode + "\n" +
				"----- " + comment + "\n" 
			);
		}
		
	}
}
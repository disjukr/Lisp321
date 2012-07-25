package
{
	public class TestResult
	{
		public var testSucceed:Boolean;
		public var index:int;
		public var expectedCode:String;
		public var actualCode:String;
		
		public function TestResult(
			testSucceed:Boolean = false,
			index:int = 0,
			expectedCode:String = "",
			actualCode:String = ""
		)
		{
			this.testSucceed = testSucceed;
			this.index = index;
			this.expectedCode = expectedCode;
			this.actualCode = actualCode;
		}
		
		public function toString():String
		{
			return(
				"\t\tline index : " + index + "\n" +
				"\t\texpected : " + expectedCode + "\n" +
				"\t\tactual : " + actualCode + "\n"
			);
		}
		
	}
}
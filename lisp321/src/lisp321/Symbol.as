package lisp321
{
	public class Symbol
	{
		
		public var name:String;
		
		public function Symbol( name:String )
		{
			this.name = name;
		}
		
		public function toString():String
		{
			return "<Symbol " + name + ">";
		}
		
	}
}
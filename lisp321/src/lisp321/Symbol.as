package lisp321
{
	/**
	 * 참조를 담는 자료형입니다.
	 * @author 0xABCDEF
	 */
	public class Symbol
	{
		/**
		 * @default 심볼의 이름입니다. 
		 */
		public var name:String;
		/**
		 * 심볼을 생성합니다.
		 * @param name 심볼의 이름입니다.
		 */
		public function Symbol( name:String )
		{
			this.name = name;
		}
		/**
		 * 문자열 표현으로 변환합니다.
		 * @return name 속성을 반환합니다.
		 */
		public function toString():String
		{
			return name;
		}
		
	}
}
package lisp321
{
	/**
	 * Parser.evaluate시에 생기는 에러를 정의합니다.
	 * @author 0xABCDEF
	 */
	public class ParsingError extends Error
	{
		/**
		 * 새 ParsingError 객체를 만듭니다. message를 지정하면 해당 값이 객체의 message 속성에 할당됩니다.
		 * @param message ParsingError 객체에 연결된 문자열이며, 이 매개 변수는 선택 요소입니다.
		 * @param id 지정된 오류 메시지에 연결할 참조 번호입니다.
		 */
		public function ParsingError( message:* = "", id:* = 0 )
		{
			super( message, id );
		}
	}
}
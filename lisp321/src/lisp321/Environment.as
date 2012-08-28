package lisp321
{
	/**
	 * 환경을 정의합니다.
	 * @author 0xABCDEF
	 */
	public class Environment
	{
		/**
		 * 상위 환경입니다.
		 */
		public var parent:Environment;
		private var contents:Object;
		/**
		 * 환경 객체를 생성합니다.
		 * @param parent 상위 환경입니다.
		 */
		public function Environment( parent:Environment=null )
		{
			this.parent = parent;
			clear();
		}
		/**
		 * 해시맵을 환경으로 변환한 값을 반환합니다. 원본 객체는 수정되지 않습니다.
		 * @param object 변환할 객체입니다.
		 * @param parent 상위 환경입니다.
		 * @return 인자가 담고있던 값들을 환경으로 변환한 값을 반환합니다.
		 */
		public static function toEnvironment( object:Object, parent:Environment=null ):Environment
		{
			var transformed:Environment = new Environment( parent );
			for( var item:String in object )
				transformed.set( item, object[ item ] );
			return transformed;
		}
		/**
		 * 속성이 존재하는지 여부를 반환합니다.
		 * @param name 속성의 이름입니다.
		 * @return 해당속성이 존재하면 true를 반환합니다.
		 */
		public function exists( name:String ):Boolean
		{
			if( contents[ name ] === undefined )
				return parent? parent.exists( name ) : false;
			else
				return true;
		}
		/**
		 * 속성의 값을 얻어옵니다.
		 * @param name 속성의 이름입니다.
		 * @return 속성의 값입니다.
		 */
		public function get( name:String ):Object
		{
			if( contents[ name ] === undefined )
				return parent? parent.get( name ) : null;
			else
				return contents[ name ];
		}
		/**
		 * 속성의 값을 설정합니다.
		 * @param name 속성의 이름입니다.
		 * @param value 설정할 값입니다.
		 * @return 설정한 값을 반환합니다.
		 */
		public function set( name:String, value:Object ):Object
		{
			return contents[ name ] = value;
		}
		/**
		 * 속성을 제거합니다.
		 * @param name 속성의 이름입니다.
		 */
		public function remove( name:String ):void
		{
			delete contents[ name ];
		}
		/**
		 * 환경을 청소합니다.
		 */
		public function clear():void
		{
			var environment:Environment = this;
			contents = {};
			contents[ "the-environment" ] =
				function():Environment{ return environment };
		}
		/**
		 * 문자열로 변환합니다.
		 * @return < 속성이름 : 값, ... > 형식의 문자열을 반환합니다.
		 */
		public function toString():String
		{
			var result:String = "<";
			for( var item:String in contents )
				result += item + " : " + contents[ item ] + ", ";
			result += ">";
			return result;
		}
		
	}
}
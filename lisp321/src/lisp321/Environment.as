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
		 * 속성이 존재하는지 여부를 반환합니다.
		 * @param name 속성의 이름입니다.
		 * @return 해당속성이 존재하면 true를 반환합니다.
		 */
		public function exists( name:String ):Boolean
		{
			return contents.hasOwnProperty( name );
		}
		/**
		 * 속성의 값을 얻어옵니다.
		 * @param name 속성의 이름입니다.
		 * @return 속성의 값입니다.
		 */
		public function get( name:String ):Object
		{
			if( contents.hasOwnProperty( name ) )
				return contents[ name ];
			return parent == null? null : parent.get( name );
		}
		/**
		 * 속성의 값을 설정합니다.
		 * @param name 속성의 이름입니다.
		 * @param value 설정할 값입니다.
		 */
		public function set( name:String, value:Object ):void
		{
			contents.set( name, value );
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
			contents = {};
		}
		
	}
}
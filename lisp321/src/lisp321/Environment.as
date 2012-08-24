package lisp321
{
	
	public class Environment
	{
		
		public var parent:Environment;
		
		private var contents:Object;
		
		public function Environment( parent:Environment=null )
		{
			this.parent = parent;
			clear();
		}
		
		public function exists( name:String ):Boolean
		{
			return contents.hasOwnProperty( name );
		}
		
		public function get( name:String ):Object
		{
			if( contents.hasOwnProperty( name ) )
				return contents[ name ];
			return parent == null? null : parent.get( name );
		}
		
		public function set( name:String, value:Object ):void
		{
			contents.set( name, value );
		}
		
		public function remove( name:String ):void
		{
			delete contents[ name ];
		}
		
		public function clear():void
		{
			contents = {};
		}
		
	}
}
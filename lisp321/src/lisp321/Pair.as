package lisp321
{
	public class Pair
	{
		public var car:Object;
		public var cdr:Object;
		
		public function Pair( car:Object = null, cdr:Object = null )
		{
			this.car = car;
			this.cdr = cdr;
		}
		
		public static function isList( list:Pair ):Boolean
		{
			if( list )
			{
				while( list.cdr )
				{
					if( list.cdr is Pair )
						list = list.cdr as Pair;
					else return false;
				}
				return true;
			} else return false;
		}
		
		public static function list( args:Array ):Pair
		{
			var list:Pair = new Pair;
			var current:Pair = list;
			if( args )if( args.length )
			{
				for( var i:int=0; i<args.length; ++i )
				{
					if( args[ i ] is Array )
						args[ i ] = Pair.list( args[ i ] );
					current.car = args[ i ];
					if( i<args.length-1 )
					{
						current.cdr = new Pair;
						current = current.cdr as Pair;
					}
				}
				return list;
			}
			return null;
		}
		
		public function get tail():Pair
		{
			var tail:Pair = this;
			while( tail.cdr is Pair )
				tail = tail.cdr as Pair;
			return tail;
		}
		
		public function get length():int
		{
			if( car )
			{
				var i:int = 1;
				var tail:Pair = this;
				while( tail.cdr is Pair )
				{
					tail = tail.cdr as Pair;
					++i;
				}
				return i;
			} return 0;
		}
		
		public function map( callback:Function, thisObject:* = null ):Pair
		{
			var ary:Array = [];
			var current:Pair = this;
			while( current is Pair )
			{
				ary.push( callback.apply( thisObject, [ current.car ] ) );
				current = current.cdr as Pair;
			}
			return Pair.list( ary );
		}
		
		public function foldl( callback:Function, param:Object, thisObject:* = null ):Object
		{
			if( cdr is Pair )
				return cdr.foldl( callback, callback.apply( thisObject, [ param, car ] ), thisObject );
			else return callback.apply( thisObject, [ param, car ] );
		}
		
		public function toArray():Array
		{
			var array:Array = [];
			var current:Object = this;
			while( current is Pair )
			{
				array.push( current.car );
				current = current.cdr;
				if( current == null )
					return array;
			}
			array.push( current );
			return array;
		}
		
		public function toString():String
		{
			return "< " +
				String( car ) + ", " + String( cdr ) +
				" >";
		}
		
	}
}
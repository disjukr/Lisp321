package lisp321
{
	/**
	 * 객체쌍을 저장하는 자료형입니다.
	 * @author 0xABCDEF
	 */
	public class Pair
	{
		/**
		 * @default 첫번째 항목입니다.
		 */
		public var car:Object;
		/**
		 * @default 나머지 항목입니다.
		 */
		public var cdr:Object;
		/**
		 * 객체쌍을 만듭니다.
		 * @param car 첫번째 항목입니다.
		 * @param cdr 나머지 항목입니다.
		 */
		public function Pair( car:Object = null, cdr:Object = null )
		{
			this.car = car;
			this.cdr = cdr;
		}
		/**
		 * 리스트 여부를 반환합니다.
		 * @param list 판단할 Pair 객체입니다.
		 * @return 인자가 리스트라면 true를 반환합니다.
		 */
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
		/**
		 * 배열을 리스트로 변환합니다. 원본 배열은 수정되지 않습니다.
		 * @param args 변환할 배열입니다.
		 * @return 리스트로 변환한 값을 반환합니다. 배열 안에 리스트가 들어있을 경우 그 것도 리스트로 변환합니다.
		 */
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
		/**
		 * 리스트의 마지막 객체쌍을 반환합니다.
		 * @return cdr이 Pair라면 cdr의 tail을 반환하고 그렇지 않을 경우 자신을 반환합니다.
		 */
		public function get tail():Pair
		{
			var tail:Pair = this;
			while( tail.cdr is Pair )
				tail = tail.cdr as Pair;
			return tail;
		}
		/**
		 * 리스트의 길이를 구합니다.
		 * @return 리스트의 길이입니다.
		 */
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
		/**
		 * 리스트의 각 항목에 함수를 실행하고 원래 리스트의 각 항목에 대한 함수 결과에 해당하는 항목으로 구성된 새 리스트를 만듭니다.
		 * @param callback 리스트의 각 항목에 실행할 함수입니다.
		 * @param thisObject 함수에서 this로 사용할 객체입니다.
		 * @return 원래 리스트의 각 항목에 함수를 실행한 결과가 포함된 새 리스트입니다.
		 */
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
		/**
		 * 리스트의 왼쪽부터 함수를 실행해나간 결과를 반환합니다.
		 * @param callback 리스트의 각 항목끼리 실행할 함수입니다.
		 * @param param 첫번째 항목과 같이 함수의 인자로 사용될 객체입니다.
		 * @param thisObject 함수에서 this로 사용할 객체입니다.
		 * @return 연산이 연결된 결과가 반환됩니다.
		 */
		public function foldl( callback:Function, param:Object, thisObject:* = null ):Object
		{
			if( cdr is Pair )
				return cdr.foldl( callback, callback.apply( thisObject, [ param, car ] ), thisObject );
			else return callback.apply( thisObject, [ param, car ] );
		}
		/**
		 * 리스트를 배열로 변환합니다.
		 * @return 리스트의 항목은 배열로 변환하지 않습니다.
		 */
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
		/**
		 * 문자열로 변환합니다.
		 * @return &lt;car, cdr&gt; 형식의 문자열을 반환합니다.
		 */
		public function toString():String
		{
			return "< " +
				String( car ) + ", " + String( cdr ) +
				" >";
		}
		
	}
}
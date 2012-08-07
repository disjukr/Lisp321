package lisp321
{
	public class ParsingError extends Error
	{
		public function ParsingError( message:* ="", id:* = 0 )
		{
			super( message, id );
		}
	}
}
package lisp321
{
	public class EvaluationError extends Error
	{
		public function EvaluationError( message:* = "", id:* = 0 )
		{
			super( message, id );
		}
	}
}
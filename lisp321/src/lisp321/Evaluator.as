package lisp321
{
	public class Evaluator
	{
		public static function evaluate( form:Object, environment:Object ):Object
		{
			if( form is Symbol )
				return environment[ Symbol( form ).name ];
			if( form is Array )
			{
				// TODO : 구현
			}
			//if form is Atom
			return form;
		}
		
	}
}
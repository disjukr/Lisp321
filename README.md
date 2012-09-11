Lisp321
=======

소프트웨어 마에스트로 3기 1단계 1차 프로젝트로 만들어진 결과물로, Lisp 프로그래밍 언어를 해석 및 실행해주는 라이브러리입니다.


구성
----

Lisp 코드를 해석할 때는 전체적으로 세 단계를 거치게 됩니다.

1. `Lexer`가 평문(`String`)을 입력으로 받고 토큰열(`Vector.<Token>`)을 반환합니다. `Lexer` 내부에서 토큰을 분리할 때는 정규표현식을 사용합니다.

2. `Lexer`가 반환한 토큰열을 `Parser`가 입력으로 받고 그 토큰열을 상응하는 폼(form)의 배열로 반환합니다.

3. `Parser`가 반환한 폼의 배열의 원소를 `Evaluator`가 입력으로 받고 원소를 평가한 값을 반환합니다.

위의 과정을 `Interpreter`가 한번에 처리하게 되며 사용법은 아래와 같습니다.


사용 예
-------

플래시 IDE를 열고 1프레임에 다음과 같이 입력합니다.

	import lisp321.Interpreter;
	import lisp321.Environment;
	var environment:Environment = Environment.toEnvironment( Interpreter.basicForms );
	environment.set( "display", trace );
	var code:String =
	<![CDATA[
	(define fibonacci
	    (lambda (num)
	        (if (< num 2)
	            num
	            (+ (fibonacci (- num 1))
	                (fibonacci (- num 2))))))
	(define display-fibonacci
	    (lambda (num)
	        (display (concat
	            (concat
	                (concat
	                    "(fibonacci "
	                    (number->string num))
	                ") : ")
	            (number->string (fibonacci num))))))
	(display-fibonacci 1)
	(display-fibonacci 2)
	(display-fibonacci 3)
	(display-fibonacci 4)
	(display-fibonacci 5)
	(display-fibonacci 6)
	(display-fibonacci 7)
	(display-fibonacci 8)
	(display-fibonacci 9)
	(display-fibonacci 10)
	]]>.toString().replace( /\r/g, "" );
	Interpreter.interpret( code, environment );

위 코드를 실행하면

	(fibonacci 1) : 1
	(fibonacci 2) : 1
	(fibonacci 3) : 2
	(fibonacci 4) : 3
	(fibonacci 5) : 5
	(fibonacci 6) : 8
	(fibonacci 7) : 13
	(fibonacci 8) : 21
	(fibonacci 9) : 34
	(fibonacci 10) : 55

이렇게 출력됩니다.


만든 이
-------

소프트웨어 마에스트로 3기 [최종찬][1]이 만들었습니다.

[1]: http://blog.0xabcdef.com/
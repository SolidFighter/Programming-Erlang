-module(exercise_5).
-export([even/1, odd/1]).

even(X) ->
	case X rem 2 of
	0 ->
		true;
	1 ->
		false
	end.

odd(X) ->
	not even(X).

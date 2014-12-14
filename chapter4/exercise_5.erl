-module(exercise_5).
-export([even/1, odd/1]).

even(X) ->
  X rem 2 =:= 0.	

odd(X) ->
  not even(X).

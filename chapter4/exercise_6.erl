-module(exercise_6).
-export([filter/2]).
-compile(export_all).

filter(F, L) ->
	filter_iter(F, L, []). 

filter_iter(F, [H | T], NewList) ->
	case F(H) of
	true ->
		filter_iter(F, T, [H | NewList]);
	false ->
		filter_iter(F, T, NewList)
	end;
filter_iter(_F, [], NewList) ->
	lists:reverse(NewList).

test() -> 	
	[2, 4] = filter(fun(X) -> X rem 2 =:= 0 end, [1, 2, 3, 4, 5]),
	[6, 8, 10] = filter(fun(X) -> X rem 2 =:= 0 end, [6, 7, 8, 9, 10]),
	test_ok.


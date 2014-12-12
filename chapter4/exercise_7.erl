-module(exercise_7).
-export([split/1]).
-compile(export_all).

%split(L) ->
%	{exercise_6:filter(fun(X) -> X rem 2 =:= 0 end, L), exercise_6:filter(fun(X) -> X rem 2 =/= 0 end, L)}.

split(L) ->
	split_iter(L, [], []).
split_iter([H | T], Odd, Even) ->
	case exercise_5:even(H) of	
	true ->
		split_iter(T, Odd, [H | Even]);
	false ->
		split_iter(T, [H | Odd], Even)
	end;
split_iter([], Odd, Even) ->
	{lists:reverse(Even), lists:reverse(Odd)}.

test() ->
	{[2, 4], [1, 3, 5]} = split([1, 2, 3, 4, 5]),
	{[6, 8, 10], [7, 9, 11]} = split([6, 7, 8, 9, 10, 11]),
	test_ok.
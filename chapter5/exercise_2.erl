-module(exercise_2).
-export([map_search_pred/2]).
-compile(export_all).

map_search_pred(Map, Pred) when erlang:is_map(Map) ->
	List = maps:to_list(Map),
	list_search_pred(List, Pred).

list_search_pred([{Key, Value} | T], Pred) ->
	case Pred(Key, Value) of
		true ->
			{Key, Value};
		false ->
			list_search_pred(T, Pred)
	end;
list_search_pred([], _Pred) ->
	no_such_element.

test() ->
	OddKeyEvenValue = fun(X, Y) -> X rem 2 =/= 0 andalso Y rem 2 =:= 0 end,
	true = OddKeyEvenValue(7, 4),
	{3, 6} = map_search_pred(#{1 => 3, 2 => 4, 3 => 6}, OddKeyEvenValue),
	{7, 4} = map_search_pred(#{1 => 3, 7 => 4, 3 => 5}, OddKeyEvenValue),
	test_ok.
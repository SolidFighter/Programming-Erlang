-module(exercise_2).
-export([my_tuple_to_list/1]).

my_tuple_to_list({}) ->
	[];
my_tuple_to_list(T) ->
	my_tuple_to_list_iter(T, 1, []).

my_tuple_to_list_iter(T, Index, L) ->
	if 
	Index > erlang:tuple_size(T) -> 
		lists:reverse(L);		
	true ->
		my_tuple_to_list_iter(T, Index + 1, [element(Index , T) | L])
	end.



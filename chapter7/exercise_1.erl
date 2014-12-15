-module(exercise_1).
-export([reverse/1]).

reverse(Bin) when is_binary(Bin) ->
  List = [X || <<X:8>> <= Bin],
  list_to_binary(lists:reverse(List)).
  
-module(exercise_1).
-export([reverse_byte/1]).
-compile(export_all).

reverse_byte(Bin) when is_binary(Bin) ->
  List = [X || <<X:8>> <= Bin],
  list_to_binary(lists:reverse(List)).
  
test() ->
  <<>> = reverse_byte(<<>>),
  <<1>> = reverse_byte(<<1>>),
  <<3, 2, 1>> = reverse_byte(<<1, 2, 3>>),
  test_ok.

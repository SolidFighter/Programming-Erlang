-module(exercise_1).
-export([dialyzer_test/1]).

-spec dialyzer_test(Argu) -> {ok, Result} when
  Argu :: tuple(),
  Result :: list().
dialyzer_test(Argu) ->
  {ok, tuple_to_list(Argu)}. 

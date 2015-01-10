-module(exercise_2).
-export([md5/1]).

md5(FileName) ->
  {ok, Content} = file:read_file(FileName),
  erlang:md5(Content).
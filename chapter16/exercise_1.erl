-module(exercise_1).
-export([is_need_recompile/1]).
-include_lib("kernel/include/file.hrl").

is_need_recompile(Module) ->
  {ok, #file_info{mtime=WriteTime}} = file:read_file_info(lists:append(Module, ".erl")),
  {ok, #file_info{mtime=WriteTime1}} = file:read_file_info(lists:append(Module, ".beam")),
  case WriteTime > WriteTime1 of
    true -> 
      io:format("need to recompile.~n");
    false ->
      io:format("no need to recompile.~n")
  end.





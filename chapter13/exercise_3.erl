-module(exercise_3).
-export([my_spawn/4, test/0, my_list_to_atom/0]).

my_spawn(Mod, Func, Args, Time) ->
  Pid = spawn(Mod, Func, Args),
  spawn(fun() -> 
    timer:sleep(Time * 1000),
    io:format("To kill Pid ~p.~n", [Pid]),
    exit(Pid, kill)
  end),
  Pid.

my_list_to_atom() ->
  receive 
    List when is_list(List) ->
      io:format("result = ~p.~n", [list_to_atom(List)]); 
    true ->
      io:format("invalid msg.~n")
  end.

test() ->
  Pid = my_spawn(exercise_3, my_list_to_atom, [], 5),
  Pid ! "fvck",
  timer:sleep(10000),
  Pid ! "fvck1".

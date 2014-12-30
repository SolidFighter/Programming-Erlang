-module(exercise_1).
-export([my_spawn/3, convert/0, test/0]).

my_spawn(Mod, Func, Args) ->
  Pid = spawn(Mod, Func, Args), 
  spawn(fun() -> 
    statistics(wall_clock),
    Ref = monitor(process, Pid), 
    receive 
      {'DOWN', Ref, process, Pid, Why} ->
        {_, Time} = statistics(wall_clock), 
        io:format("the process ~p died because ~p, it has run ~p seconds.~n", [Pid, Why, Time/(1000)]);
      true ->  
        io:format("invalid msg.~n")
    end
  end),
  Pid.

convert() ->
  receive 
    Lists ->
      lists:list_to_tuple(Lists)
  end.

test() ->
  Pid = my_spawn(exercise_1, convert, []),
  timer:sleep(5000),
  Pid ! {1, 2, 3}.

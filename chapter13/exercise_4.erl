-module(exercise_4).
-export([create_active_process/0, monitor_process/1, test/0, loop/0]).

loop() ->
  receive 
    kill ->
      list_to_atom(kill) % kill itself 
    after 5000 ->
      io:format("I'm running, Pid = ~p.~n", [self()]),
      loop()
  end.

create_active_process() ->
  spawn(exercise_4, loop, []).
  
monitor_process(Pid) ->
  spawn(fun() ->
    Ref = monitor(process, Pid),
    receive 
      {'DOWN', Ref, process, Pid, Why} ->
        io:format("Pid ~p exit because ~p.~n", [Pid, Why]),
        monitor_process(create_active_process())
      after 20000 ->
        Pid ! kill,
        monitor_process(Pid) 
        %monitor_process(create_active_process())
    end
  end).

test() ->
  monitor_process(create_active_process()).
-module(exercise_6).
-export([start/0]).

start() ->
  Pid = start([fun exercise_5:do_task/0, fun do_task/0]),
  on_exit(Pid).  

on_exit(Pid) ->
  spawn(fun() ->
    _Ref = monitor(process, Pid),
    receive 
      {'DOWN', _Ref, process, Pid, Why} ->
        io:format("worker ~p died because ~p.~n", [Pid, Why]),
        start()
    end
  end).

start(Tasks) ->
  spawn(fun() ->
    io:format("Pids = ~p.~n", [[spawn_link(Task) || Task <- Tasks]]),
    receive 
      after infinity ->
        true
    end
  end).

do_task() ->
  io:format("I'm running ,fvck, Pid = ~p.~n", [self()]),
  timer:sleep(1000),
  do_task().



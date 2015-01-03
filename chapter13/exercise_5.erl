-module(exercise_5).
-export([start/1, monitor_worker/1, do_task/0]).
-define(MAX_TIME_TO_LIVE, 30).

start(NumWorker) ->
  Monitor = create_monitor(), 
  start_workers(Monitor, NumWorker).

create_monitor() ->
  create_monitor([]).
create_monitor(Workers) ->
  spawn(exercise_5, monitor_worker, [Workers]).
 
start_workers(_Monitor, 0) ->
  io:format("all workers has started.~n");
start_workers(Monitor, NumWorker) ->
  Worker = create_worker(),
  add_worker_to_monitor_queue(Monitor, Worker), 
  start_workers(Monitor, NumWorker - 1).
     
monitor_worker(Workers) ->
  receive 
    {add, Worker} ->
      monitor(process, Worker),
      io:format("Add worker ~p to monitor queue.~n", [Worker]),
      monitor_worker([Worker | Workers]);
    {'DOWN', _Ref, process, Worker, Why} ->
      io:format("Process ~p died because ~p.~n", [Worker, Why]),
      io:format("Workers = ~p.~n", [Workers]),
      NewWorkers = lists:delete(Worker, Workers),
      io:format("NewWorkers = ~p.~n", [NewWorkers]),
      NewWorker = create_worker(),
      monitor(process, NewWorker),
      io:format("Add new worker ~p to monitor queue.~n", [NewWorker]),
      monitor_worker([NewWorker | NewWorkers])
  end.

add_worker_to_monitor_queue(Monitor, Worker) ->
  Monitor ! {add, Worker}.

create_worker() ->
  spawn(exercise_5, do_task, []).

do_task() ->
  TimeToLive = get_random_num(),
  io:format("Time to live is ~p.~n", [TimeToLive]),
  do_task(TimeToLive).
do_task(Seconds) when Seconds =< 0 ->
  io:format("I'm dieing, Pid = ~p.~n", [self()]),
  list_to_atom(kill); % kill itself 
do_task(Seconds) ->
  io:format("I'm running, Pid = ~p.~n", [self()]),
  timer:sleep(2000),
  do_task(Seconds - 2).

get_random_num() ->
  random:seed(erlang:now()),
  random:uniform(?MAX_TIME_TO_LIVE).

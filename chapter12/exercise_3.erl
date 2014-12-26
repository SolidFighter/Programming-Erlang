-module(exercise_3).
-export([start/0, trans_msg/1]).
-define(N, 100).
-define(M, 400).

start() ->
  Pids = for(1, ?N, fun() -> spawn(exercise_3, trans_msg, [1]) end),
  %io:format("Pids = ~p.~n", [Pids]),
  [H | T] = Pids, 
  H ! {T ++ [H], "hello world."}.

for(Max, Max, F) ->
  [F()];  
for(I, Max, F) ->
  [F() | for(I + 1, Max, F)].  

trans_msg(Count) -> 
  receive 
    {Pids, Msg} ->
      io:format("Pid:~p, Msg:~p.~n", [self(), Msg]),
      [H | T] = Pids,
      H ! {T ++ [H], Msg},
      if 
        Count < ?M ->
          trans_msg(Count+1);
        true ->
          %io:format("Pid:~p, Count = ~p, exit.~n", [self(), Count])
          exit
      end;
    true ->
      io:format("invalid msg.~n"),
      trans_msg(Count+1)
    after 5000 ->
      io:format("Pid:~p timeout, exit.~n", [self()])
  end.



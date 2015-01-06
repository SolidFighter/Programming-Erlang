-module(yafs).
-export([start/3]).

start(MM, _Argc, _Args) ->
  loop(MM).

loop(MM) ->
  receive
    {chan, MM, {test, argc}} ->
      MM ! {send, {ok, test}},
      loop(MM);
    {chan, MM, {test1, argc}} ->
      io:format("test1.~n"),
      loop(MM);
    {chan_closed, MM} ->
      io:format("client exit.~n"),
      loop(MM);
  end.


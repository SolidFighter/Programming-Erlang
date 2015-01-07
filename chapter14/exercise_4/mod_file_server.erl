-module(mod_file_server).
-export([start/3]).

start(MM, _Argc, _Args) ->
  loop(MM).

loop(MM) ->
  receive
    {chan, MM, {list}} ->
      MM ! {send, yafs:list()},
      loop(MM);
    {chan, MM, {get, FileName}} ->
      MM ! {send, yafs:get(FileName)},
      loop(MM);
    {chan_closed, MM} ->
      io:format("client exit.~n"),
      loop(MM)
  end.


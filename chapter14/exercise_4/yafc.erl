-module(yafc).
-export([connect/3, list/1, get/2]).

list(Pid) ->
  lib_chan:rpc(Pid, {list}).

get(Pid, FileName) ->
  lib_chan:rpc(Pid, {get, FileName}).

connect(Addr, Port, Password) ->
  lib_chan:connect(Addr, Port, file_server, Password, "").

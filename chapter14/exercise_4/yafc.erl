-module(yafc).
-export([connect/3, list/1, get/2, put/2]).

list(Pid) ->
  lib_chan:rpc(Pid, {list}).

get(Pid, FileName) ->
  {ok, Content} = lib_chan:rpc(Pid, {get, FileName}),
  file:write_file(FileName, Content). 

put(Pid, FileName) ->
  {ok, Content} = file:read_file(FileName),
  lib_chan:cast(Pid, {put, FileName, Content}).

connect(Addr, Port, Password) ->
  lib_chan:connect(Addr, Port, file_server, Password, "").


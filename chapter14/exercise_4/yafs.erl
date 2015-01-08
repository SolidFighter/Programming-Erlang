-module(yafs).
-export([list/0, get/1, put/2, start/1]).

start(ConfFile) ->
  lib_chan:start_server(ConfFile).

list() ->
  file:list_dir(".").

get(FileName) ->
  file:read_file(FileName).

put(FileName, Content) ->
  file:write_file(FileName, Content).
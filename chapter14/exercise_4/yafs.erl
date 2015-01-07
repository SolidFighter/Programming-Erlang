-module(yafs).
-export([pwd/0, list/1, get/1]).

pwd() ->
  file:get_cwd().

list(Dir) ->
  file:list_dir(Dir).

get(FileName) ->
  file:read_file(FileName).
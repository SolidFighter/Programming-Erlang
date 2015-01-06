-module(yafs).
-export([pwd/0]).

pwd() ->
  file:get_cwd().
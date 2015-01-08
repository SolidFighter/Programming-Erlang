-module(exercise_3).
-export([get_cpuinfo/0]).

get_cpuinfo() ->
  os:cmd("lscpu | grep -i \"model name\"").
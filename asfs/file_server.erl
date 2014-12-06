-module(file_server).
-export([loop/1, start/1]).

start(Dir) ->
	spawn(file_server, loop, [Dir]).

loop() ->
	receive 
		
-module(file_server).
-export([loop/1, start/1]).

start(Dir) ->
	spawn(file_server, loop, [Dir]).

loop(Dir) ->
	receive 
	{Client, list} ->
		Client ! {self(), file:list_dir(Dir)};
	{Client, {get, FileName}} ->
		FullFileName = filename:join([Dir, FileName]),
		Client ! {self(), file:consult(FullFileName)}
	end.

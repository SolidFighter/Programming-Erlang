-module(afile_server).
-export([loop/1, start/1]).

start(Dir) ->
	spawn(afile_server, loop, [Dir]).

loop(Dir) ->
	receive 
		{Client, list} ->
			Client ! {self(), file:list_dir(Dir)};
		{Client, {get, FileName}} ->
			FullFileName = filename:join([Dir, FileName]),
			Client ! {self(), file:read_file(FullFileName)};
		{Client, {put, {ok, Content}}} ->
			io:format("~p~n", [Content]),
			Client ! ok
	end,
	loop(Dir).

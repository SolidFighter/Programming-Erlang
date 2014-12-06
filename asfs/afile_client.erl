-module(afile_client).
-export([list_dir/1, get_file/2, put_file/2]).

list_dir(ServerPid) ->
	ServerPid ! {self(), list},
	receive 
	{ServerPid, {ok, FileNames}} ->
		FileNames
	end.

get_file(ServerPid, FileName) ->	
	ServerPid ! {self(), {get, FileName}},
	receive 
	{ServerPid, {ok, Content}} ->
		Content
	after 5000 ->
		io:format("get file timeout.~n")
	end.

put_file(ServerPid, FileName) ->
	ServerPid ! {self(), {put, file:read_file(FileName)}},
	receive
	ok ->
		ok
	after 5000 ->
		io:format("put file timeout.~n")
	end.
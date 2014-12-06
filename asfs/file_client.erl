-module(file_client).
-export([list_dir/1, get_file/2]).


list_dir(ServerPid) ->
	ServerPid ! {self(), list},
	receive 
	{ServerPid, FileNames} ->
		FileNames
	end.

get_file(ServerPid, FileName) ->	
	ServerPid ! {self(), {get, FileName}},
	receive 
	{ServerPid, {ok, Content}} ->
		Content
	end.

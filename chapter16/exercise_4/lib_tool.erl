-module(lib_tool).
-export([md5/1]).
-define(BYTES_PER_READ, 1024).

md5(FileName) ->
  {ok, FileHandle} = file:open(FileName, [read, binary, raw]),
  md5(FileHandle, 0, erlang:md5_init()).  

md5(FileHandle, Location, Context) ->
  case file:pread(FileHandle, Location, ?BYTES_PER_READ) of
    {ok, Data} ->
      NewContext = erlang:md5_update(Context, Data),
      md5(FileHandle, Location + ?BYTES_PER_READ, NewContext);
    eof ->
      erlang:md5_final(Context)
    end.

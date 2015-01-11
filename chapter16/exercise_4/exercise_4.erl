-module(exercise_4).
-export([search_same_pic/1]).

-spec search_same_pic(Dir) -> FileNames when
  Dir :: string(),
  FileNames :: list().
search_same_pic(Dir) ->
  PicFileNames = lib_find:files(Dir, "*.jpg", true), 
  FileNameMd5 = [{FileName, lib_tool:md5(FileName)} || FileName <- PicFileNames],
  search_same_pic(FileNameMd5, []).

search_same_pic([], Result) -> 
  Result;
search_same_pic(FileNameMd5, Result) -> 
  {SearchResult, RemainResult} = partition(FileNameMd5),
  if 
    length(SearchResult) > 1 ->
      search_same_pic(RemainResult, [SearchResult | Result]);
    true ->
      search_same_pic(RemainResult, Result)
  end.

partition([H | T]) ->
  {FileName, Md5} = H,
  partition(T, Md5, [FileName], []).
partition([H | T], Md5, SearchResult, RemainResult) ->
  {FileName, Md5Value} = H,
  if
    Md5 =:= Md5Value ->
      partition(T, Md5, [FileName | SearchResult], RemainResult); 
    true ->
      partition(T, Md5, SearchResult, [H | RemainResult])
  end;
partition([], _Md5, SearchResult, RemainResult) ->
  {SearchResult, RemainResult}.

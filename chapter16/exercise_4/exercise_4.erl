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
  [{_FileName, Md5} | _T] = FileNameMd5,
  {SearchResult, RemainResult} = lists:partition(fun({_FileName1, Md5Value}) ->
    Md5 =:= Md5Value end, FileNameMd5),
  if 
    length(SearchResult) > 1 ->
      search_same_pic(RemainResult, [[FN || {FN, _} <- SearchResult] | Result]);
    true ->
      search_same_pic(RemainResult, Result)
  end.

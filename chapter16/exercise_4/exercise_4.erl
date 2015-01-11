-module(exercise_4).
-export([search_same_pic/1]).

search_same_pic(Dir) ->
  PicFileNames = lib_find:files(Dir, "*.jpg", true), 
  FileNameMd5 = [{FileName, lib_tool:md5(FileName)} || FileName <- PicFileNames],
  search_same_pic(FileNameMd5, []).

search_same_pic([{FileName, Md5} | T], Result) -> 
  SearchResult = lists:keyfind(Md5, 2, T),
  if 
    SearchResult =:= false ->
      search_same_pic(T, Result);
    true ->
      {FileName1, _Md5} = SearchResult,
      search_same_pic(lists:keydelete(Md5, 2, T), [{FileName, FileName1}| Result])
  end;
search_same_pic([], Result) -> 
  Result.


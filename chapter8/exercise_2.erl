-module(exercise_2).
-export([search_module/0, search_func/0, search_func_once/0]).
%search the module have the most export functions
search_module() ->
  lists:max(get_result(fun length/1)).

%search the most frequent function
search_func() -> 
  Funcs = compresss_func_list(get_result(fun(X) -> X end), []),
  lists:max([{Y, X} || {X, Y} <- maps:to_list(merge_func(Funcs, #{}))]).

%search the function occurs in the modules only once
search_func_once() -> 
  Funcs = compresss_func_list(get_result(fun(X) -> X end), []),
  [{X, Y} || {X, Y} <- maps:to_list(merge_func(Funcs, #{})), Y =:= 1].

get_result(Pred) ->
  [{get_result(Module, Pred), Module} || {Module, _File} <- code:all_loaded()].
get_result(Module, Pred) ->
  [{exports, Funcs} | _T] = Module:module_info(),
  Pred(Funcs).

%merge the same function
merge_func([H | T], FuncMap) ->
  Result = maps:get(H, FuncMap, nil),
  if 
    Result =:= nil ->
      merge_func(T, maps:put(H, 1, FuncMap));
    true ->
      merge_func(T, maps:put(H, Result+1, FuncMap))
  end;
merge_func([], FuncMap) ->
  FuncMap.

%compress the function lists to one list
compresss_func_list([{Funcs, _Module} | T], Result) ->
  compresss_func_list(T, lists:append(Funcs, Result));
compresss_func_list([], Result) ->
  Result.

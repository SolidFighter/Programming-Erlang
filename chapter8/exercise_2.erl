-module(exercise_2).
-export([search_module/0]).

%search module loaded have the most export functions
search_module() ->
  GetExports = fun(Module) -> 
    [{exports, Funcs} | _T] = Module:module_info(),
    length(Funcs) 
  end,
  [H | T] = [{Module, GetExports(Module)} || {Module, _File} <- code:all_loaded()],
  search_module(T, H).
search_module([{Module1, Exports1} | T1], {Module, Exports}) ->
  if 
    Exports1 > Exports ->
      search_module(T1, {Module1, Exports1});
    true ->
      search_module(T1, {Module, Exports})
  end;
search_module([], Result) ->
  Result.

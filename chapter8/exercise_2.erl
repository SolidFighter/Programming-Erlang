-module(exercise_2).
-export([search_module/0]).

%search the module loaded have the most export functions
search_module() ->
  GetNumExports = fun(Module) -> 
    [{exports, Funcs} | _T] = Module:module_info(),
    length(Funcs) 
  end,
  lists:max([{GetNumExports(Module), Module} || {Module, _File} <- code:all_loaded()]).

-module(exercise_2).
-export([term_to_packet/1]).
-compile(export_all).

term_to_packet(Term) ->
  Data = term_to_binary(Term),
  DataSize = byte_size(Data),  
  <<DataSize:32, Data/binary>>.

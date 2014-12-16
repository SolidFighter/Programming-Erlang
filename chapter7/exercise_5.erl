-module(exercise_5).
-export([bit_reverse/1]).
-compile(export_all).

bit_reverse(Bin) when is_binary(Bin) ->
  bit_reverse(Bin, <<>>).
bit_reverse(<<H:1, T/bits>>, DBin) ->
  bit_reverse(T, <<H:1, DBin/bits>>);
bit_reverse(<<>>, DBin) ->
  DBin.

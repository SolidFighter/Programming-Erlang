-module(exercise_3).
-export([packet_to_term/1]).
-compile(export_all).

packet_to_term(Packet) ->
  <<DataSize:32, Data:DataSize/binary>> = Packet,
  binary_to_term(Data). 

test() ->
  [1, 2, 3] = packet_to_term(exercise_2:term_to_packet([1, 2, 3])),
  {1, 2, 3} = packet_to_term(exercise_2:term_to_packet({1, 2, 3})),
  <<1, 2, 3>> = packet_to_term(exercise_2:term_to_packet(<<1, 2, 3>>)),
  #{a := 1, b := 2, c := 3} = packet_to_term(exercise_2:term_to_packet(#{a => 1, b => 2, c => 3})),
  [] = packet_to_term(exercise_2:term_to_packet([])),
  {} = packet_to_term(exercise_2:term_to_packet({})),
  <<>> = packet_to_term(exercise_2:term_to_packet(<<>>)),
  #{} = packet_to_term(exercise_2:term_to_packet(#{})),
  io:format("exercise_3 test_ok.~n").





-module(exercise_1).
-export([nano_get_url/1]).

nano_get_url(Host) ->
  {ok, Socket} = gen_tcp:connect(Host, 80, [binary, {packet, 0}]),
  ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
  receive_data(Socket, []).

receive_data(Socket, Sofar) ->
  receive 
    {tcp, Socket, Bin} ->
      receive_data(Socket, [Bin | Sofar]);
    {tcp_closed, Socket} ->
      list_to_binary(lists:reverse(Sofar))
  end.
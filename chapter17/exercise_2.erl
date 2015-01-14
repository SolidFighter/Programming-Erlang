-module(exercise_2).
-export([start/0, client_eval/3, loop/1, listen/1]).

start() ->
  {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4},  
    {reuseaddr, true},
    {active, once}]),
  spawn(exercise_2, listen, [Listen]).

listen(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  io:format("Server Socket = ~p.~n",[Socket]),
  spawn(exercise_2, listen, [Listen]),
  loop(Socket).

loop(Socket) ->
  receive
    {tcp, Socket, Bin} ->
      inet:setopts(Socket, [{active, once}]),
      io:format("Server received binary = ~p~n",[Bin]),
      {Module, Func, Args} = binary_to_term(Bin),  
      io:format("Server (unpacked)  Module=~p, Func=~p, Args=~p.~n",[Module, Func, Args]),
      Reply = erlang:apply(Module, Func, Args),  
      io:format("Server replying = ~p.~n",[Reply]),
      gen_tcp:send(Socket, term_to_binary(Reply)),  
      loop(Socket);
    {tcp_closed, Socket} ->
      io:format("Server socket closed~n")
  end.

client_eval(Module, Func, Args) ->
  {ok, Socket} = gen_tcp:connect("localhost", 2345, [binary, {packet, 4}]),
  ok = gen_tcp:send(Socket, term_to_binary({Module, Func, Args})),
  receive
    {tcp,Socket,Bin} ->
      io:format("Client received binary = ~p.~n",[Bin]),
      Val = binary_to_term(Bin),
      io:format("Client result = ~p.~n",[Val]),
      gen_tcp:close(Socket)
  end.


-module(exercise_3).
-export([start/0, client_eval/3, loop/1, server/0]).

start() ->
  spawn(exercise_3, server, []).

server() ->
  {ok, Socket} = gen_udp:open(2345, [binary]),
  loop(Socket).

loop(Socket) ->
  receive
    {udp, Socket, Host, Port, Bin} ->
      io:format("Server received binary = ~p from ~p on port ~p.~n",[Bin, Host, Port]),
      {Ref, Module, Func, Args} = binary_to_term(Bin),  
      io:format("Server (unpacked)  Module=~p, Func=~p, Args=~p.~n",[Module, Func, Args]),
      Reply = erlang:apply(Module, Func, Args),  
      io:format("Server replying = ~p.~n",[Reply]),
      gen_udp:send(Socket, Host, Port, term_to_binary({Ref, Reply})),  
      loop(Socket)
  end.

client_eval(Module, Func, Args) ->
  {ok, Socket} = gen_udp:open(0, [binary]),
  Ref = make_ref(),
  ok = gen_udp:send(Socket, "localhost", 2345, term_to_binary({Ref, Module, Func, Args})),
  receive
    {udp, Socket, _Host,_Port, Bin} ->
      io:format("Client received binary = ~p from ~p on port ~p.~n",[Bin, _Host, _Port]),
      {Ref, Val} = binary_to_term(Bin),
      io:format("Client result = ~p.~n",[Val])
    after 2000 ->
      io:format("Response timeout.~n")
  end.


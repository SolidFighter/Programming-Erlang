-module(prime_test_server).
-behaviour(gen_server).
-export([start_link/0, is_prime/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

start_link() -> gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
init([]) -> 
  process_flag(trap_exit, true),
  io:format("~p starting~n",[?MODULE]),
  {ok, []}.

handle_call({prime_test, Number}, _From, State) -> 
  {reply, lib_primes:is_prime(Number), State}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%client method 
is_prime(Number) -> 
  %%gen_server:call(?MODULE, {prime_test, Number}).
  gen_server:call(prime_test_server, {prime_test, Number}).


-module(job_center).
-behaviour(gen_server).
-export([start_link/0, db_init/0, add_job/1, work_wanted/0, job_done/1, job_statistics/0]).
-include_lib("stdlib/include/qlc.hrl").

-define(SERVER, ?MODULE).
-define(READY, 0).
-define(DOING, 1).
-define(DONE, 2).
-record(jobs, {job_number, job, status}).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	terminate/2, code_change/3]).

start_link() -> gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
init([]) -> 
  mnesia:start(),
  mnesia:wait_for_tables([jobs], 20000),
  {ok, []}.

handle_call({add, Job}, _From, State) -> 
  NextJobNumber = get_next_job_number(),
  add_job_item(NextJobNumber, Job, ?READY), 
  {reply, ok, State};
handle_call({get}, _From, State) -> 
  Jobs = query(),
  JobItem = get_job(Jobs),
  if 
    JobItem =:= no ->
      {reply, no, State};
    true -> 
      add_job_item(JobItem#jobs.job_number, JobItem#jobs.job, ?DOING), 
      {reply, {JobItem#jobs.job_number, JobItem#jobs.job}, State}
  end;
handle_call({done, JobNumber}, _From, State) -> 
  Jobs = query(JobNumber),
  if 
    Jobs =:= [] ->
      {reply, no, State};
    true ->
      [H | _T] = Jobs,
      add_job_item(H#jobs.job_number, H#jobs.job, ?DONE), 
      {reply, done, State}
  end;
handle_call({statistic}, _From, State) -> 
  Jobs = query(),
  {reply, Jobs, State}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.


%%client method 
add_job(Job) -> 
  gen_server:call(?MODULE, {add, Job}).
work_wanted() -> 
  gen_server:call(?MODULE, {get}).
job_done(JobNumber) -> 
  gen_server:call(?MODULE, {done, JobNumber}).
job_statistics() -> 
  gen_server:call(?MODULE, {statistic}).


%%this method just need to call one time 
db_init() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  mnesia:create_table(jobs,   [{attributes, record_info(fields, jobs)}, {disc_copies, [node()]}, {type, ordered_set}]),
  mnesia:stop().
  
query() ->
  do(qlc:q([X || X <- mnesia:table(jobs)])).
query(JobNumber) ->
  do(qlc:q([X || X <- mnesia:table(jobs), X#jobs.job_number =:= JobNumber])).
do(Q) ->
  F = fun() -> qlc:e(Q) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

add_job_item(JobNumber, Job, JobStatus) ->
  Row = #jobs{job_number=JobNumber, job=Job, status=JobStatus},
  F = fun() ->
    mnesia:write(Row)
  end,
  mnesia:transaction(F).

get_next_job_number() ->
  Jobs = query(),
  io:format("Jobs = ~p.~n", [Jobs]),
  if 
    Jobs =:= [] ->
      0;
    true ->
      {jobs, JobNumber, _Job, _JobStatus} = lists:last(Jobs),
      JobNumber + 1
  end.

get_job([]) ->
  no; 
get_job([H | T]) ->
  if 
    H#jobs.status =:= ?READY ->
      H;
    true ->
      get_job(T)
  end.


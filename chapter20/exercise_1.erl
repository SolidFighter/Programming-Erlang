-module(exercise_1). 
-export([test/0, init/0, start/0, query/1, add_users_item/3, remove_users_item/1]).
-include_lib("stdlib/include/qlc.hrl").

-record(users, {name, password, email}).
-record(tips, {url, description, checktime}).
-record(abuse, {username, visite_times, ip}).

init() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  mnesia:create_table(users,   [{attributes, record_info(fields, users)}, {disc_copies, [node()]}]),
  mnesia:create_table(tips,   [{attributes, record_info(fields, tips)}, {disc_copies, [node()]}]),
  mnesia:create_table(abuse,   [{attributes, record_info(fields, abuse)}, {disc_copies, [node()]}]),
  mnesia:stop().

start() ->
  mnesia:start(),
  mnesia:wait_for_tables([users, tips, abuse], 20000).

query(select_users_some) ->
  do(qlc:q([{X#users.name, X#users.email} || X <- mnesia:table(users)]));
query(Table) ->
  do(qlc:q([X || X <- mnesia:table(Table)])).

do(Q) ->
  F = fun() -> qlc:e(Q) end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

add_users_item(Name, Password, Email) ->
  Row = #users{name=Name, password=Password, email=Email},
  F = fun() ->
    mnesia:write(Row)
  end,
  mnesia:transaction(F).

remove_users_item(Name) ->
  Oid = {users, Name},
  F = fun() ->
    mnesia:delete(Oid)
  end,
  mnesia:transaction(F).

test() ->
  start(),
  add_users_item("myang", "yyl", "myang199088@163.com"),
  add_users_item("yangmeng", "yyl", "97578250@qq.com"),
  io:format("result = ~p.~n", [query(users)]),
  remove_users_item("myang"),
  io:format("result = ~p.~n", [query(users)]).

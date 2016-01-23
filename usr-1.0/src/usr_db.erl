% file : user_db.erl
% desc : database api for subscriber db

-module(usr_db).
-include("../include/usr.hrl").
-export([create_tables/1, close_tables/0]).
-export([add_usr/1, update_usr/1]).
-export([lookup_id/1, lookup_msisdn/1]).
-export([restore_backup/0]).
-export([delete_disabled/0, loop_delete_disabled/1]).
-export([add_test/2]).

create_tables(Filename) ->
  ets:new(usrRam, [named_table, {keypos, #usr.msisdn}]),
  ets:new(usrIndex, [named_table]),
  dets:open_file(usrDisk, [{file, Filename}, {keypos, #usr.msisdn}]).

close_tables() ->
  ets:delete(usrRam),
  ets:delete(usrIndex),
  dets:close(usrDisk).

add_test(PhoneNo, CustId) ->
  ets:insert(usrIndex, {CustId, PhoneNo}),
  ok. 

add_usr(#usr{msisdn=PhoneNo, id=CustId} = Usr) ->
  io:format("usr_db add_usr called : ~w~n", [PhoneNo]),
  catch ets:insert(usrIndex, {CustId, PhoneNo}),
  update_usr(Usr).

update_usr(Usr) ->
  ets:insert(usrRam, Usr),
  dets:insert(usrDisk, Usr),
  ok.

% -----------------
lookup_id(CustId) ->
  case get_index(CustId) of 
    {ok, PhoneNo} -> lookup_msisdn(PhoneNo);
    {error, instance} -> {error, instance}
  end.

lookup_msisdn(PhoneNo) ->
  case ets:lookup(usrRam, PhoneNo) of
    [Usr] -> {ok, Usr};
    [] -> {error, instance}
  end.

get_index(CustId) ->
  case ets:lookup(usrIndex, CustId) of 
    [{CustId, PhoneNo}] -> {ok, PhoneNo};
    [] -> {error, instance}
  end.

restore_backup() ->
  Insert = fun(#usr{msisdn=PhoneNo, id=Id} = Usr) -> 
    ets:insert(usrRam, Usr),
    ets:insert(usrIndex, {Id, PhoneNo}),
    % why continue ? what is that?
    continue
  end,
  dets:traverse(usrDisk, Insert).

delete_disabled() ->
  ets:safe_fixtable(usrRam, true),
  catch loop_delete_disabled(ets:first(usrRam)),
  ets:safe_fixtable(usrRam, false),
  ok.

loop_delete_disabled('$end_of_table') ->
  ok;
loop_delete_disabled(PhoneNo) ->
  case ets:lookup(usrRam, PhoneNo) of
    [#usr{status=disabled, id = CustId}] -> delete_usr(PhoneNo, CustId);
    _-> ok
  end,
  loop_delete_disabled(ets:next(usrRam, PhoneNo)).

delete_usr(PhoneNo, CustId) ->
  ets:delete(usrRam, PhoneNo),
  ets:delete(usrIndex, {PhoneNo, CustId}),
  dets:delete(usrDisk, PhoneNo).




% run direct test
% escript db.erl
-module(db).
-export([new/0, write/3, read/2, delete/2, destroy/1]).
-vsn(1.0).

new() -> dict:new().

write(Key, Data, Db) -> dict:store(Key, Data, Db).

read(Key, Db) ->
  case dict:fetch(Key, Db) of
    error -> {error, instance};
    {ok, Data} -> {ok, Data}
  end.

delete(Key, Db) -> dict:erase(Key, Db).

destroy(_Db) -> ok.

% escript main function
% the fetch raise exception 
main(_) ->
  Db = new(),
  write(hw, helloworld, Db),
  io:format("~p~n", [db:module_info()]),
  io:format("~s~n", [read(hw, Db)]).



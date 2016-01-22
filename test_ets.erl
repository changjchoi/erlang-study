-module(test_ets).
-export([bound_test/0]).
%%-include_lib("eunit/include/eunit.hrl").

bound_test() ->
  Table = ets:new(random_tab, []),
  generate_rows(Table, 1000),
  view(Table, 10).

view(Table, Num) -> 
  MS = [{{'$1', '$2'}, [{'==', '$2', Num}], ['$$']}],
  view2(ets:select(Table, MS, 1)).

view2({[Rec], C}) ->
  io:format("Record ? = ~p~n", [Rec]),
  view2(ets:select(C));
view2('$end_of_table') -> ok.

generate_rows(_Table, 0) -> ok;
generate_rows(Table, N) -> 
  ets:insert(Table, {key(), val()}),
  generate_rows(Table, N-1).

key() -> key(10).
key(N) -> key(<< (random:uniform(26) - 1) >>, N - 1).
% Take 8 char in base64:encode(Acc)
key(Acc, 0) -> binary_part(base64:encode(Acc), 0, 8);
key(Acc, N) -> key(<< Acc/binary, (random:uniform(26) - 1) >>, N - 1).
val() -> random:uniform(50).

  


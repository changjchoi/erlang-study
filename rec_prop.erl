-module(rec_prop).
-export([rec_to_prop/2, r2p/1]).

-record(person, {age, addr, name}).
-define(record_to_tuplelist(Rec, Ref), lists:zip(record_info(fields, Rec),tl(tuple_to_list(Ref)))).
-define(rec_name(RecName), record_info(fields, RecName)). 
-define(rec_name2(RecName), RecName). 

r2p(Rec) ->
  RecName = element(1, Rec),
  rec_to_prop(Rec, ?rec_name(RecName)).

rec_to_prop(Rec, RecordFields) ->
  loop_rec(RecordFields, 1, Rec, []).

loop_rec([H|T], N, Rec, L) ->
  loop_rec(T, N+1, Rec, [{H, element(N+1, Rec)}|L]);
loop_rec([], _, _, L) -> 
  L.



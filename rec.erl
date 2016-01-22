-module(rec).
-export([test/0]).
-record(foo, {a, b, c}).

%-spec fields (document()) -> [{label(), value()}].
%@doc Convert document to a list of all its fields
%fields (Doc) -> doc_foldr (fun (Label, Value, List) -> [{Label, Value} | List] end, [], Doc).

%-spec document ([{label(), value()}]) -> document().
%@doc Convert list of fields to a document
document (Fields) -> list_to_tuple (flatten (Fields)).

%-spec flatten ([{label(), value()}]) -> [label() | value()].
%@doc Flatten list by removing tuple constructors
flatten ([]) -> [];
flatten ([{Label, Value} | Fields]) -> [Label, Value | flatten (Fields)].


% Convert record to prop list 
rec2prop(Rec, RecordFields) ->
  loop_rec(RecordFields, 1, Rec, []).

loop_rec([H|T], N, Rec, L) ->
  loop_rec(T, N+1, Rec, [{H, element(N+1, Rec)}|L]);
loop_rec([], _, _, L) ->
  L.

% convert prop list to record
prop2rec(Prop, RecName, DefRec, RecordFields) ->
  loop_fields(erlang:make_tuple(tuple_size(DefRec), RecName), RecordFields, DefRec, Prop, 2).

loop_fields(Tuple, [Field|T], DefRec, Props, N) ->
  case lists:keysearch(Field, 1, Props) of
    {value, {_, Val}} ->
      loop_fields(setelement(N, Tuple, Val), T, DefRec, Props, N+1);
    false ->
      loop_fields(setelement(N, Tuple, element(N, DefRec)), T, DefRec, Props, N+1)
  end;
loop_fields(Tuple, [], _, _, _) ->
  Tuple.


test() ->
  V1 = #foo{a="A", b="B", c="C"},
  io:format("rec ~p~n",     [V1]),
  io:format("rec got ~p~n", [element(#foo.a, V1)]),
  V2 = setelement(#foo.a, V1, "A+"),

  io:format("rec ~p~n",     [V2]),
  io:format("rec got ~p~n", [element(#foo.b, V2)]),
  V3 = setelement(#foo.b, V2, "B+"),

  io:format("-> ~p~n",     [V3]),
  Fields = rec2prop(V3, record_info(fields, foo)),
  document(Fields).
   



% run
% escript list.erl
-define(OUT(Line), io:format("~p~n", [Line])).

main(_) ->
  ?OUT([X+1||X <- [1,2,3]]),
  ?OUT([X || X <- [1,2,3], X rem 2 == 0]),
  Database = [ {francesco, harryPoter}, {simon, jamesBond}, {marcus, jamesBond},
               {francesco, daVinciCode}],
  ?OUT([Person || {Person, _} <- Database]),
  ?OUT([Book || {Person, Book} <- Database, Person == francesco]),
  ?OUT([{X, Y} || X <- lists:seq(1,3), Y <- lists:seq(X, 3)]).



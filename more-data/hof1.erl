
-module(hof1).
-export([foreach/2, times/1, doubleAll/1, foo/0, bar/0]).
-export([append/1, qsort/1]).
%-export([Bump/1, Add/1]).

-define(OUT(Line), io:format("~p~n", [Line])).

foreach(_F, []) -> ok;
foreach(F, [X|Xs]) -> F(X), foreach(F, Xs).

times(X) -> fun(Y) -> X * Y end.

doubleAll(Xs) -> lists:map(fun(X) -> X*2 end, Xs).

foo() -> X = 2, Bump = fun(X) -> X+1 end, Bump(10).
bar() -> X = 3, Add = fun(Y) -> Y+X end, Add(10).

% what ??
append(Xss) -> [X || Xs <- Xss, X <- Xs].

qsort([]) -> [];
qsort([X|Xs]) -> qsort([Y|| Y <- Xs, Y =< X]) ++ [X] ++ 
  qsort([Y || Y <- Xs, Y > X]).

%positive(X) -> fun(X) -> if X < 0 -> false; X >= 0 -> true end end.

% Test
main(_) ->
  ?OUT(foo()),
  ?OUT(bar()),
  Positive = fun(X) -> 
               if X < 0 -> false; X >= 0 -> true end
             end,
  %Positive = fun(X) -> if X < 0 -> false; X >= 0 -> true end,
  ?OUT(lists:filter(Positive, [-2, -1, 0, 1, 2])),
  %?OUT(append([1,2,3])),
  ?OUT(qsort([2,3,4,5,1])).




-module(tuples1).
-export([test1/0, test2/0]).

-record(person, {name, age=0, phone="000-0000"}).

%%Person = #person{name="cjchoi"}.

birthday(P) ->
  P#person{age = P#person.age+10}.

birthday2(#person{age=Age} = P) ->
  P#person{age = Age +11}.

%%joe() ->
 %% { "Joe", 21, "999-9999" }.

joe() ->
  #person{name="cjchoi", age=30, phone="777-7777"}.

showPerson({Name, Age, Phone}) ->
  io:format( "name: ~p age: ~p phone:~p~n", [Name, Age, Phone]).

showPerson2(P) ->
  io:format( "name: ~p age: ~p phone:~p~n", 
    [P#person.name,P#person.age, P#person.phone]).


test1() ->
  showPerson(joe()).

test2() ->
  showPerson2(birthday2(joe())).


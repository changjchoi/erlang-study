
%% record 
-record(login_attemp, {'_id', email, time}).
%% is salt needed ?
-record(user, {'_id', username, email, password}).
-define(JSON, {<<"content-type">>, <<"application/json; charset=utf-8">>}).

%% DEBUG MODE
-ifdef(debug).
-define(DBG(Format, Args), io:format("[~p:~p:~p:~p] : "++Format++"~n", [time(), self(),?MODULE,?LINE]++Args)).
-define(DBG0(Format), io:format("[~p:~p:~p:~p] : "++Format++"~n", [time(),self(),?MODULE,?LINE])).
-else.
-define(DBG(F,A),[]).
-define(DBG0(F),[]).
-endif.


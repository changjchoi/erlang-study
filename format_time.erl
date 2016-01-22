-module(format_time).
-export([format_time/0]).

localtime_ms() ->
      {_, _, Micro} = Now = os:timestamp(),
      {Date, {Hours, Minutes, Seconds}} = calendar:now_to_local_time(Now),
      {Date, {Hours, Minutes, Seconds, Micro div 1000 rem 1000}}.

format_time() ->
      format_time(localtime_ms()).

format_time({{Y, M, D}, {H, Mi, S, Ms}}) ->
      {io_lib:format("~b-~2..0b-~2..0b", [Y, M, D]),
      io_lib:format("~2..0b:~2..0b:~2..0b.~3..0b", [H, Mi, S, Ms])};
format_time({{Y, M, D}, {H, Mi, S}}) ->
      {io_lib:format("~b-~2..0b-~2..0b", [Y, M, D]),
      io_lib:format("~2..0b:~2..0b:~2..0b", [H, Mi, S])}.

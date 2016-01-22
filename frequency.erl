% compile 
% erlc -DDEBUG frequency.erl
% 1> c(frequency, {d, debug}).
-module(frequency).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([print/0, init/0]).

% include header
-include("utils.hrl").

start() -> 
  register(frequency, spawn(frequency, init, [])).

init() ->
  %  
  ?DBG0("Inited:"),
  % When trap_exit is set to true, exit signals arriving to a process are
  % converted to {'EXIT', From, Reason} messages
  process_flag(trap_exit, true),
  Frequencies = { get_frequencies(), []},
  loop(Frequencies).

get_frequencies() -> [10, 11, 12, 13, 14, 15].

% client function
stop() -> call(stop).
allocate() -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).
print() -> call(print).

call(Message) ->
  % Send Message to frequency
  frequency ! { request, self(), Message },
  % and wait reply
  receive { reply, Reply } -> Reply end.

% main loop
loop(Frequencies) ->
  receive
    % case {request, Pid, allocate }
    { request, Pid, allocate } -> 
      % allocate function ?
      { NewFrequencies, Reply } = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    { request, Pid, { deallocate, Freq }} ->
      NewFrequencies = deallocate(Frequencies, Freq), 
      reply(Pid, ok),
      loop(NewFrequencies);
    { request, Pid, print } ->
      reply(Pid, Frequencies),
      loop(Frequencies);
    { 'EXIT', Pid, _Reason } -> 
      ?DBG("Called:", []),
      NewFrequencies = exited(Frequencies, Pid),
      loop(NewFrequencies);
    % stop command
    { request, Pid, stop } ->
      reply(Pid, ok)
  end.

% send reply message to Pid
reply(Pid, Reply) -> Pid ! { reply, Reply }.

% Help ftn used to allocate and...
% Not use Pid
allocate({[], Allocated}, _Pid) ->
  % return { NewFrequencies, Reply }
  {{[], Allocated}, {error, no_frequency}};
% the rest Free array, allocation [{Freq, Pid}|Allocated] 
allocate({[Freq|Free], Allocated}, Pid) ->
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) -> 
  % lists:keysearch(key, tuple idx?, tuple lists), return {value, Tuple} | false
  % 7> lists:keysearch(10, 1, [{10, test}]).
  % {value,{10,test}}
  {value, {Freq, Pid}} = lists:keysearch(Freq, 1, Allocated),
  % unlike : remove the link
  unlink(Pid),
  %receive 
  %  {'EXIT', Id, _} -> true
  %after 0 -> true
  %end,
  NewAllocated = lists:keydelete(Freq, 1, Allocated),
  {[Freq|Free], NewAllocated}.

% search second tuple value 
exited({ Free, Allocated }, Pid) ->
  case lists:keysearch(Pid, 2, Allocated) of
    % if searched
    {value, {Freq, Pid}} -> 
      NewAllocated = lists:keydelete(Freq, 1, Allocated),
      {[Freq|Free], NewAllocated};
    false -> {Free, Allocated}
  end.



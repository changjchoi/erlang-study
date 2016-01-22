-module(digraph_test).
-export([
  init/0,
  test/0
]).


init() ->
  ets:new(state, [bag, named_table]),
  G = digraph:new(),
  ets:insert(state, {graph, G}).

test() ->
  [{graph, G}] = ets:lookup(state, graph),
  N1 = digraph:add_vertex(G),
  N2 = digraph:add_vertex(G, N1, 1),
  io:format("Vertex 1: ~p~n", [N1]),
  N3 = digraph:add_vertex(G),
  N4 = digraph:add_vertex(G, N3, 2),
  io:format("Vertex 2: ~p~n", [N1]),
  E1 = digraph:add_edge(G, N1, N2),
  G.


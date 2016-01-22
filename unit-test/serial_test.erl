-module(serial_test).
-include_lib("eunit/include/eunit.hrl").
-import(serial, [treeToList/1, listToTree/1]).

tree0() -> {leaf, ant}.
tree1() -> {node,
             {node,
               {leaf, cat},
               {node,
                 {leaf, dog},
                 {leaf, emu}
               }
             },
             {leaf, fish}
           }.


leaf_test() ->
  ?assertEqual(tree0(), listToTree(treeToList(tree0()))).
node_test() ->
  ?assertEqual(tree1(), listToTree(treeToList(tree0()))).


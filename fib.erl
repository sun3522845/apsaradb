-module(fib).
-export([generatetree/2,apsaradb/3]).


generatetree([], []) ->
    nil;

generatetree(InOrder, PostOrder) ->
    Root=lists:last(PostOrder),
    NTree =lists:sublist(PostOrder, length(PostOrder)-1),
    {InOrderLtree,[IRRoot|InOrderRtree]}=lists:splitwith(fun(A)->A/=Root end,InOrder),
    {PostOrderLtree,PostOrderRtree}=lists:split(length(InOrderLtree),NTree),
    {Root,generatetree(InOrderLtree,PostOrderLtree),generatetree(InOrderRtree,PostOrderRtree)}.

nodestolist ({_, nil, nil}) -> [];
nodestolist ({_, nil, B})     -> [B];
nodestolist ({_, A, nil})     -> [A];
nodestolist ({_, A, B})         -> [A,B].

nodevalue({A, _, _}) -> A;
nodevalue(_) -> {err, error}.

travers([]) -> [];
travers(Node) -> lists:map(fun nodevalue/1, Node) ++ travers(lists:concat(lists:map(fun nodestolist/1, Node))).

apsaradb(InOrder, PostOrder, TransformTable) ->
    Tree=generatetree(InOrder,PostOrder),
    ListOrder=travers([Tree]),
    {Key,Value}=TransformTable,
    TMap = lists:zip(Key,Value), 
    lists:map(fun(X) -> element(2,lists:keyfind(X,1,TMap)) end, ListOrder).


%%%===================================================================
%%% Generated by generate_api.rb 2014-02-28 17:00:37 +0800
%%%===================================================================
-module(response_encoder).
-export([encode/2]).
  
encode(town, Value) ->
    Type = 1,
    {Name, PositionX, PositionY, UserId} = Value,
    DataList = [
        utils_protocol:encode_short(Type),
        utils_protocol:encode_string(Name),
        utils_protocol:encode_integer(PositionX),
        utils_protocol:encode_integer(PositionY),
        utils_protocol:encode_string(UserId)
    ],
    list_to_binary(DataList);
encode(user, Value) ->
    Type = 2,
    {Name, Age, Towns} = Value,
    DataList = [
        utils_protocol:encode_short(Type),
        utils_protocol:encode_string(Name),
        utils_protocol:encode_integer(Age),
        utils_protocol:encode_array(Towns, fun(Item) -> response_encoder:encode(town, Item) end)
    ],
    list_to_binary(DataList).
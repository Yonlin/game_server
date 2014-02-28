%%%===================================================================
%%% Generated by generate_api.rb 2014-02-28 21:44:05 +0800
%%%===================================================================
-module(api_encoder).
-export([encode/2]).

encode(town, Value) ->
    {Name, PositionX, PositionY, UserId} = Value,
    DataList = [
    utils_protocol:encode_short(0),
        utils_protocol:encode_string(Name),
        utils_protocol:encode_integer(PositionX),
        utils_protocol:encode_integer(PositionY),
        utils_protocol:encode_string(UserId)
    ],
    list_to_binary(DataList);
encode(building, Value) ->
    {Name, Position} = Value,
    DataList = [
    utils_protocol:encode_short(1),
        utils_protocol:encode_string(Name),
        utils_protocol:encode_integer(Position)
    ],
    list_to_binary(DataList);
encode(user, Value) ->
    {Uuid, Udid, Name, Gem, Paid, Building, Towns, Team} = Value,
    DataList = [
    utils_protocol:encode_short(2),
        utils_protocol:encode_string(Uuid),
        utils_protocol:encode_string(Udid),
        utils_protocol:encode_string(Name),
        utils_protocol:encode_integer(Gem),
        utils_protocol:encode_float(Paid),
        encode(building, Building),
        utils_protocol:encode_array(Towns, fun(Item) -> api_encoder:encode(town, Item) end),
        utils_protocol:encode_array(Team, fun(Item) -> utils_protocol:encode_integer(Item) end)
    ],
    list_to_binary(DataList);
encode(login_params, Value) ->
    {Udid} = Value,
    DataList = [
    utils_protocol:encode_short(3),
        utils_protocol:encode_string(Udid)
    ],
    list_to_binary(DataList);
encode(public_info_params, Value) ->
    {UserId} = Value,
    DataList = [
    utils_protocol:encode_short(4),
        utils_protocol:encode_string(UserId)
    ],
    list_to_binary(DataList).

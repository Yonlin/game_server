%%%===================================================================
%%% Generated by generate_api.rb 2014-02-28 17:00:37 +0800
%%%===================================================================
-module(request_encoder).
-export([encode/2]).
  
encode(<<"sessions_controller#login">>, Value) ->
    Type = 1,
    {Udid} = Value,
    DataList = [
        utils_protocol:encode_short(Type),
        utils_protocol:encode_string(Udid)
    ],
    list_to_binary(DataList);
encode(<<"users_controller#public_info">>, Value) ->
    Type = 2,
    {UserId} = Value,
    DataList = [
        utils_protocol:encode_short(Type),
        utils_protocol:encode_string(UserId)
    ],
    list_to_binary(DataList).
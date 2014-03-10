%%%===================================================================
%%% Generated by generate_api.rb 2014-03-10 17:56:05 +0800
%%%===================================================================
-module(api_decoder).
-export([decode/1, decode_protocol/2]).
-include("include/protocol.hrl").

decode(<<ProtocolId:?SHORT, Data/binary>>) ->
    ProtocolName = api_protocol:protocol_name(ProtocolId),
    decode_protocol(ProtocolName, Data).

decode_protocol(success, Bin0) ->
    {Code, Bin1} = utils_protocol:decode_integer(Bin0),
    {[{code, Code}], Bin1};
decode_protocol(error, Bin0) ->
    {Code, Bin1} = utils_protocol:decode_integer(Bin0),
    {Desc, Bin2} = utils_protocol:decode_string(Bin1),
    {[{code, Code}, {desc, Desc}], Bin2};
decode_protocol(town, Bin0) ->
    {Name, Bin1} = utils_protocol:decode_string(Bin0),
    {PositionX, Bin2} = utils_protocol:decode_integer(Bin1),
    {PositionY, Bin3} = utils_protocol:decode_integer(Bin2),
    {UserId, Bin4} = utils_protocol:decode_string(Bin3),
    {[{name, Name}, {position_x, PositionX}, {position_y, PositionY}, {user_id, UserId}], Bin4};
decode_protocol(building, Bin0) ->
    {Name, Bin1} = utils_protocol:decode_string(Bin0),
    {Position, Bin2} = utils_protocol:decode_integer(Bin1),
    {[{name, Name}, {position, Position}], Bin2};
decode_protocol(user, Bin0) ->
    {Uuid, Bin1} = utils_protocol:decode_string(Bin0),
    {Udid, Bin2} = utils_protocol:decode_string(Bin1),
    {Name, Bin3} = utils_protocol:decode_string(Bin2),
    {Gem, Bin4} = utils_protocol:decode_integer(Bin3),
    {Paid, Bin5} = utils_protocol:decode_float(Bin4),
    {Building, Bin6} = api_decoder:decode_protocol(building, Bin5),
    {Towns, Bin7} = utils_protocol:decode_array(Bin6, fun(Data) -> api_decoder:decode_protocol(town, Data) end),
    {Team, Bin8} = utils_protocol:decode_array(Bin7, fun(Data) -> utils_protocol:decode_integer(Data) end),
    {[{uuid, Uuid}, {udid, Udid}, {name, Name}, {gem, Gem}, {paid, Paid}, {building, Building}, {towns, Towns}, {team, Team}], Bin8};
decode_protocol(hero, Bin0) ->
    {Uuid, Bin1} = utils_protocol:decode_string(Bin0),
    {UserId, Bin2} = utils_protocol:decode_string(Bin1),
    {Level, Bin3} = utils_protocol:decode_integer(Bin2),
    {ConfigId, Bin4} = utils_protocol:decode_integer(Bin3),
    {[{uuid, Uuid}, {user_id, UserId}, {level, Level}, {config_id, ConfigId}], Bin4};
decode_protocol(heros_info, Bin0) ->
    {Heros, Bin1} = utils_protocol:decode_array(Bin0, fun(Data) -> api_decoder:decode_protocol(hero, Data) end),
    {[{heros, Heros}], Bin1};
decode_protocol(formation, Bin0) ->
    {Uuid, Bin1} = utils_protocol:decode_string(Bin0),
    {UserId, Bin2} = utils_protocol:decode_string(Bin1),
    {Matrix, Bin3} = utils_protocol:decode_array(Bin2, fun(Data) -> utils_protocol:decode_string(Data) end),
    {[{uuid, Uuid}, {user_id, UserId}, {matrix, Matrix}], Bin3};
decode_protocol(login_params, Bin0) ->
    {Udid, Bin1} = utils_protocol:decode_string(Bin0),
    {[{udid, Udid}], Bin1};
decode_protocol(public_info_params, Bin0) ->
    {UserId, Bin1} = utils_protocol:decode_string(Bin0),
    {[{user_id, UserId}], Bin1};
decode_protocol(hero_info_params, Bin0) ->
    {Id, Bin1} = utils_protocol:decode_string(Bin0),
    {[{id, Id}], Bin1};
decode_protocol(heros_info_params, Bin0) ->
    {UserId, Bin1} = utils_protocol:decode_string(Bin0),
    {[{user_id, UserId}], Bin1};
decode_protocol(formation_info_params, Bin0) ->
    {UserId, Bin1} = utils_protocol:decode_string(Bin0),
    {[{user_id, UserId}], Bin1};
decode_protocol(formation_update_params, Bin0) ->
    {UserId, Bin1} = utils_protocol:decode_string(Bin0),
    {Matrix, Bin2} = utils_protocol:decode_array(Bin1, fun(Data) -> utils_protocol:decode_string(Data) end),
    {[{user_id, UserId}, {matrix, Matrix}], Bin2}.

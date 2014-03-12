%%% The MIT License (MIT)
%%%
%%% Copyright (c) 2014-2024
%%% Savin Max <mafei.198@gmail.com>
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in all
%%% copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%%% SOFTWARE.
%%%
%%% @doc
%%%        Chat Channel manager.
%%% @end
%%% Created :  三  3 12 17:32:46 2014 by Savin Max

-module(chat_server).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-export([create_channel/5,
         delete_channel/1,
         channel_info/1]).

-include("include/gproc_macros.hrl").
-include("include/chat_records.hrl").

-record(state, {}).

-define(SERVER, ?MODULE).
-define(TAB, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

create_channel(ChannelId, Name, Desc, MaxCacheAmount, MaxCacheTime) ->
    gen_server:call(?SERVER, {create_channel, ChannelId, Name, Desc, MaxCacheAmount, MaxCacheTime}).

delete_channel(ChannelId) ->
    gen_server:cast(?SERVER, {delete_channel, ChannelId}).

channel_info(ChannelId) ->
    case ets:match_object(?TAB, ets_utils:makepat(#chat_channel{id=ChannelId})) of
        [] -> undefined;
        [Channel] -> Channel
    end.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    {ok, #state{}}.

handle_call({create_channel, Channel}, _From, State) ->
    Result = case ?GET_PID({chat_channel, Channel#chat_channel.id}) of
        undefined ->
            ets:insert(?TAB, Channel),
            chat_sup:start_child([Channel#chat_channel.id,
                                  Channel#chat_channel.maxCacheAmount,
                                  Channel#chat_channel.maxCacheTime]);
        Pid ->
            {ok, Pid}
    end,
    {reply, Result, State};
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast({delete_channel, Id}, State) ->
    ets:match_delete(?TAB, ets_utils:makepat(#chat_channel{id=Id})),
    case ?GET_PID({chat_channel, Id}) of
        undefined -> ok;
        Pid -> supervisor:terminate_child(chat_sup, Pid)
    end,
    {noreply, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%-------------------------------------------------------------------
%% @doc yaconf public API
%% @end
%%%-------------------------------------------------------------------

-module(yammy_conf_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  yammy_conf_sup:start_link().

stop(_State) ->
  ok.

%% internal functions

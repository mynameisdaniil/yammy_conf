%%%-------------------------------------------------------------------
%% @doc yaconf public API
%% @end
%%%-------------------------------------------------------------------

-module(yammy_conf_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  File = application:get_env(yammy_config, file, "./priv/config.yaml"),
  io:format("Loading YAML config: ~p\n", [File]),
  yamerl_app:set_param(node_mods, [yamerl_node_erlang_atom]),
  [Yaml] = yamerl:decode_file(File, []),
  AtomizedYaml = atomize_keys(Yaml),
  io:format("YAML contents: ~p\n", [AtomizedYaml]),
  application:set_env(AtomizedYaml, [{persistent, true}]),
  yammy_conf_sup:start_link().

stop(_State) ->
  ok.

%% internal functions

atomize_keys([{_, _}|_] = Proplist) ->
  [ atomize_keys(Pair) || Pair <- Proplist ];

atomize_keys({Key, [{_, _}|_] = Value}) ->
  {list_to_atom(Key), atomize_keys(Value)};

atomize_keys({Key, Value}) ->
  {list_to_atom(Key), Value};

atomize_keys(Value) ->
  Value.

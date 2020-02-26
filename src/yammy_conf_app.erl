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
  [Yaml] = yamerl:decode_file(File, [str_node_as_binary]),
  AtomizedYaml = atomize_keys(Yaml),
  io:format("YAML contents: ~p\n", [AtomizedYaml]),
  application:set_env(AtomizedYaml, [{persistent, true}]),
  yammy_conf_sup:start_link().

stop(_State) ->
  ok.

%% internal functions

atomize_keys(Proplist) when is_list(Proplist) ->
  [ atomize_keys(Pair) || Pair <- Proplist ];

atomize_keys({Key, Value}) when is_list(Value) ->
  {binary_to_atom(Key, utf8), atomize_keys(Value)};

atomize_keys({Key, Value}) ->
  {binary_to_atom(Key, utf8), Value};

atomize_keys(Value) ->
  Value.

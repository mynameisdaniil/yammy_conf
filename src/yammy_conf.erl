-module(yammy_conf).

-export([start/0]).

start() ->
  {ok, _} = application:ensure_all_started(yammy_conf).


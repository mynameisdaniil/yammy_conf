REBAR=./rebar3
ELVIS=./elvis
APP=yammy_conf
CONF=./config/sys.config
ERL=/usr/bin/env erl
ERL_FLAGS="+C multi_time_warp"

.PHONY: build clean dialyzer test run elvis dialyzer todo

build:
	$(REBAR) compile

clean:
	$(REBAR) clean

dialyzer:
	$(REBAR) dialyzer

test:
	$(REBAR) ct

run:
	ERL_FLAGS=$(ERL_FLAGS) $(REBAR) shell --apps $(APP) --config ./priv/sys.config --sname $(APP)@localhost --setcookie mycookie

elvis:
	$(ELVIS) rock

observer:
	$(ERL) -sname observer@localhost -hidden -setcookie mycookie -run observer

todo:
	$(REBAR) todo


.SUFFIXES: .erl .beam

.erl.beam:
	erlc -W $<

ERL = erl -boot start_clean

MODS=adapter_db1 adapter_db1_test  

all: compile
	${ERL} -pa '/home/myang/Program/Programming-Erlang/chapter24/exercise_1' -s adapter_db1_test test -s init stop

compile: ${MODS:%=%.beam}

clean:
	rm -rf *.beam erl_crash.dump 

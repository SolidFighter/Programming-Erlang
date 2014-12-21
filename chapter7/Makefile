.SUFFIXES: .erl .beam

.erl.beam:
	erlc -W $<

ERL = erl -boot start_clean

MODS=exercise_1 exercise_2 exercise_3

all: compile
	${ERL} -pa '/home/myang/Program/Programming-Erlang/chapter7' -s exercise_1 test -s exercise_3 test -s init stop

compile: ${MODS:%=%.beam}

clean:
	rm -rf *.beam erl_crash.dump 
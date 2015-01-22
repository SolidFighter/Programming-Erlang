.SUFFIXES: .erl .beam

.erl.beam:
	erlc -W $<

ERL = erl -boot start_sasl -config elog4

MODS=area_server prime_server sellaprime_supervisor sellaprime_app my_alarm_handler \
	lib_primes prime_test_server lib_lin
all: compile
	#${ERL} -pa '/home/myang/Program/Programming-Erlang/chapter23' -s sellaprime_supervisor \
	#start_in_shell_for_testing 
compile: ${MODS:%=%.beam}

clean:
	rm -rf *.beam erl_crash.dump 

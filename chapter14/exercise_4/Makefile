.SUFFIXES: .erl .beam

.erl.beam:
	erlc -W $<

ERL = erl -boot start_clean

MODS=lib_chan lib_chan_mm lib_chan_cs lib_chan_auth lib_md5 mod_file_server yafs

all: compile
	@echo "make clean - clean up"

compile: ${MODS:%=%.beam}

clean:
	rm -rf *.beam erl_crash.dump 

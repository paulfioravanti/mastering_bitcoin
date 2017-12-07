# This Makefile is automatically generated with "mix cure.bootstrap"!
# Please do not remove the following variables as they point to 
# the necessary source-files.

INC_PARAMS = /Users/paul/Documents/Software/Code/elixir/mastering_bitcoin/deps/cure/c_src
ELIXIR_COMM_C = $(INC_PARAMS)/elixir_comm.c
C_FLAGS = -std=c++11 -I$(INC_PARAMS) -L$(INC_PARAMS) -O3
BTC_LIBS = `pkg-config --cflags --libs libbitcoin`

# You can add other build targets on the next line:
ALL = program

# Targets:
all: $(ALL)
program:
	g++ $(C_FLAGS) -o program main.cpp $(ELIXIR_COMM_C) $(BTC_LIBS)
clean:
	rm -f program

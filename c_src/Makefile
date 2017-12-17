COMPILER = g++ -std=c++11
APP_DIR = /Users/paul/Documents/Software/Code/elixir/mastering_bitcoin
CURE_DEPS = $(APP_DIR)/deps/cure/c_src
LIBBITCOIN = `pkg-config --cflags --libs libbitcoin`
C_FLAGS = -I$(CURE_DEPS) -L$(CURE_DEPS) $(LIBBITCOIN) -O3 -x c++
PRIV_DIR = $(APP_DIR)/priv/
C_SRC_DIR = $(APP_DIR)/c_src/
ELIXIR_COMM_C = $(CURE_DEPS)/elixir_comm.c
OBJECTS = addr.o vanity-miner.o

all: $(OBJECTS)
$(OBJECTS): %.o: %.cpp
	$(COMPILER) $(C_FLAGS) $(C_SRC_DIR)$< -o $(PRIV_DIR)$@ $(ELIXIR_COMM_C)

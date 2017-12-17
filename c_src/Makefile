CC = g++ -std=c++11
APP_DIR = /Users/paul/Documents/Software/Code/elixir/mastering_bitcoin
CURE_DEPS_DIR = $(APP_DIR)/deps/cure/c_src
CURE_DEPS = -I$(CURE_DEPS_DIR) -L$(CURE_DEPS_DIR)
LIBBITCOIN_DEPS = `pkg-config --cflags --libs libbitcoin`
ELIXIR_COMM_C = -x c++ $(CURE_DEPS_DIR)/elixir_comm.c
C_FLAGS = $(CURE_DEPS) $(LIBBITCOIN_DEPS) $(ELIXIR_COMM_C) -O3
PRIV_DIR = $(APP_DIR)/priv
C_SRC_DIR = $(APP_DIR)/c_src
EXECUTABLES = addr vanity-miner

all: $(EXECUTABLES)
# REF: https://www.gnu.org/software/make/manual/html_node/Static-Usage.html#Static-Usage
# $< - prerequisite file, $@ - executable file
$(EXECUTABLES): %: %.cpp
	$(CC) $(C_FLAGS) $(C_SRC_DIR)/$< -o $(PRIV_DIR)/$@

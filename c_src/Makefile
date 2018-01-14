CC = g++ -std=c++11
APP_DIR = $(shell dirname $(shell pwd))
CURE_DEPS_DIR = $(APP_DIR)/deps/cure/c_src
CURE_DEPS = -I$(CURE_DEPS_DIR) -L$(CURE_DEPS_DIR)
ELIXIR_COMM_C = -x c++ $(CURE_DEPS_DIR)/elixir_comm.c
LIBBITCOIN_DEPS = $(shell pkg-config --cflags --libs libbitcoin)
C_FLAGS = $(CURE_DEPS) $(ELIXIR_COMM_C) $(LIBBITCOIN_DEPS) -O3
PRIV_DIR = $(APP_DIR)/priv
C_SRC_DIR = $(APP_DIR)/c_src
EXECUTABLES = satoshi-words merkle vanity-miner

all: $(EXECUTABLES)
# REF: https://www.gnu.org/software/make/manual/html_node/Static-Usage.html#Static-Usage
#
# * $< - prerequisite file
# * $@ - executable file
$(EXECUTABLES): %: %.cpp
	$(CC) $(C_FLAGS) $(C_SRC_DIR)/$< -o $(PRIV_DIR)/$@

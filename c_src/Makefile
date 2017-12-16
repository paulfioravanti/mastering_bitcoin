COMPILER = g++ -std=c++11
APP_DIR = /Users/paul/Documents/Software/Code/elixir/mastering_bitcoin
CURE_DEPS = $(APP_DIR)/deps/cure/c_src
LIBBITCOIN = `pkg-config --cflags --libs libbitcoin`
C_FLAGS = -I$(CURE_DEPS) -L$(CURE_DEPS) $(LIBBITCOIN) -O3 -x c++
PRIV_DIR = $(APP_DIR)/priv/
C_SRC_DIR = $(APP_DIR)/c_src/
ELIXIR_COMM_C = $(CURE_DEPS)/elixir_comm.c
ALL = addr vanity-miner

define compile
	$(COMPILER) $(C_FLAGS) \
		-o $(PRIV_DIR)$(1) $(C_SRC_DIR)$(1).cpp $(ELIXIR_COMM_C)
endef

all: $(ALL)
addr:
	$(call compile,addr)
vanity-miner:
	$(call compile,vanity-miner)

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :mastering_bitcoin, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:mastering_bitcoin, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

# 1. $ cp config/config.example.exs config/config.exs
# 2. Fill in username and password of your local machine's bitcoin full node
config :mastering_bitcoin,
  bitcoin_url: "http://<user>:<password>@localhost:8332",
  cpp_compile: """
  g++ -std=c++11 -I./deps/cure/c_src -L./deps/cure/c_src -O3 -x c++ \
  -o {file} {file}.cpp ./deps/cure/c_src/elixir_comm.c \
  $(pkg-config --cflags --libs libbitcoin)
  """

# NOTE: Not sure how to install Goon properly or even if it's really needed
# for this project, so for now, just use the "basic driver".
# https://github.com/alco/goon
config :porcelain, driver: Porcelain.Driver.Basic

if Mix.env == :dev do
  # Configures automated testing/linting
  config :mix_test_watch,
  clear: true,
  tasks: [
    "test",
    # "dogma",
    "credo --strict",
  ]
end

use Mix.Config
alias Dogma.Rule

config :dogma,
  # Select a set of rules as a base
  rule_set: Dogma.RuleSet.All,
  # Pick paths not to lint
  exclude: [
    ~r(\A_build/),
    ~r(\Adeps/)
  ],
  # Override an existing rule configuration
  override: []

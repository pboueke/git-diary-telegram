use Mix.Config

config :app,
  bot_name: "git-diary"

config :nadia,
  token: System.get_env("BOT_TOKEN")